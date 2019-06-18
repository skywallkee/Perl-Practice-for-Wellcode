# Print K-th divisor of a given number
# Solution: http://codeforces.com/contest/762/submission/55699793
use strict;
use warnings;
my $input = <>;
my ($number, $k) = split(" ", $input);
my @divisor_list_first = ();
my @divisor_list_second = ();
my $nr_divs = 0;
foreach(1 .. sqrt($number))
{
	if($number % $_ == 0)
	{
		push(@divisor_list_first, $_);
		if($_ != $number / $_)
		{
			push(@divisor_list_second, $number / $_);
			$nr_divs += 1;
		}
		$nr_divs += 1;
	}
}
#print "First half: @divisor_list_first \n";
#print "Second half: @divisor_list_second \n";
#print "Nr divisors: $nr_divs \n";
if($nr_divs >= $k)
{
	if($k > scalar @divisor_list_first)
	{
		print "$divisor_list_second[$nr_divs-$k]";
	}
	else
	{
		print "$divisor_list_first[$k-1]";
	}
}
else
{
	print "-1";
}
