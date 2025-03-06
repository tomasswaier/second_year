setwd("~/arch/second_year/pas/")
getwd()
library(PASWR2)
library(MASS)
tourists <- matrix(data = c(9.303, 9.536, 9.918, 
                            7.959, 7.736, 8.875, 
                            15.224, 15.629, 16.090, 
                            0.905, 0.894, 0.883, 
                            17.463, 18.635, 20.148), 
                   byrow = TRUE, nrow = 5)
tourists


row.names(tourists)<-c("German","french","British","American","Rest")
colnames(tourists)<-c("2003","2004","2005")
dimnames(tourists)<-list(c("German","french","British","American","Rest"),c("2003","2004","2005"))
tourists

apply(tourists,1,sum)
apply(tourists,2,sum)
for (celsius in seq(18,28,2)) {
  f<-(9/5)*celsius+32  
  print(c(celsius,f))
}
head(WHEATUSA2004)
quantile(WHEATUSA2004$acres,probs = seq(0,1,0.1))
max(WHEATUSA2004$acres)
IQR(WHEATUSA2004$acres)
mean(WHEATUSA2004$acres)


below20<-quantile(WHEATUSA2004$acres,probs=0.2);below20
WHEATUSA2004[WHEATUSA2004$acres<below20,]
above80 <-quantile(WHEATUSA2004$acres,probs=0.8)
WHEATUSA2004[WHEATUSA2004$acres>above80,]



head(VIT2005)
table(VIT2005$out)
ggplot(data=VIT2005,aes(x="",fill=out))+geom_bar() +coord_polar("y")







