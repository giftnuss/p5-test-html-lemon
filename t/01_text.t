
use strict;
use Test::HTML::Clear tests => 4;

my $HTML1 = "<p>Hallo Welt!</p>";
text_eq($HTML1,"Hallo Welt!");
text_eq_count($HTML1,"Hallo Welt!",1);

text_match($HTML1, qr/^Hallo/, "match");
text_match_count($HTML1, qr/^Hallo/, 1, "match count");
