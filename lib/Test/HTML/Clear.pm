package Test::HTML::Clear;

require 5.008_001;
use strict;
use warnings;

use HTML::Parser;
use Test::Builder;

use parent 'Exporter';

our (@EXPORT_OK, @EXPORT, $VERSION, %PARSER_OPTIONS);

$VERSION = '0.01';

my $Test = Test::Builder->new;

@EXPORT = qw(
  text_eq text_eq_count
  text_match text_match_count
  tag_found tag_found_count
);

%PARSER_OPTIONS = (
  api_version => 3
);

# Cribbed from the Test::Builder synopsis
sub import {
  my($self) = shift;
  my $pack = caller;
  $Test->exported_to($pack);
  $Test->plan(@_);
  $self->export_to_level(1, $self, @EXPORT);
}

sub _get_parser {
  HTML::Parser->new(%PARSER_OPTIONS);
}

sub _check_text {
  my ($compare,$checkcount,$HTML,$expect,$name) = @_;
  my $parser = _get_parser();
  my @texts;
  $parser->handler(text => \@texts, '@{text}');
  $parser->parse($HTML);
  my $cnt = 0;
  foreach my $text (@texts) {
	if($compare->($text, $expect)) {
	  $cnt++;
	}
  }
  $Test->ok($checkcount->($cnt),$name);	
}

sub text_eq {
  my ($HTML,$expect,$name) = (@_,"found expected text");
  _check_text(
      sub { $_[0] eq $_[1] },
      sub { $_[0] > 0 },
      $HTML,$expect,$name
  );
}

sub text_match {
  my ($HTML,$expect,$name) = (@_,"match expected text");
  _check_text(
      sub { $_[0] =~ $_[1] },
      sub { $_[0] > 0 },
      $HTML,$expect,$name
  );
}

sub text_eq_count {
  my ($HTML,$expect,$count,$name) = (@_,"found expected text count");
  _check_text(
      sub { $_[0] eq $_[1] },
      sub { $_[0] == $count },
      $HTML,$expect,$name
  );
}

sub text_match_count {
  my ($HTML,$expect,$count,$name) = (@_,"match expected text count");
  _check_text(
      sub { $_[0] =~ $_[1] },
      sub { $_[0] == $count },
      $HTML,$expect,$name
  );
}

sub _check_tag {
  my ($checkcount,$HTML,$tagname,$attrref,$name) = @_;
  my $parser = _get_parser();
  my @tags;
  $parser->report_tags($tagname);
  $parser->handler(start => \@tags, '@{attr}');
  $parser->parse($HTML);
  my $cnt = 0;
  TAGS:
  foreach my $attributes (@tags) {
	foreach my $attr (keys %$attributes) {
	  next TAGS unless defined $attrref->{$attr};
	}
    $cnt++;
  }
  $Test->ok($checkcount->($cnt),$name);
}

sub tag_found {
  my ($HTML,$tag,$attrspec,$name) = @_;
  $name ||= "tag $tag found";
  _check_tag(
      sub { $_[0] > 0 },
      $HTML,$tag,$attrspec,$name
  );
}

sub tag_found_count {
  my ($HTML,$tag,$attrspec,$count,$name) = @_;
  $name ||= "found $count $tag tag." . ($count == 1 ? '' : 's'); 
  _check_tag(
      sub { $_[0] == $count },
      $HTML,$tag,$attrspec,$name
  );
}

1;


