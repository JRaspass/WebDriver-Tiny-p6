use WebDriver::Tiny;

my $drv = WebDriver::Tiny.new(:4444port);

$drv.get('https://www.google.co.uk');

say $drv.capabilities;
say $drv.js('return 1+1');
say $drv.screenshot.bytes;
say $drv.status;
say $drv.title;
say $drv.url;
say $drv.user-agent;

say $drv('div').tag;
say $drv('input[name=q]').visible;

# Type into the search box 'p', 'e', 'r', 'l', <RETURN>.
$drv('input[name=q]').send-keys("perl$wd-return");

say $drv.title;
say $drv.url;

# Click the first perl result (perl.org).
$drv('h3.r > a').click;

say $drv.title;
say $drv.url;
