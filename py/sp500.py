import requests
from bs4 import BeautifulSoup

url = "https://finance.yahoo.co.jp/quote/%5EGSPC"
res = requests.get(url)

soup = BeautifulSoup(res.text, 'html.parser')
stock = soup.find_all('span',{"class":"_3BGK5SVf"})

close = []

for s in stock:
    close.append(s.string)

print(close[3:7])

