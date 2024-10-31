library(ggplot2)

###### Poisson Distribution

lamba=10
k=0:25

prob_poi=dpois(k,lamba)

pro_dist_poi=data.frame(k_pnt=k,Probablity=prob_poi)

ggplot(pro_dist_poi,aes(x=k_pnt,y=Probablity))+
  geom_bar(stat = "identity",fill="pink",color="black")+
  labs(title = paste("Poisson Distribution (lambda =", lamba, ")"),
       x = "Number of Events (k)", y = "Probability") +
  theme_minimal()


varying_lamba=1:15

vary_dist_data=data.frame()

for(l in varying_lamba){
  vary_prob=dpois(k,l)
  
  vary_dist_data=rbind(vary_dist_data,
                       data.frame(
                         k_pnt=k,
                         Probab=vary_prob,
                         Vary_lamba=as.factor(l)
                       ))
  
}

ggplot(vary_dist_data,aes(x=k_pnt,y=Probab,color=Vary_lamba))+
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(title = "Poisson Distribution for Different Lambda Values",
       x = "Number of Events (k)", y = "Probability",
       color = "Lambda") +
  theme_minimal()
