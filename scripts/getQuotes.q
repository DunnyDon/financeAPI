\l p.q
getQuotes:{
	system"l getQuotes.p";
	quotes: (uj/) flip value (flip .j.k (.p.get`raw_data)`)`result;
	quotes:`time xcols update time:.z.t - "t"$exchangeDataDelayedBy*60000 from quotes;
	quotes:?[quotes;();0b;cl!cl: `symbol`bid`bidSize`ask`askSize`fullExchangeName`quoteType`currency`longName`market`bookValue`exchangeDataDelayedBy,cls where any (string cls:cols quotes) like/:("pre*";"post*";"reg*";"fifty*";"twoH*";"price*";"divid*";"eps*")];
	quotes:![quotes;();0b;clsDel!clsDel: clsD where (lower string clsD:cols quotes)like\:"*time*"];
	quotes:delete regularMarketDayRange,regularMarketDayRange,priceHint,fullExchangeName from update `$symbol,marketID:`$fullExchangeName,`$quoteType,`$currency from quotes;
	:`time`marketID xcols quotes
	}

updateQuotes:{
        `time xasc x uj getQuotes[]
        }
