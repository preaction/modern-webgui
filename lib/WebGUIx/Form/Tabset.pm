package WebGUIx::Form::Tabset;

use Moose;

has 'tabs' => (
    is      => 'rw',
    isa     => 'ArrayRef[WebGUIx::Form::Tab]',
    default => sub { [] },
);

1;
