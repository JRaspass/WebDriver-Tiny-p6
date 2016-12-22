need MIME::Base64;
need WebDriver::Tiny::Elements;
need WebDriver::Tiny::Request;

unit class WebDriver::Tiny does WebDriver::Tiny::Request;

# From http://www.w3.org/TR/webdriver/#sendkeys
constant $wd-return is export = "\c[57350]";

has $!capabilities;

my SetHash $sessions;

method BUILD(
      Hash:D :$capabilities = {},
       Str:D :$host         = 'localhost',
    uint16:D :$port!,
) {
    $!base = "http://$host:$port/session";

    my $res = self!post :desiredCapabilities($capabilities);

    $!capabilities = $res.<value>;

    $sessions.{ $!base ~= "/$res.<sessionId>" } = True;
}

method CALL-ME(Str:D $value, Str:D :$using = 'css') {
    my @ids
        = self!post('elements', :$using, :$value).<value>.map({ .<ELEMENT> });

    Elements.new :$!base :@ids;
}

method capabilities of Hash { $!capabilities }
method html         of Str  { self!get: 'source' }
method screenshot   of Buf  { MIME::Base64.decode: self!get: 'screenshot' }
method title        of Str  { self!get: 'title'  }
method url          of Str  { self!get: 'url'    }
method user-agent   of Str  { self.js:  'return window.navigator.userAgent' }

method get(Str:D $url) {
    self!post: 'url', :$url;
    self;
}

method js(Str:D $script, *@args) {
    self!post('execute', :@args, :$script).<value>;
}

method status of Hash {
    # /status is the only path without the session prefix, so surpress it.
    temp $!base = substr $!base, 0, rindex $!base, '/session/';

    self!get: 'status';
}

# Best-effort cleanup of sessions.
sub delete-session(Str:D $url) {
    req: 'DELETE', $url, :silent if $sessions.{$url}:delete;
}

method DESTROY { delete-session $!base }
           END { delete-session $_ for $sessions.keys }
