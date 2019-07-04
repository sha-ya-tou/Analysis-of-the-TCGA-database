# -*- coding: utf-8 -*-
import networkx as nx
import xlsxwriter
import pandas as pd
G = nx.Graph()
# 从文件@filename中读取网络的adjacentMatrix，通过networkx的add_edges方法向对象G中添加边
def readNetwork(filename):
    f = open(filename, 'r')
    rowCount = 1;
    colCount = 1;
    for line in f.readlines():
        line = line.strip().split("\t")
        for node in line:
            if node == '1':
                G.add_edge(rowCount, colCount)
            colCount += 1
        colCount = 1
        rowCount += 1
    print(G.edges())
readNetwork(r"D:\Users\admin\Desktop\hub\Degree_Matrix.txt")

def topNBetweeness():
    result = nx.betweenness_centrality(G,normalized=False)
    score = sorted(result.items(), key=lambda item:item[1], reverse = True)
    filename1 = xlsxwriter.Workbook(r'D:\Users\admin\Desktop\hub\Hub_BetweennessCenter.xlsx')
    sheet1 = filename1.add_worksheet('sheet1')
    for i in range(len(score)):
        sheet1.write(i, 0, score[i][0])
        sheet1.write(i, 1, score[i][1])
    filename1.close()

def topClossness():
    score = nx.closeness_centrality(G)
    score = sorted(score.items(), key=lambda item: item[1], reverse=True)
    filename2 = xlsxwriter.Workbook(r'D:\Users\admin\Desktop\hub\Hub_ClosenessCenter.xlsx')
    sheet2 = filename2.add_worksheet()
    for i in range(len(score)):
        sheet2.write(i, 0, score[i][0])
        sheet2.write(i, 1, score[i][1])
    filename2.close()
topNBetweeness()
topClossness()
