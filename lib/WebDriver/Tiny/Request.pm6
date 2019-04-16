use Cro::HTTP::Client;

unit role WebDriver::Tiny::Request;

has Str $!base;

method  !get(Str:D $path)              { req('GET',  $!base ~ $path).<value> }
method !post(Str:D $path = '', *%args) { req('POST', $!base ~ $path, |%args) }

sub req(Str:D $method, Str:D $url, Bool:D :$silent = False, *%args) {
    state $client = Cro::HTTP::Client.new: :content-type('application/json');

    dd $url;
    dd %args;

    my $res = await $client.request: $method, $url, :body(%args);

    await $res.body;
}
