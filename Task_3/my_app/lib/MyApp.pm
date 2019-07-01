package MyApp;
use Mojo::Base 'Mojolicious';
use Mojo::Pg;

# This method will run once at server start
sub startup {
  my $self = shift;

  my $pg = Mojo::Pg->new('postgresql://wellcode:1234@127.0.0.1/wellcodet3');
  
  $self->helper(cache => sub { state $cache = {} });
  $self->helper(db => sub { state $db = $pg->db } );
  $self->cache->{logged} = 0;
  $self->cache->{username} = '';

  # Load configuration from hash returned by config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;
  # Normal route to controller
  $r->get('/')->to('user#index');
  $r->post('/')->to('user#index');
  $r->get('/login')->to('user#login');
  $r->post('/login')->to('user#login');
  $r->get('/register')->to('user#register');
  $r->post('/register')->to('user#register');
}

1;
