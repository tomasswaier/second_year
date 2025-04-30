#' Cviko 5
#' PhDr. Kkt. Ing. Šimon Mizerák s.r.o.

#All of these functions determine how much space is under the graph curve
#Each distribution has it's own graph shape:
#Normal = Gaussian = Bell curve
#Poisson = shape determined by lambda
#Exponentiation = looks like an exponential curve
#Binomial = Bernoulli = looks like two vertical lines on either sides
#Geometric = starts high, ends low
#if you don't understand, Google these distributions

#for every function there are 4 variants
#d = value for a given value = distribution function
#p = probability for a range of a random variable 
#q = value of a quantile for a random variable
#r = random value from a given vector

#' Exercise 1
#' Let X be Poisson's random variable with a middle value of 2 (lambda).
#' Find P(X = 0), P(X >= 3) & P(X? <= k) >= 0.7

#Poisson is mainly used if we are dealing with a range of random variables dependent
#on another variable (lambda)

#a) P(X = 0)
dpois(0, 2)

#b) P(X >= 3)
#P(X >= 3) = 1 - P(x < 3)
ppois(2, 2, lower = FALSE) #if TRUE => P(X <= lambda) else P(X > lambda)
1  - ppois(2, 2) #same but mathematically done

#c) P(X? <= k) >= 0.7
#we want the value for quantile 70%
qpois(0.7, 2)

#' Exercise 2
#' Let X be an exponentially random variable Exp(lambda = 3).
#' Find P(2 < X < 6)

#This function tells us the distance of two random events in a Poisson distribution

#P(2 < X < 6) = P(X < 6) - P(X < 2)
#basically, how much space does X take up between 2 and 6
pexp(6, 3) - pexp(2, 3)


#' Exercise 3
#' Let X be a normal random variable N(mi = 7, sigma = 3).
#' Find P(X > 7.1)
#' Find the value of k if P(X < k) = 0.8

#X ~ N(mi, sigma ^ 2) (X is approximitaly the value of this function)
#mi tells us where the top of the graph is at
#sigma tells us how thin the bell of the curve will be

#a) P(X > 7.1)
#P(X > 7.1) = 1 - P(X <= 7.1)
pnorm(7.1, 7, 3, lower = FALSE)
1 - pnorm(7.1, 7, 3) #same but mathematically done

#b) P(X < k) = 0.8
#basically, when does the variable X take up 80% of the are under the graph
qnorm(0.8, 7, 3)


#' Exercise 4
#' Let X be a normal random variable N(mi = 3, sigma ^ 2 = 0.5)
#' Find P(X > 3.5)

#careful, because we got sigma ^ 2, so we need to put the square root into the function
#this is because the function takes the given value of sigma and squares it

pnorm(3.5, 3, sqrt(0.5), lower = F) 
1 - pnorm(3.5, 3, sqrt(0.5)) #same but mathematically done


#' Exercise 8
#' A distributor knows, that 80% of socks delivered are in good condition.
#' We randomly take 60 socks. 
#' Find the probability, that 70-90% of socks chosen are in good condition.

#we only have two possible states the socks can be in: good and bad condition
#this means we are looking at a Binomial distribution
#we need to do a Bernoulli experiment for each percentage we need
#we sum them all up and get our final probability 

dbinom((60 * 0.7):(60 * 0.9), 60, 0.8)
sum(dbinom((60 * 0.7):(60 * 0.9), 60, 0.8))
sum(dbinom(42:54, 60, 0.8)) #same but prettier

#' Exercise 9
#' It is known that 3% of tomato seeds won't grow. 
#' These seeds are sold in packets with 20 seeds each.
#' The package guarantees that 18 seeds will surely grow.
#' Find the probability that a randomly selected packet will grow less than 18 of seeds.

#again, this is a standard Binomial distribution, the seeds will either grow or won't

pbinom(17, 20, (1 - 0.03))
pbinom(17, 20, 0.97) #same but prettier


#' Exercise 11
#' We are observing the top of a road.
#' Let us assume that the average number of cars passing a certain point is 2 cars per 30 seconds
#' a) Find the probability that 3 or more cars will pass the point in 30 seconds
#' b) Find the probability that 10 or more cars will pass the point in 3 minutes

#we have a changing variable (cars passed)
#this means we'll use Poisson with lambda being the number of cars passed in 30 seconds

#a) 3+ cars / 30 sec
ppois(3, 2, lower = FALSE)

#b) 10 + cars / 3 min

#the times have changed (literally) and we need to calculate our new lambda
#if 2 cars pass every 0.5 min (30 secs), then for 3 mins the number of cars passed will be
# 3 * 2 / 0.5 = 12

