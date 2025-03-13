setwd("~/arch/second_year/pas/")
#'#library(PA)
#'#round((9/2)*4-sqrt(10)+log(6)-exp(1),3)
#'#countby5 <- seq(from=5,ro=100,by=5)
#'#countby5
u <- c(1,2,5,4)
v <- c(2,2,1,1)
#'#which(u==5)
which(v>=2)

u
c(u,v)
u*c(u,v)
g <- seq(from=1,to=10)
g[1:3]
j <- seq(from=1,to= 30,by=2)
j[c(1,3,5)]

q <- c(3,0,1,6)
r <- c(1,0,2,4)
q %*% r
x <- cbind(u,v);x
y <- cbind(u,v);y
#w <- x %*% y;w
library(PASWR2)
head(VIT2005)
wheatspain <- wheat.surface
max(wheatspain)

BABIES <- read.table(file = "babies.data")

head(BABIES)
dim(BABIES)
summary(BABIES)
#BABIES$bwt[BABIES$bwt == 999] <- NA

#BABIES$gestatoin[BABIES$gestation==999] <- NA
CLEAN <- na.omit(BABIES)
dim(BABIES)
dim(CLEAN)
complete.cases(BABIES)






