# massIngestionDataloader

Companion code to Kx Technical White Paper [“Mass ingestion through data loaders”](https://code.kx.com/q/wp/data-loaders/)


Example usage:

```q
//cd to directory where files are located

//start worker processes
q .mi.worker.q -p 5100
q .mi.worker.q -p 5101
q .mi.worker.q -p 5102

//start orchestrator process
q .mi.runOrchestrator.q -p 5000

//load hdb
cd hdb
q .

//query to confirm data looks good
select count i by date from marketTrades
```
//TODO
1. have date column mapped to symDate -> use int partitioned with sym mapping
2. have input files dynamically loaded in
3. Improve Logging
4. Define HDB locations in init script rather than worker and orchestrator
5. Update syms (do I want AAPL.US or AAPL)
6. Include Cuurency
7. Incorporate FX rates apis and have rate conversions
8. Set up Corporate Actions data to be loaded (use the getRefData.q script)
9. Create config dictionary for files to tableName mapping?
