package t::WebGUIx::Asset::Role::Versioning;

use Moose::Role;
use Test::Sweet;

around asset_properties => sub {
    my ( $orig ) = @_;
    my $p = $orig->();
    $p->{ data }{ status } = "approved";
    return $p;
};

test add_revision {
    my $asset   = $self->{asset};
    my $new_revision = $asset->add_revision;
    isa_ok( $new_revision, ref $asset );
    is( $new_revision->assetId, $asset->assetId );
    
    my $revision_date   = time + 10;
    $new_revision   = $asset->add_revision( 
        revisionDate => $revision_date,
        data         => {
            title       => "New Revision",
        },
    );
    is( $new_revision->revisionDate, $revision_date );
    is( $new_revision->data->revisionDate, $revision_date );
    is( $new_revision->data->title, "New Revision" );
}

1;
