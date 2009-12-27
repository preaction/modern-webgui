package WebGUIx::Field::Group;

use Moose;
extends qw{ WebGUIx::Field };

override get_html => sub {
    my ( $self ) = @_;
    my $groups = $self->session->db->buildArrayRefOfHashRefs(
        "SELECT * FROM groups ORDER BY groupName"
    );

    my $tmpl    = WebGUIx::Template::File->new( 
        file        => 'field/group.html',
    );
    $tmpl->var->{groups} = $groups;
    $tmpl->var->{field} = $self;
    # XXX: This needs to be in config file
    $tmpl->tt_options->{INCLUDE_PATH} = "/data/modern-webgui/tmpl"; 
    my $html    = '';
    $tmpl->process( \$html );
    return $html;
};

1;
