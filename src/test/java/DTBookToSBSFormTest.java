import java.io.File;

import java.net.URI;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.io.FileUtils;

import org.daisy.maven.xspec.TestResults;
import org.daisy.maven.xspec.XSpecRunner;

import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.assertEquals;

import org.ops4j.pax.exam.Configuration;
import org.ops4j.pax.exam.junit.PaxExam;
import org.ops4j.pax.exam.Option;
import org.ops4j.pax.exam.spi.reactors.ExamReactorStrategy;
import org.ops4j.pax.exam.spi.reactors.PerClass;
import org.ops4j.pax.exam.util.PathUtils;

import static org.ops4j.pax.exam.CoreOptions.junitBundles;
import static org.ops4j.pax.exam.CoreOptions.mavenBundle;
import static org.ops4j.pax.exam.CoreOptions.options;
import static org.ops4j.pax.exam.CoreOptions.systemProperty;

@RunWith(PaxExam.class)
@ExamReactorStrategy(PerClass.class)
public class DTBookToSBSFormTest {
	
	@Inject
	private XSpecRunner xspecRunner;
	
	@Configuration
	public Option[] config() {
		return options(
			systemProperty("logback.configurationFile").value("file:" + PathUtils.getBaseDir() + "/src/test/resources/logback.xml"),
			mavenBundle().groupId("org.slf4j").artifactId("slf4j-api").version("1.7.2"),
			mavenBundle().groupId("ch.qos.logback").artifactId("logback-core").version("1.0.11"),
			mavenBundle().groupId("ch.qos.logback").artifactId("logback-classic").version("1.0.11"),
			mavenBundle().groupId("org.apache.felix").artifactId("org.apache.felix.scr").version("1.6.2"),
			mavenBundle().groupId("com.google.guava").artifactId("guava").versionAsInProject(),
			mavenBundle().groupId("org.daisy.libs").artifactId("saxon-he").versionAsInProject(),
			mavenBundle().groupId("net.java.dev.jna").artifactId("jna").versionAsInProject(),
			mavenBundle().groupId("org.liblouis").artifactId("liblouis-java").versionAsInProject(),
			mavenBundle().groupId("org.daisy.pipeline.modules.braille").artifactId("common-java").versionAsInProject(),
			mavenBundle().groupId("org.daisy.pipeline.modules.braille").artifactId("liblouis-native").versionAsInProject().classifier("linux"),
			mavenBundle().groupId("org.daisy.pipeline.modules.braille").artifactId("liblouis-core").versionAsInProject(),
			mavenBundle().groupId("org.daisy.pipeline.modules.braille").artifactId("liblouis-saxon").versionAsInProject(),
			mavenBundle().groupId("ch.sbs.pipeline").artifactId("sbs-braille-tables").versionAsInProject(),
			mavenBundle().groupId("org.daisy.pipeline").artifactId("saxon-adapter").versionAsInProject(),
			mavenBundle().groupId("org.apache.servicemix.bundles").artifactId("org.apache.servicemix.bundles.xmlresolver").versionAsInProject(),
			mavenBundle().groupId("org.daisy.maven").artifactId("xspec-runner").versionAsInProject(),
			mavenBundle().groupId("commons-io").artifactId("commons-io").versionAsInProject(),
			junitBundles()
		);
	}
	
	@Test
	public void runXSpec() throws Exception {
		File testsDir = new File(PathUtils.getBaseDir() + "/src/test/xspec");
		File reportsDir = new File(PathUtils.getBaseDir() + "/target/surefire-reports");
		reportsDir.mkdirs();
		Map<String,File> tests = new HashMap<String,File>();
		Collection<File> testFiles = FileUtils.listFiles(testsDir, new String[]{"xspec"}, true);
		for (File file : testFiles)
			tests.put(
				file.getAbsolutePath().substring(testsDir.getAbsolutePath().length() + 1)
					.replaceAll("\\.xspec$", "")
					.replaceAll("[\\./\\\\]", "_"),
				file);
		TestResults result = xspecRunner.run(tests, reportsDir);
		assertEquals("Number of failures and errors should be zero", 0L, result.getFailures() + result.getErrors());
	}
}
