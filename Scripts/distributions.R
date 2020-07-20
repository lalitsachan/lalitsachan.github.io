library(ggplot2)
library(scales)
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
# uniform
x=sample(1:6,100000,replace = T)
d=data.frame(x=x)
ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='seagreen2',color='white',aes(y=..count../sum(..count..)))+
  ylab('density')+xlab('X')
#bernoulli
x=sample(c(0,1),10000,replace=T,p=c(0.2,0.8))
d=data.frame(x=x)
ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='skyblue2',color='white',aes(y=..count../sum(..count..)))+
  ylab('density :Bernoulli(p=0.8)')+xlab('X')

#binomial

x=rbinom(10000,100,0.1)
d=data.frame(x=x)
p1=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='skyblue2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Binomial(n=100,p=0.1)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:100))
p1

x=rbinom(10000,100,0.5)
d=data.frame(x=x)
p2=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='palevioletred2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Binomial(n=100,p=0.5)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:100))
p2

x=rbinom(10000,100,0.9)
d=data.frame(x=x)
p3=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='aquamarine2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Binomial(n=100,p=0.9)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:100))
p3

multiplot(p1,p2,p3)

# Poisson

x=rpois(10000,5)
d=data.frame(x=x)
p1=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='skyblue2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Poisson(lambda=5)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:150))
p1

x=rpois(10000,20)
d=data.frame(x=x)
p2=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='palevioletred2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Poisson(lambda=20)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:150))
p2

x=rpois(10000,100)
d=data.frame(x=x)
p3=ggplot(d,aes(x=as.factor(x)))+
  geom_bar(fill='aquamarine2',color='white',aes(y=..count../sum(..count..)))+
  ylab('Poisson(lambda=200)')+xlab('X')+scale_x_discrete(breaks= pretty_breaks(),limits=c(1:150))
p3

multiplot(p1,p2,p3)


#exponential

x=rexp(10000,0.5)
d=data.frame(x=x)
p1=ggplot(d,aes(x=x))+
  geom_histogram(bins=300,fill='aquamarine2',color='aquamarine2',aes(y=..count../sum(..count..)))+
  ylab('Exp(lambda=0.5)')+xlab('X')+scale_x_continuous(limits=c(0,10))
p1

x=rexp(10000,5)
d=data.frame(x=x)
p2=ggplot(d,aes(x=x))+
  geom_histogram(bins=300,fill='skyblue2',color='skyblue2',aes(y=..count../sum(..count..)))+
  ylab('Exp(lambda=5)')+xlab('X')+scale_x_continuous(limits=c(0,10))
p2


x=rexp(10000,10)
d=data.frame(x=x)
p3=ggplot(d,aes(x=x))+
  geom_histogram(bins=300,fill='palevioletred2',color='palevioletred2',aes(y=..count../sum(..count..)))+
  ylab('Exp(lambda=10)')+xlab('X')+scale_x_continuous(limits=c(0,10))
p3

