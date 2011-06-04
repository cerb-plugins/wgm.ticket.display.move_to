<?php
if (class_exists('Extension_TicketToolbarItem',true)):
	class TicketToolbarItem_WgmDisplayShortcut extends Extension_TicketToolbarItem {
		function render(Model_Ticket $ticket) { 
			$tpl = DevblocksPlatform::getTemplateService();
			
			$groups = DAO_Group::getAll();
			$tpl->assign('groups', $groups);
			
			$buckets = DAO_Bucket::getAll();
			$tpl->assign('buckets', $buckets);
			
			$team_categories = DAO_Bucket::getTeams();
			$tpl->assign('team_categories', $team_categories);
			
			$tpl->assign('ticket', $ticket); /* @var $message Model_Ticket */			
			$tpl->display('devblocks:wgm.ticket.display.move_to::button.tpl');
		}
	};
endif;

if (class_exists('DevblocksControllerExtension',true)):
class Controller_WgmDisplayShortcutAjax extends DevblocksControllerExtension {
	function isVisible() {
		// The current session must be a logged-in worker to use this page.
		if(null == ($worker = CerberusApplication::getActiveWorker()))
			return false;
		return true;
	}

	/*
	 * Request Overload
	 */
	function handleRequest(DevblocksHttpRequest $request) {
		$stack = $request->path;
		array_shift($stack); // example
		
	    @$action = array_shift($stack) . 'Action';

	    switch($action) {
	        case NULL:
	            // [TODO] Index/page render
	            break;
	            
	        default:
			    // Default action, call arg as a method suffixed with Action
				if(method_exists($this,$action)) {
					call_user_func(array(&$this, $action));
				}
	            break;
	    }
	    
	    exit;
	}

	function writeResponse(DevblocksHttpResponse $response) {
		return;
	}
	
	function saveDisplayMoveToAction() {
		@$ticket_id = DevblocksPlatform::importGPC($_REQUEST['ticket_id'],'integer');
		@$bucket = DevblocksPlatform::importGPC($_REQUEST['wgm_moveto'],'string','');
		
		$groups = DAO_Group::getAll();
		$buckets = DAO_Bucket::getAll();
		
		if(empty($ticket_id))
			exit;
		
		// Team/Category
		if(!empty($bucket)) {
			list($team_id, $bucket_id) = CerberusApplication::translateTeamCategoryCode($bucket);

			if(!empty($team_id)) {
				$fields = array(
			    	DAO_Ticket::TEAM_ID => $team_id,
			    	DAO_Ticket::CATEGORY_ID => $bucket_id,
			    );
			    DAO_Ticket::update($ticket_id, $fields);
			}
		}
		
		exit;
	}
};
endif;