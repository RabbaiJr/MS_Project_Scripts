#!/usr/bin/perl

#Open the grouped week analysis file and assign it the INFILE filehandle: die if this file doesn't exist
open(INFILE, "grouped_week_analysis.txt" ||die "File grouped_week_analysis.txt not found\n"); 

#Open an output file for the analysis results:
open(OUT, ">genotype_max_longevity.txt");
print OUT "Marker\tMax_longevity\n";


#Read the header (first line of the grouped_week_analysis file
$head = <INFILE>;


#Now loop through the rows of the file:
while($line = <INFILE>)
{
#Remove line endings 
chomp $line;

#Usse a REGEX to split the row of data into marker name and then an array called @data with all of the major allele frequency proportions
($marker, @data) = split(/\t/, $line);

#Set the maximum streak and current streak of allele presence <0.99 > 0.01 to zero.
$max_streak = 0;
$current_streak = 0;

#Now loop over the allele proportion values for this row in @data and find the longest streak
foreach $cell(@data)
  {
  #See if the criteria are met, if not, reset the current streak
  if($cell >= 0.01 && $cell <= 0.99){$current_streak++;} else {$current_streak = 0;}
  
  #Assign the $current_streak value to $max_streak if its the best streak so far
  if($current_streak > $max_streak){$max_streak = $current_streak;}
  }


#Now print out the current SNP name and its maximum streak:
print OUT "$marker\t$max_streak\n";
}
