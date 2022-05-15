bollingerBand:{flip `date`price`movingAverage`upperBound`lowerBound!enlist[y],enlist[x],enlist[mavgs],(+;-).\:(mavgs:30 mavg x;2*dev x)};

bollBandTab:{
  select from (reverse update fills prevPrice from reverse update prevPrice:  prev price from (exec bollingerBand[price;time] from holdings where sym=x) )where (price>lowerBound) and lowerBound>prevPrice
 };

getWgts:{
 update wgt:100*(price*qty)%sum price* qty by time from holdings
 };
/update (wgt xexp 2)*dev price by sym from getWgts[]
