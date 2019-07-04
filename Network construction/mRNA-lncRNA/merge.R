
setwd("C:\\Users\\YunGu\\Desktop\\TCGA11_coexpressionMerge")   #���ù���Ŀ¼�����޸ģ�
miRNA = read.table("diffmiRNAExp.txt", row.names=1 ,header=T,sep="\t",check.names=F)
RNA = read.table("diffmRNAExp.txt", row.names=1 ,header=T,sep="\t",check.names=F)

#ȡǰ�ĸ��ֶΣ�ȡ�������ϲ���һ������merge.txt
colnames(miRNA)=gsub("(.*?)\\-(.*?)\\-(.*?)\\-(.*?)\\-.*","\\1\\-\\2\\-\\3\\-\\4",colnames(miRNA))
colnames(RNA)=gsub("(.*?)\\-(.*?)\\-(.*?)\\-(.*?)\\-.*","\\1\\-\\2\\-\\3\\-\\4",colnames(RNA))
sameSample=intersect(colnames(miRNA),colnames(RNA))
merge=rbind(id=sameSample,miRNA[,sameSample],RNA[,sameSample])
write.table(merge,file="merge.txt",sep="\t",quote=F,col.names=F)

miRNALabel=cbind(rownames(miRNA),"miRNA")
RNALabel=cbind(rownames(RNA),"gene")
nodeLabel=rbind(c("ID","Classify"),miRNALabel,RNALabel)
write.table(nodeLabel,file="nodeLabel.txt",sep="\t",quote=F,col.names=F,row.names=F)
