{if !$ticket->is_deleted}
{if $active_worker->hasPriv('core.ticket.actions.move')}
  	<select id="wgm_moveto" name="wgm_moveto">
		<option value="">-- {$translate->_('common.move_to')|lower} --</option>
   		{if empty($ticket->category_id)}{assign var=t_or_c value="t"}{else}{assign var=t_or_c value="c"}{/if}
   		<optgroup label="{$translate->_('common.inboxes')|capitalize}">
   		{foreach from=$teams item=team}
   			<option value="t{$team->id}">{$team->name}{if $t_or_c=='t' && $ticket->team_id==$team->id} (*){/if}</option>
   		{/foreach}
   		</optgroup>
   		
   		{foreach from=$team_categories item=categories key=teamId}
   			{assign var=team value=$teams.$teamId}
   			{if !empty($active_worker_memberships.$teamId)}
	   			<optgroup label="-- {$team->name} --">
	   			{foreach from=$categories item=category}
	 				<option value="c{$category->id}">{$category->name}{if $t_or_c=='c' && $ticket->category_id==$category->id} (current bucket){/if}</option>
	 			{/foreach}
	 			</optgroup>
	 		{/if}
  		{/foreach}
   	</select>
   	
   	<script type="text/javascript">
   		$('#wgm_moveto').change(function(e) {
   	   		genericAjaxGet('', 'c=wgm.ticketdisplaymoveto&a=saveDisplayMoveTo&ticket_id={$ticket->id}&wgm_moveto=' + $(this).val(), function(html) {
   	   	   		window.location.reload();
   	   		});
   		});
   	</script>
{/if}
{/if}
