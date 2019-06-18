# Find out how many Bulbasaurs we can catch
# Solution: http://codeforces.com/problemset/submission/757/55703277
use strict;
use warnings;
my $newspaper = <>;
my %letter;
my $bulbies = 0;
foreach(split//,$newspaper)
{
	if(exists($letter{$_}))
	{
		$letter{$_} += 1;
		if($bulbies < $letter{$_})
		{
			$bulbies = $letter{$_};
		}
	}
	else
	{
		$letter{$_} = 1;
		if($bulbies == 0)
		{
			$bulbies = 1;
		}
	}
}
if(exists($letter{"a"}))
{
	$letter{"a"} = int($letter{"a"}/2);
}
if(exists($letter{"u"}))
{
	$letter{"u"} = int($letter{"u"}/2);
}
foreach(split//,"Bulbasr")
{
	if(exists($letter{$_}))
	{
		if($bulbies > $letter{$_})
		{
			$bulbies = $letter{$_}
		}
	}
	else
	{
		$bulbies = 0;
	}
}
print int($bulbies);
