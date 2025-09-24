library(PASWR2)
RAT

ggplot(data=RAT,aes(sample=survival.time))+stat_qq()+stat_qq_line()
#ci for population mean when sd not known
#mean(x)-t(1-a/2;n-1)s/sqrt(n)...
mean(RAT$survival.time)#x
sd(RAT$survival.time)#s
length(RAT$survival.time)
#1-d/2
#0.92 ( in problem text) 1-d/2 = 0.96
#n-1=19

#113,45 +- 1,85 * 37,78/sqrt20 = 98,65 ; 128,25
t.test(RAT$survival.time,conf.level = 0.92)
#mean(x)-mean(y)-t(1-a/2;vsqrt(s*2x/nx+s*2y/ny))
ggplot(data=GLUCOSE,aes(sample=old-new))+stat_qq()+stat_qq_line()
GLUCOSE




#balls 2 

# P615 :4
#step 3 :critical value - oblast zamietnutia
# t< t-critical value th:m<170
#     >d=0.05           onesided
#       t0.05,df=t0.05,29
#             n-1 = -1699
#step 4 :kedže neplatí , že t<t-critical =>nezamietamme h0
#

#t8
#2 systems fro measuring speed fo a ball. h1 is that system 1 measures faster 
#sppeds so they do 12 tests
#je to p8rov8 vzorka teda sú aj závislé premenné
#1step h0:  rozdiel je <=0    vs h1 rozdiel je >0 alpha je 0.1
diff <- TENNIS$speed1-TENNIS$speed2
diff
#step 2 t=(d-mo)/(sd/sqrt(N0))  = -1329-0/(16,42/sqrt(12))
t<--0.28
sum(diff)
#... idk dud
#proste nezamietame

pnorm(115,100,10)-pnorm(90,100,10)
qnorm(0.9,100,10)


sqrt(0.1*0.9/500)
choose(500,55)*0.1^55*0.9^(500-55)
sig<-sqrt((0.383*0.617)/250)
pnorm(0.402,0.383,sig)-pnorm(0.358,0.383,sig)
pnorm(sqrt(100)-sqrt(129))-pnorm(sqrt(80)-sqrt(129))
1-pnorm(sqrt(520)-sqrt(439))

pexp(6,3)-pexp(2,3)
pnorm(7.1,7,3,lower.tail = FALSE);

qnorm(0.8,7,3);

pnorm(3.5,3,sqrt(0.5),lower.tail = FALSE);
qnorm(0.04,10,3.5)
pnorm(65,60,2)-pnorm(57,60,2)

pbinom(1,8,pnorm(3,5,2))
pnorm(10,5,2)
4/9 * 6/9
64800/3600
choose(5,2)
help(qt)
pt(3,5)-pt(2,5)
qt(0.05,5)
