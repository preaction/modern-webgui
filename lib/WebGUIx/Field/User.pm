package WebGUIx::Field::User;

use Moose;
extends qw{ WebGUIx::Field };

override get_html => sub {
    my ( $self ) = @_;
    my $users   = $self->session->db->buildArrayRefOfHashRefs( 
        q{SELECT * FROM users WHERE userId NOT IN ("1") ORDER BY username}
    );
    my $tmpl    = WebGUIx::Template::File->new( 
        file        => 'field/user.html',
    );
    $tmpl->var->{users} = $users;
    $tmpl->var->{field} = $self;
    # XXX: This needs to be in config file
    $tmpl->tt_options->{INCLUDE_PATH} = "/data/modern-webgui/tmpl"; 
    my $html    = '';
    $tmpl->process( \$html );
    return $html;
};

1;
