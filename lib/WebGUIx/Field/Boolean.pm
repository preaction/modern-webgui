package WebGUIx::Field::Boolean;

use Moose;
extends 'WebGUIx::Field';

sub print {
    my ( $self ) = @_;
    my $html    = '<label><input type="radio" name="%s" value="1" %s /> Yes</label>'
                . '<label><input type="radio" name="%s" value="0" %s /> No</label>'
                ;
    my $selected_yes    = $self->value  ? 'checked="checked"' : '';
    my $selected_no     = !$self->value ? 'checked="checked"' : '';
    return sprintf $html, $self->name, $selected_yes, $self->name, $selected_no;
}

1;
