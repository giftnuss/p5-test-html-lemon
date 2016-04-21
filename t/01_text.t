
use strict;

use Test::Builder::Tester tests => 1;
use Test::HTML::Lemon;

test_out(
"ok 1 - found expected text",
"not ok 2 - found expected text",
"ok 3 - found expected text count",
"not ok 4 - found expected text count",
"ok 5 - match",
"ok 6 - match count"
);

my $HTML1 = "<p>Hallo Welt!</p>";
text_eq($HTML1,"Hallo Welt!");
test_fail(+1);
text_eq($HTML1,"Hello World!");
text_eq_count($HTML1,"Hallo Welt!",1);
test_fail(+1);
text_eq_count($HTML1,"Hallo",2);

text_match($HTML1, qr/^Hallo/, "match");
text_match_count($HTML1, qr/^Hallo/, 1, "match count");

test_test("text tests works");
