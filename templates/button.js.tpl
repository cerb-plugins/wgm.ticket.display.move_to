{if !$ticket->is_deleted && $active_worker->hasPriv('core.ticket.actions.move')}
<select id="wgm_moveto" name="wgm_moveto" style="display:none;">
	<option value="">-- {'common.move_to'|devblocks_translate|lower} --</option>
		{if empty($ticket->bucket_id)}{assign var=t_or_c value="t"}{else}{assign var=t_or_c value="c"}{/if}
		<optgroup label="{'common.inboxes'|devblocks_translate|capitalize}">
		{foreach from=$groups item=group}
			<option value="t{$group->id}">{$group->name}{if $t_or_c=='t' && $ticket->group_id==$group->id} (*){/if}</option>
		{/foreach}
		</optgroup>
		
		{foreach from=$group_buckets item=buckets key=groupId}
			{assign var=group value=$groups.$groupId}
			{if !empty($active_worker_memberships.$groupId)}
 			<optgroup label="-- {$group->name} --">
 			{foreach from=$buckets item=bucket}
			<option value="c{$bucket->id}">{$bucket->name}{if $t_or_c=='c' && $ticket->bucket_id==$bucket->id} (current bucket){/if}</option>
		{/foreach}
		</optgroup>
	{/if}
	{/foreach}
</select>
 	
<script type="text/javascript">
	$subpage = $('BODY > DIV.cerb-subpage');
	$toolbar = $subpage.find('FORM.toolbar');

	$moveto = $('#wgm_moveto');
	
	$moveto.change(function(e) {
		genericAjaxGet('', 'c=wgm.ticketdisplaymoveto&a=saveDisplayMoveTo&ticket_id={$ticket->id}&wgm_moveto=' + $(this).val(), function(html) {
				window.location.reload();
		});
	});
	
	$moveto.appendTo($toolbar).show();
</script>
{/if}
