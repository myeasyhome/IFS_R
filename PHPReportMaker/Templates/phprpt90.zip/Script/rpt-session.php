<!--##session session_script##-->
<?php
ewr_Header(FALSE);
$session = new crsession;
$session->Page_Main();

//
// Page class for session
//
class crsession {

	// Page ID
	var $PageID = "session";

	// Project ID
	var $ProjectID = "<!--##=PROJ.ProjID##-->";

	// Page object name
	var $PageObjName = "session";

	// Page name
	function PageName() {
		return ewr_CurrentPage();
	}

	// Page URL
	function PageUrl() {
		return ewr_CurrentPage() . "?";
	}
	
	// Main
	// - Uncomment ** for database connectivity / Page_Loading / Page_Unloaded server event
	function Page_Main() {
		global $conn;
		$GLOBALS["Page"] = &$this;

		//**$conn = ewr_Connect();

	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Page_Loading")) { ##-->
		// Global Page Loading event (in userfn*.php)
		//**Page_Loading();
	<!--## } ##-->

		if (ob_get_length())
			ob_end_clean();

		$time = time();
		$_SESSION["EWR_LAST_REFRESH_TIME"] = $time;
		echo ewr_Encrypt($time);

	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Page_Unloaded")) { ##-->
		// Global Page Unloaded event (in userfn*.php)
		//**Page_Unloaded();
	<!--## } ##-->

		 // Close connection
		//**ewr_CloseConn();

	}
}
?>
<!--##/session##-->