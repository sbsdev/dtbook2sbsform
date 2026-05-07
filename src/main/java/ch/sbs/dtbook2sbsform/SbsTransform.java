package ch.sbs.dtbook2sbsform;

import net.sf.saxon.Transform;

/**
 * Saxon command-line entry point that registers the SBS louis:translate extension function.
 * Replaces org.liblouis.LouisTransform, which uses LouisExtensionFunctionDefinition — an
 * implementation that lacks soft-hyphen pre-processing and U+2011 normalisation.
 */
public class SbsTransform extends Transform {

    @Override
    public void setFactoryConfiguration(boolean schemaAware, String className) {
        super.setFactoryConfiguration(schemaAware, className);
        getConfiguration().registerExtensionFunction(new LouisTranslateFunction());
    }

    public static void main(String[] args) {
        new SbsTransform().doTransform(args, "java ch.sbs.dtbook2sbsform.SbsTransform");
    }
}
