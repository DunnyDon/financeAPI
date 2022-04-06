getRefData:{[]
 refData:`sym`name`date`active`typ`id xcol .j.k raze system"curl https://api.iextrading.com/1.0/ref-data/symbols";
 refData:select from refData where not null `$name;
 typeMapping:`RE`CE`SI`LP`CS`ET!("REIT";"Closed end Fund";"Secondary Issue";"Limited Partnerships";"Common Stock";"ETF");
 refData:update `$sym,"D"$date,`$typ,typeDesc:typeMapping[`$typ] from refData;
 :refData
 }

loadRefData:{[]
 `sym`name`marketCap`IPO`sector`industry`sumQuote xcol ("S* *****";enlist csv)0:`:../data/companylist.csv
 }

/@TODO combine API and data on disk
combineRefData:{[]
 loadRefData[] uj getRefData[]
 }
