package TestClass::WebGUIx::Asset;

use base qw(Test::Class);
use Test::More;
use Test::Deep;
use WebGUI::Test;
use WebGUIx::Asset::Schema;
use WebGUIx::Constant;

# A Test::Class for WebGUIx::Assets
# When creating your own, inherit from TestClass::WebGUIx::Asset 
# and override the asset_name and asset_class sub.

# Must override this
sub asset_name { return "Asset" }
sub asset_class { return 'WebGUIx::Asset' }

sub create : Test(startup => 7) {
    my ( $self ) = @_;
    my $asset   = $self->schema->resultset($self->asset_name)->create({
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
    } );

    isa_ok( $asset_again, ref($asset), "Asset from database has same class" );

    # Can we get the asset from the db once more?
    $asset_again    = $self->schema->resultset( 'Tree' )->find( {
        assetId         => $asset->assetId,
    } );
    
    $self->{asset} = $asset;
}

sub delete : Test(shutdown => 1) {
    my ( $self ) = @_;
    my $asset_id    = $self->{asset}->assetId;
    $self->{asset}->delete;
    ok( !$self->schema->resultset($self->asset_name)->find({ assetId => $asset_id }), 
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
