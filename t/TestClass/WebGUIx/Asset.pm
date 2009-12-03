package TestClass::WebGUIx::Asset;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Deep;
use WebGUI::Test;
use WebGUIx::Asset::Schema;
use WebGUIx::Constant;

# A Test::Class for WebGUIx::Assets
# When creating your own, inherit from TestClass::WebGUIx::Asset 
# and override the asset_class and asset_properties sub.

# Must override this
sub asset_class { return 'WebGUIx::Asset' }
sub asset_properties { 
    return {
        data        => {
            groupIdEdit     => $WebGUIx::Constant::GROUPID_ADMIN,
            groupIdView     => $WebGUIx::Constant::GROUPID_REGISTERED_USER,
        },
        tree        => {
            #className      # filled in by default
            #parentId       # filled in by default
        },
    };
}

#----------------------------------------------------------------------------

=head2 _create_users ( )

Create user objects to test with

=cut

sub _create_users : Test( startup ) {
    my ( $self ) = @_;
    my $session = $self->session;

    $self->{user} = {
        admin   => WebGUI::User->new( $session, $WebGUIx::Constant::USERID_ADMIN ),
        visitor => WebGUI::User->new( $session, $WebGUIx::Constant::USERID_VISITOR ),
        normal  => WebGUI::User->create( $session ),
    };
}

#----------------------------------------------------------------------------

=head2 _delete_users ( )

Delete all the users we created for this test

=cut

sub _delete_users : Test( shutdown ) {
    my ( $self ) = @_;
    for my $user ( values %{$self->{user}} ) {
        next if grep { $_ eq $user->getId } (
            $WebGUIx::Constant::USERID_ADMIN, $WebGUIx::Constant::USERID_VISITOR,
        );
        $user->delete;
    }
}

#----------------------------------------------------------------------------

sub can_add : Test(7) {
    my ( $self ) = @_;
    my $asset   = $self->{asset};
    my $session = $self->session;
    my ( $config ) = $session->quick(qw( config ));

    # Store config
    WebGUI::Test->originalConfig( "assets/" . $self->asset_class . "/addGroup" );
    
    ### Test with config
    $config->set( 
        "assets/" . $self->asset_class . "/addGroup", 
        $WebGUIx::Constant::GROUPID_REGISTERED_USER,
    );
    $session->user({ user => $self->{user}->{admin} });
    ok( $asset->can_add(), "Admin can_add as default" );
    ok( $asset->can_add( $self->{user}->{normal} ), "Normal user can_add as argument" );
    ok( !$asset->can_add( $self->{user}->{visitor}->getId ), "Visitor cannot add as userId" );

    ### Test without config (turn admin on)
    $config->delete( 
        "assets/" . $self->asset_class . "/addGroup", 
    );
    ok( $asset->can_add( $self->{user}->{admin} ), "Admin can_add as user" );
    ok( !$asset->can_add( $self->{user}->{normal}->getId ), "Normal user cannot add as userId" );
    $session->user({ user => $self->{user}->{visitor} });
    ok( !$asset->can_add(), "Visitor cannot add as default" );
    $self->{user}->{normal}->addToGroups([ $WebGUIx::Constant::GROUPID_TURN_ADMIN_ON ]);
    ok( $asset->can_add( $self->{user}->{normal} ), "Normal user can add when in turn admin on group" );
    $self->{user}->{normal}->deleteFromGroups([ $WebGUIx::Constant::GROUPID_TURN_ADMIN_ON ]);

}

#----------------------------------------------------------------------------

sub can_edit : Test(3) {
    my ( $self ) = @_;
    my $asset   = $self->{asset};
    my $session = $self->session;
    
    $session->user({ user => $self->{user}->{admin} });
    ok( $asset->can_edit, "Admin can_edit as default" );
    ok( !$asset->can_edit( $self->{user}->{normal} ), "Normal cannot edit as argument" );
    ok( !$asset->can_edit( $self->{user}->{visitor}->getId ), "Visitor cannot edit as userId" );

    return;
}

#----------------------------------------------------------------------------

sub can_view : Test(3) {
    my ( $self ) = @_;
    my $asset   = $self->{asset};
    my $session = $self->session;
    
    $session->user({ user => $self->{user}->{admin} });
    ok( $asset->can_view, "Admin can_view as default" );
    ok( $asset->can_view( $self->{user}->{normal} ), "Normal can_view as argument" );
    ok( !$asset->can_view( $self->{user}->{visitor}->getId ), "Visitor cannot edit as userId" );

    return;
}

#----------------------------------------------------------------------------

