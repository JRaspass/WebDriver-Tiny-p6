use Test;
use WebDriver::Tiny::Elements;

plan 4;

sub make(*@ids) { WebDriver::Tiny::Elements.new( :base('base') :@ids ) }

my $e = make(1..9);

is-deeply $e.first, make(1), 'first';
is-deeply $e.last,  make(9), 'last';

is $e.size, 9, 'size';

is-deeply $e, make(1..9), 'Original is unaffected';
