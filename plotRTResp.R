library(ggplot2)
library(reshape2)
#resps <- read.table('BigList.txt',header=T)
resps <- read.table('BigList_all.txt',header=T)
names(resps) <- c('Subj','Date','Sound','RT.arousal' , 'RESP.arousal','RT.valence','RESP.valence')
resps$Sound <- gsub('.wav','',resps$Sound)

resps.reshaped<-reshape(resps,direction="long",varying=c('RT.arousal','RT.valence','RESP.arousal','RESP.valence'),timevar="Scale")
write.csv(resps.reshaped, file="BigList_Long.csv")

#ggplot(resps.reshaped,aes(group=Sound,fill=Sound,x=RESP))+geom_density(aes(group=Sound),alpha=I(.3))+facet_grid(Scale~.)+theme_bw()
jitterp <- ggplot(resps.reshaped,aes(y=Scale,x=RESP,size=RT,color=Scale))+geom_jitter(height=.05,width=0)+facet_wrap(~Sound)+theme_bw()
ggsave(jitterp,file='jitterplot.png',width=8,height=8)
p <- ggplot(resps.reshaped,aes(group=Sound,x=RESP))+geom_histogram()+facet_grid(Sound~Scale)+theme_bw()
ggsave(p,file='histograms.png',width=8,height=40)
