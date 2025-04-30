#Tomas MEravy Murarik 
#cvicenieU 16:00 A
#1
pnorm(0.54, 0.55, 0.011)
#3
1-pnorm(0,75-80,sqrt(10^2+15^2))
#4
set.seed(666)
p <- rbinom(10000, 1000, 0.5)
mean(p)
sd(p)
#10
without <- choose(4, 3)
without

with <- factorial(4 + 3 - 1) / (factorial(4 - 1) * factorial(3))
with

#6 FALSE
p <- rpois(625, 0.55)
# Normal Distribution
library(lattice)
histogram(p)
mean(p)
sd(p) 

#8
1-ppois(2,4)
help(ppois)
#9
first = 50 + 45 + 130
second= 5 ^ 2 + 6 ^ 2 + 13 ^ 2
first
second

1 - pnorm(210, 225, sqrt(230))


sum(dbinom((20 * 0.4) : (20 * 0.6), 20, 0.37))


help(dnorm)
