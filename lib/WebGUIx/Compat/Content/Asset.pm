package WebGUIx::Compat::Content::Asset;

# A WebGUI Content handler for WebGUIx Assets

use Moose;
use WebGUIx::Asset::Schema;

sub handler {
    my ( $session ) = @_;
    $session->log->info( 'Entered WebGUIx::Compat::Content::Asset' ); 
    
    my $schema 
        = WebGUIx::Asset::Schema->connect( sub { $session->db->dbh } );
     
    $session->log->info( q{Trying to get asset by url "} . $session->url->getRequestedUrl . q{"} );

    my $row
        = $schema->resultset('Any')->find({ url => $session->url->getRequestedUrl });
    
    if ( $row ) {
        my $asset   = $row->as_asset;
        $session->log->info( sprintf 'Found asset %s (%s)', $asset->assetId, ref $asset ); 
        my $func    = 'www_' . ( $session->form->get('func') || "view" );
        if ( my $sub = $asset->can( $func ) ) {
            my $output; 
            eval { $output = $sub->($asset) };
            if ( $@ ) {
                $session->log->error( 
                    sprintf 'Problem running %s::%s for asset %s (%s): %s',
                    ref $asset, $func, $asset->url, $asset->assetId, $@,
                );
            }
            if ( !$output ) {
                return 'No output!';
            }
            else { 
                return $output;
            }
        }
        else {
            $session->log->error( 
                sprintf 'Could not call %s::%s for asset %s (%s): %s',
                ref $asset, $func, $asset->url, $asset->assetId, $@, 'Method does not exist',
            );
            
            # Try www_view method
            my $output;
            eval { $output = $asset->www_view };
            if ( $@ ) {
                $session->log->error( 
                    sprintf 'Problem running %s::%s for asset %s (%s): %s',
                    ref $asset, 'www_view', $asset->url, $asset->assetId, $@,
                );
            }
            if ( !$output ) {
                return 'No output!';
            }
            else { 
                return $output;
            }
        }
    }

    $session->log->info( 'Left WebGUIx::Compat::Content::Asset' ); 
    return;
}

1;
