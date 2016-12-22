need WebDriver::Tiny::Request;

unit class WebDriver::Tiny::Elements does WebDriver::Tiny::Request;

has @.ids;

method TWEAK(:$!base) { $!base ~= '/element' }

# Manip
method first { self.new :$!base :ids($.ids[  0]) }
method last  { self.new :$!base :ids($.ids[*-1]) }
method size  { @.ids.elems }

method enabled  { self!get: "@.ids[0]/enabled"   }
method rect     { self!get: "@.ids[0]/rect"      }
method selected { self!get: "@.ids[0]/selected"  }
method tag      { self!get: "@.ids[0]/name"      }
method visible  { self!get: "@.ids[0]/displayed" }

method click { self!post: "@.ids[0]/click"; self }

method send-keys(Str:D $value) {
    self!post: "@.ids[0]/value", :value($value.comb);
    self;
}
