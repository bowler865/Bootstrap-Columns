 <!---
 
 This file is a modified version of the Grid layout index.cfm for the Collections display object that comes with MuraCMS.
 
 Instead it uses Bootstrap 3 columns to control the number of columns displayed at each breakpoint.
 
 See the ReadMe for further instructions.
 
--->
<cfsilent>
	<cfparam name="objectParams.columnsXS" default="col-xs-12">
    <cfparam name="objectParams.columnsSM" default="col-sm-6">
    <cfparam name="objectParams.columnsMD" default="col-md-4">
    <cfparam name="objectParams.columnsLG" default="col-lg-3">
	<cfparam name="objectParams.imageSize" default="medium">
	<cfparam name="objectParams.imageHeight" default="AUTO">
	<cfparam name="objectParams.imageWidth" default="AUTO">
	<cfparam name="objectParams.modalimages" default="false">
    <cfparam name="objectParams.linkTitles" default="true">

	<cfset imageSizeArgs={
		size=objectParams.imageSize,
		height=objectParams.imageHeight,
		width=objectParams.imageWidth
	}>
</cfsilent>
<cfoutput>
<div class="mura-collection">
<div class="row">
  <cfloop condition="iterator.hasNext()">
    <div class="#objectParams.columnsXS# #objectParams.columnsSM# #objectParams.columnsMD# #objectParams.columnsLG#">
      <cfsilent>
        <cfset item=iterator.next()>
        </cfsilent>
      <div class="mura-collection-item">
        
        <div class="mura-collection-item__holder">
          <cfif listFindNoCase(objectParams.displaylist,'Image')>
            <div class="mura-item-content">
              <cfif item.hasImage()>
                <cfif objectparams.modalimages>
                  <a href="#item.getImageURL(size='large')#" title="#esapiEncode('html_attr',item.getValue('title'))#" data-rel="shadowbox[gallery]" class="#this.contentListItemImageLinkClass#"><img src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#" class="img-responsive"></a>
                  <cfelse>
                  <cfif objectParams.linkTitles>
                    <cfif item.getSubType() is 'Featured Property'>
                      <a href="http://heritagegroupct.idxre.com/idx/detail.cfm?cid=49352&bid=17&pid=#item.getRemoteID()#&ff=1" target="_blank"><img src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#" class="img-responsive"></a>
                      <cfelse>
                      <a href="#item.getURL()#"><img src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#" class="img-responsive"></a>
                      </cfif>
                    <cfelse>
                    <img src="#item.getImageURL(argumentCollection=imageSizeArgs)#" alt="#esapiEncode('html_attr',item.getValue('title'))#" class="img-responsive">
                    </cfif>
                  </cfif>
                </cfif>
              </div>
            </cfif>
          #m.dspObject_include(
          theFile='collection/includes/dsp_meta_list.cfm',
          item=item,
          fields=objectParams.displaylist,
          linkTitles=objectParams.linkTitles
          )#
          <a href="#item.getURL()#" class="btn">FULL BIO</a>
          </div>
        </div>
      </div>
    </cfloop>
<div class="clearfix"></div>
</div>
</div>

#m.dspObject_include(
	theFile='collection/includes/dsp_pagination.cfm',
	iterator=iterator,
	nextN=iterator.getNextN(),
	source=objectParams.source
)#

<cfif len(objectParams.viewalllink)>
	<a class="view-all" href="#objectParams.viewalllink#">#HTMLEditFormat(objectParams.viewalllabel)#</a>
</cfif>
</cfoutput>
<script>
  // mura.js
  Mura(function(m) {
    m.loader()
     .loadcss(m.themepath + '/display_objects/collection/layouts/bootstrap-columns/assets/dist/css/columns.min.css');
	m.loader()
	 .loadjs(m.themepath + '/display_objects/collection/layouts/bootstrap-columns/assets/dist/js/columns.min.js');
  });
</script>
