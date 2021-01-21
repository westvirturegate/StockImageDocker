import requests
from bs4 import BeautifulSoup

url = "https://finance.yahoo.com/quote/%5ETNX/history?p=%5ETNX"
res = requests.get(url)

soup = BeautifulSoup(res.text, 'html.parser')
stock = soup.find_all(class_="Py(10px) Pstart(10px)")

date = soup.find_all(class_="Py(10px) Ta(start) Pend(10px)")

close = []

for s in stock:
        close.append(s.string)

print(close[0],close[1],close[2],close[3],close[4],close[5])
         
