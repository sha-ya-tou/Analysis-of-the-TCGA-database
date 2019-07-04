use strict;
use warnings;

my %hash=();

open(RF,"DEmiRNA.txt") or die $!;
while(my $line=<RF>){
	chomp($line);
	$hash{$line}=1;
}
close(RF);

open(RF,"starBase_miRNA.txt") or die $!;
open(WF,">miRNA.txt") or die $!;
while(my $line=<RF>){
	if($.==1){
		print WF $line;
		next;
	}
	my @arr=split(/\t/,$line);
	my @zeroArr=split(/\|/,$arr[0]);
	if(exists $hash{$zeroArr[0]}){
		print WF $line;
	}
}
close(WF);
close(RF);
#split函数讲字符串转换为数组
#$. 前一次读的文件句柄的当前行号
#exists一般是用来测试hash表中是否存在一个变量
#chomp()函数去掉字符串结尾的换行符
