#!perl

if ($#ARGV) {
	print <<ED;
Usage       : perl $0 <route-file.gpx>
Description : Takes a GPS GPX file and writes out a reverse route.
Example     : perl $0 "Abinger Common.gpx"
Author      : Richard Aldridge
Created     : 10:34 19/05/2022
Modified    : 11:12 19/05/2022
ED

	exit(1);
}

$fn_in = $fn_out = $ARGV[0];

$fn_out =~ s/\.gpx/-reversed.gpx/;

@gpx_points = ();

open(INFILE,"<$fn_in");
open(OUTFILE,">$fn_out");

$in_point =0;

$point = "";

while($line=<INFILE>) {
	chomp($line);

	if(!$in_point) {
		if($line =~ /<rtept/) {
			$in_point = 1;
			
			$point = "$line\n";
		} elsif ($line =~ /<\/rte>/) {
			
			while($rv_point = pop(@gpx_points)) {
				print OUTFILE "$rv_point";
			}
			
			print OUTFILE "$line\n";
		} else {
			print OUTFILE "$line\n";
		}
	} else {
		if ($line =~ /<\/rtept/) {
			$point .= "$line\n";
			
			push(@gpx_points,$point);
			
			$in_point = 0;
		} else {
			$point .= "$line\n";
		}
	}
}

close(OUTFILE);
close(INFILE);

exit(0);
