package Test::HTML::Lemon;

require 5.008_001;
use strict;
use warnings;

use HTML::Parser;
use Test::Builder;

use parent 'Exporter';

our (@EXPORT_OK, @EXPORT, $VERSION, %PARSER_OPTIONS);

$VERSION = '0.2';

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

  local $Test::Builder::Level = $Test::Builder::Level + 2;
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
  my $joker = defined($attrref) && delete($attrref->{"..."});
  
  if(defined($attrref)) {
      TAGS:
      foreach my $attributes (@tags) {
	      my %attrref = %$attrref;
		  unless($joker) {
	          foreach my $attr (keys %$attributes) {
	              next TAGS unless
	                  defined $attrref{$attr} &&
	                  $attrref{$attr} eq $attributes->{$attr};
	              delete $attrref{$attr};
	          }
              $cnt++ unless %attrref;
          }
          else {
			  foreach my $spec (keys %attrref) {
			      next TAGS unless
			          defined $attributes->{$spec} &&
			          $attributes->{$spec} eq $attrref{$spec}	  
			  }
			  $cnt++;
		  }
      }
  }
  else {
	  $cnt = @tags;
  }
  
  local $Test::Builder::Level = $Test::Builder::Level + 2;
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
  $name ||= "found $count $tag tag" . ($count == 1 ? '' : 's') . "."; 
  _check_tag(
      sub { $_[0] == $count },
      $HTML,$tag,$attrspec,$name
  );
}

1;

__END__

=head1 NAME

Test::HTML::Lemon - just another HTML testing module

=head1 SYNOPSIS

=head1 DESCRIPTION


=item C<tag_found($HTML, $tag, $attrspec, $name)>

=item C<tag_found_count($HTML, $tag, $attrspec, $count, $name)>

C<$HTML> - the HTML to check

C<$tag> - the tag name which will be recognized

C<$attrspec> - hash reference of attributes. Normaly all attributes
must exist with the given value. If the "magic" key "..." is present
and has a true value, than the HTML code can contain more attributes 
as given in the spec. C<$attrspec> with value C<undef> means that the 
attributes check is skiped.

Exactly C<$count> should be found in the C<$HTML>. 

C<$name> - is the optional test description.

=head1 LICENSE

Perl has a free license, so this module shares it with this
programming language.

Copyleft 2013 by Sebastian Knapp E<lt>sk@computer-leipzig.comE<gt>




