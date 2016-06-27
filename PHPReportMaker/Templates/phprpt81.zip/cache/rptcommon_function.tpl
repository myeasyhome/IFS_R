function ewExrptcommon() {
 try {
var ewAr = new Array();
var ewSB = new StringBuilder();
ew_SetLocale();
ew_LoadCurrent();
ewAr[1] = "/*"+"\r\n"+" *** -----------------------------------------"+"\r\n"+" ***  IMPORTANT - DO NOT CHANGE"+"\r\n"+" ***"+"\r\n"+""+"\r\n"+" ***********************"+"\r\n"+" * Common variables"+"\r\n"+" */"+"\r\n"+""+"\r\n"+"// Global system variable: bDBMsAccess, bDBMsSql, bDBMySql, bDBPostgreSql, bDBOracle"+"\r\n"+""+"\r\n"+"// Table level variables - set up in rpt-phpcommon-table.php"+"\r\n"+"var gsTblVar;"+"\r\n"+"var gsTblName;"+"\r\n"+""+"\r\n"+"// Chart level variables"+"\r\n"+"var goChts;"+"\r\n"+"var goCht;"+"\r\n"+"var gsChartName;"+"\r\n"+"var gsChartVar;"+"\r\n"+"var gsChartObj;"+"\r\n"+""+"\r\n"+"// Chart array"+"\r\n"+"var arAllCharts;"+"\r\n"+""+"\r\n"+"// Field level variables"+"\r\n"+"var goFlds;"+"\r\n"+"var goFld;"+"\r\n"+"var gsFld;"+"\r\n"+"var gsFldQuoteS, gsFldQuoteE;"+"\r\n"+"var gsFldName;"+"\r\n"+"var gsFldVar;"+"\r\n"+"var gsFldParm;"+"\r\n"+"var gsFldObj;"+"\r\n"+"var gsSessionFldVar;"+"\r\n"+""+"\r\n"+"// Field arrays"+"\r\n"+"var arKeyFlds;"+"\r\n"+"var arFlds;"+"\r\n"+"var arAllFlds;"+"\r\n"+""+"\r\n"+"// Dropdown filter"+"\r\n"+"var gsDdValFldVar, pfxDdVal = \"sv_\";"+"\r\n"+"var gsDdDefaultValue;"+"\r\n"+""+"\r\n"+"// Extended filter related"+"\r\n"+"var gsSv1FldVar, pfxSv1 = \"sv_\"; // Don't change, must be the same as pfxDdVal"+"\r\n"+"var gsSv2FldVar, pfxSv2 = \"sv2_\";"+"\r\n"+"var gsSo1FldVar, pfxSo1 = \"so_\"; // Don't change"+"\r\n"+"var gsSo2FldVar, pfxSo2 = \"so2_\";"+"\r\n"+"var gsScFldVar, pfxSc = \"sc_\";"+"\r\n"+""+"\r\n"+"// Drill down filter related"+"\r\n"+"var pfxDrOpt = \"do_\";"+"\r\n"+"var pfxDrFtr = \"df_\";"+"\r\n"+"var pfxDrLst = \"dl_\";"+"\r\n"+""+"\r\n"+"// Reports"+"\r\n"+"var pfxRangeFrom = \"rf_\";"+"\r\n"+"var pfxRangeTo = \"rt_\";"+"\r\n"+"var pfxSel = \"sel_\";"+"\r\n"+""+"\r\n"+"// Popup filter"+"\r\n"+"var gsPopupFldVar, sfxPopup = \"_Popup\";"+"\r\n"+""+"\r\n"+"// User level prefix"+"\r\n"+"var pfxUserLevel = ReadReg(\"HKCU\\\\Software\\\\PHPReportMaker\\\\8.0\\\\Settings\\\\General\\\\UserLevelTableNamePrefix\");"+"\r\n"+"if (pfxUserLevel == \"\") pfxUserLevel = ReadReg(\"HKCU\\\\Software\\\\PHPReportMaker\\\\7.0\\\\Settings\\\\General\\\\UserLevelTableNamePrefix\");"+"\r\n"+"if (pfxUserLevel == \"\") pfxUserLevel = \"||PHPReportMaker||\";"+"\r\n"+""+"\r\n"+"/**"+"\r\n"+" ************************"+"\r\n"+" * Commonly used functions"+"\r\n"+" */"+"\r\n"+""+"\r\n"+"// Read registry"+"\r\n"+"function ReadReg(RegPath) {"+"\r\n"+"	try {"+"\r\n"+"		var obj = new ActiveXObject(\"WScript.Shell\");"+"\r\n"+"		return obj.RegRead(RegPath);"+"\r\n"+"	} catch(e) {"+"\r\n"+"		return \"\";"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Convert Data"+"\r\n"+"function ConvertData(v, t) {"+"\r\n"+"	try {"+"\r\n"+"		switch (t.toLowerCase()) {"+"\r\n"+"			case \"boolean\": if (String(v) == \"1\" || v === true) return 1; else return 0;"+"\r\n"+"			case \"integer\": return int(v);"+"\r\n"+"			case \"long\": return int(v);"+"\r\n"+"			case \"single\": return float(v);"+"\r\n"+"			case \"double\": return double(v);"+"\r\n"+"			default: return v;"+"\r\n"+"		}"+"\r\n"+"	} catch(e) {"+"\r\n"+"		return v;"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Get chart object"+"\r\n"+"function GetChtObj(chtname) {"+"\r\n"+"	CHART = TABLE.Charts(chtname);"+"\r\n"+"	goCht = goChts[chtname];"+"\r\n"+"	if (goCht) {"+"\r\n"+"		gsChartVar = goCht.ChartVar;"+"\r\n"+"		gsChartName = goCht.ChartName;"+"\r\n"+"	} else {"+"\r\n"+"		gsChartVar = CHART.ChartVar;"+"\r\n"+"		gsChartName = CHART.ChartName;"+"\r\n"+"	}"+"\r\n"+"	//gsChartObj = gsTblVar + \"->\" + gsChartVar;"+"\r\n"+"	gsChartObj = gsPageObj + \"->\" + gsChartVar;"+"\r\n"+""+"\r\n"+"	return true;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GetFieldTypeName(FldTyp) {"+"\r\n"+"	switch (FldTyp) {"+"\r\n"+"		//Case adBigInt, adInteger, adSmallInt, adTinyInt, adSingle, adDouble, adNumeric, adCurrency, adUnsignedTinyInt, adUnsignedSmallInt, adUnsignedInt, adUnsignedBigInt, 139"+"\r\n"+"		case 20:"+"\r\n"+"		case 3:"+"\r\n"+"		case 2:"+"\r\n"+"		case 16:"+"\r\n"+"		case 4:"+"\r\n"+"		case 5:"+"\r\n"+"		case 131:"+"\r\n"+"		case 6:"+"\r\n"+"		case 17:"+"\r\n"+"		case 18:"+"\r\n"+"		case 19:"+"\r\n"+"		case 21:"+"\r\n"+"		case 139:"+"\r\n"+"			return \"EWR_DATATYPE_NUMBER\";"+"\r\n"+"		//Case adDate, adDBDate, adDBTimeStamp, 146"+"\r\n"+"		case 7:"+"\r\n"+"		case 133:"+"\r\n"+"		case 135:"+"\r\n"+"		case 146:"+"\r\n"+"			return \"EWR_DATATYPE_DATE\";"+"\r\n"+"		//Case adDBTime, 145"+"\r\n"+"		case 134:"+"\r\n"+"		case 145:"+"\r\n"+"			return \"EWR_DATATYPE_TIME\";"+"\r\n"+"		//Case adLongVarChar, adLongVarWChar"+"\r\n"+"		case 201:"+"\r\n"+"		case 203:"+"\r\n"+"			return \"EWR_DATATYPE_MEMO\";"+"\r\n"+"		//Case adChar, adWChar, adVarChar, adVarWChar, 141"+"\r\n"+"		case 129:"+"\r\n"+"		case 130:"+"\r\n"+"		case 200:"+"\r\n"+"		case 202:"+"\r\n"+"		case 141:"+"\r\n"+"			return \"EWR_DATATYPE_STRING\";"+"\r\n"+"		//Case adBoolean"+"\r\n"+"		case 11:"+"\r\n"+"			return \"EWR_DATATYPE_BOOLEAN\";"+"\r\n"+"		//Case adGUID"+"\r\n"+"		case 72:"+"\r\n"+"			return \"EWR_DATATYPE_GUID\";"+"\r\n"+"		//Case adBinary, adVarBinary, adLongVarBinary"+"\r\n"+"		case 128:"+"\r\n"+"		case 204:"+"\r\n"+"		case 205:"+"\r\n"+"			return \"EWR_DATATYPE_BLOB\";"+"\r\n"+"		default:"+"\r\n"+"			return \"EWR_DATATYPE_OTHER\";"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Get field object"+"\r\n"+"function GetFldObj(fldname) {"+"\r\n"+"	FIELD = TABLE.Fields(fldname);"+"\r\n"+"	goFld = goFlds[fldname];"+"\r\n"+"	if (goFld) {"+"\r\n"+"		gsFldParm = goFld.FldParm;"+"\r\n"+"		gsFldVar = goFld.FldVar;"+"\r\n"+"		gsFldName = goFld.FldName;"+"\r\n"+"		gsFld = ew_FieldSqlName(goFld);"+"\r\n"+"		gsFldQuoteS = goFld.FldQuoteS;"+"\r\n"+"		gsFldQuoteE = goFld.FldQuoteE;"+"\r\n"+"	} else {"+"\r\n"+"		gsFldParm = FIELD.FldParm;"+"\r\n"+"		gsFldVar = FIELD.FldVar;"+"\r\n"+"		gsFldName = FIELD.FldName;"+"\r\n"+"		gsFld = ew_FieldSqlName(FIELD);"+"\r\n"+"		gsFldQuoteS = FIELD.FldQuoteS;"+"\r\n"+"		gsFldQuoteE = FIELD.FldQuoteE;"+"\r\n"+"	}"+"\r\n"+"	//gsFldObj = gsTblVar + \"->\" + gsFldParm;"+"\r\n"+"	gsFldObj = gsPageObj + \"->\" + gsFldParm;"+"\r\n"+"	gsSessionFldVar = gsTblVar + \"_\" + gsFldParm;"+"\r\n"+""+"\r\n"+"	// Dropdown filter"+"\r\n"+"	gsDdValFldVar = pfxDdVal + gsFldParm;"+"\r\n"+""+"\r\n"+"	// Extended filter related"+"\r\n"+"	gsSv1FldVar = pfxSv1 + gsFldParm;"+"\r\n"+"	gsSv2FldVar = pfxSv2 + gsFldParm;"+"\r\n"+"	gsSo1FldVar = pfxSo1 + gsFldParm;"+"\r\n"+"	gsSo2FldVar = pfxSo2 + gsFldParm;"+"\r\n"+"	gsScFldVar = pfxSc + gsFldParm;"+"\r\n"+""+"\r\n"+"	// Report"+"\r\n"+"	gsPopupFldVar = gsSessionFldVar + sfxPopup;"+"\r\n"+""+"\r\n"+"	return true;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GetFldVal(fld, fldtype) {"+"\r\n"+"	if (bDBMySql) {"+"\r\n"+"		return fld;"+"\r\n"+"	} else {"+"\r\n"+"		if (ew_GetFieldType(fldtype) == 4) {"+"\r\n"+"			return \"((\" + fld + \") ? \\\"1\\\" : \\\"0\\\")\";"+"\r\n"+"		} else if (fldtype == 18 || fldtype == 19 || fldtype == 131 || fldtype == 139) {"+"\r\n"+"			return \"ewr_Conv(\" + fld + \", \" + fldtype + \")\";"+"\r\n"+"		} else {"+"\r\n"+"			return fld;"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GetSearchDefaultValue() {"+"\r\n"+"	var sDefaultValue = goFld.FldDefaultSearch;"+"\r\n"+"	if (ew_IsEmpty(sDefaultValue)) {"+"\r\n"+"		sDefaultValue = \"\";"+"\r\n"+"	} else if (!IsArrayString(sDefaultValue)) {"+"\r\n"+"		sDefaultValue = \"array(\" + sDefaultValue + \")\";"+"\r\n"+"	}"+"\r\n"+"	return sDefaultValue;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GetDropdownDefaultValue() {"+"\r\n"+"	var sDdDefaultValue = goFld.FldDefault;"+"\r\n"+"	var sYr = goFld.FldDateSearchDefaultYear;"+"\r\n"+"	var sQtr = goFld.FldDateSearchDefaultQuarter;"+"\r\n"+"	var sMth = goFld.FldDateSearchDefaultMonth;"+"\r\n"+"	var sDy = goFld.FldDateSearchDefaultDay;"+"\r\n"+"	switch (goFld.FldDateSearch.toLowerCase()) {"+"\r\n"+"		case \"year\":"+"\r\n"+"			if (ew_IsNotEmpty(sYr)) {"+"\r\n"+"				sDdDefaultValue = sYr;"+"\r\n"+"			}"+"\r\n"+"			break;"+"\r\n"+"		case \"quarter\":"+"\r\n"+"			if (ew_IsNotEmpty(sYr) && ew_IsNotEmpty(sQtr)) {"+"\r\n"+"				if (!isNaN(sYr) && !isNaN(sQtr)) {"+"\r\n"+"					sDdDefaultValue = \"\\\"\" + sYr + \"|\" + sQtr + \"\\\"\";"+"\r\n"+"				} else {"+"\r\n"+"					sDdDefaultValue = sYr + \" . \\\"|\\\" . \" + sQtr;"+"\r\n"+"				}"+"\r\n"+"			}"+"\r\n"+"			break;"+"\r\n"+"		case \"month\":"+"\r\n"+"			if (ew_IsNotEmpty(sYr) && ew_IsNotEmpty(sMth)) {"+"\r\n"+"				if (!isNaN(sYr) && !isNaN(sMth)) {"+"\r\n"+"					sDdDefaultValue = \"\\\"\" + sYr + \"|\" + sMth.pad(\"0\", 2) + \"\\\"\";"+"\r\n"+"				} else {"+"\r\n"+"					sDdDefaultValue = sYr + \" . \\\"|\\\" . \" + sMth;"+"\r\n"+"				}"+"\r\n"+"			}"+"\r\n"+"			break;"+"\r\n"+"		case \"day\":"+"\r\n"+"			if (ew_IsNotEmpty(sYr) && ew_IsNotEmpty(sMth) && ew_IsNotEmpty(sDy)) {"+"\r\n"+"				if (!isNaN(sYr) && !isNaN(sMth) && !isNaN(sDy)) {"+"\r\n"+"					sDdDefaultValue = \"\\\"\" + sYr + \"|\" + sMth.pad(\"0\", 2) + \"|\" + sDy.pad(\"0\", 2) + \"\\\"\";"+"\r\n"+"				} else {"+"\r\n"+"					sDdDefaultValue = sYr + \" . \\\"|\\\" . \" + sMth + \" . \\\"|\\\" . \" + sDy;"+"\r\n"+"				}"+"\r\n"+"			}"+"\r\n"+"			break;"+"\r\n"+"		default:"+"\r\n"+"			if (goFld.FldHtmlTag == \"CHECKBOX\" || (goFld.FldHtmlTag == \"SELECT\" && goFld.FldSelectMultiple)) {"+"\r\n"+"				if (ew_IsNotEmpty(sDdDefaultValue) && ew_ContainText(sDdDefaultValue, \",\") && !IsArrayString(sDdDefaultValue)) {"+"\r\n"+"					sDdDefaultValue = \"array(\" + sDdDefaultValue + \")\";"+"\r\n"+"				}"+"\r\n"+"			}"+"\r\n"+"	}"+"\r\n"+"	if (ew_IsEmpty(sDdDefaultValue)) sDdDefaultValue = \"EWR_INIT_VALUE\";"+"\r\n"+"	return sDdDefaultValue;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// String is array(...) or array[...]"+"\r\n"+"function IsArrayString(str) {"+"\r\n"+"	if (/array\\([^\\)]*\\)$/.test(str.trim()) || /\\[[^\\]]*\\]$/.test(str.trim()))"+"\r\n"+"		return true;"+"\r\n"+"	else"+"\r\n"+"		return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if is aggregate"+"\r\n"+"function IsAggregateSql(sql) {"+"\r\n"+"	var wrksql = sql.trim();"+"\r\n"+"	var i = wrksql.indexOf(\"(\");"+"\r\n"+"	if (i >= 0) {"+"\r\n"+"		wrksql = wrksql.substr(0,i-1).toUpperCase();"+"\r\n"+"		if (wrksql == \"AVG\" || wrksql == \"COUNT\" || wrksql == \"MAX\" || wrksql == \"MIN\" || wrksql == \"SUM\") {"+"\r\n"+"			return true;"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Return field value list"+"\r\n"+"function GetFieldValues(f) {"+"\r\n"+"	var values = f.FldTagValues;"+"\r\n"+"	var list = \"\";"+"\r\n"+"	var val = \"\";"+"\r\n"+"	if (SYSTEMFUNCTIONS.IsBoolFld() && ew_GetFieldHtmlTag(f) == \"CHECKBOX\") {"+"\r\n"+"		var ar = values.split(\"\\r\\n\");"+"\r\n"+"		for (var i = 0; i < ar.length; i++) {"+"\r\n"+"			val = ar[i].split(\",\")[0];"+"\r\n"+"			val = ew_UnQuote(val);"+"\r\n"+"			if (val == \"1\" || val.toUpperCase() == \"Y\" || val.toUpperCase() == \"YES\" || val.toUpperCase() == \"T\" || val.toUpperCase() == \"TRUE\") break;"+"\r\n"+"		}"+"\r\n"+"		list = ew_DoubleQuote(val,1);"+"\r\n"+"	} else if (ew_IsNotEmpty(values)) {"+"\r\n"+"		var ar = values.split(\"\\r\\n\");"+"\r\n"+"		for (var i = 0; i < ar.length; i++) {"+"\r\n"+"			if (ew_IsNotEmpty(ar[i].trim())) {"+"\r\n"+"				val = ar[i].split(\",\")[0];"+"\r\n"+"				list += ew_DoubleQuote(val,1) + \",\";"+"\r\n"+"			}"+"\r\n"+"		}"+"\r\n"+"		if (list.length > 0) list = list.substr(0,list.length-1);"+"\r\n"+"	}"+"\r\n"+"	return list;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Return activate field value"+"\r\n"+"function ActivateFieldValue(f) {"+"\r\n"+"	var val;"+"\r\n"+"	switch (ew_GetFieldType(f.FldType)) {"+"\r\n"+"	case 4: // Boolean"+"\r\n"+"		val = \"1\";"+"\r\n"+"		if (bDBMsAccess)"+"\r\n"+"			val = \"True\";"+"\r\n"+"		break;"+"\r\n"+"	case 1: // Numeric"+"\r\n"+"		val = 1;"+"\r\n"+"		break;"+"\r\n"+"	default:"+"\r\n"+"		if (f.NativeDataType == 247) { // ENUM"+"\r\n"+"			if (ew_HasTagValue(f, \"Y\")) // Assume ENUM(Y,N)"+"\r\n"+"				val = \"Y\";"+"\r\n"+"			else"+"\r\n"+"				val = \"1\";"+"\r\n"+"		} else {"+"\r\n"+"			val = \"Y\";"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return val;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Popup Filter"+"\r\n"+"function IsPopupFilter(f) {"+"\r\n"+"	return ew_IsPopupFilter(f);"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Extended Filter"+"\r\n"+"function IsExtendedFilter(f) {"+"\r\n"+"	return f.FldExtendedBasicSearch;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Text filter"+"\r\n"+"function IsTextFilter(f) {"+"\r\n"+"	return !IsDateFilter(f) && (f.FldHtmlTag != \"SELECT\" && f.FldHtmlTag != \"RADIO\" && f.FldHtmlTag != \"CHECKBOX\");"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Auto Suggest"+"\r\n"+"function IsAutoSuggest(f) {"+"\r\n"+"	return IsTextFilter(f) && f.FldSelectType == \"Table\";"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Date Filter"+"\r\n"+"function IsDateFilter(f) {"+"\r\n"+"	return ew_IsDateFilter(f);"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if use Ajax"+"\r\n"+"function IsUseAjax(f) {"+"\r\n"+"	return IsExtendedFilter(goFld) && (IsDateFilter(goFld) || (!IsTextFilter(goFld) && !(ew_GetFieldType(goFld.FldType) == 4 || goFld.FldTypeName == \"ENUM\" || goFld.FldTypeName == \"SET\")));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsShowChart(cht, pos) {"+"\r\n"+"	return (cht.ShowChart && ew_IsNotEmpty(cht.ChartXFldName) && ew_IsNotEmpty(cht.ChartYFldName) && (!pos || pos == cht.ChartPosition));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if popup calendar required"+"\r\n"+"function IsPopupCalendar() {"+"\r\n"+"	for (var i = 1, tlen = DB.Tables.Count(); i <= tlen; i++) {"+"\r\n"+"		var WRKTABLE = DB.Tables(i);"+"\r\n"+"		if (WRKTABLE.TblGen) {"+"\r\n"+"			for (var j = 1, flen = WRKTABLE.Fields.Count(); j <= flen; j++) {"+"\r\n"+"				var WRKFLD = WRKTABLE.Fields(j);"+"\r\n"+"				if (WRKFLD.FldGenerate && WRKFLD.FldPopCalendar)"+"\r\n"+"					return true;"+"\r\n"+"			}"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function FieldTD_Header(f) {"+"\r\n"+"	var sStyle = FieldCellStyle(f);"+"\r\n"+"	if (ew_IsNotEmpty(sStyle)) sStyle = \" style=\\\"\" + sStyle + \"\\\"\";"+"\r\n"+"	return sStyle;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function FieldCellStyle(f) {"+"\r\n"+"	var bFldColumnWrap = f.FldColumnWrap;"+"\r\n"+"	var sFldColumnWidth = f.FldColumnWidth;"+"\r\n"+"	var sStyle = \"\";"+"\r\n"+"	if (ew_IsNotEmpty(f.FldAlign)) {"+"\r\n"+"		sStyle += \"text-align: \" + f.FldAlign + \";\";"+"\r\n"+"	}"+"\r\n"+"	if (ew_IsNotEmpty(sFldColumnWidth)) {"+"\r\n"+"		if (ew_IsNotEmpty(sStyle)) sStyle += \" \";"+"\r\n"+"		sStyle += \"width: \" + sFldColumnWidth;"+"\r\n"+"		if (!isNaN(sFldColumnWidth)) sStyle += \"px\";"+"\r\n"+"		sStyle += \";\";"+"\r\n"+"	}"+"\r\n"+"	if (!bFldColumnWrap) {"+"\r\n"+"		if (ew_IsNotEmpty(sStyle)) sStyle += \" \";"+"\r\n"+"		sStyle += \"white-space: nowrap;\";"+"\r\n"+"	}"+"\r\n"+"	return sStyle;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function FieldViewStyle(f) {"+"\r\n"+"	var sStyle = \"\";"+"\r\n"+"	if (f.FldBold) {"+"\r\n"+"		sStyle += \"font-weight: bold;\";"+"\r\n"+"	}"+"\r\n"+"	if (f.FldItalic) {"+"\r\n"+"		if (ew_IsNotEmpty(sStyle)) sStyle += \" \";"+"\r\n"+"		sStyle += \"font-style: italic;\";"+"\r\n"+"	}"+"\r\n"+"	//if (ew_IsNotEmpty(f.FldAlign)) {"+"\r\n"+"	//	if (ew_IsNotEmpty(sStyle)) sStyle += \" \";"+"\r\n"+"	//	sStyle += \"text-align: \" + f.FldAlign + \";\";"+"\r\n"+"	//}"+"\r\n"+"	return sStyle;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function FieldTD_Item(f) {"+"\r\n"+"	//return FieldTD_Header(f);"+"\r\n"+"	return \"\"; // Set up in RenderRow / RenderListRow"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function CharsetToIconvEncoding(Charset) {"+"\r\n"+"	switch (Charset.toLowerCase()) {"+"\r\n"+"		case \"iso-8859-6\": return \"ISO-8859-6\";"+"\r\n"+"		case \"x-mac-arabic\": return \"MacArabic\";"+"\r\n"+"		case \"windows-1256\": return \"CP1256\";"+"\r\n"+"		case \"iso-8859-4\": return \"ISO-8859-4\";"+"\r\n"+"		case \"windows-1257\": return \"CP1257\";"+"\r\n"+"		case \"ibm852\": return \"CP852\";"+"\r\n"+"		case \"iso-8859-2\": return \"ISO-8859-2\";"+"\r\n"+"		case \"x-mac-ce\": return \"MacCentralEurope\";"+"\r\n"+"		case \"windows-1250\": return \"CP1250\";"+"\r\n"+"		case \"gb2312\": return \"GBK\";"+"\r\n"+"		case \"hz-gb-2312\": return \"GBK\";"+"\r\n"+"		case \"big5\": return \"BIG5\";"+"\r\n"+"		case \"cp866\": return \"CP866\";"+"\r\n"+"		case \"iso-8859-5\": return \"ISO-8859-5\";"+"\r\n"+"		case \"koi8-r\": return \"KOI8-R\";"+"\r\n"+"		case \"koi8-u\": return \"KOI8-U\";"+"\r\n"+"		case \"x-mac-cyrillic\": return \"MacCyrillic\";"+"\r\n"+"		case \"windows-1251\": return \"CP1251\";"+"\r\n"+"		case \"iso-8859-7\": return \"ISO-8859-7\";"+"\r\n"+"		case \"x-mac-greek\": return \"MacGreek\";"+"\r\n"+"		case \"windows-1253\": return \"CP1253\";"+"\r\n"+"		case \"iso-8859-8-i\": return \"ISO-8859-8\";"+"\r\n"+"		case \"iso-8859-8\": return \"ISO-8859-8\";"+"\r\n"+"		case \"x-mac-hebrew\": return \"MacHebrew\";"+"\r\n"+"		case \"windows-1255\": return \"CP1255\";"+"\r\n"+"		case \"x-mac-icelandic\": return \"MacIceland\";"+"\r\n"+"		case \"euc-jp\": return \"EUC-JP\";"+"\r\n"+"		case \"iso-2022-jp\": return \"ISO-2022-JP\";"+"\r\n"+"		case \"shift_jis\": return \"SHIFT_JIS\";"+"\r\n"+"		case \"euc-kr\": return \"EUC-KR\";"+"\r\n"+"		case \"iso-2022-kr\": return \"ISO-2022-KR\";"+"\r\n"+"		case \"Johab\": return \"JOHAB\";"+"\r\n"+"		case \"iso-8859-3\": return \"ISO-8859-3\";"+"\r\n"+"		case \"iso-8859-15\": return \"ISO-8859-15\";"+"\r\n"+"		case \"windows-874\": return \"CP874\";"+"\r\n"+"		case \"ibm857\": return \"CP857\";"+"\r\n"+"		case \"iso-8859-9\": return \"ISO-8859-9\";"+"\r\n"+"		case \"x-mac-turkish\": return \"MacTurkish\";"+"\r\n"+"		case \"windows-1254\": return \"CP1254\";"+"\r\n"+"		case \"utf-16\": return \"UTF-16\";"+"\r\n"+"		case \"utf-8\": return \"UTF-8\";"+"\r\n"+"		case \"windows-1258\": return \"CP1258\";"+"\r\n"+"		case \"ibm850\": return \"CP850\";"+"\r\n"+"		case \"iso-8859-1\": return \"ISO-8859-1\";"+"\r\n"+"		case \"macintosh\": return \"Macintosh\";"+"\r\n"+"		case \"windows-1252\": return \"CP1252\";"+"\r\n"+"		// Add your encodings here"+"\r\n"+"		default: return \"\";"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function CharsetToMySqlCharset(Charset) {"+"\r\n"+"	switch (Charset.toLowerCase()) {"+"\r\n"+"		//case \"iso-8859-6\": return \"\";"+"\r\n"+"		//case \"x-mac-arabic\": return \"\";"+"\r\n"+"		case \"windows-1256\": return \"cp1256\";"+"\r\n"+"		//case \"iso-8859-4\": return \"\";"+"\r\n"+"		case \"windows-1257\": return \"cp1257\";"+"\r\n"+"		case \"ibm852\": return \"cp852\";"+"\r\n"+"		case \"iso-8859-2\": return \"latin2\";"+"\r\n"+"		case \"x-mac-ce\": return \"macce\";"+"\r\n"+"		case \"windows-1250\": return \"cp1250\";"+"\r\n"+"		case \"gb2312\": return \"gb2312\";"+"\r\n"+"		//case \"hz-gb-2312\": return \"\";"+"\r\n"+"		case \"big5\": return \"big5\";"+"\r\n"+"		case \"cp866\": return \"cp866\";"+"\r\n"+"		//case \"iso-8859-5\": return \"\";"+"\r\n"+"		case \"koi8-r\": return \"koi8r\";"+"\r\n"+"		case \"koi8-u\": return \"koi8u\";"+"\r\n"+"		//case \"x-mac-cyrillic\": return \"\";"+"\r\n"+"		case \"windows-1251\": return \"cp1251\";"+"\r\n"+"		case \"iso-8859-7\": return \"greek\";"+"\r\n"+"		//case \"x-mac-greek\": return \"\";"+"\r\n"+"		//case \"windows-1253\": return \"\";"+"\r\n"+"		case \"iso-8859-8-i\": return \"hebrew\";"+"\r\n"+"		case \"iso-8859-8\": return \"hebrew\";"+"\r\n"+"		//case \"x-mac-hebrew\": return \"\";"+"\r\n"+"		//case \"windows-1255\": return \"\";"+"\r\n"+"		case \"x-mac-icelandic\": return \"\";"+"\r\n"+"		case \"euc-jp\": return \"ujis\";"+"\r\n"+"		//case \"iso-2022-jp\": return \"\";"+"\r\n"+"		case \"shift_jis\": return \"sjis\";"+"\r\n"+"		case \"euc-kr\": return \"euckr\";"+"\r\n"+"		//case \"iso-2022-kr\": return \"\";"+"\r\n"+"		//case \"Johab\": return \"\";"+"\r\n"+"		//case \"iso-8859-3\": return \"\";"+"\r\n"+"		//case \"iso-8859-15\": return \"\";"+"\r\n"+"		//case \"windows-874\": return \"\";"+"\r\n"+"		//case \"ibm857\": return \"\";"+"\r\n"+"		case \"iso-8859-9\": return \"latin5\";"+"\r\n"+"		//case \"x-mac-turkish\": return \"\";"+"\r\n"+"		//case \"windows-1254\": return \"\";"+"\r\n"+"		case \"utf-16\": return \"ucs2\";"+"\r\n"+"		case \"utf-8\": return \"utf8\";"+"\r\n"+"		//case \"windows-1258\": return \"\";"+"\r\n"+"		case \"ibm850\": return \"cp850\";"+"\r\n"+"		case \"iso-8859-1\": return \"latin1\";"+"\r\n"+"		case \"macintosh\": return \"macroman\";"+"\r\n"+"		case \"windows-1252\": return \"latin1\";"+"\r\n"+"		// Add your encodings here"+"\r\n"+"		default: return \"\";"+"\r\n"+"	}"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsMsAccess() {"+"\r\n"+"	return bDBMsAccess;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsMsSQL() {"+"\r\n"+"	return bDBMsSql;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsMySQL() {"+"\r\n"+"	return bDBMySql;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsPostgreSQL() {"+"\r\n"+"	return bDBPostgreSql;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function IsOracle() {"+"\r\n"+"	return bDBOracle;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Get Oracle service name from connection string"+"\r\n"+"function GetOracleServiceName(ConnStr) {"+"\r\n"+"	sName = \"\";"+"\r\n"+"	var wrkstr = ConnStr.toUpperCase();"+"\r\n"+"	var p1 = wrkstr.indexOf(\"DATA SOURCE=\");"+"\r\n"+"	if (p1 > 0) {"+"\r\n"+"		p1 += 12; // Skip \"Data Source=\";"+"\r\n"+"		p2 = ConnStr.indexOf(\";\", p1);"+"\r\n"+"		if (p2 > p1)"+"\r\n"+"			sName = ConnStr.substr(p1, p2-p1);"+"\r\n"+"		else"+"\r\n"+"			sName = ConnStr.substr(p1);"+"\r\n"+"	}"+"\r\n"+"	return sName;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UseMysqlt() {"+"\r\n"+"	return PROJ.GetV(\"UseMysqlt\");"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UseADODB() {"+"\r\n"+"	return UseMysqlt() || !bDBMySql;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UseEmailExport() {"+"\r\n"+"	for (var i = 0, len = goTbls.length; i < len; i++) {"+"\r\n"+"		var WRKTABLE = goTbls[i];"+"\r\n"+"		var bTblGen = WRKTABLE.TblGen;"+"\r\n"+"		if (bTblGen) {"+"\r\n"+"			if ((!WRKTABLE.TblUseGlobal && WRKTABLE.TblExportEmail) || (WRKTABLE.TblUseGlobal && PROJ.ExportEmail))"+"\r\n"+"				return true;"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UsePdfExport() {"+"\r\n"+"	for (var i = 0, len = goTbls.length; i < len; i++) {"+"\r\n"+"		var WRKTABLE = goTbls[i];"+"\r\n"+"		var bTblGen = WRKTABLE.TblGen;"+"\r\n"+"		if (bTblGen) {"+"\r\n"+"			if ((!WRKTABLE.TblUseGlobal && WRKTABLE.TblExportPDF) || (WRKTABLE.TblUseGlobal && PROJ.ExportPDF))"+"\r\n"+"				return true;"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UseJSTemplate() {"+"\r\n"+""+"\r\n"+"	function UseJSTemplateScript(WRKTABLE, ScriptName, ReportType) {"+"\r\n"+"		if (CUSTOMSCRIPTS.ScriptExist(\"Template\", \"Table\", ScriptName, ReportType, WRKTABLE.TblName, \"\")) {"+"\r\n"+"			var wrkcode = CUSTOMSCRIPTS.ScriptItem(\"Template\", \"Table\", ScriptName, ReportType, WRKTABLE.TblName, \"\").ScriptCode;"+"\r\n"+"			return (wrkcode.trim() != \"\");"+"\r\n"+"		}"+"\r\n"+"		return false;"+"\r\n"+"	}"+"\r\n"+""+"\r\n"+"	for (var i = 0, len = goTbls.length; i < len; i++) {"+"\r\n"+"		var WRKTABLE = goTbls[i];"+"\r\n"+"		var bTblGen = WRKTABLE.TblGen;"+"\r\n"+"		if (bTblGen) {"+"\r\n"+"			if (WRKTABLE.TblReportType == \"rpt\") {"+"\r\n"+"				if (UseJSTemplateScript(WRKTABLE, \"CustomTemplateHeader\", WRKTABLE.TblReportType) ||"+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateBody\", WRKTABLE.TblReportType) ||"+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateFooter\", WRKTABLE.TblReportType))"+"\r\n"+"					return true;"+"\r\n"+"			} else if (WRKTABLE.TblReportType == \"summary\") {"+"\r\n"+"				if (UseJSTemplateScript(WRKTABLE, \"CustomTemplateHeader\", WRKTABLE.TblReportType) || "+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateGroupHeader\", WRKTABLE.TblReportType) || "+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateBody\", WRKTABLE.TblReportType) || "+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateGroupFooter\", WRKTABLE.TblReportType) || "+"\r\n"+"					UseJSTemplateScript(WRKTABLE, \"CustomTemplateFooter\", WRKTABLE.TblReportType))"+"\r\n"+"					return true;"+"\r\n"+"			} else if (WRKTABLE.TblReportType == \"dashboard\") {"+"\r\n"+"				if (UseJSTemplateScript(WRKTABLE, \"CustomTemplate\", WRKTABLE.TblReportType))"+"\r\n"+"					return true;"+"\r\n"+"			}"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Return if Export is required"+"\r\n"+"function IsExport() {"+"\r\n"+"	for (var i = 0, len = goTbls.length; i < len; i++) {"+"\r\n"+"		var WRKTABLE = goTbls[i];"+"\r\n"+"		var bTblGen = WRKTABLE.TblGen;"+"\r\n"+"		if (bTblGen) {"+"\r\n"+"			var bUseGlobal = WRKTABLE.TblUseGlobal;"+"\r\n"+"			bExport = (bUseGlobal) ? PROJ.ExportHtml : WRKTABLE.TblExportHtml;"+"\r\n"+"			if (bExport) return true;"+"\r\n"+"			bExport = (bUseGlobal) ? PROJ.ExportWord : WRKTABLE.TblExportWord;"+"\r\n"+"			if (bExport) return true;"+"\r\n"+"			bExport = (bUseGlobal) ? PROJ.ExportExcel : WRKTABLE.TblExportExcel;"+"\r\n"+"			if (bExport) return true;"+"\r\n"+"			bExport = (bUseGlobal) ? PROJ.ExportEmail : WRKTABLE.TblExportEmail;"+"\r\n"+"			if (bExport) return true;"+"\r\n"+"			bExport = (bUseGlobal) ? PROJ.ExportPDF : WRKTABLE.TblExportPDF;"+"\r\n"+"			if (bExport) return true;"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenInfo() {"+"\r\n"+"	return TABLE && (TABLE.TblType != \"REPORT\" && TABLE.TblReportType == \"rpt\" ||"+"\r\n"+"		TABLE.TblType == \"REPORT\" && ew_InArray(TABLE.TblReportType, [\"summary\", \"crosstab\", \"gantt\"]));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenHeader() {"+"\r\n"+"	return (!PROJ.AppCompat || (PROJ.AppCompat && ew_IsNotEmpty(PROJ.AppHeader)));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenFooter() {"+"\r\n"+"	return (!PROJ.AppCompat || (PROJ.AppCompat && ew_IsNotEmpty(PROJ.AppFooter)));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenLogin() {"+"\r\n"+"	return (!PROJ.AppCompat || (PROJ.AppCompat && ew_IsEmpty(PROJ.AppLogin)));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenLogout() {"+"\r\n"+"	return (!PROJ.AppCompat || (PROJ.AppCompat && ew_IsEmpty(PROJ.AppLogout)));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GenDefault() {"+"\r\n"+"	return (!PROJ.AppCompat || (PROJ.AppCompat && ew_IsEmpty(PROJ.AppDefault)));"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function GetProjCssFileName() {"+"\r\n"+"	var filename = PROJ.ProjVar + \".css\";"+"\r\n"+"	if (PROJ.OutputNameLCase) {"+"\r\n"+"		filename = filename.toLowerCase();"+"\r\n"+"	}"+"\r\n"+"	if (ew_IsNotEmpty(ew_FolderPath(\"_css\"))) {"+"\r\n"+"		filename = ew_FolderPath(\"_css\") + \"/\" + filename;"+"\r\n"+"	}"+"\r\n"+"	return filename;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function SummaryCaption(typ) {"+"\r\n"+"	return \"<?php echo $ReportLanguage->Phrase(\\\"Rpt\" + typ + \"\\\"); ?>\";"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"var UseFusionChartsFree = true; // v8"+"\r\n"+""+"\r\n"+"function IsFCFChart(typ) {"+"\r\n"+"	return UseFusionChartsFree && (typ == 20 || typ == 21 || typ == 22); // v8"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UsePhpExcel() {"+"\r\n"+"	return ew_GetCtrlById(\"phpexcel\") != null;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function UsePhpWord() {"+"\r\n"+"	return ew_GetCtrlById(\"phpword\") != null;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Table has drill down parameter"+"\r\n"+"function HasDrillDownParm(t) {"+"\r\n"+"	for (var i = 1, cnt = t.Fields.Count(); i <= cnt; i++) {"+"\r\n"+"		var f = t.Fields(i);"+"\r\n"+"		if (f.FldGenerate && f.FldDrillParameter)"+"\r\n"+"			return true;"+"\r\n"+"	}"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"// Check if Drill Down source field"+"\r\n"+"function IsDrillDownSource(f) {"+"\r\n"+"	for (var i = 0; i < nAllFldCount; i++) {"+"\r\n"+"		var fld = goFlds[arAllFlds[i]];"+"\r\n"+"		if (ew_IsFieldDrillDown(fld)) {"+"\r\n"+"			var sFldDrillSourceFields = fld.FldDrillSourceFields.trim();"+"\r\n"+"			if (sFldDrillSourceFields.substr(sFldDrillSourceFields.length-2) == \"||\")"+"\r\n"+"				sFldDrillSourceFields = sFldDrillSourceFields.substr(0,sFldDrillSourceFields.length-2);"+"\r\n"+"			var arSourceFlds = sFldDrillSourceFields.split(\"||\");"+"\r\n"+"			for (var j = 0, cnt = arSourceFlds.length; j < cnt; j++) {"+"\r\n"+"				var SOURCEFLD = goFlds[arSourceFlds[j]];"+"\r\n"+"				if (SOURCEFLD.FldName == f.FldName)"+"\r\n"+"					return true;"+"\r\n"+"			}"+"\r\n"+"		}"+"\r\n"+"	}"+"\r\n"+"	for (var i = 0, len = arAllCharts.length; i < len; i++) {"+"\r\n"+"		var cht = goChts[arAllCharts[i]];"+"\r\n"+"		if (IsShowChart(cht) && ew_IsChartDrillDown(cht)) {"+"\r\n"+"			var sChtDrillSourceFields = cht.ChartDrillSourceFields.trim();"+"\r\n"+"			if (sChtDrillSourceFields.substr(sChtDrillSourceFields.length-2) == \"||\")"+"\r\n"+"				sChtDrillSourceFields = sChtDrillSourceFields.substr(0,sChtDrillSourceFields.length-2);"+"\r\n"+"			var arSourceFlds = sChtDrillSourceFields.split(\"||\");"+"\r\n"+"			for (var j = 0, cnt = arSourceFlds.length; j < cnt; j++) {"+"\r\n"+"				var SOURCEFLD = goFlds[arSourceFlds[j]];"+"\r\n"+"				if (SOURCEFLD.FldName == f.FldName)"+"\r\n"+"					return true;"+"\r\n"+"			}"+"\r\n"+"		}"+"\r\n"+"	}; // End for i"+"\r\n"+"	return false;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"function SqlTableName(t) {"+"\r\n"+"	var name;"+"\r\n"+"	name = ew_QuotedName(t.TblName);"+"\r\n"+"	if (ew_IsNotEmpty(t.TblSchema))"+"\r\n"+"		name = ew_QuotedName(t.TblSchema) + \".\" + name;"+"\r\n"+"	return name;"+"\r\n"+"}"+"\r\n"+""+"\r\n"+"/*"+"\r\n"+" ***"+"\r\n"+" ***  IMPORTANT - DO NOT CHANGE"+"\r\n"+" *** -----------------------------------------"+"\r\n"+" */"+"\r\n"+"";

ewSB.Append(ewAr[1]);

return ewSB.ToString();
 } catch(e) {
  throw e;
 }
}