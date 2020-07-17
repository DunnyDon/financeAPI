\l p.q
getQuotes:{
	system"l getQuotes.p";
	quotes: (uj/) flip value (flip .j.k (.p.get`raw_data)`)`result;
	:quotes
	}
