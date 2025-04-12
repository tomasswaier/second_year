library(PASWR2)
#uloha 2 
#a)  P(x<3)
pt(3,df=5)

#b) P(2<3)
pt(3,df=5)-pt(2,df=5)
#c ) p(x<a) = 0.05
qt(0.05,df=5)

#uloha 4
# P(a<x<b)
a<- qchisq(0.05,10); a
b <-qchisq(0.95,10
);b
#5
#P(X<8)
#6 F-rozdelenie - fisherovo
#p(x<1)
pf(1,2,5)
#p(x<m)=0.5
qf(0.5,2,5)
#P(x<a)=0.1
qf(0.10,2,5)
