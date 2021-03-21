import http.client

conn = http.client.HTTPSConnection("apidojo-yahoo-finance-v1.p.rapidapi.com")

headers = {
    'x-rapidapi-key':,
    'x-rapidapi-host': "apidojo-yahoo-finance-v1.p.rapidapi.com"
    }

def getStats(str):
        conn.request("GET", str, headers=headers)

        res = conn.getresponse()
        data = res.read()
        data= data.decode("utf-8")
        return data

def getQuotesAPI(str):
        conn.request("GET", str, headers=headers)

        res = conn.getresponse()
        data = res.read()

        raw_data = data.decode("utf-8")
        return(raw_data)
