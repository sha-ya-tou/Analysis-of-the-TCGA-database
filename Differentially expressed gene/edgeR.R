#Set a fixed threshold to screen for differential genes
#source("http://bioconductor.org/biocLite.R")   #source("https://bioconductor.org/biocLite.R")
biocLite("edgeR")
install.packages("gplots")

foldChange=1
padj=0.05

setwd("C:\\Users\\YunGu\\Desktop\\TCGA\\video\\TCGA07")                    #设置工作目录
library("edgeR")
rt=read.table("mRNA.symbol.txt",sep="\t",header=T,check.names=F)  #改成自己的文件名
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp),colnames(exp))
data=matrix(as.numeric(as.matrix(exp)),nrow=nrow(exp),dimnames=dimnames)
data=avereps(data)
data=data[rowMeans(data)>1,]

#group=c("normal","tumor","tumor","normal","tumor")
group=c(rep("normal",4),rep("tumor",178))                         #按照癌症和正常样品数目修改
design <- model.matrix(~group)
y <- DGEList(counts=data,group=group)
y <- calcNormFactors(y)
y <- estimateCommonDisp(y)
y <- estimateTagwiseDisp(y)
et <- exactTest(y,pair = c("normal","tumor"))
topTags(et)
ordered_tags <- topTags(et, n=100000)

allDiff=ordered_tags$table
allDiff=allDiff[is.na(allDiff$FDR)==FALSE,]
diff=allDiff
newData=y$pseudo.counts

write.table(diff,file="edgerOut.xls",sep="\t",quote=F)
diffSig = diff[(diff$FDR < padj & (diff$logFC>foldChange | diff$logFC<(-foldChange))),]
write.table(diffSig, file="diffSig.xls",sep="\t",quote=F)
diffUp = diff[(diff$FDR < padj & (diff$logFC>foldChange)),]
write.table(diffUp, file="up.xls",sep="\t",quote=F)
diffDown = diff[(diff$FDR < padj & (diff$logFC<(-foldChange))),]
write.table(diffDown, file="down.xls",sep="\t",quote=F)

normalizeExp=rbind(id=colnames(newData),newData)
write.table(normalizeExp,file="normalizeExp.txt",sep="\t",quote=F,col.names=F)   #输出所有基因校正后的表达值（normalizeExp.txt）
diffExp=rbind(id=colnames(newData),newData[rownames(diffSig),])
write.table(diffExp,file="diffmRNAExp.txt",sep="\t",quote=F,col.names=F)         #输出差异基因校正后的表达值（diffmRNAExp.txt）

heatmapData <- newData[rownames(diffSig),]

#volcano
pdf(file="vol.pdf")
xMax=max(-log10(allDiff$FDR))+1
yMax=12
plot(-log10(allDiff$FDR), allDiff$logFC, xlab="-log10(FDR)",ylab="logFC",
     main="Volcano", xlim=c(0,xMax),ylim=c(-yMax,yMax),yaxs="i",pch=20, cex=0.4)
diffSub=allDiff[allDiff$FDR<padj & allDiff$logFC>foldChange,]
points(-log10(diffSub$FDR), diffSub$logFC, pch=20, col="red",cex=0.4)
diffSub=allDiff[allDiff$FDR<padj & allDiff$logFC<(-foldChange),]
points(-log10(diffSub$FDR), diffSub$logFC, pch=20, col="green",cex=0.4)
abline(h=0,lty=2,lwd=3)
dev.off()

#heatmap
hmExp=log10(heatmapData+0.001)
library('gplots')
hmMat=as.matrix(hmExp)
pdf(file="heatmap.pdf",width=60,height=90)
par(oma=c(10,3,3,7))
heatmap.2(hmMat,col='greenred',trace="none")
dev.off()
