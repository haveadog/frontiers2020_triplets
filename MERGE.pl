
use strict;
use warnings;
use Data::Dumper qw(Dumper);


use List::MoreUtils qw(uniq);
 


#perl perl_script_to_merge_triplets.pl /Users/ahubbard/all_triplets_info_for_carl.tsv T1

#perl perl_script_to_merge_triplets.pl /Users/ahubbard/all_the_tables.txt T1

#perl perl_script_to_merge_triplets.pl /Users/ahubbard/all_the_HS_data.txt T1

#perl perl_script_to_merge_triplets.pl /Users/ahubbard/Downloads/allTriplets.txt T1

#perl perl_script_to_merge_triplets.pl /Users/ahubbard/Downloads/small_heidi_triplets.txt T1

##perl perl_script_to_merge_triplets.pl /Users/ahubbard/Downloads/allTriplets_4v20.txt T1 1.8




my $files = $ARGV[0];
my $sampleTimes = $ARGV[1];
my $threshold = $ARGV[2];

my @multiFiles;

@multiFiles = split(/,/, $files);
my @times = split(/,/, $sampleTimes);


my %infoOnEachTriplet;
# read in each of the files



my @knownArray = ("cysteine","carnitine","glycine","cysteine","N_stearoyltaurine","pyruvate","N_palmitoyltaurine","stearoyl_ethanolamide","N_acetyltaurine","N_oleoyltaurine","adenosine", "UDP_glucuronate", "1_stearoyl_2_linoleoyl_GPE__18_0_18_2_", "1_stearoyl_2_linoleoyl_GPI__18_0_18_2_", "1_palmitoyl_2_oleoyl_GPC__16_0_18_1_","adenosine_5__monophosphate__AMP_", "fructose_6_phosphate", "1_palmitoyl_2_oleoyl_GPI__16_0_18_1_","pterin","cysteinylglycine", "glucosamine_6_phosphate","N6_succinyladenosine", "phosphopantetheine", "N_acetylglucosaminylasparagine", "gamma_glutamylcysteine", "1_palmitoyl_2_linoleoyl_GPS__16_0_18_2_","1_palmitoyl_2_oleoyl_GPE__16_0_18_1_", "glutathione__reduced__GSH_", "glycerophosphoethanolamine", "3__dephosphocoenzyme_A", "myristoleate__14_1n5_", "glucose_6_phosphate", "1_palmitoleoyl_3_oleoyl_glycerol__16_1_18_1_","coenzyme_A","2_palmitoleoyl_GPC__16_1_","1_palmitoyl_GPE__16_0_", "1_palmitoyl_2_oleoyl_GPE__16_0_18_1_","picolinate","N_methyl_GABA","riboflavin__Vitamin_B2","1_stearoyl_GPG__18_0_","2_palmitoyl_GPC__16_0_","thymine","2__deoxyuridine", "guanosine_3__monophosphate__3__GMP_","guanosine_2__monophosphate__2__GMP","uridine_3__monophosphate__3__UMP","pseudouridine","stearoyl_ethanolamide","thiamin_diphosphate","betaine_aldehyde","taurine");
#my @knownArray = ("cysteine","carnitine","glycine");


#the dictionary will look something like this:

#consider the {file}{number}{A}{B}{C}




#should probably initalize this variable!

