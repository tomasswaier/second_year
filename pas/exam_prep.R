library(PASWR2)


#2.

mean1 <- -30*0.7 + -5*0.1 + 0*0.1 + 30*0.1
mean1

7*3 + 12/2 -7^2 +sqrt(4)
setwd("~/arch/second_year/pas/")
getwd()
#log() exp() sin() ...
cos(3)
vectorMeow<-c(1,2,3)
vectorMeow
pi
Inf
#large num
library(PASWR2)
lifetimesA<-PASWR2::BATTERY$lifetime[PASWR2::BATTERY$facility=="A"]
lifetimesB<-PASWR2::BATTERY$lifetime[PASWR2::BATTERY$facility=="B"]
plot(lifetimesA, type="l", col="blue", ylim=range(c(lifetimesA, lifetimesB)))
lines(lifetimesB, col="red")
lifetimesA
stem(lifetimesA)

#3

adam <- choose(11,5)
adam
brano <- choose(11,6)
brano

help(rnorm)
grades<-c ( "A" , "D" , "C" , "D" , "C" , "C" , "C" , "C" , "F" , "B" )
grades
table(grades)
names(which.max(table(grades)))
table(grades)/length(grades)
prop.table(table(grades))
  library(MASS)

x <- c(1, 2, 2, 2, 2, 3, 3, 3, 4)
boxplot(x,horizontal = TRUE)
quine$Age
table(quine$Age)
with(data=quine,table(Age))
help(barplot)
barplot(table(quine$Age))
#5
#RANO
#RANA

rano <- factorial(4)
rano

rana <- factorial(4)/factorial(2)
rana

#6

x <- -4
u <-7
w <- (x)^u
w


data<-BABERUTH$hr[BABERUTH$team=="NY-A"]
my_breaks<-seq(10,70,10)
histogram(data)
hist(data,breaks=my_breaks)
table(data)
mean(data)
median(data)
studentMatrix<-matrix(c(73,75,74,74,95,94,12,95,66,67,63,100),byrow = TRUE,nrow=3)
student1<-c(73,75,74,74)
student2<-c(95,94,12,95)
student3<-c(66,67,63,100)
together<-rbind(student1,student2,student3)
colnames(together)<-c("Test1","Test2","Test3","Test4")
means<-apply(together,1,mean)
medians<-apply(together,1,median)
wholeTable<-cbind(together,means,medians)
wholeTable

#9

pera <- 0.72 * 0.02 + 0.28 * 0.11
pera * 100

help(colnames)
help(cbind)
fivenum(student1)

boxplot(Cars93$Min.Price)


first<-boxplot(BODYFAT$fat[BODYFAT$sex=="M"])
second<-boxplot(BODYFAT$fat[BODYFAT$sex=="F"])
help(multiplot)
boxplot(fat ~sex , labels=c("Female","Male") ,data=BODYFAT,col=c("gray","red"))
quantile(BODYFAT$age)

u <- c(1, 2, 5, 4)
v <- c(2, 2, 1, 1)
which(u==5)
u*c(u*v)

#10

top <- 0.94*0.05 
bot <- top + 0.94*0.045
top/bot


#11
z <-c(-9,-3,-6,0)
s <- c(1,1,0,1)

z%*%s

dim(VIT2005[VIT2005$totalprice >=400000 & VIT2005$garage >=1, ])[1]
VIT2005[VIT2005$totalprice>=40000  & VIT2005$garage>=1,]
community<- WHEATSPAIN
min(WHEATSPAIN$acres)
sort(WHEATSPAIN$acres,decreasing = FALSE)
wheat.surface <- c(18817, 65, 440, 25143, 66326, 34214,
                   + 311479, 74206, 7203, 619858, 13118, 263424, 6111, 9500,
                   + 143250, 558292, 100)
wheat.surface
wheat.spain <- data.frame(community,wheat.surface)
wheat.spain
wheat.spain[wheat.spain$wheat.surface == max(wheat.spain$wheat.surface),]
wheat.c<-wheat.spain[wheat.spain$community !="Australia" ,]
australia_elper<-wheat.spain[wheat.spain$community=="Australia",]
connected<-rbind(wheat.c,australia_elper)
connected
choose(90,8)
choose(6,2)*choose(7,2)*choose(10,3)*choose(5,3)
factorial(7)/factorial(2)
factorial(11)/(factorial(2)*factorial(2))
#statistics
factorial(10)/(factorial(3)*factorial(2)*factorial(3))
#11f 7m
choose(11,3)*7/choose(18,4)
11*choose(7,3)/choose(18,4)
0.98*0.02+0.98*0.02


my.data<-c(1,2,3,Inf,NaN)
mean(my.data)



newData<-c(1, 2, 2, 3, 3, 4, 4, 4)
boxplot(newData,horizontal = TRUE)
help(boxplot)
0.04*0.05/(0.4*0.05+0.3*0.04+0.2*0.02+0.1*0.01)
z<-c(-3, -10, -1, -6)
x<-c(1, 0, 2, 4)
sum(z*x)
0.72*0.02+0.28*0.11
choose(12,8)
community$acres
quantile(community$acres)
100/90*80

ggplot(data=community,aes(x=community,y=acres,fill=community)) +geom_bar(stat="identity", show.legend=FALSE)

ggplot(community, aes(x=community, y=acres, fill=community)) +
  geom_bar(stat="identity", show.legend=FALSE) +
  labs(title="Vek osôb", x="Meno", y="Vek") +
  theme_minimal()

thing<-rep(c(3,5,7,10),+c(10,20,30,40))
mean(thing)
(3*0.1+5*0.2+7*0.3+10*0.4)/2
