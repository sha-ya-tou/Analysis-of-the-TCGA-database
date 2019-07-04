#source("http://bioconductor.org/biocLite.R")     source("https://bioconductor.org/biocLite.R")
#biocLite(c("GO.db", "preprocessCore", "impute"))
#install.packages(c("matrixStats", "Hmisc", "splines", "foreach", "doParallel", "reshape", "fastcluster", "dynamicTreeCut", "survival"))
#install.packages("WGCNA")

setwd("C:\\Users\\YunGu\\Desktop\\TCGA12_WGCNA\\WGCNA")     #���ù���Ŀ¼�����޸ģ�
library(WGCNA)
rt=read.table("merge.txt",sep="\t",row.names=1,header=T,check.names=F,quote="!")
datExpr = t(rt)  #��������ת��

######select beta value######
powers1=c(seq(1,10,by=1),seq(12,30,by=2))  #�趨����ֵ��Χ
RpowerTable=pickSoftThreshold(datExpr, powerVector=powers1)[[2]]  #��ø�����ֵ�µ�R����ƽ�����Ӷ�
#��ͼ����ͼ��Soft Threshold (power)��ʾȨ�أ��������ʾ���Ӷ�k��p(k)������ԣ���ͼ�������ʾƽ�����Ӷȣ�һ��Ҫ��k��p(k)������Դﵽ0.85ʱ��power��Ϊ��ֵ
cex1=0.7
#pdf(file="softThresholding.pdf")
par(mfrow=c(1,2))
plot(RpowerTable[,1], -sign(RpowerTable[,3])*RpowerTable[,2],xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n")
text(RpowerTable[,1], -sign(RpowerTable[,3])*RpowerTable[,2], labels=powers1,cex=cex1,col="red")
# this line corresponds to using an R^2 cut-off of h
abline(h=0.85,col="red")
plot(RpowerTable[,1], RpowerTable[,5],xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n")
text(RpowerTable[,1], RpowerTable[,5], labels=powers1, cex=cex1,col="red")

beta1=9   #����ǰ�����г���ͼ��ѡ��powerֵ�������miRNA�ļ�Ȩֵ������ÿ���ڵ����ͼ    ��ɫ����0.85�����ں�ɫ����
#����ٽ�����
ADJ= adjacency(datExpr,power=beta1)
vis=exportNetworkToCytoscape(ADJ,edgeFile="edge.txt",nodeFile="node.txt",threshold = 0.8)#��ֵ��0.6���ϣ���ֵ��С������ԾͶ��ˣ����߾Ͷ��ˣ�������һ�㣬Ư��   ɾ��