my $poke_nr = <>;
my %pokemons;
my @numbers = split(" ", <>);
my $biggest_poke = 0;
my $max_poke = 0;
my $current_max = 0;
foreach(@numbers)
{
	if(exists($pokemons{$_}))
	{
		$pokemons{$_} = $pokemons{$_} + 1;
	}
	else
	{
		$pokemons{$_} = 1;
		if($_ > $biggest_poke)
		{
			$biggest_poke = $_;
		}
	}
}
foreach my $i(2 .. $biggest_poke)
{
	$current_max = 0;
	for(my $j = $i; $j <= $biggest_poke; $j += $i)
	{
		if(exists($pokemons{$j}))
		{
			$current_max += $pokemons{$j};
		}
	}
	if($current_max > $max_poke)
	{
		$max_poke = $current_max;
	}
}
if($max_poke > 0)
{
	print $max_poke;
}
else
{
	if(exists($pokemons{1}))
	{
		print 1;
	}
	else
	{
		print 0;
	}

}
