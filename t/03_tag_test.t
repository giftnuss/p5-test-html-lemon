
use strict;
use warnings;

use Test::Builder::Tester tests => 5;
use Test::HTML::Lemon;

my $HTML1 = "<p>Hallo Welt!</p>";

test_out("ok 1 - tag p found");
tag_found($HTML1,'p',{});
test_test("default tag test");

test_out("not ok 1 - tag p found");
test_err("#   Failed test 'tag p found'",
         "#   at t/03_tag_test.t line 17.");
tag_found($HTML1,'p',{id => 'p1'});
test_test("default tag test error message");

test_out("ok 1 - tag p is there");
tag_found($HTML1,'p',{},"tag p is there");
test_test("custom tag test message");

test_out("ok 1 - tag p exists");
tag_found_count($HTML1,'p',{},1,"tag p exists");
test_test("custom tag count test message");

my $HTML2 = "<ul><li class=f>apple<li class=f>pear<li class=v>potato</ul>";

test_out(
  "ok 1 - found 2 li tags.",
  "ok 2 - and 1 vegetable"
);
tag_found_count($HTML2,'li',{class => "f"},2);
tag_found_count($HTML2,'li',{class => "v"},1,"and 1 vegetable");

test_test("custom tag count test message 2");
