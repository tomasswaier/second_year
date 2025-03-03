setwd("~/arch/second_year/pas/")
library(PASWR2)
library(MASS)
#gets u to documentation
help(package="MASS")

# gets to u documentation of a function
help(lqs,package = "MASS")
# returns all used packages
search()
#all packages
library(Cars93)


# task num2 
head(Cars93)
hist.min.prince<-ggplot(data=Cars93,aes(x=Min.Price,y=..density..))+ geom_histogram(fill='red',binwidth = 5)+ geom_density(col='darkred',size=1)
hist.max.price<- ggplot(data=Cars93,aes(x=Max.Price,y=..density..))+ geom_histogram(fill='red',binwidth = 5)+ geom_density(col='darkred',size=1)
hist.weight<-ggplot(data=Cars93,aes(x=Weight,y=..density..))+ geom_histogram(fill='red',binwidth = 100)+ geom_density(col='darkred',size=1)
hist.length<-ggplot(data=Cars93,aes(x=Length,y=..density..))+ geom_histogram(fill='red',binwidth = 5)+ geom_density(col='darkred',size=1)
multiplot(hist.max.price,hist.min.prince,hist.weight,hist.length,layout=matrix(c(1,2,3,4),byrow=TRUE,nrow=2))


bwplot(data=Cars93,Price ~DriveTrain|Type)

#aint workin
ggplot(data=Cars93,aes(x=DriveTrain,y=Price)+geom_boxplot())
WHEATSPAIN


quantile(WHEATSPAIN$hectares)
quantile(WHEATSPAIN$hectares,probs=seq(from=0,to=1,by=0.1))

mean(WHEATSPAIN$hectares)
max(WHEATSPAIN$hectares)
min(WHEATSPAIN$hectares)
IQR(WHEATSPAIN$hectares)
q1<-quantile(WHEATSPAIN$hectares)[2]
q1
q3<-quantile(WHEATSPAIN$hectares)[4]
q3-q1
var(WHEATSPAIN$hectares)
#standard deviation
sd(WHEATSPAIN$hectares)
sum(WHEATSPAIN$hectares)

describe<-function(x){
  Quantile<-quantile(x)
  Mean<-mean(x)
  Var<-var(x)
  SD<-sd(x)
  Total<-sum(x)
  Range<-range(x)
  print(c(Quantile=Quantile,Mean=Mean,Var=Var,SD=SD,Total=Total,Range=Range))  
}
describe(WHEATSPAIN$hectares)


quantile(WHEATSPAIN$hectares,probs=0.1)
WHEATSPAIN[WHEATSPAIN$hectares < quantile(WHEATSPAIN$hectares,probs=0.1),]
quantile(WHEATSPAIN$hectares,probs=0.9)
WHEATSPAIN[WHEATSPAIN$hectares > quantile(WHEATSPAIN$hectares,probs=0.9),]

WHEATSPAIN.sorted <-WHEATSPAIN[order(WHEATSPAIN$hectares),]
which(WHEATSPAIN.sorted$community=="Navarra")
percentile <-10/(length(WHEATSPAIN$hectares)-1)
quantile(WHEATSPAIN$hectares,probs = percentile)



ggplot(data=WHEATSPAIN,aes(x=acres))+geom_histogram(fill="green")


ggplot(data=WHEATSPAIN,aes(x=acres,y=..density..))+geom_histogram(fill="green")+ geom_density(col="blue",size=1)

hist(WHEATSPAIN$acres,breaks=c(0,100000,250000,360000,1550000))
WHEATSPAIN$acres.cat<-cut(WHEATSPAIN$acres,breaks=c(0,100000,250000,360000,1550000))
WHEATSPAIN
ggplot(data=WHEATSPAIN,aes(x=acres))+geom_bar()
ggplot(data=WHEATSPAIN,aes(x=acres,y=..density..))+geom_histogram(fill="green",breaks=c(0,100000,250000,360000,150000))+geom_density(col="red")


ggplot(data=WHEATSPAIN,aes(x=acres,y=..density..))+geom_histogram(fill="green",breaks=c(0,100000,250000,360000,150000))+geom_density(col="red")+geom_vline(xintercept=mean(WHEATSPAIN$acres))
