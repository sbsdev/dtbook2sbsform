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
import java.util.HashMap;
import java.util.Map;

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
        private final Map<String, Translator> cache = new HashMap<>();

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
            } catch (RuntimeException e) {
                throw new XPathException("louis:translate: " + e.getMessage());
            } catch (TranslationException | DisplayException e) {
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
            return normalize(translator.translate(text, null, null, null).getBraille());
        }

        // Strip soft hyphens and record which inter-character positions in the stripped text had one.
        StringBuilder stripped = new StringBuilder(text.length());
        int[] markedPos = new int[text.length()]; // over-allocated
        int slen = 0;
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c == SOFT_HYPHEN) {
                if (slen > 0) markedPos[slen - 1] = 1; // soft hyphen after stripped char slen-1
            } else {
                stripped.append(c);
                slen++;
            }
        }
        if (slen == 0) return "";

        // Pass the markers as interCharacterAttributes so liblouis maps them to output positions.
        int[] interCharAttrs = slen > 1 ? Arrays.copyOf(markedPos, slen - 1) : null;
        TranslationResult result =
            translator.translate(stripped.toString(), null, null, interCharAttrs);
        String braille = normalize(result.getBraille());
        int[] outInterChar = result.getInterCharacterAttributes();

        if (outInterChar == null || outInterChar.length == 0) return braille;

        // Insert braille soft-hyphen 't' wherever a soft hyphen mapped to an output inter-position.
        StringBuilder sb = new StringBuilder(braille.length() * 2);
        for (int i = 0; i < braille.length(); i++) {
            sb.append(braille.charAt(i));
            if (i < outInterChar.length && outInterChar[i] != 0) sb.append('t');
        }
        // hard-hyphen immediately followed by soft-hyphen marker → braille hard-hyphen indicator.
        return sb.toString().replace("-t", "-m");
    }

    private static String normalize(String s) {
        return s.replace(NON_BREAKING_HYPHEN, '-');
    }
}
