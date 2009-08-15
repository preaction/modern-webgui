#!/usr/bin/env perl

use strict;
use warnings;

use Module::Find qw(useall);
use Test::Class;
use TestClass::WebGUIx::Asset::Snippet;

Test::Class->runtests(qw(
    TestClass::WebGUIx::Asset::Snippet
));
