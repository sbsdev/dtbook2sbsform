package ch.sbs.dtbook2sbsform;

import net.sf.saxon.s9api.*;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.liblouis.LouisExtensionFunctionDefinition;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.dom.DOMSource;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@RunWith(Parameterized.class)
public class XSpecTest {

    private static final String XSPEC_NS = "http://www.jenitennison.com/xslt/xspec";

    private static final Processor PROCESSOR;
    private static final Map<String, XsltExecutable> COMPILED = new ConcurrentHashMap<>();

    static {
        PROCESSOR = new Processor(false);
        PROCESSOR.registerExtensionFunction(new LouisExtensionFunctionDefinition());
    }

    private final File xspecFile;

    public XSpecTest(File xspecFile) {
        this.xspecFile = xspecFile;
    }

    @Parameterized.Parameters(name = "{0}")
    public static List<Object[]> xspecFiles() throws IOException {
        return Files.walk(Paths.get("src/test/xspec"))
                .filter(p -> p.toString().endsWith(".xspec"))
                .sorted()
                .map(p -> new Object[]{p.toFile()})
                .collect(Collectors.toList());
    }

    @Test
    public void run() throws Exception {
        Document xspec = parseXml(xspecFile);
        Element description = xspec.getDocumentElement();
        String stylesheetAttr = description.getAttribute("stylesheet");
        File stylesheetFile = new File(xspecFile.getParentFile(), stylesheetAttr);

        XsltExecutable exec = COMPILED.computeIfAbsent(
                stylesheetFile.getCanonicalPath(),
                path -> {
                    try {
                        XsltCompiler compiler = PROCESSOR.newXsltCompiler();
                        return compiler.compile(new javax.xml.transform.stream.StreamSource(stylesheetFile));
                    } catch (SaxonApiException e) {
                        throw new RuntimeException("Failed to compile " + path, e);
                    }
                });

        List<String> failures = new ArrayList<>();

        NodeList scenarios = description.getElementsByTagNameNS(XSPEC_NS, "scenario");
        for (int i = 0; i < scenarios.getLength(); i++) {
            Element scenario = (Element) scenarios.item(i);
            // Skip nested scenarios (only process top-level ones)
            if (!scenario.getParentNode().equals(description)) continue;

            String label = scenario.getAttribute("label");
            try {
                runScenario(exec, scenario, label, failures);
            } catch (Exception e) {
                failures.add("Scenario [" + label + "] threw exception: " + e.getMessage());
            }
        }

        if (!failures.isEmpty()) {
            throw new AssertionError(
                    xspecFile.getName() + ": " + failures.size() + " scenario(s) failed:\n"
                    + String.join("\n", failures));
        }
    }

