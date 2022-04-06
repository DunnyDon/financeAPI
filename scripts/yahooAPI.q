\l p.q
\l yahooAPI.p
/get statistics for sym, takes string as param
/@TODO review columns and order
getStatsQ:{
  getStats:.p.qcallable .p.get`getStats; 
  res:.j.k raze getStats raze "/stock/v2/get-statistics?symbol=",x,"&region=US";
 `sym xcols update sym:enlist `$res`symbol from flip   keyVals!enlist each {$[(99h=type x)and `raw in key x;:x`raw;:x]}each(raze  res _ `symbol)keyVals:`averageVolume`dayLow`ask`askSize`volume`fiftyTwoWeekHigh`fiftyTwoWeekLow`bid`bidSize`dayHigh`shortTermTrend`midTermTrend`longTermTrend`recommendationKey`averageVolume10days`previousClose`twoHundredDayAverage`financialCurrency`revenuePerShare`quickRatio`recommendationMean`grossProfits`grossProfits`earningsGrowth`earningsGrowth`returnOnAssets`debtToEquity`returnOnEquity`totalCash`totalDebt`totalRevenue`totalRevenue`postMarketChangePercent`regularMarketChange`profitMargins`52WeekChange`earningsQuarterlyGrowth`pegRatio`regularMarketOpen`averageDailyVolume3Month`exchangeName`averageDailyVolume10Day`marketCap`marketState
 }

/Quotes API
getQuotes:{[syms;region]
        getQ:.p.qcallable .p.get`getQuotesAPI;
	/@TODO change to dictionary
	if[region~"nyse";region:"US"];
	if[region~"paris";region:"FR"];
	if[region~"lse";region:"BR"];
        quotes:getQ raze  "/market/v2/get-quotes?region=",region,"&symbols=","%2C" sv string syms;
        /quotes: getQ raze "/market/v2/get-quotes?region=US&symbols=AMD%2CIBM%2CAAPL";

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
