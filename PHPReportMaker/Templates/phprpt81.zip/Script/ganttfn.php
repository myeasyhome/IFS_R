<!--##session ganttfunctions##-->
<?php

//
// Gantt Chart for PHP Report Maker 8
// (C)2011-2014 e.World Technology Limited
//

/**
 * Gantt chart classes
 */

//
// Gantt Chart Categories
//
class crGanttCategories {
	var $Title = "";
	var $Interval = EWR_GANTT_INTERVAL_NONE; // 0-5
	var $CategoriesAttrs = array();
	var $CategoryAttrs = array();
	var $StartDate;
	var $EndDate;

	function SetTitle($title) {
		$this->Title = $title;
		$this->Interval = EWR_GANTT_INTERVAL_NONE; // Reset
	}

	function SetInterval($interval) {
		$this->Interval = $interval;
		$this->Title = ""; // Reset
	}
}

//
// Gantt Chart Data Column
//
class crGanttDataColumn {
	var $FieldName = ""; // Field name
	var $Caption = ""; // Header text
	var $ColumnAttrs = array();
	var $TextAttrs = array();
	var $FormatFunction = "";

	// Constructor
	function crGanttDataColumn($fldname, $caption, $formatfunc) {
		$this->FieldName = $fldname;
		$this->Caption = $caption;
		$this->FormatFunction = $formatfunc;
	}
}

//
// Gantt Chart
//
class crGantt extends crChart {
	var $Name = "";
	var $ProcessesHeaderText;
	var $DateFormat = "yyyy/mm/dd";
	var $UseAdodbTime;
	
	// Table object
	var $Table;

	// Tables
	var $TaskTable = "";
	var $ProcessTable = ""; // Optional
	var $MilestoneTable = ""; // Optional
	var $ConnectorTable = ""; // Optional
	var $TrendlineTable = ""; // Optional

	// Task Table Fields
	var $TaskIdField = "";
	var $TaskNameField = "";
	var $TaskStartField = "";
	var $TaskEndField = "";
	var $TaskFromTaskIdField = ""; // Optional
	var $TaskMilestoneDateField = ""; // Optional
	var $TaskFilter = ""; // Table filter
	var $TaskIdFilter = ""; // Task Id filter
	var $TaskNameFilter = ""; // Task Name filter

	// Category
	var $Categories = array(); // Array of crGanttCategories
	var $Intervals = array(); // Array of category intervals
	var $Connectors = array(); // Array of connectors
	var $Trendlines = array(); // Array of trendlines
	var $Milestones = array(); // Array of milestones
	var $StartDate;
	var $EndDate;
	var $FixedStartDate; // Must in 'yyyy-mm-dd' format
	var $FixedEndDate; // Must in 'yyyy-mm-dd' format

	// Data columns
	var $DataColumns = array(); // Array of crGanttDataColumn

	// XML DOMDocument object
	var $XmlDoc;

	// Default styles
	var $HeaderColor = '4567aa';
	var $HeaderFontColor = 'ffffff';
	var $CategoryColor = '';
	var $CategoryFontColor = '';
	var $HeaderIsBold = '1';
	var $TaskColors = array('FF0000', 'FF0080', 'FF00FF', '8000FF', 'FF8000',
		'FF3D3D', '7AFFFF', '0000FF', 'FFFF00', 'FF7A7A', '3DFFFF', '0080FF',
		'80FF00', '00FF00', '00FF80', '00FFFF'); // Task colors
	var $ShowWeekNumber = TRUE;

	// Chart properties
	var $ChartAttrs = array(); // Attributes for <chart>
	var $ProcessesAttrs = array(); // Attributes for <processes>
	var $ProcessAttrs = array(); // Attributes for <process>
	var $TasksAttrs = array(); // Attributes for <tasks>
	var $TaskAttrs = array('alpha'=>75); // Attributes for <task>
	var $ConnectorsAttrs = array(); // Attributes for <connectors>
	var $ConnectorAttrs = array(); // Attributes for <connector>
	var $DataTableAttrs = array(); // Attributes for <datatable>
	var $TrendlineAttrs = array(); // Attributes for <trendline>
	var $MilestoneAttrs = array('radius'=>'6', 'shape'=>'Polygon', 'numSides'=>'4', 'borderColor'=>'333333', 'borderThickness'=>'1'); // Attributes for <milestone>

