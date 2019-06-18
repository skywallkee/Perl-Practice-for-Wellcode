# Print the number of mouses bought and total price for the given computer mouse slots
# Solution: http://codeforces.com/contest/762/submission/55700901
use strict;
use warnings;

my ($usb_nr, $ps_nr, $both_nr) = split(" ", <>);
my $nr_prices = <>;
my @prices_usb = ();
my @prices_ps = ();
my $current_price = 0;
my $current_type = "";
my $equipped_usb = 0;
my $equipped_ps = 0;
my $equipped_both = 0;
my $cost = 0;
my $bought = 0;
foreach(1 .. $nr_prices)
{
	($current_price, $current_type) = split(" ", <>);
	if($current_type eq "USB")
	{
		push(@prices_usb, $current_price);
	}
	else
	{
		push(@prices_ps, $current_price);
	}
}
@prices_usb = sort {$a <=> $b} @prices_usb;
@prices_ps = sort {$a <=> $b} @prices_ps;
#print "Prices USB: @prices_usb \n";
#print "Prices PS/2: @prices_ps \n";
$bought = 0;
foreach(0 .. scalar $usb_nr-1)
{
	if($_ < scalar @prices_usb)
	{
		#print "Equipped USB PC with $prices_usb[$_]\n";
		$equipped_usb += 1;
		$cost += $prices_usb[$_];
		$bought += 1;
	}
}
splice @prices_usb, 0, $bought;
$bought = 0;
foreach(0 .. $ps_nr-1)
{
	if($_ < scalar @prices_ps)
	{
		#print "Equipped PS/2 PC with $prices_ps[$_]\n";
		$equipped_ps += 1;
		$cost += $prices_ps[$_];
		$bought += 1;
	}
}
splice @prices_ps, 0, $bought;
my $pos_usb = 0;
my $pos_ps = 0;
while($pos_usb < scalar @prices_usb and $pos_ps < scalar @prices_ps and $equipped_both < $both_nr)
{
	if($prices_usb[$pos_usb] <= $prices_ps[$pos_ps])
	{
		#print "Equipped PC with both with USB: $prices_usb[$pos_usb]\n";
		$equipped_both += 1;
		$cost += $prices_usb[$pos_usb];
		$pos_usb += 1;
	}
	else
	{
		#print "Equipped PC with both with PS/2: $prices_ps[$pos_ps]\n";
		$equipped_both += 1;
		$cost += $prices_ps[$pos_ps];
		$pos_ps += 1;
	}
}
while($pos_usb < scalar @prices_usb and $equipped_both < $both_nr)
{
	#print "Equipped PC with both with USB: $prices_usb[$pos_usb]\n";
	$equipped_both += 1;
	$cost += $prices_usb[$pos_usb];
	$pos_usb += 1;
}
while($pos_ps < scalar @prices_ps and $equipped_both < $both_nr)
{
	#print "Equipped PC with both with PS/2: $prices_ps[$pos_ps]\n";
	$equipped_both += 1;
	$cost += $prices_ps[$pos_ps];
	$pos_ps += 1;
}
print $equipped_usb + $equipped_ps + $equipped_both, " ", $cost;
