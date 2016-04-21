
use strict;
use Test::HTML::Lemon tests => 4;

my $HTML1 = "<p>Hallo Welt!</p>";
tag_found($HTML1,'p',{});
tag_found_count($HTML1,'p',{},1);

my $HTML2 = "<p id=p1>Hallo Welt!</p>";
tag_found($HTML2,'p',{id => 'p1'});
tag_found_count($HTML2,'p',{id => 'p1'},1);