sub create : Test(startup => 7) {
    my ( $self ) = @_;
    my $asset   = $self->schema->resultset($self->asset_class)->create({
        session     => $self->session,
        %{ $self->asset_properties },
    });
    isa_ok( $asset, $self->asset_class );
    isa_ok( $asset, 'WebGUIx::Asset', 'asset' );
    like( $asset->assetId, qr/[a-zA-Z0-9_-]{22}/,
        "assetId is a GUID"
    );
    like( $asset->revisionDate, qr/\d+/,
        "revisionDate is a number"
    );
    cmp_ok( $asset->revisionDate, "<=", time,
        "revisionDate is created from time()"
    );
    is( $asset->tree->className, $self->asset_class,
        "className is set by default",
    );

    # Can we get the asset from the db again?
    my $asset_again = $self->schema->resultset( 'Any' )->find( {
        session         => $self->session,
        assetId         => $asset->assetId,
        revisionDate    => $asset->revisionDate,
    } )->as_asset;

    isa_ok( $asset_again, ref($asset), "Asset from database has same class" );

    # Can we get the asset from the db once more?
    $asset_again    = $self->schema->resultset( 'Tree' )->find( {
        session         => $self->session,
        assetId         => $asset->assetId,
    } )->as_asset( $self->session );
    
    $self->{asset} = $asset;
}

#----------------------------------------------------------------------------

sub cut : Test(1) {
    my ( $self ) = @_;
    my $asset   = $self->{asset};
    $asset->cut;
    is( $asset->tree->state, $WebGUIx::Constant::STATE_CLIPBOARD );
}

#----------------------------------------------------------------------------

sub delete : Test(shutdown => 1) {
    my ( $self ) = @_;
    my $asset_id    = $self->{asset}->assetId;
    $self->{asset}->delete;
    ok( !$self->schema->resultset($self->asset_class)->find({ assetId => $asset_id }), 
        "Deleted asset not in database" 
    );
}

#----------------------------------------------------------------------------

sub duplicate : Test(4) {
    my ( $self ) = @_;
    my $asset       = $self->{asset};
    my $copy        = $asset->duplicate;

    isnt( $asset->assetId, $copy->assetId, 'copy has new id' );
    isnt( $asset->tree->assetId, $copy->tree->assetId, 'copy has new id' );
    isnt( $asset->data->assetId, $copy->data->assetId, 'copy has new id' );

    my $new_copy = $self->schema->resultset('Any')->find({ 
        assetId => $copy->assetId,
    })->as_asset;
    ok( $new_copy, 'new copy can be instanced from database' );

    return;
}

#----------------------------------------------------------------------------

sub get_edit_form : Test(1) {
    my ( $self ) = @_;
    ok(1);
    #note( $self->{asset}->get_edit_form->print );
    use WebGUIx::Template::File;
    my $tmpl    = WebGUIx::Template::File->new( 
        file => 'edit_asset.tmpl',
        tt_options => {
            INCLUDE_PATH => '/data/modern-webgui/tmpl',
        },
    );
    $tmpl->add_form( $self->{asset}->get_edit_form );
    $tmpl->process or die( $tmpl->error );
}

#----------------------------------------------------------------------------

sub get_parent : Test(2) {
    my ( $self ) = @_;
    is( $self->{asset}->tree->parentId, $WebGUIx::Constant::ASSETID_ROOT,
        "Default parentId is root asset",
    );
    is ( $self->{asset}->get_parent->assetId, $WebGUIx::Constant::ASSETID_ROOT,
        "get_parent returns an asset",
    );
}

#----------------------------------------------------------------------------

sub get_url : Test(3) {
    my ( $self ) = @_;
    my $asset = $self->{asset};

    is( 
        $asset->get_url, 
        $self->session->url->gateway . $asset->data->url,
    );
    is( 
        $asset->get_url( param1 => 'one' ), 
        $self->session->url->gateway . $asset->data->url . '?param1=one'
    );
    is( 
        $asset->get_url( param1 => 'one', param2 => ['two','too','to'] ), 
        $self->session->url->gateway . $asset->data->url . '?param1=one;param2=two;param2=too;param2=to'
    );

    return;
}

#----------------------------------------------------------------------------

sub get_url_full : Test(3) {
    my ( $self ) = @_;
    my $asset = $self->{asset};

    is( 
        $asset->get_url_full, 
        $self->session->url->getSiteURL . $self->session->url->gateway . $asset->data->url,
    );
    is( 
        $asset->get_url_full( param1 => 'one' ), 
        $self->session->url->getSiteURL . $self->session->url->gateway . $asset->data->url . '?param1=one'
    );
    is( 
        $asset->get_url_full( param1 => 'one', param2 => ['two','too','to'] ), 
        $self->session->url->getSiteURL . $self->session->url->gateway . $asset->data->url . '?param1=one;param2=two;param2=too;param2=to'
    );

    return;
}

#----------------------------------------------------------------------------

sub has_children : Test(1) {
    my ( $self ) = @_;
    my $asset = $self->{asset};
    ok( !$asset->has_children );
}

#----------------------------------------------------------------------------

sub paste : Test(1) {
    my ( $self ) = @_;
    my $asset = $self->{asset};


}

#----------------------------------------------------------------------------

sub schema {
    my ( $self ) = @_;
    if ( !$self->{_schema} ) {
        $self->{_schema} 
            = WebGUIx::Asset::Schema->connect( sub { $self->session->db->dbh } );
        $self->session->{schema} = $self->{_schema};
    }
    return $self->{_schema};
}

#----------------------------------------------------------------------------

sub session {
    return WebGUI::Test->session;
}

1;