    private void runScenario(XsltExecutable exec, Element scenario, String label, List<String> failures)
            throws Exception {
        // Collect params
        Map<QName, XdmValue> params = new LinkedHashMap<>();
        NodeList paramNodes = scenario.getElementsByTagNameNS(XSPEC_NS, "param");
        for (int i = 0; i < paramNodes.getLength(); i++) {
            Element param = (Element) paramNodes.item(i);
            if (!param.getParentNode().equals(scenario)) continue;
            String name = param.getAttribute("name");
            String select = param.getAttribute("select");
            params.put(new QName(name), evaluateParam(select));
        }

        // Get context element
        Element contextEl = firstChildElement(scenario, XSPEC_NS, "context");
        if (contextEl == null) {
            failures.add("Scenario [" + label + "]: no x:context found");
            return;
        }
        List<Node> contextNodes = childElements(contextEl);
        if (contextNodes.isEmpty()) {
            failures.add("Scenario [" + label + "]: x:context has no element children");
            return;
        }

        // Get expected text (normalize line endings: CR→LF)
        Element expectEl = firstChildElement(scenario, XSPEC_NS, "expect");
        if (expectEl == null) {
            failures.add("Scenario [" + label + "]: no x:expect found");
            return;
        }
        String expected = normalizeLineEndings(expectEl.getTextContent());

        // Import all context elements into a single fresh document so:
        // (a) the preceding:: axis cannot see nodes from other scenarios, and
        // (b) sibling elements remain visible to each other within one transform call.
        DocumentBuilder freshBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        Document freshDoc = freshBuilder.newDocument();
        Node root;
        if (contextNodes.size() == 1) {
            root = freshDoc.importNode(contextNodes.get(0), true);
            freshDoc.appendChild(root);
        } else {
            // Wrap multiple elements in a neutral container; the default XSLT template
            // will apply-templates to children, processing each in document order.
            Element wrapper = freshDoc.createElement("_");
            freshDoc.appendChild(wrapper);
            for (Node n : contextNodes) {
                wrapper.appendChild(freshDoc.importNode(n, true));
            }
            root = wrapper;
        }
        // Strip whitespace-only text nodes injected by the indent="yes" XSLT serializer
        // during utfx2xspec conversion, so they don't pollute the transform input.
        stripWhitespaceOnlyTextNodes(root);
        StringWriter sw = new StringWriter();
        XsltTransformer transformer = exec.load();
        for (Map.Entry<QName, XdmValue> entry : params.entrySet()) {
            transformer.setParameter(entry.getKey(), entry.getValue());
        }
        transformer.setSource(new DOMSource(freshDoc));
        Serializer serializer = PROCESSOR.newSerializer(sw);
        serializer.setOutputProperty(Serializer.Property.METHOD, "text");
        transformer.setDestination(serializer);
        transformer.transform();

        // Trim leading/trailing whitespace: XSpec indentation leaks into <x:expect> text content.
        String actual = normalizeLineEndings(sw.toString()).trim();
        expected = expected.trim();
        if (!expected.equals(actual)) {
            failures.add("Scenario [" + label + "]:\n  expected: " + repr(expected)
                    + "\n  actual:   " + repr(actual));
        }
    }

    private static XdmValue evaluateParam(String select) throws SaxonApiException {
        if (select.matches("\\d+")) {
            return new XdmAtomicValue(Long.parseLong(select));
        }
        if (select.startsWith("'") && select.endsWith("'")) {
            return new XdmAtomicValue(select.substring(1, select.length() - 1));
        }
        XPathCompiler xpc = PROCESSOR.newXPathCompiler();
        return xpc.evaluate(select, null);
    }

    private static String normalizeLineEndings(String s) {
        return s.replace("\r\n", "\n").replace("\r", "\n");
    }

    private static Document parseXml(File file) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
        factory.setFeature("http://xml.org/sax/features/validation", false);
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(file);
    }

    private static Element firstChildElement(Element parent, String ns, String localName) {
        NodeList children = parent.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE
                    && localName.equals(child.getLocalName())
                    && ns.equals(child.getNamespaceURI())) {
                return (Element) child;
            }
        }
        return null;
    }

    private static void stripWhitespaceOnlyTextNodes(Node node) {
        NodeList children = node.getChildNodes();
        List<Node> toRemove = new ArrayList<>();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.TEXT_NODE) {
                String val = child.getNodeValue();
                // Saxon indent="yes" always starts indentation with \n.
                // Original significant whitespace (e.g. a space between inline elements)
                // starts with a space character. Only strip nodes that start with \n.
                if (val.startsWith("\n") && val.trim().isEmpty()) {
                    toRemove.add(child);
                }
            } else if (child.getNodeType() == Node.ELEMENT_NODE) {
                stripWhitespaceOnlyTextNodes(child);
            }
        }
        for (Node n : toRemove) {
            node.removeChild(n);
        }
    }

    private static List<Node> childElements(Element parent) {
        List<Node> result = new ArrayList<>();
        NodeList children = parent.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                result.add(child);
            }
        }
        return result;
    }

    private static String repr(String s) {
        return "\"" + s.replace("\n", "\\n").replace("\t", "\\t") + "\"";
    }
}
