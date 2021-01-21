library(dplyr)
library(tidyr)
library(ggplot2)
library(GGally)
library(ellipse)
library(ggExtra)
library(tagcloud)
library("gghighlight")

N =240 

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

dat = data.frame(date =tail(Nikkei$date,N), Nikkei = tail(Nikkei$price,N)/tail(dy$price,N),SP500 = tail(SP500$price,N),BTC = tail(BTC$price,N),Gold = tail(Gold$price,N),Bond10 = tail(Bond10$price,N))

for (tmp in 0:3){
	d = head(dat,120 + tmp)

	d = tail(d,120)
	date = as.Date.factor(d$date)
	d = d[,colnames(d) != "date"]

	color_unif1 <- smoothPalette(1:dim(d)[1], pal="RdBu")


	test = paste0("/img2/",tmp,".png")
	png(test, width = 800, height = 600)

	n = 30


	set.seed(1230)

	N_col <- ncol(d)
	ggp <- ggpairs(d, upper='blank', diag='blank', lower='blank')

	for(i in 1:N_col) {
		  x <- d[,i]
	  p <- ggplot(data.frame(x), aes(x = date, y = x))
	    p <- p + theme_bw(base_size=14)
	    p <- p + theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1))
	      if (class(x) == 'factor') {
		          p <- p + geom_bar( color='grey5')
	      } else {
		          bw <- (max(x)-min(x))/10
	          p <- p + geom_line(color='deepskyblue4')
		      p <- p+ geom_ribbon(fill="lightblue2", alpha=0.5, aes(ymin=min(x), ymax=x)) 
		      
		      # p <- p + geom_histogram(binwidth=bw,color='lightblue3',fill = 'lightblue1')
		      # p <- p + geom_line(eval(bquote(aes(y=..count..*.(bw)))), stat='density',color='deepskyblue4')
		    }
	      p <- p + geom_label(data=data.frame(x=min(date), y=Inf, label=colnames(d)[i]), aes(x=x, y=y, label=label), hjust=0, vjust=1)
	        p <- p + scale_fill_manual(values=alpha(c('white', 'lightblue2'), 0.5))
	        if(N_col >= 3) {
			    p <- p + ylim(min(x), max(x)*1.2)
		  }
		  
		  ggp <- putPlot(ggp, p, i, i)
	}

	# p <- p + geom_point(data = ratecut,aes(date,rep(min(x),length(ratecut$date))))
	# data.frame(x = x, date = date)[data.frame(x = x, date = date)$date == cut,]

	zcolat <- seq(-1, 1, length=81)
	zcolre <- c(zcolat[1:40]+1, rev(zcolat[41:81]))

	for(i in 1:(N_col-1)) {
		  for(j in (i+1):N_col) {
			      x <- diff(as.numeric(d[,i]))
	    y <- diff(as.numeric(d[,j]))
	        r = rep(0,(length(x)-n+1))
	        for (k in 1:(length(x)-n+1)) {
			      r[k] = cor(x[k:(k+n-1)],y[k:(k+n-1)], method='spearman', use='pairwise.complete.obs')
		    }
		    # r = c(rep(0,30),r)
		    # zcol <- lattice::level.colors(r, at=zcolat, col.regions=cm.colors)
		    # ell <- ellipse::ellipse(r, level=0.95, type='l', npoints=50, scale=c(.2, .2), centre=c(.5, .5))
		    p <- ggplot(data.frame(date = date[n:length(date)],corr = c(0,r)), aes(x=date,y = corr))
		    p <- p + theme_bw() + theme(
						      plot.background=element_blank(),
						            # panel.grid.major=element_blank(),
						            # panel.grid.minor=element_blank(),
						            panel.border=element_blank(),
						            axis.ticks=element_blank()
							        )
		        p <- p + geom_line(color='magenta3')
		        p <- p+ geom_ribbon(fill="plum1", alpha=0.5, aes(ymin=0, ymax=corr))
			    p <- p + ylim(-1,1)+xlim(min(date),max(date))
			    # p <- p + geom_bar(stat = "identity", fill = zcol, color = zcol)
			    # p <- p + geom_polygon(fill=zcol, color=zcol)
			    # textcol <- ifelse(ave(r)[1] < 0, 'blue', 'red')
			    textcol <- ifelse(100*round(ave(r)[1],2) < 0, 'blue', ifelse(100*round(ave(r)[1],2) == 0, 'black', 'red'))
			        # p <- p + geom_text(data=NULL, aes(x = median(date),y=0), label=100*round(ave(r)[1], 2), size=10, col=textcol,alpha=0.01 )
			        p <- p + annotate("text",x = median(date)+30,y=0, label=100*round(ave(r)[1], 2), size=10, col=textcol,alpha=0.8)
			        ggp <- putPlot(ggp, p, i, j)
				  }
	}

	for(j in 1:(N_col-1)) {
		  for(i in (j+1):N_col) {
			      x <- d[,j]
	    y <- d[,i]
	        p <- ggplot(data.frame(x, y), aes(x=x, y=y))
	        p <- p + theme_bw(base_size=14)
		    p <- p + theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1))
		    if (class(x) == 'factor') {
			          p <- p + geom_boxplot(aes(group=x), alpha=3/6, outlier.size=0, fill='white')
		          p <- p + geom_point(position=position_jitter(w=0.4, h=0), size=2, col=color_unif1)
			      } else {
				            p <- p + geom_point(size=2, col=color_unif1)
			        p <- p + theme(panel.background = element_rect(fill = "grey" , colour = "black"))
				    }
		        # p <- p + scale_shape_manual(values=c(21, 24))
		        # p <- p + scale_fill_manual(values=alpha(c('white', 'grey40'), 0.5))
		        ggp <- putPlot(ggp, p, i, j)
		      }
	}

	ggp

}

