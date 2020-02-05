

#make sure that we've loaded the copula package
library(copula)



##read in all of the arguments
args = commandArgs(trailingOnly=TRUE)
kor_M1_M2 = args[1]
kor_M1_ratio = args[2]
kor_M2_ratio = args[3]
kor_M1_M2_two = args[4]
kor_M1_ratio_two = args[5]
kor_M2_ratio_two = args[6]
alpha = args[7]
AMetab = args[8] 
BMetab= args[9] 
CMetab= args[10] 

#this is going to be the main function
#whose arguments (for each triplet) will be the correlation between M1 and M2, the correlation between M1 and the ratio of M1/M2
#and the correlation between M2 and the ratio of M1/M2
#as well as alpha (the level of signifcance)

p.gain.simulation<-function(kor_M1_M2, kor_M1_ratio, kor_M2_ratio,kor_M1_M2_two, kor_M1_ratio_two, kor_M2_ratio_two,alpha, AMetab, BMetab, CMetab)
{

library(copula)
korrel<-as.numeric(c(kor_M1_M2, kor_M1_ratio, kor_M2_ratio))
korrelII <- as.numeric(c(kor_M1_M2_two, kor_M1_ratio_two, kor_M2_ratio_two))

#get settings for the gaussian copula here
norm.cop<-normalCopula(korrel^3, dim=3, dispstr="un")
norm.copII <- normalCopula(korrelII^3, dim=3, dispstr="un")
pval1.l<-pval2.l<-pval3.l<-NULL
alpha=as.numeric(alpha)



#for(j in 1:100)
#re-create the copula 10 times
for(j in 1:10)
{
 #test<-rCopula(norm.cop, 5000)
 
 
 ##this is going to be the dummy variable
 theIndicator = c(rep(0,5000),rep(1,5000))
 
 
 #now, we draw from the copula (three dimensions for each triplet)
 test <- (rCopula(5000, norm.cop))
 testII <- (rCopula(5000, norm.copII))
 print(j)
 print("is j")
 
 
 
 #we will build two models, one for each triplet
 #draw values from the distribution of correlation between B and C in control 
 
 ###################
 ###FIRST TRIPLET###
 ###################
 
 #okay, if you are following along take hist of IVNTR1 hist(IVNTR1) to show that it's gaussian
 IVNTR1<- qnorm((rank(test[,1],na.last="keep")-
0.5)/sum(!is.na(test[,1])))
  
  #draw values from the distribution of correlation between B and ratio in control
 IVNTR2<- qnorm((rank(test[,2],na.last="keep")-
 0.5)/sum(!is.na(test[,2])))

 #draw values from the distribution of correlation between C and ratio in control
 IVNTR3<- qnorm((rank(test[,3],na.last="keep")-
 0.5)/sum(!is.na(test[,3])))
 
  
 ###################
 ###SECOND TRIPLET ###
 ###################
 ###second triplet
 #draw values from the distribution of correlation between B and C in second triplet
 #essentially just repeat of everything that we've done for the first triplet
 
  IVNTR1_II<- qnorm((rank(test[,1],na.last="keep")-
0.5)/sum(!is.na(test[,1])))

  #draw values from the distribution of correlation between B and C in second triplet
 IVNTR2_II<- qnorm((rank(test[,2],na.last="keep")-
 0.5)/sum(!is.na(test[,2])))

 #draw values from the distribution of correlation between B and C in second triplet
 IVNTR3_II<- qnorm((rank(test[,3],na.last="keep")-
 0.5)/sum(!is.na(test[,3])))
 
 ###########MODEL BUILDING##########
 ###from the draws from each triplet 
 ##we we will build models, with the draws from the first triplet simply being in 
 
 ##just combine the draws from each triplet's copula 
 #into a single model, distinguing between each using a categorical variable
 #this is the same format as what we have for the models
 #used in the paper, except leveraging data pulled
 #from the copula distributions
 IVNTR1 = as.numeric(rbind(IVNTR1, IVNTR1_II))
 IVNTR2 = as.numeric(rbind(IVNTR2, IVNTR2_II))
 IVNTR3 = as.numeric(rbind(IVNTR3, IVNTR3_II))
 
 pval1<-pval2<-pval3<-rep(NA, 1000)
 for(i in 1:1000)
 {
 #print(i)
 #print("is i")
 
 #we're looking simply at the p-gain
 #of the form Y ~ X where X is a randomly chosen value (var1)
 #and pval1 is the p-value for the interaction term drawing from kor_M1_M2
 #pval2  is the p-value for the interaction term drawing from kor_M1_ratio
 #pval3 is the p-value for the interaction term drawing from kor_M2_ratio
 var1<-runif(10000,min=0, max=1)
 pval1[i]<-summary(lm(IVNTR1~var1*theIndicator))$coefficients[4,4]
 pval2[i]<-summary(lm(IVNTR2~var1*theIndicator))$coefficients[4,4]
 pval3[i]<-summary(lm(IVNTR3~var1*theIndicator))$coefficients[4,4]
 
 
 }
 #break
 pval1.l<-c(pval1.l, pval1)
 pval2.l<-c(pval2.l, pval2)
 pval3.l<-c(pval3.l, pval3)
}
#break

#make sure that we're including the best model
#i.e. the one with the most p-gain
test2<-cbind(apply(cbind(pval1.l, pval2.l),1,min), pval3.l)
pgain<-test2[,1]/test2[,2]
pgain.order<-pgain[order(pgain, decreasing=TRUE)]

toPlotName = paste(AMetab, BMetab, CMetab, sep ="_")

pdf(toPlotName)
plot(pgain)
dev.off()

#find p-gain at the given level of significance
print(pgain.order[length(pgain)*alpha])

write.table(pgain.order[length(pgain)*alpha], file = toPlotName)


return(pgain)
}

#call the function
testSimulation = p.gain.simulation(kor_M1_M2, kor_M1_ratio, kor_M2_ratio,kor_M1_M2_two, kor_M1_ratio_two, kor_M2_ratio_two,alpha, AMetab, BMetab, CMetab)