ppois(10, 12, lower = FALSE)


#' Exercise 14
#' The lifetime of an engine follows a Normal distribution, mi = 10, sigma = 3.5
#' The manufacturer will repair the faults for free within the guarantee period of it's life.
#' The manufacturer doesn't want to replace more than 4% of cars.
#' What is the largest guarantee period he can achieve this in?

#P(x <= k) = 0.04
#the 0.04 is a quantile

qnorm(0.04, 10, 3.5)


#' Exercise 19
#' The hardness of a metal plate follows a Normal distribution with mi = 60, sigma = 2.
#' a) This metal plate will conform standards if it's measure is between 57 and 65.
#' Find the percentage of this range.
#' b) A contractor will buy these plates if 4 out of 4 of these plates are in the range of a).
#' Find the probability of this happening.
#' c) An acceptable plate is one, who's hardness does not deviate a value of "c" from the middle value.
#' Find the value of c, so that 97% of plates are acceptable.
#' d) Find the probability that 10 out of 20 plates have a hardness greater than 60.

#a) P(57 <= X <= 65)
p <- pnorm(65, 60, 2) - pnorm(57, 60, 2)
p

#b) P(X = 4) 
#we have to do a Bernoulli (Binomial) experiment to determine if an acceptable plate is chosen
#we need to choose four acceptable ones out of four
#we already calculated the probability of a plate conforming the standards in a)

dbinom(4, 4, p)

#c) middle value = 60
#we don't want the value c itself but the difference between it and the middle 

k <- qnorm(0.97, 60, 2)
k - 60

#d)
#again we'll do a Binomial experiment, because the plates will either have the value or won't

pbinom(10, 20, 0.5)


#' Exercise 20
#' The weekly production of a banana plantation can be modeled as a Normal distribution
#' Mi = 5, Sigma = 2
#' a) Find the probability that during 1 out of 8 randomly selected weeks the production will be less than 3 tons.
#' b) Find the probability that at least 3 randomly selected weeks will yield a production of more than 10 tons

#a)
#another binomial distribution, where we choose, if the random week contains more than 3 tons
#first we calculate the probability of getting less than 3 tons

p <- pnorm(3, 5, 2) 
dbinom(1, 8, p)

#b) 
#P(X > 10) = 1 - P(X <= 10)
#P(X >= 3) = 1 - P(X < 3)
#first we calculate the probability of getting more than 10 tons
#because the probability of a) happening even once is minuscule and because we don't have any
#other variables available, we will use a geometric distribution

k <- 1 - pnorm(10, 5, 2)
pgeom(2, k, lower = FALSE)


#tube has mean of 5 std 0.03 .If thickness is mean of 0.5 std 0.001 they. both are independant
#find mean and std
VZ<- 0.03^2 + 4*0.001^2
VZ
SZ<-sqrt(VZ)
SZ
#flow of water in canal is N(100,20) capacity is N(120,30), sluice gate is opened when flow exceeds capacity
#what is prob that canal will open ?
1-pnorm(0,100-120,sqrt(20^2+30^2))

#cereal manufacturer creates a new cereal with mean 8.2 per box std 0.25,12.4 with std 3 and 4.1 width std 1/2
#a)what are mean and std of amount of ingredients if they are independent
sqrt(0.25^2+3^2+0.5^2)

#if box is advertised as having 24 what percent of time will the actual be at least what is advertised
pnorm(24,8.2+12.4+4.1,sqrt(0.25^2+3^2+0.5^2),lower=FALSE)


#' Cviko 8
#' PhDr. Kkt. Ing. Šimon Mizerák s.r.o.

#' 6.2
#Student Test distribution is similar to a Gaussian (Normal) distribution in shape.
#It's two parameters are a random variable X and df (degrees of freedom). For this
#exercise df = 5.


#t5
#a) P(X < 3)
pt(3, 5)

#b) P(2 < X < 3)
pt(3, 5) - pt(2, 5)

#c) P(X < a) = 0.05
qt(0.05, 5)

#'6.4
#Here we are working with a Chi-squared distribution, which is skewed to the right
#(the tip is to the left). Chi squared also has a degrees of freedom as a variable.ň
#In this exercise the df = 10.

a <- qchisq(0.05, 10)
a

#we have to be careful because in order to calculate b we need to add the probability
#of being in X < a and the probability of being in a < X < b.

b <- qchisq(0.95, 10)
b

#'6.5
#a) P(X < 8)
pchisq(8, 10)

#b) P(X > 6)
pchisq(6, 10, lower.tail = F)

