#source("http://bioconductor.org/biocLite.R")     source("https://bioconductor.org/biocLite.R")
#biocLite(c("GO.db", "preprocessCore", "impute"))
#install.packages(c("matrixStats", "Hmisc", "splines", "foreach", "doParallel", "reshape", "fastcluster", "dynamicTreeCut", "survival"))
#install.packages("WGCNA")

setwd("C:\\Users\\YunGu\\Desktop\\TCGA12_WGCNA\\WGCNA")     #设置工作目录（需修改）
library(WGCNA)
rt=read.table("merge.txt",sep="\t",row.names=1,header=T,check.names=F,quote="!")
datExpr = t(rt)  #处理矩阵，转置

######select beta value######
powers1=c(seq(1,10,by=1),seq(12,30,by=2))  #设定软阈值范围
RpowerTable=pickSoftThreshold(datExpr, powerVector=powers1)[[2]]  #获得各个阈值下的R方和平均连接度
#作图，左图：Soft Threshold (power)表示权重，纵坐标表示连接度k与p(k)的相关性，右图纵坐标表示平均连接度，一般要求k与p(k)的相关性达到0.85时的power作为β值
cex1=0.7
#pdf(file="softThresholding.pdf")
par(mfrow=c(1,2))
plot(RpowerTable[,1], -sign(RpowerTable[,3])*RpowerTable[,2],xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n")
text(RpowerTable[,1], -sign(RpowerTable[,3])*RpowerTable[,2], labels=powers1,cex=cex1,col="red")
# this line corresponds to using an R^2 cut-off of h
abline(h=0.85,col="red")
plot(RpowerTable[,1], RpowerTable[,5],xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n")
text(RpowerTable[,1], RpowerTable[,5], labels=powers1, cex=cex1,col="red")

beta1=9   #根据前边运行出的图形选择power值，基因和miRNA的加权值，根据每个节点绘制图    红色的线0.85，高于红色的线
#获得临近矩阵
ADJ= adjacency(datExpr,power=beta1)
vis=exportNetworkToCytoscape(ADJ,edgeFile="edge.txt",nodeFile="node.txt",threshold = 0.8)#阈值，0.6以上，阈值放小，相关性就多了，连线就多了，尽量低一点，漂亮   删掉
