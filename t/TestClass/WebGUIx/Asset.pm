package TestClass::WebGUIx::Asset;

use base qw(Test::Class);
use Test::More;
use Test::Deep;
use WebGUI::Test;
use WebGUIx::Asset::Schema;

# A Test::Class for WebGUIx::Assets
# When creating your own, inherit from TestClass::WebGUIx::Asset 
# and override the asset_class sub.

# Must override this
sub asset_class { return "Asset" }

sub insert : Test(startup => 1) {
    my ( $self ) = @_;
    my $asset   = $self->schema->resultset($self->asset_class)->create({});
    ok( $asset->isa( $self->asset_class ), "Object is correct type");
    is( $asset->className, $self->asset_class, "Object class name saved correctly" );
    $self->{asset} = $asset;
}

sub delete : Test(shutdown => 1) {
    my ( $self ) = @_;
    my $asset_id    = $self->{asset}->assetId;
    $asset->delete;
    ok( !WebGUIx::Asset::Schema->find( assetId => $asset_id ), "Deleted asset not in database" );
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
