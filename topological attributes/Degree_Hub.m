clear 
clc 
Degree_Matrix=importdata('Degree_Matrix.txt');    %����Ǽ�Ȩ����
Hub=sum(Degree_Matrix,2);
dlmwrite('Hub.txt',Hub,'\t')    %���ݵ���txt�ļ