#c) P(X < a) = 0.15
qchisq(0.15, 10)

#d) E(x), D(x)
#In a Chi Squared distribution the mean, E(x) = df and the variance, D(x) = 2 * df
#So in this case the mean is 10 and the variance is 20.

#'6.6
#Here we are working with a Fisher distribution, or an F-distribution. F-distribution
#throws a little wrench into the mix, because it has two degrees of freedom (m & n).
#The graph is the same as a Chi-Squared distribution with the only exception being the two df's.
#(similar to Poisson and Exponential distributions)

#a) P(X < 1), median(X)
pf(1, 2, 5)

#median is the middle value, so let's find the value in the 0.5 quantile
qf(0.5, 2, 5)

#b) P(X < a) = 0.1
qf(0.1, 2, 5)

#c) E(X), D(X)
#mean = d2 / d2 - 2, if d2 > 2
5 / (5 - 2)

#variance = (2 * (d2) ^ 2 * (d1 + d2 - 2)) / (d1 * (d2 - 2) ^ 2 * (d2 - 4)), if d2 > 4
(2 * (5 ^ 2) * (2 + 5 - 2)) / (2 * (5 - 2) ^ 2 * (5 - 4))

#'6.18
#so we have two normal distributions: X ~ N(1.5, 0.1 ^ 2), Y ~ N(1, 0.09 ^ 2)

#a) 
#We basically need to find out if the difference of the random measurements is > 0.45.
#We create a distribution for X - Y ~ N(1.5 - 1, (0.1 ^ 2 / 15 + 0.09 ^ 2 / 20) ).
#Now we just find P(X - Y > 0.45):

pnorm(0.45, 0.5, sqrt((0.1 ^ 2 / 15 + 0.09 ^ 2 / 20)), lower.tail = F)

#b)
#Here we have to assume the means are unknown but the same length. We have two hypothesis:
#H0: meanX - meanY = delta
#H1: meanX - meanY != delta
#In order to calculate this we use a Student T-test (this test can only be used on N distributions)
#T0 = (difference of means - delta) / (standard deviation * sqrt(df))
#in our case delta is equal to Sx ^ 2 - Sy ^ 2 and the df = (1/15 + 1/20)

#I don't really feel like writing all this out, but T0 = -1.55115. Now we find the T1 value.
#the syntax is pt(T0 value, 1 - degrees of freedom)

pt(-1.55115, 33)
1 - pt(-1.55115, 33)

#Here we can see that H0 only has a 0.07 chance of happening, while the chance of
#H1 happening is 0.93, which means we take H1 as the correct hypothesis.

#TODO: read about T-tests in the book, it's a lot more complicated

#'6.22
#a)
#we are given the mean and SD (so we just put them into the formula)
#first off, simple exercise. We just calculate P(X < 1.49)
pnorm(1.49, 1.5, 0.01)

#b)
#we gotta calculate P(X > 1.54 | X > 1.49)
#remember conditioned probability? P = P(X > 1.54 & X > 1.49) / P(X > 1.49)
#and P(X > 1.54 & X > 1.49) = P(X > 1.54), since every X > 1.54 already includes X > 1.49
#after we just use a binomial distribution (we only have two states: Yes and No)

probability <- pnorm(1.54, 1.5, 0.01, lower.tail = F) / pnorm(1.49, 1.5, 0.01, lower.tail = F) 
pbinom(0, 50, probability)

#c) Homework

#' Cviko 9
#' PhDr. Kkt. Ing. Šimon Mizerák s.r.o.

library(ggplot2)
library(lattice)
library(PASWR2)
library(e1071)

#' We'll be practicing, what we learned (or didn't) in the last two lectures.
#' So estimators and acceptability ranges are gonna be the main point this time.

# Skewness tells us what side the graph will lean on. 
# If skewness = 0, then the graph is symmetrical (no skewness)
# If skewness < 0, then the graph is angled to the right (left/negative skewness)
# If skewness > 0, then the graph is angled to the left (right/positive skewness)

#' 7.1 Use the data from the data frame WHEATSPAIN to answer the questions:
# a) Find the mean, median, MAD, standard deviation, and IQR of the surface 
# area measured in hectares.

with(data = WHEATSPAIN, c(mean(hectares),
                          median(hectares),
                          mad(hectares, constant = 1),
                          sd(hectares),
                          IQR(hectares)))
boxplot(WHEATSPAIN$hectares, horizontal = T)
skewness(WHEATSPAIN$hectares)

# b) Remove the Castilla-Leon community and again find the mean, median, MAD, 
# standard deviation, and IQR of the same variable. Which statistics are 
# preferred as measures for these data? Comment on the results.

