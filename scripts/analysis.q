bollingerBand:{flip `date`price`movingAverage`upperBound`lowerBound!enlist[y],enlist[x],enlist[mavgs],(+;-).\:(mavgs:30 mavg x;2*dev x)};

bollBandTab:{
  select from (reverse update fills prevPrice from reverse update prevPrice:  prev price from (exec bollingerBand[price;time] from holdings where sym=x) )where (price>lowerBound) and lowerBound>prevPrice
 };

getWgts:{
 update wgt:100*(price*qty)%sum price* qty by time from holdings
 };
/update (wgt xexp 2)*dev price by sym from getWgts[]

piv2:{[t;k;p;v] 
        f:{[v;P]
                `${raze " " sv x} each string raze P[;0],'/:v,/:\:P[;1]
        };
     v:(),v;
     k:(),k;
     p:(),p;
     G:group flip k!(t:.Q.v t)k;
     F:group flip p!t p; 
     key[G]!flip(C:f[v]P:flip value flip key F)!raze      
     {[i;j;k;x;y]
       a:count[x]#x 0N;
       a[y]:x y;
       b:count[x]#0b;
       b[y]:1b;
       c:a i;
       c[k]:first'[a[j]@'where'[b j]];
       c
        }[I[;0];I J;J:where 1<>count'[I:value G]]/:\:[t v;value F]
 };

calcCorrMatrix:{
        pivTab:.Q.id 0!fills piv2[`holdings;enlist `time;enlist `sym;enlist `ProfLoss];
        flip value flip value fTab cor/:\:fTab:flip delete time from pivTab
 };

calcPortfolioRisk:{
    sqrt first  
    (first(value flip wgtMatrix)
         mmu calcCorrMatrix[])
  mmu flip value flip wgtMatrix:select  wgt:0.01*wgt*wSdev from (update wSdev:(dev ProfLoss)%avg ProfLoss by sym from getWgts[]) where time=max time
 };
