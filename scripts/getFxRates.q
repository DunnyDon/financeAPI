/FX Caller functions using exchange rates api
getLatestEuroRates:{
 $[null x;ccys:"";ccys:"?symbols=",csv sv string x];
 data:.j.k raze system raze"curl http://api.exchangeratesapi.io/v1/latest?access_key=7e6ac671849f71683eb6681a9c755083",ccys;
 update date:"D"$data`date,ccy: `$("EUR/",/:string ccy) from flip `ccy`rate! (key;value) @\: data`rates
 };

getHistEuroRates:{[sd;ed;ccy]
 $[all null ccy;ccys:"";ccys:"&symbols=",csv sv string ccy];
  sd:"-" sv "." vs string sd;
  ed:"-" sv "." vs string ed;
 data:.j.k raze system raze"curl -X GET \"http://api.exchangeratesapi.io/v1/time-series?access_key=7e6ac671849f71683eb6681a9c755083?start_at=",sd,"&end_at=",ed,ccys,"\"";
 data:flip `ccy`date`rate!raze each (enlist(count data`rates)#/:key flip data`rates),({(count cols value x)#/:key x};{value flip value x})@\:data`rates;
 `date xcols update date:"D"$string date,ccy: `$("EUR/",/:string ccy) from data
 };

getLatestFxRates:{[base;ccy]
  $[all null ccy;ccys:"";ccys:"&symbols=",csv sv string ccy];
 data:.j.k raze system raze"curl -X GET \"http://api.exchangeratesapi.io/v1/latest?access_key=7e6ac671849f71683eb6681a9c755083?base=",base,ccys,"\"";
 update date:"D"$data`date,ccy: `$((base,"/"),/:string ccy) from flip `ccy`rate! (key;value) @\: data`rates
 };

getHistFxRates:{[base;sd;ed;ccy]
 $[all null ccy;ccys:"";ccys:"&symbols=",csv sv string ccy];
  sd:"-" sv "." vs string sd;
  ed:"-" sv "." vs string ed;
 data:.j.k raze system raze"curl -X GET \"http://api.exchangeratesapi.io/v1/time-series?access_key=7e6ac671849f71683eb6681a9c755083?base=",base,"&start_at=",sd,"&end_at=",ed,ccys,"\"";
 data:flip `ccy`date`rate!raze each (enlist(count data`rates)#/:key flip data`rates),({(count cols value x)#/:key x};{value flip value x})@\:data`rates;
 `date xcols update date:"D"$string date,ccy: `$((base,"/"),/:string ccy) from data
 };

/functions above no longer work due to api key issues

getUSRates:{

	`ccy`rate xcol  update `$code from 1_ value (.j.k raze system"curl -X GET \"https://api.currencyapi.com/v3/latest?apikey= \"")`data

	}