NCL <- subset(WHEATSPAIN, subset = community != "Castilla-Leon")
with(data = NCL, c(mean(hectares),
                   median(hectares),
                   mad(hectares, constant = 1), #good kidd, m.a.a.d. city
                   sd(hectares),
                   IQR(hectares)))
boxplot(NCL$hectares, horizontal = T)
skewness(NCL$hectares)

# We should use median and SD for a), because the data is more robust. However,
# inside b), we should use median AND IRQ, because it's not as skewed as SD. We
# decide this based on skewness and based on what represents the data better.
# In a) we use SD, because Castilla-Leon skews the data, however, if we remove it in b),
# then we don't need the SD anymore, so we use IRQ.

#' 7.2 Given the estimators of the mean T1 = (X1 + 2X2 + X3)/4 and T2 = (X1 + X2 + X3)/3,
#' where X1, X2, X3 is a random sample from a N(mi, sigma ^ 2) distribution, prove that T2 
#' is more efficient than T1.

# Let's break this down. We have an estimator, which gives us an approximate value of
# a random variable X. We have two of these estimators and we have to prove, that T2
# is a more efficient and precise estimation, than T1. 

# The mean of T1 and T2 are mi (why this is, go check cviko_5). Efficiency is a value,
# given by the formula D(T2)/D(T1) and this value has to be less than 1 (this would mean
# that T2 has a higher efficiency value than T1).

# D(T1) = Var(X1 + 2X2 + X3) / (4 ^ 2)
# D(T1) = (sigma ^ 2 + (2 * sigma) ^ 2 + sigma ^ 2) / 16
# this is a normal distribution, so sigma = 1
# D(T1) = (1 + 4 + 1) / 16 = 6 / 16 = 3 / 8

# D(T2) = Var(X1 + X2 + X3) / (3 ^ 2)
# D(T2) = 3 * sigma ^ 2 / 9
# D(T2) = 3 / 9 = 1 / 3

(1/3) / (3/8)

# We have proven this to be correct, because the division < 1.

#' 7.3 Given a random sample of size n + 1 from a N (mi, sigma ^ 2) distribution, show that the median,
#' m, is roughly 64% less efficient than the sample mean for estimating the population mean.
#' (Hint: In large samples, Var(m) = pi * sigma ^ 2 / 4n.).

# We're gonna change the exercise to a sample size of n and Var(m) = pi * sigma ^ 2 / 2n)
# We tried doing it the way it is in the book, but it just didn't add up.
# #FOUND WHY! So they fucked up the formula in the book, it's supposed to be 2n. You can keep
# the n + 1 sample, but you gotta use 2n instead of 4n, when counting Var(median).

# We just gotta do the same shit as in the last exercise. Var(mean) / Var(median) >= 0.64.
# We already have the formula for Var(median), so now we gotta write Var(mean).
# We've already seen how we calculate the Var for a random variable but what if we don't have one?
# In this case Var(mean) = n * sigma ^ 2 / n ^ 2.
# After a few divisions of fractions, we get:

2/pi

#As we can see, the efficiency is about 0.64, so we have proven this to be correct.

#' 8.1  Is [ mean - 3, mean + 3] a confidence interval for the population mean of a normal distribution?
#' Why or why not?

# The answer is simple. Since the interval is symmetrical on both sides from X, and we know
# that the mean of N distribution is right in the middle, we can assume that the range 
# is a confidence interval for the mean of an N distribution.

#' 8.2

# Oh boy, this is a doozy. Alright, I'm gonna be square with you, during this part, 
# she was just yapping about everything all at the same time and it's hard to make 
# notes of. I'll make some notes sometime later and share them before the next test.

# Fun fact, 68.28% of all data is found within ± sigma of a N, 95.45% in ± 2sigma and
# 99.73% in ± 3sigma.

#' 8.3 Given a random sample {X1, X2, . . . , Xn} from a normal population N (mi, sigma ^ 2), 
#' where sigma is known:

# a) What is the confidence level for the interval mean ± 2.053749 sigma / sqrt(n)?
# Basically, we gotta find, what area is outside of the confidence range. We take
# the confidence range (from -x to mean) and multiply it by 2 (so it's from -x to x).
1 - pnorm(- 2.053749) * 2

# b) What is the confidence level for the interval mean ± 1.405072 sigma / sqrt(n)?
1 - pnorm(- 1.405072) * 2

# c) What is the value of the percentile z(alpha/2) for a 99% confidence interval?
# We know that the value outside of the interval takes up 1%, so we gotta find the value
# up until 0.5% (because the sum of both sides needs to be 1%).
qnorm(0.005)