	// Constructor
	function crGantt($table, $fid, $fname, $fstart, $fend) {
		global $ReportLanguage;
		$this->UseAdodbTime = function_exists("adodb_mktime");
		$this->TaskTable = $table;
		$this->TaskIdField = $fid;
		$this->TaskNameField = $fname;
		$this->TaskStartField = $fstart;
		$this->TaskEndField = $fend;
		$this->XmlDoc = new DOMDocument("1.0", "utf-8");
		$this->XmlDoc->appendChild($this->XmlDoc->createElement("chart"));
		$this->ChartAttrs["extendcategoryBg"] = "0";
		$this->ProcessesHeaderText = $ReportLanguage->Phrase("Tasks");
	}
	
	// Set XML attribute
	function SetAttribute(&$element, $name, $value) {
		if (!$element)
			return;
		$element->setAttribute($name, ewr_ConvertToUtf8($value));
	}

	// Get inteval as integer
	function GetIntervalValue($interval) {
		$interval = strtoupper($interval);
		if ($interval == "_YEAR") {
			return EWR_GANTT_INTERVAL_YEAR;
		} elseif ($interval == "_QUARTER") {
			return EWR_GANTT_INTERVAL_QUARTER;
		} elseif ($interval == "_MONTH") {
			return EWR_GANTT_INTERVAL_MONTH;
		} elseif ($interval == "_WEEK") {
			return EWR_GANTT_INTERVAL_WEEK;
		} elseif ($interval == "_DAY") {
			return EWR_GANTT_INTERVAL_DAY;
		} else {
			return EWR_GANTT_INTERVAL_NONE;
		}
	}

	// Add categories
	function AddCategories($type) {
		if ($type == "")
    	return;
		if (in_array(strtoupper($type), array("_YEAR", "_QUARTER", "_MONTH", "_WEEK", "_DAY"))) { // Interval
			$intv = $this->GetIntervalValue($type);
			if ($intv > EWR_GANTT_INTERVAL_NONE) {
				$this->Intervals[] = $intv;
				$cats = new crGanttCategories();
				$cats->SetInterval($intv);
				$this->Categories[$type] = $cats;
			}
		} else { // Title
			$cats = new crGanttCategories();
			$cats->SetTitle($type);
			$this->Categories[$type] = $cats;
		}
	}

	// Add data column
	function AddDataColumn($fldname, $caption, $formatfunc = "") {
		$this->DataColumns[$fldname] = new crGanttDataColumn($fldname, $caption, $formatfunc);
	}

	// Add connector
	function AddConnector($ar) {
		$this->Connectors[] = $ar;
	}

	// Add trendline
	function AddTrendline($ar) {
		$this->Trendlines[] = $ar;
	}

	// Add milestone
	function AddMilestone($ar) {
		$this->Milestones[] = $ar;
	}

	// Create datetime
	function CreateDateTime($hour, $min, $sec, $month, $day, $year) {
		if ($this->UseAdodbTime) {
			return adodb_mktime($hour, $min, $sec, $month, $day, $year);
		} else {
			return mktime($hour, $min, $sec, $month, $day, $year);
		}
	}

	// Get datetime info
	function GetDateTime($ts) {
		if ($this->UseAdodbTime) {
			return adodb_getdate($ts);
		} else {
			return getdate($ts);
		}
	}

	// Get datetime info
	function FormatDate($format, $date) {
		if ($this->UseAdodbTime) {
			return adodb_date($format, $date);
		} else {
			return date($format, $date);
		}
	}

	// Convert Year/Month/Day to string
	function YMDToStr($y, $m, $d) {
		if ($this->DateFormat == 'mm/dd/yyyy') {
			return str_pad($m, 2, '0', STR_PAD_LEFT) . '/' . str_pad($d, 2, '0', STR_PAD_LEFT) . '/' . strval($y);
		} elseif ($this->DateFormat == 'dd/mm/yyyy') {
			return str_pad($d, 2, '0', STR_PAD_LEFT) . '/' . str_pad($m, 2, '0', STR_PAD_LEFT) . '/' . strval($y);
		} else { // 'yyyy/mm/dd'
			return strval($y) . '/' . str_pad($m, 2, '0', STR_PAD_LEFT) . '/' . str_pad($d, 2, '0', STR_PAD_LEFT);
		}
	}

	// Convert date time info (from getdate) to string
	function DateTimeToStr($dt) {
		return $this->YMDToStr($dt["year"], $dt["mon"], $dt["mday"]);
	}

	// Convert date (timestamp) to string
	function DateToStr($d) {
		$dt = $this->GetDateTime($d);
		return $this->DateTimeToStr($dt);
	}

