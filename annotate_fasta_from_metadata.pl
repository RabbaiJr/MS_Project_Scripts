#!/usr/bin/perl

$seq = $ARGV[0];
$meta = $ARGV[1];

open(OUT, ">$seq.metadata");

open(META, $meta);
while(<META>)
{
chomp;
($id, @data) = split(/[\t\,]/,);
$id2data{$id} = $_;

#Edit the number in $data[4] if this column is not the one containing the strain.
#Bear in mind that #5 corresponds to col 7 as the $id is the first column so @data starts at col2 and has zero as it's first element.
$id2strain{$id} = $data[4];
}

close META;

open(SEQ, $seq);
while(<SEQ>)
{
chomp;
$n++;
if(/>(.*)/){$id = $1;  $strain = $id2strain{$id}; $metadata = $id2data{$id}; $matrix{$strain}++; if($metadata =~ /\D/){print OUT "$metadata\n";}}
}

print "\n\nStrain\tCount in $seq\n";
foreach $strain (sort keys %matrix)
{
print "$strain\t$matrix{$strain}\n";
if($strain =~ /\d/){$total += $matrix{$strain};}
}

print "\n$total of $n sequences were annotated with strain\n";

