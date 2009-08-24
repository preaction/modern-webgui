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
# and override the asset_class and asset_class sub.

# Must override this
sub asset_class { return 'WebGUIx::Asset' }

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

#sub can_edit : Test() {
#    my ( $self ) = @_;
#    my $asset   = $self->{asset};
#    my $session = $self->session;
#    
#    
#
#}

#----------------------------------------------------------------------------

#sub can_view : Test() {
#    my ( $self ) = @_;
#    my $asset   = $self->{asset};
#    my $session = $self->session;
#    
#    
#
#}

#----------------------------------------------------------------------------

sub create : Test(startup => 8) {
    my ( $self ) = @_;
    my $asset   = $self->schema->resultset($self->asset_class)->create({
        session => $self->session,
    });
    isa_ok( $asset, $self->asset_class );
    isa_ok( $asset, 'WebGUIx::Asset', 'All assets must inherit from common base' );
    is( $asset->tree->parentId, $WebGUIx::Constant::ASSETID_ROOT,
        "Default parentId is root asset",
    );
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
        assetId         => $asset->assetId,
        revisionDate    => $asset->revisionDate,
    } )->as_asset;

    isa_ok( $asset_again, ref($asset), "Asset from database has same class" );

    # Can we get the asset from the db once more?
    $asset_again    = $self->schema->resultset( 'Tree' )->find( {
        assetId         => $asset->assetId,
    } )->as_asset;
    
    $self->{asset} = $asset;
}

sub delete : Test(shutdown => 1) {
    my ( $self ) = @_;
    my $asset_id    = $self->{asset}->assetId;
    $self->{asset}->delete;
    ok( !$self->schema->resultset($self->asset_class)->find({ assetId => $asset_id }), 
        "Deleted asset not in database" 
    );
}

sub schema {
    my ( $self ) = @_;
    if ( !$self->{_schema} ) {
        $self->{_schema} 
            = WebGUIx::Asset::Schema->connect( sub { $self->session->db->dbh } );
    }
    return $self->{_schema};
}

sub session {
    return WebGUI::Test->session;
}

1;
