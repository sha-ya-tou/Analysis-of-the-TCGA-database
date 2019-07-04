use strict;
use warnings;

my %hash=();

open(RF,"diff_lncRNA.txt") or die $!;
while(my $line=<RF>){
	chomp($line);
	$hash{$line}=1;
}
close(RF);

open(RF,"mircode.txt") or die $!;
open(WF,">lncRNA_mircode.txt") or die $!;
while(my $line=<RF>){
	if($.==1){
		print WF $line;
		next;
	}
	my @arr=split(/\t/,$line);
	my @zeroArr=split(/\|/,$arr[1]);
	if(exists $hash{$zeroArr[0]}){
		print WF $line;
	}
}
close(WF);
close(RF);
