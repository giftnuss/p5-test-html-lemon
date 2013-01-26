
use strict;
use warnings;

use Test::Builder::Tester tests => 2;
use Test::HTML::Clear;

my $HTML1 = "<p>Hallo Welt!</p>";

test_out("ok 1 - tag p found");
tag_found($HTML1,'p',{});
test_test("default tag test");

test_out("not ok 1 - tag p found");
test_err("#   Failed test 'tag p found'",
         "#   at t/03_tag_test.t line 17.");
tag_found($HTML1,'p',{id => 'p1'});
test_test("default tag test error message");
