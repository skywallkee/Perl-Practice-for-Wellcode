use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
sub clear
{
	for(my $i=0; $i<10; $i++)
	{
		print "\n";
	}
}

sub existing_username
{
	my $filename = 'logins.txt';
	open(my $fh, '<:encoding(UTF-8)', $filename);
	while(my $row = <$fh>)
	{
		chomp $row;
		my @split = split(quotemeta("]["), $row);
		@split = split(quotemeta("["), $split[0]);
		my $username = $split[1];
		if($username eq $_[0])
		{
			return 1;
		}
	}
	return 0;
}

sub correct_password
{
	my $filename = 'logins.txt';
	open(my $fh, '<:encoding(UTF-8)', $filename);
	while(my $row = <$fh>)
	{
		chomp $row;
		my @split = split(quotemeta("]["), $row);
		@split = split(quotemeta("]"), $split[1]);
		my $password = $split[0];
		@split = split(quotemeta("]["), $row);
		@split = split(quotemeta("["), $split[0]);
		my $username = $split[1];
		if($username = $_[1])
		{
			if($password eq $_[0])
			{
				close $fh;
				return 1;
			}
		}
	}
	close $fh;
	return 0;
}

sub login_form
{
	print "Input the username (-1 to cancel): ";
	my $username = <>;
	chomp $username;
	if($username eq "-1")
	{
		return "";
	}
	while(existing_username($username) == 0)
	{
		print "Invalid username, please try again: ";
		$username = <>;
		chomp $username;
		if($username eq -1)
		{
			return "";
		}
	}
	print "Input the password (-1 to cancel): ";
	my $password = <>;
	chomp $password;
	if($password eq "-1")
	{
		return "";
	}
	while(correct_password($password, $username) == 0)
	{
		print "Invalid password, please try again (-1 to cancel): ";
		$password = <>;
		chomp $password;
		if($password eq "-1")
		{
			return "";
		}
	}
	return $username;
}

sub display_ui
{
	if($_[0] == 0)
	{
		print "---[Not Logged In]---\n";
		print "---------MENU--------\n";
		print "1) Log In\n";
		print "2) Exit Application\n";
	}
	else
	{
		print "---[Logged In as $_[1]]---\n";
		print "-----------MENU-----------\n";
		print "1) Add New User\n";
		print "2) Log Out\n";
		print "3) Exit Application\n";
	}
}

sub read_choice
{
	print "Introduceti optiunea dorita: ";
	my $choice = <>;
	while(valid_choice($_[0], $choice) == 0)
	{
		print "Optiune invalida, incercati din nou: ";
		$choice = <>;
	}
	return $choice;
}

sub valid_choice
{
	my $logged_in = $_[0];
	my $choice = $_[1]; 
	if(not looks_like_number($choice))
	{
		return 0;
	}
	elsif($logged_in)
	{
		if($choice == 1 or $choice == 2 or $choice == 3)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		if($choice == 1 or $choice == 2)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}

sub exit_choice
{
	if($_[0] == 1)
	{
		return 3;
	}
	else
	{
		return 2;
	}
}

sub valid_username_format
{
	my $username = $_[0];
	if($username =~ "^[a-zA-Z]" and $username =~ "[a-zA-Z0-9_]{5,}")
	{
		return 1;
	}
	return 0;
}

sub valid_password_format
{
	my $password = $_[0];
	if($password =~ "^[A-Za-z]" and $password =~ "(?=.*[a-z].*)(?=.*[A-Z].*)(?=.*[0-9]).*" and $password =~ "^.{6,}")
	{
		return 1;
	}
	return 0;
}

sub add_user_database
{
	my $username = $_[0];
	chomp $username;
	my $password = $_[1];
	chomp $password;
	my $filename = 'logins.txt';
	open(my $fh, '>>', $filename);
	print $fh "[$username][$password]\n";
	close $fh;
}

sub new_user_form
{
	print "Input the new username (-1 to cancel): ";
	my $username = <>;
	if($username eq "-1")
	{
		return 0;
	}
	while(existing_username($username) == 1 or valid_username_format($username) == 0)
	{
		if(existing_username($username) == 1)
		{
			print "Username already exists! Try again (-1 to cancel): ";
		}
		elsif(valid_username_format($username) == 0)
		{
			print "Incorrect format!\nThe username must:\n- Begin with a letter\n- Have at least 5 characters\n- Can contain only: letters, numbers, _\nTry again (-1 to cancel): ";
		}
		$username = <>;
		if($username eq "-1")
		{
			return 0;
		}
	}
	print "Input the password (-1 to cancel): ";
	my $password = <>;
	chomp $password;
	if($password eq "-1")
	{
		return 0;
	}
	while(valid_password_format($password) == 0)
	{
		print "Incorrect format!\nThe password must:\n- Begin with a letter\n- Have one uppercase letter\n- Have one lower case letter\n- Have one number\n- Be of minimum 6 characters.\nTry again (-1 to cancel): ";
		$password = <>;
		chomp $password;
		if($password eq "-1")
		{
			return 0;
		}
	}
	add_user_database($username, $password);
	return 1;
}

sub do_choice
{
	my $choice = $_[0];
	my $logged = $_[1];
	my $user = $_[2];
	if($logged)
	{
		if($choice == 1)
		{
			my $result = new_user_form();
			if($result == 1)
			{
				print "New user created!\nPress ENTER to continue...";
				<>;
			}
			else
			{
				print "Didn't create the new user!\nPress ENTER to continue...";
				<>;
			}
		}
		elsif($choice == 2)
		{
			$user = "";
			print "Successfully logged out!\nPress ENTER to continue...";
			<>;	
		}
	}
	else
	{
		$user = login_form();
		if($user)
		{
			print "Successfully logged in!\nPress ENTER to continue...";
			<>;
		}
	}
	return $user;
}

my $logged = 0;
my $running = 1;
my $choice = 0;
my $user = "";
while($running)
{
	clear();
	display_ui($logged, $user);
	$choice = read_choice($logged);
	if($choice == exit_choice($logged))
	{
		$running = 0;
	}
	else
	{
		$user = do_choice($choice, $logged, $user);
		if($user eq "")
		{
			$logged = 0;
		}
		else
		{
			$logged = 1;
		}
	}
}