# 
#------------------------------------------------------------------------------------------------
#' Zapocet Leak
#' 1.The pill weight for a particular type of vitamin follows a normal distribution with a mean
#'  of 0.5 grams and a standard deviation of 0.016 grams. Find the probability that a randomly 
#'  choosen pill is less than 0.48 grams. Round to three decimal places.
pnorm(0.48, 0.5, 0.016)

#' 2.
# With 4 bikes per 20 minutes crossing the checkpoint, that's 2 bikes per 10 minutes
1 - ppois(5, 2)

#' 3.A toy manufacturing company sources its miniature car models
#from a supplier in Japan. Quality control tests indicate that 60%
#of these car models meet the company's high standards for
#quality. The company decides to randomly select a sample of 20
#car models to inspect. Find the probability that a percentage
#between 80% to 90% (inclusive) of the sample is suitable for
#sale. Round it to three decimal places
sum(dbinom((20 * 0.8) : (20 * 0.9), 20, 0.6))

#' 4.
# to find distribution for diesel we do demand - supply 
# N(Z) ~ (75 - 80, 10 ^ 2 + 15 ^ 2) = (-5, 325)

1 - pnorm(0, -5, 325)

#' 5.Reserachers studies the weight and height of adult female in
#Slovakia. Let X=weight (in kilograms) and Y= height (in cm). The
#researchers found that E[X]=73, E[Y]=163, Var[X]=49,
#Var[Y]=81, E[XY]=12000. Choose all statements that are correct.
#Vyberte ľubovoľný počet možných odpovedí. Správna nemusí byť žiadna, ale tiež
#môžu byť správne všetky.
# X & Y are independent
73 * 163 #FALSE, because E(X, Y) != E(X) * E(Y)

# covariance = 0
covar <- 12000 - (73 * 163) #FALSE
covar

# height increases so does weight
covar / (sqrt(49) * sqrt(81)) #TRUE, because we have a positive correlation

# X & Y are dependent 
73 * 163 #TRUE, because E(X, Y) != E(X) * E(Y)

# covariance = 101
covar #TRUE

#' 6.
#' A chocolate factory produces a special blend of milk chocolate
#bars that incorporates cane sugar, milk powder, and cocoa mass.
#The production process is designed so that, on average, each bar
#contains 50 grams of cane sugar with a standard deviation of 5
#grams, 45 grams of milk powder with a standard deviation of 6
#grams, and 130 grams of cocoa mass with a standard deviation of
#13 grams. The bars are marketed as having a total weight of 210
#grams. Assuming the weights of cane sugar, milk powder, and
#sugar all follow independent normal distributions, calculate the
#percentage of chocolate bars that will actually meet or exceed the
#advertised weight of 210 grams. Round the answer into three
#decimal places.
# X ~ N(50, 5)
# Y ~ N(45, 6)
# Z ~ N(130, 13)
# W = X + Y + Z = N(50 + 45 + 130, 5 ^ 2 + 6 ^ 2 + 13 ^ 2) = N(225, 230)

1 - pnorm(210, 225, sqrt(230))

#' 7.Assume that 400 data points were collected as a random sample
#from an exponential distribution, where 0.4 is the population
#mean of such distribution. What is the approximate sampling
#distribution of the mean of the collected data?
#  Vyberte ľubovoľný počet možných
p <- rpois(400, 0.4)

# Normal Distribution
library(lattice)
histogram(p) #FALSE

# Mean = 0.001
mean(p) #FALSE

# Mean = 0.4
mean(p) #TRUE

# SD = 0.4
sd(p) #FALSE

#' 8.A population has the following elements: 422, 425, 427, 431.
#Enumerate all the samples of size 3 that can be drawn with and
#without replacement. Which statements are true:
without <- choose(4, 3)
without

with <- factorial(4 + 3 - 1) / (factorial(4 - 1) * factorial(3))
with

# Correct solutions: without = 4

#' 9.Set the seed equal to 777, and simulate m=10,000 random
#samples of size n=1,000 from a Bernoulli( ). What is
#correct
set.seed(777)
p <- rbinom(10000, 1000, 0.3)

# Sample mean = 0.3
mean(p) #FALSE

# SD = 0.014
sd(p) #FALSE

# SD = 14
sd(p) #TRUE

# Sample mean = 300
mean(p) #TRUE

#' 10Let X be a Poisson random variable with mean equal to 6. Find
#P(X>4). Give the answer in three decimal places.
1 - ppois(4, 6)

