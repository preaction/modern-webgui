package WebGUIx::Field::Boolean;

use Moose;
extends 'WebGUIx::Field';

sub get_html {
    my ( $self ) = @_;
    my $html    = '<label class="boolean"><input type="radio" name="%s" value="1" %s />Yes </label>'
                . '<label class="boolean"><input type="radio" name="%s" value="0" %s />No </label>'
                ;
    my $selected_yes    = $self->value  ? 'checked="checked"' : '';
    my $selected_no     = !$self->value ? 'checked="checked"' : '';
    return sprintf $html, $self->name, $selected_yes, $self->name, $selected_no;
}

1;
