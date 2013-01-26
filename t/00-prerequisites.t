#!/usr/bin/perl -w
use strict;
use Test::More tests => 3;

# First, check the prerequisites
use_ok('Test::Builder')
  or BAILOUT("The tests require Test::Builder");
use_ok('HTML::Parser')
  or BAILOUT("The tests require HTML::TokeParser");
use_ok('Test::HTML::Clear')
  or BAILOUT("The tests require Test::HTML::Clear");