	// Convert database date (yyyy-mm-dd) to yyyy/mm/dd
	function DBDateToStr($str) {
		$date = $this->ParseDate($str);
		return $this->DateToStr($date);
	}

	// Parse string to datetime
	function ParseDate($str) {
		if (preg_match('/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/', $str, $matches)) { // DateTime
			$year = $matches[1];
			$month = $matches[2];
			$day = $matches[3];
			$hour = $matches[4];
			$min = $matches[5];
			$sec = $matches[6];
			return $this->CreateDateTime($hour, $min, $sec, $month, $day, $year);
		} elseif (preg_match('/(\d{4})-(\d{2})-(\d{2})/', $str, $matches)) { // Date
			$year = $matches[1];
			$month = $matches[2];
			$day = $matches[3];
			return $this->CreateDateTime(0, 0, 0, $month, $day, $year);
		}
		return $str;
	}

	// Get task color
	function GetTaskColor($i) {
		$color = "";
		if (is_array($this->TaskColors)) {
			$cntar = count($this->TaskColors);
			if ($cntar > 0) {
				$color = $this->TaskColors[$i % $cntar];
				$color = str_replace('#', '', $color);
			}
		}
		return $color;
	}

	// Set up start/end dates
	function SetupStartEnd() {
		global $conn;
		$sql = "SELECT MIN(" . ewr_QuotedName($this->TaskStartField) . "), MAX(". ewr_QuotedName($this->TaskEndField) . ") FROM " . ewr_QuotedName($this->TaskTable);
		if ($this->TaskFilter <> "") $sql .= " WHERE " . $this->TaskFilter;
		$rs = $conn->Execute($sql);
		if ($rs && !$rs->EOF) {
			$start = $rs->fields[0];
			$end = $rs->fields[1];
			$rs->Close();
		} else {
			die('Error: Missing tasks.');
		}
		$start = $this->ParseDate($start);
		$end = $this->ParseDate($end);
		$arStart = $this->GetDateTime($start);
		$arEnd = $this->GetDateTime($end);
		$min = $start;
		$max = $end;
		$cnt = 0;
		foreach ($this->Intervals as $interval) {

//			if ($interval == EWR_GANTT_INTERVAL_YEAR) {
//				$start = $this->CreateDateTime(0, 0, 0, 1, 1, intval($arStart["year"]));
//				$end = $this->CreateDateTime(0, 0, 0, 12, 31, intval($arEnd["year"]));
//				$cnt++;
//			} elseif ($interval == EWR_GANTT_INTERVAL_QUARTER) {
//				$qtr = floor(intval($arStart["mon"])/4) + 1;
//				$start = $this->CreateDateTime(0, 0, 0, ($qtr*3-2), 1, intval($arStart["year"]));
//				$yr = intval($arEnd["year"]);
//				$qtr = floor(intval($arEnd["mon"])/4) + 1;
//				$mon = $qtr * 3;
//				$end = $this->CreateDateTime(0, 0, 0, $mon, ewr_DaysInMonth($yr, $mon), $yr);
//				$cnt++;
//			} elseif ($interval == EWR_GANTT_INTERVAL_MONTH) {

			if ($interval == EWR_GANTT_INTERVAL_YEAR ||
				$interval == EWR_GANTT_INTERVAL_QUARTER ||
				$interval == EWR_GANTT_INTERVAL_MONTH) {
				$mon = intval($arStart["mon"]);
				$tempstart = $this->CreateDateTime(0, 0, 0, $mon, 1, intval($arStart["year"]));
				$yr = intval($arEnd["year"]);
				$mon = intval($arEnd["mon"]);
				$tempend = $this->CreateDateTime(0, 0, 0, $mon, ewr_DaysInMonth($yr, $mon), intval($arEnd["year"]));
				$cnt++;
			} elseif ($interval == EWR_GANTT_INTERVAL_WEEK) {
				$wday = $arStart["wday"];
				$diff = ($wday >= EWR_GANTT_WEEK_START) ? ($wday - EWR_GANTT_WEEK_START) : ($wday + 7 - EWR_GANTT_WEEK_START);
				$tempstart = $start - $diff * 86400;
				$wday = $arEnd["wday"];
				$diff = ($wday >= EWR_GANTT_WEEK_START) ? ($wday - EWR_GANTT_WEEK_START) : ($wday + 7 - EWR_GANTT_WEEK_START);
				$tempend = $end + (6 - $diff) * 86400;
				$cnt++;
			}

			// Start date
			if ($tempstart < $min)
				$min = $tempstart;

			// End date
			if ($tempend > $max)
				$max = $tempend;
		}
		if ($cnt == 0) {
			$min -= 86400;
			$max += 86400;
		}
		$this->StartDate = $min;
		$this->EndDate = $max;

		// Check if fixed start date specified
		if (isset($this->FixedStartDate)) {
			$fd = $this->ParseDate($this->FixedStartDate);
			if ($fd !== FALSE)
				$this->StartDate = $fd;
		}

		// Check if fixed end date specified
		if (isset($this->FixedEndDate)) {
			$fd = $this->ParseDate($this->FixedEndDate);
			if ($fd !== FALSE)
				$this->EndDate = $fd;
		}
	}

