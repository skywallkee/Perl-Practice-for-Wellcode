package MyApp::Controller::User;
use Mojo::JSON;
use Mojo::Base 'Mojolicious::Controller';

sub valid{
  my $self = shift;
  my $username = $_[0];
  my $password = $_[1];
  if($username ne "" or $password ne ""){
    my $select = 'SELECT * FROM users';
    my $results = $self->db->query($select);
    while(my $result=$results->array){
    	if($username eq $result->[0] and $password eq $result->[1]){
		return 1;
	}
	elsif($username eq $result->[0]){
		return -1;
	}
    }
  }
  return 0;
}

sub get_site_id{
  my $site_name = $_[0];
  if($site_name eq "infoarena"){
	  return 2;
  }
  elsif($site_name eq "codeforces"){
	  return 3;
  }
  elsif($site_name eq "csacademy"){
	  return 4;
  }
  else{
	  return 5;
  }
}

sub modify_site{
  my $self = shift;
  my $username = $_[0];
  my $site = $_[1];
  my $new = $_[2];
  $self->db->update('users', {$site => $new}, {username => $username});
}

sub get_account{
  my $self = shift;
  my $username = $_[0];
  my $site_id = get_site_id($_[1]);
  my $select = 'SELECT * FROM users';
  my $results = $self->db->query($select);
  while(my $result=$results->array){
	  if($result->[0] eq $username){
		  return $result->[$site_id];
	  }
  }
  return "";
}

sub is_authenticated {
  my $self = shift;
  return $self->cache->{logged};
}

sub get_username {
  my $self = shift;
  return $self->cache->{username};
}

sub index {
  my $self = shift;
  my $logged = is_authenticated($self);
  my $username = get_username($self);
  my $logout = $self->param('logout');
  if($logout){
    $self->cache->{logged} = 0;
    $self->cache->{username} = '';
    $self->redirect_to('/');
  }

  my $save = $self->param("save");
  if($save == 1){
  	modify_site($self, $username, "infoarena", $self->param("infoarena"));
	modify_site($self, $username, "codeforces", $self->param("codeforces"));
  	modify_site($self, $username, "csacademy", $self->param("csacademy"));
  	modify_site($self, $username, "atcoder", $self->param("atcoder"));
  }

  my $infoarena = get_account($self, $username, "infoarena");
  my $codeforces = get_account($self, $username, "codeforces");
  my $csacademy = get_account($self, $username, "csacademy");
  my $atcoder = get_account($self, $username, "atcoder");

  $self->stash(infoarena => $infoarena);
  $self->stash(codeforces => $codeforces);
  $self->stash(csacademy => $csacademy);
  $self->stash(atcoder => $atcoder);
  $self->stash(logged => $logged);

  $self->render(template => 'user/index');
}

sub login {
  my $self = shift;
  my $user = $self->param('username');
  my $pass = $self->param('password');
  my $message = "";
  if(valid($self, $user, $pass)){
    $self->cache->{logged} = 1;
    $self->cache->{username} = $user;
    $self->redirect_to('/');
  }
  else{
    if($user ne "" or $pass ne ""){
    	$self->cache->{username} = '';
    	$self->cache->{logged} = 0;
    	$message = "User or Password incorrect.";
    }
  }
  my $logged = is_authenticated($self);
  $self->stash(message => $message);
  $self->stash(logged => $logged);
  $self->render(template => 'user/login');
}

sub correct_user{
	my $username = $_[0];
        if($username =~ "^[a-zA-Z]" and $username =~ "[a-zA-Z0-9_]{5,}")
        {
                return 1;
        }
        return 0;
}

sub correct_pass{
	my $password = $_[0];
        if($password =~ "^[A-Za-z]" and $password =~ "(?=.*[a-z].*)(?=.*[A-Z].*)(?=.*[0-9]).*" and $password =~ "^.{6,}")
        {
                return 1;
        }
        return 0;
}

sub register_user{
	my $self = shift;
	my $user = $_[0];
	my $pass = $_[1];
	$self->db->insert('users', {username => $user, password => $pass});
	return 1;
}

sub register {
  my $self = shift;
  my $logged = is_authenticated($self);
  my $message_user = "";
  my $message_pass = "";
  my $message_success = "";
  my $user = $self->param('username');
  my $pass = $self->param('password');
  if($self->param('register')){
  	if(correct_user($user)){
		if(valid($self, $user, "") == -1){
			$message_user = "Username already exists.";
		}
		elsif(correct_pass($pass)){
  			register_user($self, $user, $pass);
			$message_success = "Account created successfully!";
		}
		else{
			$message_pass = "Password must contain at least one uppercase letter, lowercase letter, number and the length must be at least 6";
		}
 	 }
 	 else{
		$message_user = "Username must begin with a letter and can contain only letters, numbers and _ and the length must be at least 5";
		if(not correct_pass($pass)){
			$message_pass = "Password must contain at least one uppercase letter, lowercase letter, number and the length must be at least 6";
		}
  	}
  }
  $self->stash(message_success => $message_success);
  $self->stash(message_user => $message_user);
  $self->stash(message_pass => $message_pass);
  $self->stash(logged => $logged);
  $self->render(template => 'user/register');
}

1;
