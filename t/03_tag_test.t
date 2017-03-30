
use strict;
use warnings;

use Test::Builder::Tester tests => 6;
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

my $cdml = <<'__CDML__';
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head><meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="0">
[FMP-InlineAction]IA - is a todo.[/FMP-InlineAction]<meta name="date" content="2017-03-30T18:17:31+02:00"><title>A [FMP-Field: ns_NAME_r, Raw] - [FMP-Field: f_ADR_firma, Raw]</title><link rel="stylesheet" href="/css/dingle.css" media="screen" type="text/css" ><script type="text/javascript"><!--//
 
  var formdir = "";
 
  var configuration = "testsystem";
 
  var selfformat = "adredit.html";
 
  var module = "Adressen";
 
//--></script>
<script src="/js/global.js" type="text/javascript"> </script>
<script src="/js/globaledit.js" type="text/javascript"> </script>
<script src="/js/adredit.js" type="text/javascript"> </script>
<script src="/js/telcheck.js" type="text/javascript"> </script></head><body><table width="*" cellspacing="0" cellpadding="0"><tr><td valign="top" id="sitehead"><!-- Kopfbereich -->
</td></tr><tr><td valign="top" id="sitebody"><!-- Datenbereich -->
[FMP-If: ns_current_user_id.gt.0][FMP-Include: auth/adredit.html][FMP-Else][FMP-Include: noauth/adredit.html][/FMP-If]</td></tr></table><div>Fehler: [FMP-CurrentError]<br />
     [FMP-CurrentFind]
	 Feld: [FMP-FindFieldItem], Operator: [FMP-FindOpItem] Wert: [FMP-FindValueItem]<br>
	 [/FMP-CurrentFind]
      <pre>Link: [FMP-Link]</pre></div></body></html>
__CDML__

test_out(
  "ok 1 - Content-Type ISO-8859-1",
  "ok 2 - Date tag exists",
  "ok 3 - No Cache 1",
  "ok 4 - No Cache 2",
  "ok 5 - found 4 meta tags."
);

tag_found($cdml,'meta',{ 'http-equiv' => "content-type"
                     , content    => "text/html; charset=ISO-8859-1"
                     },"Content-Type ISO-8859-1");

tag_found($cdml,'meta',{ name => 'date', "..." => 1},'Date tag exists');

tag_found($cdml,'meta',{ 'http-equiv' => 'pragma'
                      , content => 'no-cache'
                      },'No Cache 1');
                      
tag_found($cdml,'meta',{ 'http-equiv' => 'expires'
                      , content => 0 },'No Cache 2');

tag_found_count($cdml,'meta',undef,4);

test_test("CDML Document");