	// Output table
	function OutputQuery($sql, $tagname, $childtagname, $attrs, $childattrs) {
		global $conn;
		$rs = $conn->Execute($sql);
		$this->OutputArray($rs->GetRows(), $tagname, $childtagname, $attrs, $childattrs);
		if ($rs)
			$rs->Close();
	}

	// Output table
	function OutputArray($rs, $tagname, $childtagname, $attrs, $childattrs) {
		if (is_array($rs)) {
			$elements = $this->XmlDoc->getElementsByTagName($tagname);
			$el = NULL;
			foreach ($elements as $element)
				$el = $element;
			if (!$el) {
				$el = $this->XmlDoc->createElement($tagname);
				foreach ($attrs as $attr => $value)
					$this->SetAttribute($el, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
				$this->Chart_DataRendered($el);
	<!--## } ##-->
				$this->XmlDoc->documentElement->appendChild($el);
			}
			foreach ($rs as $row) {
				$cat = $this->XmlDoc->createElement($childtagname);
				foreach ($childattrs as $attr => $value)
					$this->SetAttribute($cat, $attr, $value);
				foreach ($row as $name => $value) {
					if (!is_numeric($name)) {
						if (in_array($name, array('start', 'end', 'date'))) // Date attributes
					 		$value = $this->DBDateToStr($value);
						$this->SetAttribute($cat, $name, $value);
					}
				}
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
				$this->Chart_DataRendered($cat);
	<!--## } ##-->
				$el->appendChild($cat);
			}
		}
	}

	// Ouptut <categories> node
	function OutputCategories() {
		global $ReportLanguage;
		foreach ($this->Categories as $cats) {
			$el = $this->XmlDoc->createElement("categories");
			if (!isset($cats->CategoriesAttrs['bgColor']))
				$cats->CategoriesAttrs['bgColor'] = $this->CategoryColor;
			if (!isset($cats->CategoriesAttrs['fontColor']))
				$cats->CategoriesAttrs['fontColor'] = $this->CategoryFontColor;
			foreach ($cats->CategoriesAttrs as $attr => $value)
				$this->SetAttribute($el, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
			$this->Chart_DataRendered($el);
	<!--## } ##-->
			$this->XmlDoc->documentElement->appendChild($el);
			if ($cats->Title <> "") { // Title
				$cat = $this->XmlDoc->createElement("category");
				$this->SetAttribute($cat, 'start', $this->DateToStr($this->StartDate));
				$this->SetAttribute($cat, 'end', $this->DateToStr($this->EndDate));
				$this->SetAttribute($cat, 'name', $cats->Title);
				foreach ($cats->CategoryAttrs as $attr => $value)
					$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
				$this->Chart_DataRendered($cat);
	<!--## } ##-->
				$el->appendChild($cat);
			} else { // Intervals
				$arStart = $this->GetDateTime($this->StartDate);
				$arEnd = $this->GetDateTime($this->EndDate);
				if ($cats->Interval == EWR_GANTT_INTERVAL_YEAR) {
					$yrs = intval($arStart["year"]);
					$yre = intval($arEnd["year"]);
					for ($y = $yrs; $y <= $yre; $y++) {
						$cat = $this->XmlDoc->createElement("category");
						$start = ($y == $yrs) ? $this->DateTimeToStr($arStart) : $this->YMDToStr($y, 1, 1);
						$end = ($y == $yre) ? $this->DateTimeToStr($arEnd) : $this->YMDToStr($y, 12, 31);
						$this->SetAttribute($cat, 'start', $start);
						$this->SetAttribute($cat, 'end', $end);

						//if ($start == $this->YMDToStr($y, 1, 1) && $end == $this->YMDToStr($y, 12, 31)) // Complete year
							$this->SetAttribute($cat, 'name', $y);
						foreach ($cats->CategoryAttrs as $attr => $value)
							$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
						$this->Chart_DataRendered($el);
	<!--## } ##-->
						$el->appendChild($cat);
					}
				} elseif ($cats->Interval == EWR_GANTT_INTERVAL_QUARTER) {
					$yrs = intval($arStart["year"]);
					$mons = intval($arStart["mon"]);
					$qtrs = floor(($mons-1)/3) + 1;
					$qs = $yrs * 4 + $qtrs;
					$yre = intval($arEnd["year"]);
					$mone = intval($arEnd["mon"]);
					$qtre = floor(($mone-1)/3) + 1;
					$qe = $yre * 4 + $qtre;
					for ($q = $qs; $q <= $qe; $q++) {
						$cat = $this->XmlDoc->createElement("category");
						$yr = floor($q/4);
						$qtr = $q % 4;
						$yr = ($qtr == 0) ? $yr - 1 : $yr;
						$qtr = ($qtr == 0) ? 4 : $qtr;
						$mos = ($qtr - 1) * 3 + 1;
						$moe = $qtr * 3;
						$dys = $this->CreateDateTime(0, 0, 0, $mos, 1, $yr);
						if ($this->StartDate > $dys)
							$dys = $this->StartDate;
						$dy = ewr_DaysInMonth($yr, $moe);
						$dye = $this->CreateDateTime(0, 0, 0, $moe, $dy, $yr);
						if ($this->EndDate < $dye)
							$dye = $this->EndDate;
						$start = ($q == $qs) ? $this->DateToStr($dys) : $this->YMDToStr($yr, $mos, 1);
						$end = ($q == $qe) ? $this->DateToStr($dye) : $this->YMDToStr($yr, $moe, $dy);
						$this->SetAttribute($cat, 'start', $start);
						$this->SetAttribute($cat, 'end', $end);

						//if ($start == $this->YMDToStr($yr, $mos, 1) && $end == $this->YMDToStr($yr, $moe, $dy)) // Complete quarter
							$this->SetAttribute($cat, 'name', 'Q' . $qtr);
						foreach ($cats->CategoryAttrs as $attr => $value)
							$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
						$this->Chart_DataRendered($cat);
	<!--## } ##-->
						$el->appendChild($cat);
					}
				} elseif ($cats->Interval == EWR_GANTT_INTERVAL_MONTH) {
					$yrs = intval($arStart["year"]);
					$mons = intval($arStart["mon"]);
					$ms = $yrs * 12 + $mons;
					$yre = intval($arEnd["year"]);
					$mone = intval($arEnd["mon"]);
					$me = $yre * 12 + $mone;
					for ($m = $ms; $m <= $me; $m++) {
						$cat = $this->XmlDoc->createElement("category");
						$yr = floor($m/12);
						$mo = $m % 12;
						$yr = ($mo == 0) ? $yr - 1 : $yr;
						$mo = ($mo == 0) ? 12 : $mo;
						$dy = ewr_DaysInMonth($yr, $mo);
						$start = ($m == $ms) ? $this->DateTimeToStr($arStart) : $this->YMDToStr($yr, $mo, 1);
						$end = ($m == $me) ? $this->DateTimeToStr($arEnd) : $this->YMDToStr($yr, $mo, $dy);
						$this->SetAttribute($cat, 'start', $start);
						$this->SetAttribute($cat, 'end', $end);
						if ($start == $this->YMDToStr($yr, $mo, 1) && $end == $this->YMDToStr($yr, $mo, $dy)) // Complete month
							$this->SetAttribute($cat, 'name', ewr_MonthName($mo)); // Or ewr_FormatMonth
						foreach ($cats->CategoryAttrs as $attr => $value)
							$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
						$this->Chart_DataRendered($cat);
	<!--## } ##-->
						$el->appendChild($cat);
					}
				} elseif ($cats->Interval == EWR_GANTT_INTERVAL_WEEK) {
					$ds = $this->StartDate;
					$de = $this->EndDate;
					for ($d = $ds; $d < $de; $d += 86400) {
						$dts = $this->GetDateTime($d);

						//$dte = $this->GetDateTime($d + 6*86400);
						$wday = $dts["wday"];
						$diff = ($wday >= EWR_GANTT_WEEK_START) ? ($wday - EWR_GANTT_WEEK_START) : ($wday + 7 - EWR_GANTT_WEEK_START);
						$ws = ($d == $ds) ? $ds : ($d - $diff * 86400);
						$we = ($d == $de) ? $de : ($d + (6 - $diff) * 86400);
						$d = $we;
						$cat = $this->XmlDoc->createElement("category");
						$this->SetAttribute($cat, 'start', $this->DateToStr($ws));
						$this->SetAttribute($cat, 'end', $this->DateToStr($we));
						if ($this->ShowWeekNumber && EWR_GANTT_WEEK_START == 1) { // Week start on Monday
							$this->SetAttribute($cat, 'name', $ReportLanguage->Phrase("Week") . " " . $this->FormatDate("W",$d));
						} else {
							$this->SetAttribute($cat, 'name', $ReportLanguage->Phrase("Week"));
						}
						foreach ($cats->CategoryAttrs as $attr => $value)
							$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
						$this->Chart_DataRendered($cat);
	<!--## } ##-->
						$el->appendChild($cat);
					}
				} elseif ($cats->Interval == EWR_GANTT_INTERVAL_DAY) {
					$ds = $this->StartDate;
					$de = $this->EndDate;
					for ($d = $ds; $d <= $de; $d += 86400) {
						$dt = $this->GetDateTime($d);
						$md = $dt["mday"];
						$cat = $this->XmlDoc->createElement("category");
						$sdt = $this->DateTimeToStr($dt);
						$this->SetAttribute($cat, 'start', $sdt);
						$this->SetAttribute($cat, 'end', $sdt);
						$this->SetAttribute($cat, 'name', $md);
						foreach ($cats->CategoryAttrs as $attr => $value)
							$this->SetAttribute($cat, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
						$this->Chart_DataRendered($cat);
	<!--## } ##-->
						$el->appendChild($cat);
					}
				}
			}
		}
	}

	// Output Data Table
	function OutputDataTable() {
		global $conn;
		if ($this->ProcessTable == "" || empty($this->DataColumns))
			return;
		$dt = $this->XmlDoc->createElement("dataTable");
		foreach ($this->DataTableAttrs as $attr => $value)
			$this->SetAttribute($dt, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
		$this->Chart_DataRendered($dt);
	<!--## } ##-->
		$this->XmlDoc->documentElement->appendChild($dt);
		$sql = "SELECT * FROM " . ewr_QuotedName($this->ProcessTable);
		$rs = $conn->Execute($sql);
		if ($rs && !$rs->EOF) {
			$i = 0;
			foreach ($this->DataColumns as $dc) {
				$col = $this->XmlDoc->createElement("dataColumn");
				if (!isset($dc->ColumnAttrs['headerbgColor']))
					$dc->ColumnAttrs['headerbgColor'] = $this->HeaderColor;
				if (!isset($dc->ColumnAttrs['headerFontColor']))
					$dc->ColumnAttrs['headerFontColor'] = $this->HeaderFontColor;
				if (!isset($dc->ColumnAttrs['bgColor']))
					$dc->ColumnAttrs['bgColor'] = $this->CategoryColor;
				if (!isset($dc->ColumnAttrs['fontColor']))
					$dc->ColumnAttrs['fontColor'] = $this->CategoryFontColor;
				foreach ($dc->ColumnAttrs as $attr => $value)
					$this->SetAttribute($col, $attr, $value);
				$this->SetAttribute($col, 'headerText', $dc->Caption); // Column header
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
				$this->Chart_DataRendered($col);
	<!--## } ##-->
				$dt->appendChild($col);
				$rs->MoveFirst();
				while (!$rs->EOF) {
					$txt = $this->XmlDoc->createElement("text");
					foreach ($dc->TextAttrs as $attr => $value)
						$this->SetAttribute($txt, $attr, $value);
					$fldval = $rs->fields[$dc->FieldName];
					$formatfunc = $dc->FormatFunction;
					if ($formatfunc <> "" && function_exists($formatfunc))
						$fldval = $formatfunc($fldval);
					$this->SetAttribute($txt, 'label', $fldval);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
					$this->Chart_DataRendered($txt);
	<!--## } ##-->
					$col->appendChild($txt);
					$rs->MoveNext();
				}
				$i++;
			}
			$rs->Close();
		}
	}

	// Task table order by
	function TaskTableOrderBy() {
		return " ORDER BY " . ewr_QuotedName($this->TaskStartField);
	}

	// Output Tasks
	function OutputTasks() {
		global $conn;
		$tasks = $this->XmlDoc->createElement("tasks");
		foreach ($this->TasksAttrs as $attr => $value)
			$this->SetAttribute($tasks, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
		$this->Chart_DataRendered($tasks);
	<!--## } ##-->
		$this->XmlDoc->documentElement->appendChild($tasks);
		$sql = "SELECT * FROM " . ewr_QuotedName($this->TaskTable);
		if ($this->TaskFilter <> "") $sql .= " WHERE " . $this->TaskFilter;
		$sql .= $this->TaskTableOrderBy();
		$rs = $conn->Execute($sql);
		if ($rs) {
			$arFields = array(strtolower($this->TaskIdField), strtolower($this->TaskNameField), strtolower($this->TaskStartField), strtolower($this->TaskEndField));
			$cnt = 0;
			while (!$rs->EOF) {
				$task = $this->XmlDoc->createElement("task");
				foreach ($this->TaskAttrs as $attr => $value) {
					if (!in_array(strtolower($attr), $arFields))
						$this->SetAttribute($task, $attr, $value);
				}
				if ($this->ProcessTable == "") // ' No process table, set up process id
					$this->SetAttribute($task, 'processid', $rs->fields($this->TaskIdField));
				foreach ($rs->fields as $name => $value) {
					if (!is_numeric($name) && !in_array(strtolower($name), $arFields))
						$this->SetAttribute($task, strtolower($name), $value);
				}
				$this->SetAttribute($task, 'id', $rs->fields($this->TaskIdField));
				$this->SetAttribute($task, 'name', $rs->fields($this->TaskNameField));
				$this->SetAttribute($task, 'start', $this->DBDateToStr($rs->fields($this->TaskStartField)));
				$this->SetAttribute($task, 'end', $this->DBDateToStr($rs->fields($this->TaskEndField)));
				if ($task->getAttribute('color') == "") {
					$color = $this->GetTaskColor($cnt);
					if ($color <> "")
						$this->SetAttribute($task, 'color', $color);
				}
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
				$this->Chart_DataRendered($task);
	<!--## } ##-->
				$tasks->appendChild($task);
				$rs->MoveNext();
				$cnt++;
			}
			$rs->Close();
		}
	}

	// Process table order by
	function ProcessTableOrderBy() {
		return "";
	}

	// Output processes
	function OutputProcesses() {
		global $conn;
		if (!isset($this->ProcessesAttrs['bgColor']))
			$this->ProcessesAttrs['bgColor'] = $this->HeaderColor;
		if (!isset($this->ProcessesAttrs['fontColor']))
			$this->ProcessesAttrs['fontColor'] = $this->HeaderFontColor;
		if (!isset($this->ProcessesAttrs['headerBgColor']))
			$this->ProcessesAttrs['headerBgColor'] = $this->HeaderColor;
		if (!isset($this->ProcessesAttrs['headerFontColor']))
			$this->ProcessesAttrs['headerFontColor'] = $this->HeaderFontColor;
		if (!isset($this->ProcessesAttrs['headerText']))
			$this->ProcessesAttrs['headerText'] = $this->ProcessesHeaderText;
		if (!isset($this->ProcessesAttrs['isBold']))
			$this->ProcessesAttrs['isBold'] = $this->HeaderIsBold;
		if ($this->ProcessTable <> "") { // Use process table
			$processes = $this->XmlDoc->createElement("processes");
			foreach ($this->ProcessesAttrs as $attr => $value)
				$this->SetAttribute($processes, $attr, $value);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
			$this->Chart_DataRendered($processes);
	<!--## } ##-->
			$this->XmlDoc->documentElement->appendChild($processes);
			$sql = "SELECT * FROM " . ewr_QuotedName($this->ProcessTable);
			$sql .= $this->ProcessTableOrderBy();
			$rs = $conn->Execute($sql);
			if ($rs) {
				while (!$rs->EOF) {
					$process = $this->XmlDoc->createElement("process");
					foreach ($this->ProcessAttrs as $attr => $value)
						$this->SetAttribute($process, $attr, $value);
					foreach ($rs->fields as $name => $value) {
						if (!is_numeric($name))
							$this->SetAttribute($process, $name, $value);
					}
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
					$this->Chart_DataRendered($process);
	<!--## } ##-->
					$processes->appendChild($process);
					$rs->MoveNext();
				}
				$rs->Close();
			}
		} else { // Use task table as process table
			$fid = $this->TaskIdField;
			$fname = $this->TaskNameField;
			$fstart = $this->TaskStartField;
			$sql = "SELECT DISTINCT " . ewr_QuotedName($fid) . " AS id, " .
				ewr_QuotedName($fname) . " AS name, " . ewr_QuotedName($fstart) . " FROM " . ewr_QuotedName($this->TaskTable);
			if ($this->TaskIdFilter <> "" || $this->TaskNameFilter <> "") {
				$sql .= " WHERE ";
				if ($this->TaskIdFilter <> "")
					$sql .= $this->TaskIdFilter;
				if ($this->TaskNameFilter <> "")
					$sql .= ($this->TaskIdFilter <> "" ? " AND " : "") . $this->TaskNameFilter;
			}
			$sql .= $this->TaskTableOrderBy();
			$this->OutputQuery($sql, 'processes', 'process', $this->ProcessesAttrs, $this->ProcessAttrs);
		}
	}

	// Output XML
	function Xml() {

		// Start/End dates
		$this->SetupStartEnd();

		// Chart_Rendering event
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_Rendering")) { ##-->
		$this->Chart_Rendering();
	<!--## } ##-->

		// Chart attributes
		foreach ($this->ChartAttrs as $attr => $value)
			$this->SetAttribute($this->XmlDoc->documentElement, $attr, $value);
		$this->SetAttribute($this->XmlDoc->documentElement, 'dateFormat', $this->DateFormat);
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_DataRendered")) { ##-->
		$this->Chart_DataRendered($this->XmlDoc->documentElement);
	<!--## } ##-->

		// Categories
		$this->OutputCategories();

		// Processes
		$this->OutputProcesses();

		// DataTable
		$this->OutputDataTable();

		// Tasks
		$this->OutputTasks();

		// Milestones
		if ($this->MilestoneTable <> "") {
			$sql = "SELECT * FROM " . ewr_QuotedName($this->MilestoneTable);
			$this->OutputQuery($sql, 'milestones', 'milestone', array(), $this->MilestoneAttrs);
		} elseif ($this->TaskMilestoneDateField <> "") { // Use task table as milestone table
			$sql = "SELECT " . ewr_QuotedName($this->TaskIdField) . " AS ". ewr_QuotedName('taskId') . ", " .
				ewr_QuotedName($this->TaskMilestoneDateField) . " AS " . ewr_QuotedName('date') .
				" FROM " . ewr_QuotedName($this->TaskTable) .
				" WHERE " . ewr_QuotedName($this->TaskMilestoneDateField) . " IS NOT NULL";
			$this->OutputQuery($sql, 'milestones', 'milestone', array(), $this->MilestoneAttrs);
		}
		$this->OutputArray($this->Milestones, 'milestones', 'milestone', array(), $this->MilestoneAttrs);

		// Trendlines
		if ($this->TrendlineTable <> "") {
			$sql = "SELECT * FROM " . ewr_QuotedName($this->TrendlineTable);
			$this->OutputQuery($sql, 'trendlines', 'line', array(), $this->TrendlineAttrs);
		}
		$this->OutputArray($this->Trendlines, 'trendlines', 'line', array(), $this->TrendlineAttrs);

		// Connectors
		if ($this->ConnectorTable <> "") {
			$sql = "SELECT * FROM " . ewr_QuotedName($this->ConnectorTable);
			$this->OutputQuery($sql, 'connectors', 'connector', $this->ConnectorsAttrs, $this->ConnectorAttrs);
		} elseif ($this->TaskFromTaskIdField <> "") { // Use task table as connector table
			$sql = "SELECT " . ewr_QuotedName($this->TaskFromTaskIdField) . " AS ". ewr_QuotedName('fromTaskId') . ", " .
				ewr_QuotedName($this->TaskIdField) . " AS ". ewr_QuotedName('toTaskId') . " FROM " . ewr_QuotedName($this->TaskTable);
			$this->OutputQuery($sql, 'connectors', 'connector', $this->ConnectorsAttrs, $this->ConnectorAttrs);
		}
		$this->OutputArray($this->Connectors, 'connectors', 'connector', $this->ConnectorsAttrs, $this->ConnectorAttrs);
		
		// Get the XML
		$xml = $this->XmlDoc->saveXML();

		// Chart_Rendered event
	<!--## if (SYSTEMFUNCTIONS.ServerScriptExist("Global","Chart_Rendered")) { ##-->
		$this->Chart_Rendered($xml);
	<!--## } ##-->

		// Output
		return $xml;
	}
}
?>
<!--##/session##-->