\c 40 220
system"cd /home/conordonohue/financeAPI/scripts/";
\l getCrypto.q
\l getFxRates.q
\l yahooAPI.q
holdings:update upper ccy from ("***S*FFSSS";enlist csv) 0:`:Holdings.csv;
holdings:update sym:(`$string[sym],\:".AX") from holdings where exchange=`asx,asset<>`crypto;
holdings:update sym:(`$string[sym],\:".PA") from holdings where exchange=`paris,asset<>`crypto;
holdings:update sym:(`$string[sym],\:".L") from holdings where exchange=`lse,asset<>`crypto;
usCCy:getUSRates[];
divYP:system"curl -X GET \"https://www.tradegate.de/orderbuch.php?lang=en&isin=IE00B8GKDB10\"";
divYieldETFPrice:first vals where not null vals:raze "F"$/:"<" vs/:  ">" vs raze divYP where divYP like"*last*";
ftse:system"curl -X GET \"https://live.euronext.com/fr/ajax/getIntradayPriceFilteredData/IE00B3RBWM25-XAMS\"";
ftsePrice:exec "F"$"." sv csv vs max price from ((.j.k raze ftse)`rows) where ("T"$time)=max "T"$time;
gold:system"curl -X GET \"https://live.euronext.com/en/product/etvs/je00b588cd74-xams/wt-phys-sw-gld/sgbs\"";
goldPrice:"F"$last " " vs trim first "|" vs first res where gold like\:"*€*";
quotes:(uj/)getQuotes ./: flip   (value;key)@\:exec sym by string exchange from (update exchange:`nyse from holdings where sym in `FVRR`SQ) where asset<>`crypto,not exchange in `tdg`eam;
fundData: flip  `sym`price`ccy!(`VGWD`VWRL`SGBS;(divYieldETFPrice;ftsePrice;goldPrice);`EUR`EUR`EUR);
quotes:delete rate from update ccy:`USD,price%rate from(update ccy:`GBP,price%100 from ((select sym:symbol,price:regularMarketPrice,ccy:currency from quotes) uj fundData) where ccy=`GBp) lj 1!usCCy;
data:delete rate from update ccy:`USD,bep:bep%rate from (update upper ccy from holdings) lj 1!usCCy;
data:data lj `sym xkey  quotes;
cryptoPrices: `sym xcols update sym:upper cpto from select price:price_usd from getCryptoPrices each cpto:exec lower sym from data where asset=`crypto;
data:update ProfLoss:qty*price-bep from data lj 1!cryptoPrices;



data2:raze "Total Profit and Loss today is $", string exec sum ProfLoss from data;
data:delete brokerID,brokerName,account,ccy from data;
(`$":/home/conordonohue/db/holdings/") upsert .Q.en[`$":/home/conordonohue/db/"] update time:.z.P from data;
/acting very weird breaks after working
/switch to attaching csv with portfolio breakdown and text summary of performance maybe?
system raze "curl --request POST --url https://api.sendgrid.com/v3/mail/send --header 'Authorization' --header 'Content-Type: application/json' --data '{\"personalizations\":[{\"to\":[{\"email\":\"conordonohue@gmail.com\",\"name\":\"Dunny\"}],\"subject\":\"Personal Trading Summary ",string[.z.D],"\"}],\"content\": [{\"type\": \"text/plain\", \"value\": ",(.Q.s .Q.s data2),"}],\"attachments\": [{\"content\":\"",(.Q.btoa .Q.s data),"\",\"type\": \"text/csv\", \"filename\": \"holdings.csv\"}],\"from\":{\"email\":\"conordonohue@gmail.com\",\"name\":\"GCP Personal Trading\"},\"reply_to\":{\"email\":\"conordonohue@gmail.com\",\"name\":\"GCP Personal Trading\"}}'"
\\