my $whichFile = 0;
for my $file ( @multiFiles ) {

    #print $file . " is the file that we are opening !! \n";

    open my $fh, '<', $file or die "Unable to open $file: $!";
    my @file = <$fh>;

    my $theTimePoint = $times[$whichFile];
    #print $theTimePoint . " is the timepoint \n";
    
    #loop through the lines in each files
    my $whichLine = 0;
    foreach (@file) {
        
        my @allInfo = split(/\t/, $_);
        #print $_;
        #print "is the line !! \n";
        
        #this will be either 0 or 1 depending on how the file is formatted
        my $A = $allInfo[1];
        #print $A . " is A !! \n";
        my $ratioString = $allInfo[2];
        #print $ratioString . " is ratio string !! \n";
        #die;
        #print $ratioString . " is my ratio string !! \n";
        my @ratio = split(/\//, $ratioString);
        

          
        my $corControl = 0;
        my $corHS = 0;
        
        $corControl = $allInfo[9];
        $corHS = $allInfo[10];
        
        my $diffSwitch = $corControl - $corHS;
        #print $diffSwitch;
        #die;
          if(abs($diffSwitch) >$threshold)
        {
          #print $diffSwitch;
          #print " is the diffSwitch \n";
          #die;
          
          $infoOnEachTriplet{$A}{$ratioString}{$theTimePoint} = 0;
        }
    }

    $whichFile = $whichFile + 1;
}



my %infoOnEachFile;




$whichFile = 0;
for my $file ( @multiFiles ) {

    open my $fh, '<', $file or die "Unable to open $file: $!";
    my @file = <$fh>;

    #loop through the lines in each files
    my $whichLine = 0;
    foreach (@file) {
        
        #my @allInfo = split(/\t/, $_);
        #print $_;
        #it will either be a space or a tab, not sure which
        my @allInfo = split(/\t/, $_);
        
        my $pieceCount = 0;
       # for my $piece (  @allInfo )
       #{
        #print $piece . " is the piece \n";
        #print $pieceCount . " is  pieceCount \n";
        #$pieceCount += 1;
        #}#
       #die;
        my $A = $allInfo[1];
        my $ratioString = $allInfo[0];
        my @ratio = split(/\//, $ratioString);
        
        #infoOnEachTriplet{A}{B/C}
        
         my $theTimePoint = $times[$whichFile];
        
        
        #print $whichFile . " is which File !! \n";
        #only put in if the difference is great enough !
        
        my $corControl = 0;
        my $corHS = 0;
        
        $corControl = $allInfo[9];
        $corHS = $allInfo[10];
        
        my $diffSwitch = $corControl - $corHS;
        
        #will want to add + 1 when we start working with multiple files again
      # $infoOnEachTriplet{$A}{$ratioString}{$theTimePoint} = $infoOnEachTriplet{$A}{$ratioString}{$theTimePoint};
        
        #print $infoOnEachTriplet{$A}{$ratioString}{$theTimePoint}; 
        
        my $B = $ratio[0];
        my $C = $ratio[1];
       
        $infoOnEachFile{$whichFile}{$whichLine}{"A"} = $A;
        $infoOnEachFile{$whichFile}{$whichLine}{"B"} = $B;
        $infoOnEachFile{$whichFile}{$whichLine}{"C"} = $C;
        
        
       
        $whichLine+=1;
    }


    $whichFile += 1;
}



#die;
#loop through each fork and count !

#key one is metabolite A, key II is the ratio and key III is the timepoint 
=pod
my @timePointsArray;

 my $AMetaboliteString = "";
foreach my $key (keys %infoOnEachTriplet) 
{
   
  
   
   my %dictOfAllHits;
   my $countTimepoints = 0;
   
   
   my $stringOfTimePoints = "";
  #print $key . " is the synteny block !!! \n \n";
   my $stringToOutput = "";
   #iterate through each synteny block
    my $speciesCounter = 1;
    for my $keyII (keys %{ $infoOnEachTriplet{$key}})
    {
        #print $keyII . " is key II \n";
        for my $keyIII (keys %{ $infoOnEachTriplet{$key}{$keyII}})
        {
           $stringToOutput .= $key . "\t" . $keyII . "\t" .  $keyIII . "\t" . $infoOnEachTriplet{$key}{$keyII}{$keyIII} . " \n";
        #print $infoOnEachTriplet{$key}{$keyII} . " \n";
        
            $countTimepoints += 1;
            $stringOfTimePoints .= $keyIII . ",";
            #print length($infoOnEachTriplet{$key}{$keyII}{$keyIII}) . " is the length";
            push(@timePointsArray, $keyIII);
        }
        
        
        my @unique_timePoinstArray = uniq @timePointsArray;
        
        
        
        $AMetaboliteString .= $key . "\t" . join(",",@unique_timePoinstArray);
    }

    $AMetaboliteString .= "\n";
    #print $stringToOutput;
    #print "is the StringToOuput"

}
die;
=cut



#
#

#print $AMetaboliteString . " is the AMetaboliteString \n \n";



#this may not be necessary ...


#key one is metabolite A, key II is the ratio and key III is the timepoint 
my $whichElement = 0;
foreach my $key (keys %infoOnEachTriplet) 
{
   
   my %dictOfAllHits;
   my $howManyTimePoints = 0;
   my $stringOfHitsReformatted =""; 
   print $key . " is the first key !!! \n \n";
  
   my $MetabToMatch = "";
   
   #start off with MetabToMAatch = to the element of the ratio
   
   #iterate through each synteny block
    my $speciesCounter = 1;
    for my $keyII (keys %{ $infoOnEachTriplet{$key}})
    {
        #print $keyII . " is key II \n";
        for my $keyIII (keys %{ $infoOnEachTriplet{$key}{$keyII}})
        {
            #print $key . " is key \t" . $keyII . " is key II \t" .  $keyIII . "\t" . $infoOnEachTriplet{$key}{$keyII}{$keyIII} . " \n";
            #die;
        
             my @ratio = split(/\//, $keyII);
             
             
             my $compB = $ratio[0];
             my $compC = $ratio[1];
        
             #print $keyII . " is key II \n";
             #print $compB . " is compB !! \n";
             #print $compC . " is compC !!! \n";
            #die;
        
            #key one is metabolite A, key II is the ratio and key III is the timepoint 
            #print " we have a potential extension involving:";
            #print $key . " is key \t" . $keyII . " is key II \t" .  $keyIII . "\t" . $infoOnEachTriplet{$key}{$keyII}{$keyIII} . " \n";
            foreach my $keyB (keys %infoOnEachTriplet) 
            {
   
               my %dictOfAllHits;
   
               my $stringOfHitsReformatted =""; 
  #print $key . " is the synteny block !!! \n \n";
   
   #iterate through each synteny block
                my $speciesCounter = 1;
                for my $keyIIB (keys %{ $infoOnEachTriplet{$keyB}})
                {
                 $MetabToMatch = $keyII;
                #print $keyII . " is key II \n";
                    for my $keyIIIB (keys %{ $infoOnEachTriplet{$keyB}{$keyIIB}})
                    {
                     
                     
                        my @ratioII = split(/\//, $keyIIB);
                        my $compBII = $ratioII[0];
                        my $compCII = $ratioII[1];
        
                       #print $compBII . " is compA !! \n";
                       #print $compCII . " is compB !!! \n";
           
                     
                        #print $key . "\t" . $keyII . "\t" .  $keyIII . "\t" . $infoOnEachTriplet{$key}{$keyII}{$keyIII} . " \n";
                        
                        #make sure the ratio is the same, but the timepoint is not and that sample A is also different
                        
                        #print $keyIIB . " is keyII \n";
                    
                    
                        #A/B and B/A are both prob here for highly significant pairs
                        
                        
                        #let's look for closed circuits
                        #if(($compBII eq $compB) && ($keyII ne $keyIIB))
                        
                        #exclude ratios where A, B and C are not distinct
                        
                        #print $compCII . " compCII \n";
                        
                       #print $keyII . " is key II \n";
                        #die;
                        if(($compBII eq $key) || ($compCII eq $key) ||($key eq $keyB) || ($compBII eq $compB) || ($compBII eq $key) || ($compBII eq $compC))
                           #|| ($compBII eq $compB) || ($compBII eq $compC) )
                        #|| (($key eq $compCII) && ($keyB ne $key) && ($keyII ne $compCII) && ($keyII ne $compBII)) || (($key eq $compBII) && ($keyB ne $key) && ($keyII ne $compCII) && ($keyII ne $compBII)) )
                           #($keyII ne $keyIIB))&& ($key eq $keyB) && ($keyIII ne $keyIIIB))
                        {
                       
                       
                            #this is really inelegant, but I think that it will work 
                            #if((grep {$_ eq $key} @knownArray) && (grep {$_ eq $compBII} @knownArray) && (grep {$_ eq $compCII} @knownArray))
                               #&& (grep {$_ eq $compCII} @knownArray))
                                                                   # && (grep {$_ eq $compCII} @knownArray))
                            #{
                             #print "\n$key is in the array (in theory) \n \n";
                             #print  "\n $compBII is in the array (in theory) \n \n";
                     
                            #print $compBII . " is compBII \n";
                            #print  $compCII . " is compCII \n";
                            #print $keyB . " is keyB \n";                     
                            #print $key . " is key \n";
                             #print (grep $_ eq $key, @knownArray);

                            #print "$MetabToMatch is metabTomatch !!! \n";
                             print $key . "," . $keyII . "*";
                             print $keyB . "," . $keyIIB . "\n";
                            #print "\n \n";
                             $howManyTimePoints += 1;
                            #print $howManyTimePoints . " is how many timepoints \n";
                             $MetabToMatch = $compB;
                             #die;
                             
                            #}
                        }
                        
        #print $infoOnEachTriplet{$key}{$keyII} . " \n";
                    }
            
                }
                
            $howManyTimePoints = 0;
            }

        
        
        #print $infoOnEachTriplet{$key}{$keyII} . " \n";
        }
    }

$whichElement+=1;
#print $whichElement . " is where we are !!! \n";
}




#multiple r2 by gain
#r2, p-gain and then output the prioritization score

