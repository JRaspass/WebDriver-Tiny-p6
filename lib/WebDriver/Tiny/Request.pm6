use JSON::Tiny;
use Net::HTTP::Request;
use Net::HTTP::Transport;
use Net::HTTP::URL;

unit role WebDriver::Tiny::Request;

has Str $!base;

method  !get(Str:D $path)              { req('GET',  "$!base/$path").<value> }
method !post(Str:D $path = '', *%args) { req('POST', "$!base/$path", |%args) }

sub req(Str:D $method, Str:D $url, Bool:D :$silent = False, *%args) {
    my $res = ( state $ = Net::HTTP::Transport.new ).round-trip(
        Net::HTTP::Request.new
            :body( to-json %args )
            :$method
            :url( Net::HTTP::URL.new: $url )
    );

    return if $silent;

    die $res.body.decode('utf-8') if $res.status-code != 200;

    from-json $res.body.decode('utf-8');
}
