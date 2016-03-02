{if $ticket->status_id != Model_Ticket::STATUS_DELETED && $active_worker->hasPriv('core.ticket.actions.move')}
<select id="wgm_moveto" name="bucket_id" style="display:none;">
	<option value="">-- {'common.move_to'|devblocks_translate|lower} --</option>
		{foreach from=$group_buckets item=buckets key=groupId}
			{$group = $groups.$groupId}
			{foreach from=$buckets item=bucket}
				{* If the ticket isn't in this bucket already, and it's a default bucket or the worker is a group member *}
				{if $ticket->bucket_id != $bucket->id && ($bucket->is_default || !empty($active_worker_memberships.$groupId))}
				<option value="{$bucket->id}">{$group->name}: {$bucket->name}</option>
				{/if}
		{/foreach}
	{/foreach}
</select>
 	
<script type="text/javascript">
$(function() {
	var $subpage = $('BODY > DIV.cerb-subpage');
	var $toolbar = $subpage.find('FORM.toolbar');

	var $moveto = $('#wgm_moveto');
	
	$moveto.change(function(e) {
		genericAjaxGet('', 'c=wgm.ticketdisplaymoveto&a=saveDisplayMoveTo&ticket_id={$ticket->id}&bucket_id=' + $(this).val(), function(html) {
				window.location.reload();
		});
	});
	
	$moveto.appendTo($toolbar).show();
});
</script>
{/if}
