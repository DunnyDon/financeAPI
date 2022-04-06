/usage: `sym xcols update sym:assets from getCryptoPrices each assets:`btc`eth
getCryptoPrices:{[crypto]
	/crypto:`btc
	crypto:string crypto;
	res:.j.k raze system"curl https://data.messari.io/api/v1/assets/",crypto,"/metrics";
	:(first res`data`market_data)`market_data;
	};
