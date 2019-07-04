use strict;
use warnings;

my %miHash=();

open(RF,"miRNA.txt") or die $!;
while(my $line=<RF>){
	chomp($line);
	$line=~s/^\s+|\s+$//g;
	$miHash{$line}=1;
}
close(RF);

my %hash=();
my @files=glob("*.tsv");
my @dbs=();
foreach my $file(@files){
	my $db=$file;
	$db=~s/\.tsv//g;
	push(@dbs,$db);

	open(RF,"$file") or die $!;
	while(my $line=<RF>){
		chomp($line);
		my @arr=split(/\t/,$line);
		if(exists $miHash{$arr[0]}){
			my $mirnaGene="$arr[0]\t$arr[1]";
			${$hash{$mirnaGene}}{$db}=1;
		}
	}
	close(RF);
}

open(WF,">result.xls") or die $!;
print WF "miRNA\tGene\t" . join("\t",@dbs) . "\tSum\n";
foreach my $key(keys %hash){
	my $outLine=$key;
	my $sum=0;
	foreach my $db(@dbs){
		if(exists ${$hash{$key}}{$db}){
			$sum++;
			$outLine=$outLine . "\t1";
		}
		else{
			$outLine=$outLine . "\t0";
		}
	}
	if($sum>=3){
		print WF $outLine . "\t$sum\n";
	}
}
close(WF);

