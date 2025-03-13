# Tomáš Meravý Murrárik
#Znenie ulohy> Predavac aut si zaposoval kolko aut predal pocas siedmuch dni , od Pondelka do Nedele.
#To su data zoradené podľa dní Predaj = 2,2,4,4,6,7,10
#

#vytvorenie array
arr<-c( 2,2,4,4,6,7,10)
#vytvorenie SD
sd(arr)
IQR(arr)# potrebne na odpoved
mean(arr)
median(arr)
#mean > median so it's skewed to the right but I realized that only after I sent the answer
boxplot(arr,horizontal=TRUE)# zobrazenie dat
