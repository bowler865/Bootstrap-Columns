 <!---
 
 This file is a modified version of the Grid layout configurator.cfm for the Collections display object that comes with MuraCMS.
 
 Instead it uses Bootstrap 3 columns to control the number of columns displayed at each breakpoint.
 
 See the ReadMe for further instructions.
 
--->
<cfoutput>
<cfparam name="objectParams.modalimages" default="false">
<cfset renderer=$.getContentRenderer()>

<cfif not isdefined('columnsXS')>
    <cfset columnsXS='col-xs-12'>
</cfif>

<cfif not isdefined('columnsSM')>
    <cfset columnsSM='col-sm-6'>
</cfif>

<cfif not isdefined('columnsMD')>
    <cfset columnsMD='col-md-4'>
</cfif>

<cfif not isdefined('columnsLG')>
    <cfset columnsLG='col-lg-3'>
</cfif>

<div class="mura-control-group">
  	<label>Columns (XS)</label>
	<select name="columnsXS" data-displayobjectparam="columnsXS" class="objectParam">
		<cfloop from="1" to="12" index="cols">
			<option value="col-xs-#cols#"<cfif columnsXS eq "col-xs-#cols#"> selected</cfif>>#cols#</option>
		</cfloop>
	</select>
</div>

<div class="mura-control-group">
  	<label>Columns (SM)</label>
	<select name="columnsSM" data-displayobjectparam="columnsSM" class="objectParam">
		<cfloop from="1" to="12" index="cols">
			<option value="col-sm-#cols#"<cfif columnsSM eq "col-sm-#cols#"> selected</cfif>>#cols#</option>
		</cfloop>
	</select>
</div>

<div class="mura-control-group">
  	<label>Columns (MD)</label>
	<select name="columnsMD" data-displayobjectparam="columnsMD" class="objectParam">
		<cfloop from="1" to="12" index="cols">
			<option value="col-md-#cols#"<cfif columnsMD eq "col-md-#cols#"> selected</cfif>>#cols#</option>
		</cfloop>
	</select>
</div>

<div class="mura-control-group">
  	<label>Columns (LG)</label>
	<select name="columnsLG" data-displayobjectparam="columnsLG" class="objectParam">
		<cfloop from="1" to="12" index="cols">
			<option value="col-lg-#cols#"<cfif columnsLG eq "col-lg-#cols#"> selected</cfif>>#cols#</option>
		</cfloop>
	</select>
</div>


<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</label>
	<select name="imageSize" data-displayobjectparam="imageSize" class="objectParam">
		<cfloop list="Small,Medium,Large" index="i">
			<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#i#</option>
		</cfloop>
		<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
		<cfloop condition="imageSizes.hasNext()">
			<cfset image=imageSizes.next()>
			<option value="#lcase(image.getName())#"<cfif image.getName() eq feed.getImageSize()> selected</cfif>>#esapiEncode('html',image.getName())#</option>
		</cfloop>
		<option value="custom"<cfif "custom" eq feed.getImageSize()> selected</cfif>>Custom</option>
	</select>
</div>

<div id="imageoptionscontainer" style="display:none">
    <div class="mura-control-group">
    	<label>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</label>
      	<input class="objectParam" name="imageHeight" data-displayobjectparam="imageHeight" type="text" value="#feed.getImageHeight()#" />
    </div>
    <div class="mura-control-group">
        <label class="mura-control-label">#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</label>
    	<input class="objectParam" name="imageWidth" data-displayobjectparam="imageWidth" type="text" value="#feed.getImageWidth()#" />
    </div>
</div>

<div class="mura-control-group" id="availableFields">
	<label>
		<div>#application.rbFactory.getKeyValue(session.rb,'collections.selectedfields')#</div>
		<button id="editFields" class="btn"><i class="mi-pencil"></i> #application.rbFactory.getKeyValue(session.rb,'collections.edit')#</button>
	</label>
	<div id="sortableFields" class="sortable-sidebar">
    	<cfset displaylist=feed.getdisplaylist()>
    	<ul id="displayListSort" class="displayListSortOptions">
    		<cfloop list="#displaylist#" index="i">
    			<li class="ui-state-highlight">#trim(i)#</li>
    		</cfloop>
    	</ul>
    	<input type="hidden" id="displaylist" class="objectParam" value="#esapiEncode('html_attr',feed.getdisplaylist())#" name="displaylist"  data-displayobjectparam="displaylist"/>
    </div>
</div>

<div class="mura-control-group">
  	<label>#application.rbFactory.getKeyValue(session.rb,'collections.viewimagesasgallery')#</label>
	<select name="modalimages" data-displayobjectparam="modalimages" class="objectParam">
		<cfloop list="True,False" index="i">
			<option value="#i#"<cfif objectparams.modalimages eq i> selected</cfif>>#i#</option>
		</cfloop>
	</select>
</div>
<script>
	$(function(){
		$('##editFields').click(function(){
			frontEndProxy.post({
				cmd:'openModal',
				src:'?muraAction=cArch.selectfields&siteid=#esapiEncode("url",rc.siteid)#&contenthistid=#esapiEncode("url",rc.contenthistid)#&instanceid=#esapiEncode("url",rc.instanceid)#&compactDisplay=true&displaylist=' + $("##displaylist").val()
				}
			);
		});

		$("##displayListSort").sortable({
			update: function(event) {
				event.stopPropagation();
				$("##displaylist").val("");
				$("##displayListSort > li").each(function() {
					var current = $("##displaylist").val();

					if(current != '') {
						$("##displaylist").val(current + "," + $(this).html());
					} else {
						$("##displaylist").val($(this).html());
					}

					updateDraft();
				});

				//siteManager.updateObjectPreview();

			}
		}).disableSelection();

		$('##layoutoptionscontainer').show();

		function handleImageSizeChange(){
			if($('select[name="imageSize"]').val()=='custom'){
				$('##imageoptionscontainer').show()
			}else{
				$('##imageoptionscontainer').hide();
				$('##imageoptionscontainer').find(':input').val('AUTO');
			}
		}

		$('select[name="imageSize"]').change(handleImageSizeChange);

		handleImageSizeChange();
	});
</script>
</cfoutput>
