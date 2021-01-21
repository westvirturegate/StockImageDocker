library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(ellipse)
library(ggExtra)
library(tagcloud)
library("gghighlight")

N = 120

Nikkei = tail(read.table("/data/nikkei.csv", header=TRUE, sep=","), N)
SP500 = tail(read.table("/data/sp500.csv", header=TRUE, sep=","), N)
Gold = tail(read.table("/data/Gold.csv", header=TRUE, sep=","), N)
Bond10 = tail(read.table("/data/Bond10.csv", header=TRUE, sep=","), N)


BTC = tail(read.table("/data/BTC-USD.csv", header=TRUE, sep=","), N)

dy = tail(read.table("/data/usdjpy.csv", header=TRUE, sep=","), N)

datecomp <- function(Nikkei){
	Nikkei$date <- as.Date.factor(as.vector(Nikkei$date))
	Nikkei <- complete(Nikkei ,date =  seq.Date(min((Nikkei$date)), max((Nikkei$date)), by="day"))

	Nikkei = tidyr::fill(Nikkei,close)

	Nikkei = data.frame(date = (Nikkei$date), price = as.vector(Nikkei$close))
	return(Nikkei)
}

Nikkei <- datecomp(Nikkei)
dy = datecomp(dy)
SP500 <- datecomp(SP500)
BTC <- datecomp(BTC)
Gold <- datecomp(Gold)
Bond10 <- datecomp(Bond10)

d = data.frame(date =tail(Nikkei$date,N), Nikkei = tail(Nikkei$price,N)/tail(dy$price,N),SP500 = tail(SP500$price,N),BTC = tail(BTC$price,N),Gold = tail(Gold$price,N),Bond10 = tail(Bond10$price,N))

write.csv(d, stdout(), row.names = FALSE)

