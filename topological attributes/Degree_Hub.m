clear 
clc 
Degree_Matrix=importdata('Degree_Matrix.txt');    %导入非加权网络
Hub=sum(Degree_Matrix,2);
dlmwrite('Hub.txt',Hub,'\t')    %数据导出txt文件