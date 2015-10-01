package ch.sbs.pipeline.braille.impl;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.common.base.Optional;

import static org.daisy.pipeline.braille.css.Query.parseQuery;
import static org.daisy.pipeline.braille.css.Query.serializeQuery;
import org.daisy.pipeline.braille.common.BrailleTranslator;
import org.daisy.pipeline.braille.common.TextTransform;
import org.daisy.pipeline.braille.common.Transform;
import static org.daisy.pipeline.braille.common.Transform.Provider.util.dispatch;
import static org.daisy.pipeline.braille.common.Transform.Provider.util.memoize;
import static org.daisy.pipeline.braille.common.util.Files.unpack;
import static org.daisy.pipeline.braille.common.util.URIs.asURI;
import org.daisy.pipeline.braille.liblouis.LiblouisTranslator;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.ComponentContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component(
	name = "ch.sbs.pipeline.braille.impl.TranslatorProvider",
	service = {
		LiblouisTranslator.Provider.class,
		BrailleTranslator.Provider.class,
		TextTransform.Provider.class
	}
)
public class TranslatorProvider implements LiblouisTranslator.Provider {
	
	private URI virtualDis;
	
	@Activate
	private void activate(ComponentContext context, final Map<?,?> properties) {
		File f = new File(makeUnpackDir(context), "virtual.dis");
		unpack(context.getBundleContext().getBundle().getEntry("/liblouis/virtual.dis"), f);
		virtualDis = asURI(f);
	}
	
	public Iterable<LiblouisTranslator> get(String query) {
		Map<String,Optional<String>> q = new HashMap<String,Optional<String>>(parseQuery(query));
		Optional<String> o;
		if (q.remove("sbs") != null) {
			if ((o = q.remove("liblouis-table")) != null)
				q.put("liblouis-table", Optional.of(virtualDis + "," + o.get()));
			return liblouisTranslatorProvider.get(serializeQuery(q)); }
		return empty;
	}
	
	public Transform.Provider<LiblouisTranslator> withContext(Logger context) {
		return this;
	}
	
	@Reference(
		name = "LiblouisTranslatorProvider",
		unbind = "unbindLiblouisTranslatorProvider",
		service = LiblouisTranslator.Provider.class,
		cardinality = ReferenceCardinality.MULTIPLE,
		policy = ReferencePolicy.DYNAMIC
	)
	protected void bindLiblouisTranslatorProvider(LiblouisTranslator.Provider provider) {
		if (provider != this)
			liblouisTranslatorProviders.add(provider);
	}
	
	protected void unbindLiblouisTranslatorProvider(LiblouisTranslator.Provider provider) {
		liblouisTranslatorProviders.remove(provider);
		liblouisTranslatorProvider.invalidateCache();
	}
	
	private List<Transform.Provider<LiblouisTranslator>> liblouisTranslatorProviders
	= new ArrayList<Transform.Provider<LiblouisTranslator>>();
	private Transform.Provider.MemoizingProvider<LiblouisTranslator> liblouisTranslatorProvider
	= memoize(dispatch(liblouisTranslatorProviders));
	
	private static final Iterable<LiblouisTranslator> empty = Optional.<LiblouisTranslator>absent().asSet();
		
	private static File makeUnpackDir(ComponentContext context) {
		File directory;
		for (int i = 0; true; i++) {
			directory = context.getBundleContext().getDataFile("resources" + i);
			if (!directory.exists()) break; }
		directory.mkdirs();
		return directory;
	}
	
	private static final Logger logger = LoggerFactory.getLogger(TranslatorProvider.class);
	
}
