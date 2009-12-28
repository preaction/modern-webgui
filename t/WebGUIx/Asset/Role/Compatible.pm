package t::WebGUIx::Asset::Role::Compatible;

use Moose::Role;
use Test::Sweet;
use WebGUIx::Constant;

with 't::WebGUIx::Asset::Role::Versioning';

#sub addRevision {
#sub canAdd {
#sub canEdit {
#sub canEditIfLocked {
#sub canView {
#sub get {
#sub getAutoCommitWorkflowId {
#sub getChildCount {
#sub getContainer {
#sub getContentLastModified {
#sub getCurrentRevisionDate { 
#sub getIcon {
#sub getId {
#sub getName {
#sub getTitle {
#sub getUiLevel {
#sub getUrl {
#sub hasChildren {
#around new => sub {

test newByPropertyHashRef {
    # As called by www_add...
    my %properties = (
        parentId                    => $WebGUIx::Constant::ASSETID_ROOT,
        groupIdView                 => $WebGUIx::Constant::GROUPID_EVERYONE,
        groupIdEdit                 => $WebGUIx::Constant::GROUPID_ADMIN,
        ownerUserId                 => $WebGUIx::Constant::USERID_ADMIN,
        encryptPage                 => 0,
        styleTemplateId             => $WebGUIx::Constant::ASSETID_STYLE_FAILSAFE,
        printableStyleTemplateId    => $WebGUIx::Constant::ASSETID_STYLE_FAILSAFE,
        isHidden                    => 0,
        className                   => $self->asset_class,
        assetId                     => "new",
        url                         => $self->session->id->generate,
    );
    my $new_asset = $self->asset_class->newByPropertyHashRef($self->session, {%properties});

    isa_ok( $new_asset, $self->asset_class );
    ok( !$new_asset->in_storage );
    is( $new_asset->tree->parentId, $properties{parentId} );
    is( $new_asset->data->groupIdView, $properties{groupIdView} );
    is( $new_asset->data->groupIdEdit, $properties{groupIdEdit} );
    is( $new_asset->data->ownerUserId, $properties{ownerUserId} );
    is( $new_asset->tree->className, $properties{className} );
    is( $new_asset->data->url, $properties{url} );
}


#sub processPropertiesFromFormPost {
#sub updateHistory {
#around www_add => sub {
#around www_add_save => sub {
#around www_edit => sub {
#sub www_editSave {
#sub www_view {

1;
