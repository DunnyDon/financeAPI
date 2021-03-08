\l p.q
getQuotes:{[syms]
	system"l getQuotes.p";
	getQ:.p.qcallable .p.get`getQuotesAPI;

	quotes:getQ raze  "/market/v2/get-quotes?region=US&symbols=","%2C" sv string syms;
	quotes: getQ raze "/market/v2/get-quotes?region=US&symbols=AMD%2CIBM%2CAAPL";

	quotes: (uj/) flip value (flip .j.k quotes)`result;
	quotes:?[quotes;();0b;cl!cl: `symbol`bid`bidSize`ask`askSize`fullExchangeName`quoteType`currency`longName`market`bookValue`exchangeDataDelayedBy,cls where any (string cls:cols quotes) like/:("pre*";"post*";"reg*";"fifty*";"twoH*";"price*";"divid*";"eps*")];
	quotes:![quotes;();0b;clsDel!clsDel: clsD where (lower string clsD:cols quotes)like\:"*time*"];
	quotes:delete regularMarketDayRange,regularMarketDayRange,priceHint,fullExchangeName from update `$symbol,marketID:`$fullExchangeName,`$quoteType,`$currency from quotes;
	 quotes:`time xcols update time:.z.t - "t"$exchangeDataDelayedBy*60000 from quotes;
	:`time`marketID xcols quotes
	}


updateQuotes:{[syms]
        `time xasc x uj getQuotes[syms]
        }
