use strict;
use warnings;

my %hash=();

open(RF,"diff_miRNA.txt") or die $!;
while(my $line=<RF>){
	chomp($line);
	$line=~s/^\s+|\s+$//g;
	$hash{$line}=1;
}
close(RF);

my %repHash=();
open(RF,"lncRNA_mircode.txt") or die $!;
open(WF,">lncRNA_miRNA.txt") or die $!;
print WF "lncRNA\tmiRNA\n";
while(my $line=<RF>){
	my @arr=split(/\t/,$line);
	my @threeArr=split(/\//,$arr[3]);
  $threeArr[0]=~s/miR\-//g;
	foreach my $mirna(@threeArr){
		if(exists $hash{"hsa-mir-$mirna"}){
			unless(exists $repHash{"$arr[1]\thsa-mir-$mirna"}){
			  print WF "$arr[1]\thsa-mir-$mirna\n";
			  $repHash{"$arr[1]\thsa-mir-$mirna"}=1;
		  }
		}
	}
}
close(WF);
close(RF);


