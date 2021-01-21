import requests
from bs4 import BeautifulSoup

url = "https://stocks.finance.yahoo.co.jp/stocks/detail/?code=998407.O"
res = requests.get(url)

soup = BeautifulSoup(res.text, 'html.parser')

stock = soup.find_all(class_='ymuiEditLink mar0')

close = []

for s in stock:
    close.append(s.strong.string)

print(close[0:4])
