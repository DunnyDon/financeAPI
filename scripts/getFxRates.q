getLatestEuroRates:{
 $[null x;ccys:"";ccys:"?symbols=",csv sv string x];
 data:.j.k raze system raze"curl https://api.exchangeratesapi.io/latest",ccys; 
 update date:"D"$data`date,ccy: `$("EUR/",/:string ccy) from flip `ccy`rate! (key;value) @\: data`rates
 }

getHistEuroRates:{[sd;ed;ccy]
 $[all null ccy;ccys:"";ccys:"&symbols=",csv sv string ccy];
  sd:"-" sv "." vs string sd;
  ed:"-" sv "." vs string ed;
 data:.j.k raze system raze"curl -X GET \"https://api.exchangeratesapi.io/history?start_at=",sd,"&end_at=",ed,ccys,"\""; 
 data
 }
