\l p.q

getMarketSummary:{
	system"l marketSummary.p";
	/convert data from json to kdb+ table
	summary: (uj/) flip value (flip .j.k (.p.get`raw_data)`)`result;
	/format and tidy up data
	summaryShort:select fullExchangeName,symbol,regularMarketChangePercent,quoteType,regularMarketPreviousClose,regularMarketChange,exchangeDataDelayedBy,exchangeTimezoneShortName,regularMarketPrice,market,exchange,shortName,region from summary;
	summaryShort:@[summaryShort;exec c from (meta summaryShort) where null t;first each value each];

	/update time based on the time the is data delayed by
	/time is is UTC
	summaryShort:update time:.z.t - "t"$exchangeDataDelayedBy*60000 from summaryShort;
	/format data 
	finalSummary:`time`sym`venue xcols `shortName`fullExchangeName _ update sym:`$shortName,venue:`$fullExchangeName from ?[summaryShort;();0b;(clsnrm,`$lower 7_/: string cls where (cls like"regular*"))!(clsnrm:`time`shortName`fullExchangeName`market`quoteType),cls where (cls:cols summaryShort) like"regular*"];
	:finalSummary
	}
updateMarketSummary:{
	`time xasc x uj getMarketSummary[]
	}
