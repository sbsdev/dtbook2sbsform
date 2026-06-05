package ch.sbs.dtbook2sbsform;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.value.EmptySequence;
import net.sf.saxon.value.SequenceType;
import net.sf.saxon.value.StringValue;

import org.liblouis.CompilationException;
import org.liblouis.DisplayException;
import org.liblouis.TranslationException;
import org.liblouis.TranslationResult;
import org.liblouis.Translator;

import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Saxon extension function louis:translate(table, text) that restores two behaviours of the old
 * SBS liblouis-javabindings (ch.sbs.liblouis/louis) that the official org.liblouis/liblouis-java
 * bindings do not provide:
 *
 * 1. Soft-hyphen pre-processing (U+00AD in input): the old bindings stripped soft hyphens before
 *    calling lou_translate, tracked their positions via outputPosArray, and reinserted braille
 *    soft-hyphen markers ('t') at the corresponding output positions.  A hard-hyphen followed by
 *    a soft-hyphen marker ("-t") was collapsed to the braille hard-hyphen indicator ("-m").
 *    We use the official Translator.translate(text, null, null, interCharacterAttributes) API to
 *    pass per-inter-character markers through the translation and read them back via
 *    TranslationResult.getInterCharacterAttributes(), which gives the positions in the output.
 *
 * 2. Non-breaking hyphen normalisation (U+2011 → '-' in output): the old bindings replaced U+2011
 *    with '-' before returning.  The non-breaking property is meaningless once translation is done
 *    (line wrapping is handled separately by LineBreaker.java).
 */
public class LouisTranslateFunction extends ExtensionFunctionDefinition {

    private static final StructuredQName FUNC_NAME =
        new StructuredQName("louis", "http://liblouis.org/liblouis", "translate");

    static final char SOFT_HYPHEN = '­';
    static final char NON_BREAKING_HYPHEN = '‑';

    @Override public StructuredQName getFunctionQName() { return FUNC_NAME; }
    @Override public int getMinimumNumberOfArguments() { return 2; }
    @Override public int getMaximumNumberOfArguments() { return 2; }

    @Override
    public SequenceType[] getArgumentTypes() {
        return new SequenceType[]{SequenceType.SINGLE_STRING, SequenceType.SINGLE_STRING};
    }

    @Override
    public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
        return SequenceType.SINGLE_STRING;
    }

    @Override
    public ExtensionFunctionCall makeCallExpression() {
        return new Call();
    }

    private static final class Call extends ExtensionFunctionCall {
        private final Map<String, Translator> cache = new ConcurrentHashMap<>();

        @Override
        public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {
            if (arguments[0].head() == null || arguments[1].head() == null)
                return EmptySequence.getInstance();
            String table = arguments[0].head().getStringValue();
            String text  = arguments[1].head().getStringValue();
            try {
                Translator translator = cache.computeIfAbsent(table, t -> {
                    try { return new Translator(t); }
                    catch (CompilationException e) { throw new RuntimeException(e.getMessage(), e); }
                });
                return new StringValue(translate(translator, text));
            } catch (RuntimeException | TranslationException | DisplayException e) {
                throw new XPathException("louis:translate: " + e.getMessage());
            }
        }
    }

    /** Translates text, restoring soft-hyphen markers and normalising U+2011. */
    static String translate(Translator translator, String text)
            throws TranslationException, DisplayException {
        // Collapse ASCII whitespace runs (including newlines) to a single space.
        // This matches the intent of the old ch.sbs.liblouis/louis squeeze() but preserves
        // U+00A0 NBSP (not matched by \s), which liblouis translates to a braille NBSP indicator.
        text = text.replaceAll("\\s+", " ");
        if (text.indexOf(SOFT_HYPHEN) < 0) {
            return translator.translate(text, null, null, null).getBraille()
                    .transform(LouisTranslateFunction::normalize);
        }

        // Strip soft hyphens and record which inter-character positions in the stripped text had one.
        StringBuilder stripped = new StringBuilder(text.length());
        int[] hyphenPoints = new int[text.length()]; // over-allocated
        int strippedLength = 0;
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c == SOFT_HYPHEN) {
                if (strippedLength > 0) hyphenPoints[strippedLength - 1] = 1; // soft hyphen after stripped char strippedLength-1
            } else {
                stripped.append(c);
                strippedLength++;
            }
        }
        if (strippedLength == 0) return "";

        // Pass the markers as interCharacterAttributes so liblouis maps them to output positions.
        int[] inputHyphenPoints = strippedLength > 1 ? Arrays.copyOf(hyphenPoints, strippedLength - 1) : null;
        TranslationResult result =
            translator.translate(stripped.toString(), null, null, inputHyphenPoints);
        // Do NOT normalize yet: the 'ver' contraction produces U+2011 (dots 36a) while a real
        // ASCII hyphen produces U+002D (dots 36). We must distinguish them before normalizing.
        String braille = result.getBraille();
        int[] outputHyphenPoints = result.getInterCharacterAttributes();

        if (outputHyphenPoints == null || outputHyphenPoints.length == 0) return normalize(braille);

        // Insert braille soft-hyphen 't' wherever a soft hyphen mapped to an output inter-position.
        StringBuilder withHyphenationMarkers = new StringBuilder(braille.length() * 2);
        for (int i = 0; i < braille.length(); i++) {
            withHyphenationMarkers.append(braille.charAt(i));
            if (i < outputHyphenPoints.length && outputHyphenPoints[i] != 0) withHyphenationMarkers.append('t');
        }
        // 't' following a '-' need to be replaced with '-m'. This seems easy, however 'ver'
        // translates into '-', so we have to make sure we do not replace those. Luckily 'ver' is
        // translated using dots 36a, which maps into U+2011 by the sbs braille tables. This is then
        // normalized into a plain '-'. So just make sure to do the '-t' -> '-m' replacement *before*
        // you normalize U+2011 into '-'
        return withHyphenationMarkers.toString()
                .replace("-t", "-m")
                .transform(LouisTranslateFunction::normalize);
    }

    private static String normalize(String s) {
        return s.replace(NON_BREAKING_HYPHEN, '-');
    }
}
