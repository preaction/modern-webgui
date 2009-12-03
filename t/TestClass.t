#!/usr/bin/env perl

use strict;
use warnings;

use Module::Find qw(useall);
use Test::Class;
use TestClass::WebGUIx::Asset::RawContent;
use TestClass::WebGUIx::Template::Asset;

Test::Class->runtests(qw(
    TestClass::WebGUIx::Asset::RawContent
    TestClass::WebGUIx::Template::Asset
));
