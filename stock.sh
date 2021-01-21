#! /bin/bash 
#sp500:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/SP500.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" >> /data/sp500.csv

#nikkei:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/Nikkei.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" >> /data/nikkei.csv

#gold:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/gold.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" >> /data/Gold.csv

#BTC:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/BTC-USD.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" >> /data/BTC-USD.csv

#Bond10:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/Bond10.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" | sed "/null/d" >> /data/Bond10.csv

#USD_JPY:
echo \'`date --date "1 day ago" +"%Y/%m/%d"`\'\, `python3 /py/usdjpy.py` | tr -d ",'" | sed "s/\s/,/g" | sed "s/\//-/g" >> /data/usdjpy.csv


