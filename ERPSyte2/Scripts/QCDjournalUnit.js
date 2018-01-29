(function (window, undefined) {
    "use strict";

    // статусы загрузки
    var dirLoadStatus_undefined = 0;
    var dirLoadStatus_process = 1;
    var dirLoadStatus_success = 2;
    var dirLoadStatus_error = 3;

    // статус справочника
    var dirUMs = dirLoadStatus_undefined;
    var dirTemaNIOKR = dirLoadStatus_undefined;
    var dirChecker = dirLoadStatus_undefined;

    $("document").ready(addButtonEvent); //docReady(addButtonEvent); //document.addEventListener("DOMContentLoaded", addButtonEvent);
    $("document").ready(loadDirectories); 

    function loadDirectories() {
        blockUItxt("Подождите, идет&nbsp;инициализация&nbsp;справочников.");

        initDates();
        loadDirUMs();
        loadDirTemaNIOKR();
        loadDirChecker();
    }

    function initDates() {
        var x = new Date();
        $('#DateTransferTo').datepicker('setDate', x);
        x.setMonth(x.getMonth() - 1);
        $('#DateTransferFrom').datepicker('setDate', x);
    }

    function initFilterFields() {
        $("#UMs").val("все");
        $("#Repeated").val("все");
        $("#TemaNIOKR").val("все");
        $("#VendN").val("все");
        $("#Checker").val("все");
        $("#Scrap").val("все");
        $("#ShowTo").val("Кооперация");
    }

    function addButtonEvent() {
        //var bApplyFilter = document.getElementById("bApplyFilter");
        //if (bApplyFilter)
        //    bApplyFilter.addEventListener("click", doApplyFilter);
        $("#bApplyFilter").bind("click", doApplyFilter);
        $("#bExportExcel").bind("click", doExportExcel);
    }

    function doApplyChoice(event) {
        try {
            //alert("doApplyChoice: proc: " + this.dataset.proc + " item: " + this.dataset.item + " value: " + this.dataset.value);
            var cProc = this.getAttribute("data-proc"); //dataset.proc
            var cItem = this.getAttribute("data-item"); //dataset.item;
            var cValue = this.getAttribute("data-value"); //dataset.value
            var cLogin = document.getElementById("ftUserDataLogin").value;

            var choiceData = [];
            choiceData[0] = cProc;
            choiceData[1] = cItem;
            choiceData[2] = cValue;
            choiceData[3] = cLogin;
            var postData = '{ "aData":' + JSON.stringify(choiceData) + '}';

            $.ajax({
                url: "../Services/WCFService.svc/ajax/setApplyChoice",
                type: "POST",
                data: postData,
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: blockUItxt("Подождите, идет&nbsp;запрос&nbsp;данных."),
                //complete: function () { $.unblockUI(); },
                success: returnChoiceData,
                error: returnError
            });

            if (event)
                event.preventDefault ? event.preventDefault() : (event.returnValue = false); //убрать реакцию браузера на событие W3C / IE 
            return false;
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnChoiceData(data) {
        try {
            //var responseText = JSON.parse(data);

            //if (responseText.Severity == 0) {
            doApplyFilter();
            //}

        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        } finally {
            //$.unblockUI();
        }
    }

    function doApplyFilter(event) {
        try {
            var cShowTo = document.getElementById('ShowTo');
            var cShowTo_value = cShowTo.options[cShowTo.selectedIndex].value;

            var cDateTransferFrom = document.getElementById('DateTransferFrom');
            var cDateTransferTo = document.getElementById('DateTransferTo');
            var cDateAcceptFrom = document.getElementById('DateAcceptFrom');
            var cDateAcceptTo = document.getElementById('DateAcceptTo');

            var cDateTransferFrom2 = document.getElementById('DateTransferFrom2');
            var cDateTransferTo2 = document.getElementById('DateTransferTo2');
            var cDateAcceptFrom2 = document.getElementById('DateAcceptFrom2');
            var cDateAcceptTo2 = document.getElementById('DateAcceptTo2');

            var cItem = document.getElementById('Item');
            var cDescription = document.getElementById('Description');
            var cRepeated = document.getElementById('Repeated');
            var cTemaNIOKR = document.getElementById('TemaNIOKR');
            var cVend = document.getElementById('Vend');
            var cVendN = document.getElementById('VendN');
            var cChecker = document.getElementById('Checker');
            var cScrap = document.getElementById('Scrap');
            var cLot = document.getElementById('Lot');

            var cWaitWork = document.getElementById('cbWaitWork');
            var cWaitANP = document.getElementById('cbWaitANP');
            var cWaitWorkDay = document.getElementById('tbWaitWork');
            var cWaitANPDay = document.getElementById('tbWaitANP');

            var cShowOnlyLocQCD = document.getElementById('cbShowOnlyLocQCD');
            var cShowOnlyLocWork = document.getElementById('cbShowOnlyLocWork');
            var cUM = document.getElementById('UMs');

            var cShowRecordset_primary = "1";
            var cShowRecordset_secondary = "0";
            var cShowRecordset_details = "0";
            var cShowRecordset_vendors = "0";

            var filterData = [];
            filterData[0] = (cShowTo_value == "все" || cShowTo_value == "Кооперация") ? "1" : "0";
            filterData[1] = (cShowTo_value == "все" || cShowTo_value == "Закупка") ? "1" : "0";

            filterData[2] = (cDateTransferFrom.value == "") ? "" : cDateTransferFrom.value.split('.').reverse().join('');
            filterData[3] = (cDateTransferTo.value == "") ? "" : cDateTransferTo.value.split('.').reverse().join('');
            filterData[4] = (cDateAcceptFrom.value == "") ? "" : cDateAcceptFrom.value.split('.').reverse().join('');
            filterData[5] = (cDateAcceptTo.value == "") ? "" : cDateAcceptTo.value.split('.').reverse().join('');

            filterData[6] = (cDateTransferFrom2.value == "") ? "" : cDateTransferFrom2.value.split('.').reverse().join('');
            filterData[7] = (cDateTransferTo2.value == "") ? "" : cDateTransferTo2.value.split('.').reverse().join('');
            filterData[8] = (cDateAcceptFrom2.value == "") ? "" : cDateAcceptFrom2.value.split('.').reverse().join('');
            filterData[9] = (cDateAcceptTo2.value == "") ? "" : cDateAcceptTo2.value.split('.').reverse().join('');

            filterData[10] = cItem.value;
            filterData[11] = cDescription.value;
            filterData[12] = cRepeated.options[cRepeated.selectedIndex].value;
            filterData[13] = cTemaNIOKR.options[cTemaNIOKR.selectedIndex].value;
            filterData[14] = cVend.value;
            filterData[15] = cVendN.options[cVendN.selectedIndex].value;
            filterData[16] = cChecker.options[cChecker.selectedIndex].value;
            filterData[17] = cScrap.options[cScrap.selectedIndex].value;
            filterData[18] = cLot.value;

            filterData[19] = (cWaitWork.checked) ? "1" : "0";
            filterData[20] = (cWaitANP.checked) ? "1" : "0";
            filterData[21] = cWaitWorkDay.value;
            filterData[22] = cWaitANPDay.value;

            filterData[23] = (cShowOnlyLocQCD.checked) ? "1" : "0";
            filterData[24] = (cShowOnlyLocWork.checked) ? "1" : "0";
            filterData[25] = cUM.options[cUM.selectedIndex].value;

            filterData[26] = cShowRecordset_primary;
            filterData[27] = cShowRecordset_secondary;
            filterData[28] = cShowRecordset_details;
            filterData[29] = cShowRecordset_vendors;

            var postData = '{ "aData":' + JSON.stringify(filterData) + '}';

            $.ajax({
                url: "../Services/WCFService.svc/ajax/getQCDjournalRows",
                type: "POST",
                data: postData,
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: blockUItxt("Подождите, идет&nbsp;запрос&nbsp;данных."),
                complete: function () { $.unblockUI(); },
                success: returnFilterData,
                error: returnError
            });

            if (event)
                event.preventDefault ? event.preventDefault() : (event.returnValue = false); //убрать реакцию браузера на событие W3C / IE 
            return false;
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function removeDataRow() {
        $("[id*=GridViewData] tr").not($("[id*=GridViewData] tr.hdrow")).remove();
    }

    function returnFilterData(data) {
        try {
            removeDataRow();

            if (data.length > 0) {

                var vjii_num, vtrans_num, vDateTransfer, vItem, vDescription, vLot, vPurchase,
                    vKind, vTemaNIOKR, vSerNums, vRepeated, vDocumentIncom, vQty, vAnpNum, vAnpScrap,
                    vVendNum, vVendName, vCheckerName, vAuthorName, vNote, vwhse, vDerQtyAccepted,
                    vDerQtyScrapped, vDerScrapPercent, vDerDocumentNum, vDerManual, vDerQtyAvailable,
                    vUM, vDerDateAnpScrap, vDerDateLastAccept, vDerDateAccept, vDerQty1, vDerQty2,
                    vDerQty3, vDerQty4, vDerQty5, vDerQty6, vDerQty7, vDerQty8, vDerQty9, vRcvTransNum,
                    vRcvLoc, vRcvName, vString;

                $.each(data, function (kRow, vRow) {

                    vjii_num = 0;
                    vtrans_num = 0;

                    vDateTransfer = 0;
                    vItem = "&nbsp;";
                    vDescription = "&nbsp;";
                    vLot = "&nbsp;";
                    vPurchase = "&nbsp;";
                    vKind = "&nbsp;";
                    vTemaNIOKR = "&nbsp;";
                    vSerNums = "&nbsp;";
                    vRepeated = 0;
                    vDocumentIncom = "&nbsp;";
                    vQty = 0;
                    vAnpNum = "&nbsp;";
                    vAnpScrap = "&nbsp;";
                    vVendNum = "&nbsp;";
                    vVendName = "&nbsp;";
                    vCheckerName = "&nbsp;";
                    vAuthorName = "&nbsp;";
                    vNote = "&nbsp;";

                    vwhse = "&nbsp;";
                    vDerQtyAccepted = 0;
                    vDerQtyScrapped = 0;
                    vDerScrapPercent = 0;
                    vDerDocumentNum = "&nbsp;";
                    vDerManual = 0;
                    vDerQtyAvailable = 0;

                    vUM = "&nbsp;";

                    vDerDateAnpScrap = 0;
                    vDerDateLastAccept = 0;
                    vDerDateAccept = 0;

                    vDerQty1 = 0;
                    vDerQty2 = 0;
                    vDerQty3 = 0;
                    vDerQty4 = 0;
                    vDerQty5 = 0;
                    vDerQty6 = 0;
                    vDerQty7 = 0;
                    vDerQty8 = 0;
                    vDerQty9 = 0;

                    vRcvTransNum = 0;
                    vRcvLoc = "&nbsp;";
                    vRcvName = "&nbsp;";

                    vString = "";

                    $.each(this, function (kField, vField) {
                        if (kField === "jii_num") {
                            vjii_num = vField;
                        } else if (kField === "trans_num") {
                            vtrans_num = vField;

                        } else if (kField === "DateTransfer" && vField !== null && vField != "") {
                            vDateTransfer = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "Item") {
                            vItem = vField;
                        } else if (kField === "Description") {
                            vDescription = vField;
                        } else if (kField === "Lot") {
                            vLot = vField;
                        } else if (kField === "Purchase") {
                            vPurchase = vField;
                        } else if (kField === "Kind") {
                            vKind = vField;
                        } else if (kField === "TemaNIOKR") {
                            vTemaNIOKR = vField;
                        } else if (kField === "SerNums") {
                            vSerNums = vField;
                        } else if (kField === "Repeated") {
                            vRepeated = vField;
                        } else if (kField === "DocumentIncom") {
                            vDocumentIncom = vField;
                        } else if (kField === "Qty") {
                            vQty = vField;
                        } else if (kField === "AnpNum") {
                            vAnpNum = vField;
                        } else if (kField === "AnpScrap") {
                            vAnpScrap = vField;
                        } else if (kField === "VendNum") {
                            vVendNum = vField;
                        } else if (kField === "VendName") {
                            vVendName = vField;
                        } else if (kField === "CheckerName") {
                            vCheckerName = vField;
                        } else if (kField === "AuthorName") {
                            vAuthorName = vField;
                        } else if (kField === "Note") {
                            vNote = vField;

                        } else if (kField === "whse") {
                            vwhse = vField;
                        } else if (kField === "DerQtyAccepted") {
                            vDerQtyAccepted = vField;
                        } else if (kField === "DerQtyScrapped") {
                            vDerQtyScrapped = vField;
                        } else if (kField === "DerScrapPercent") {
                            vDerScrapPercent = vField;
                        } else if (kField === "DerDocumentNum") {
                            vDerDocumentNum = vField;
                        } else if (kField === "DerManual") {
                            vDerManual = vField; //(vField === 1) ? "Да" : "&nbsp;"
                        } else if (kField === "DerQtyAvailable") {
                            vDerQtyAvailable = vField;

                        } else if (kField === "UM") {
                            vUM = vField;

                        } else if (kField === "DerDateAnpScrap" && vField !== null && vField != "") {
                            vDerDateAnpScrap = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "DerDateLastAccept" && vField !== null && vField != "") {
                            vDerDateLastAccept = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "DerDateAccept" && vField !== null && vField != "") {
                            vDerDateAccept = zKdDateFormat(new Date(parseInt(vField.substr(6))));

                        } else if (kField === "DerQty1") {
                            vDerQty1 = vField;
                        } else if (kField === "DerQty2") {
                            vDerQty2 = vField;
                        } else if (kField === "DerQty3") {
                            vDerQty3 = vField;
                        } else if (kField === "DerQty4") {
                            vDerQty4 = vField;
                        } else if (kField === "DerQty5") {
                            vDerQty5 = vField;
                        } else if (kField === "DerQty6") {
                            vDerQty6 = vField;
                        } else if (kField === "DerQty7") {
                            vDerQty7 = vField;
                        } else if (kField === "DerQty8") {
                            vDerQty8 = vField;
                        } else if (kField === "DerQty9") {
                            vDerQty9 = vField;

                        } else if (kField === "RcvTransNum") {
                            vRcvTransNum = vField;
                        } else if (kField === "RcvLoc") {
                            vRcvLoc = vField;
                        } else if (kField === "RcvName") {
                            vRcvName = vField;
                        }
                    });

                    //vString += "<td class=itcolct>" + (vIsVersionAdvance === 1 ? "Да" : "&nbsp;") + "</td>";

                    vString += "<td class=itcolrt>" + vjii_num + "</td>";
                    vString += "<td class=itcol>" + vDateTransfer + "</td>";
                    vString += "<td class=itcol>" + (vDerDateAccept != 0 ? vDerDateAccept : "&nbsp;") + "</td>";
                    vString += "<td class=itcolnw>" + vItem + "</td>";
                    vString += "<td class=itcol>" + vDescription + "</td>";
                    vString += "<td class=itcol>" + vLot + "</td>";
                    vString += "<td class=itcol>" + vKind + "</td>";
                    vString += "<td class=itcol>" + (vRepeated == 1 ? "Да" : "&nbsp;") + "</td>";
                    vString += "<td class=itcolnw>" + vDocumentIncom + "</td>";
                    vString += "<td class=itcol>" + vDerDocumentNum + "</td>";
                    vString += "<td class=itcolrt>" + vQty + "</td>";
                    vString += "<td class=itcol>" + vUM + "</td>";
                    vString += "<td class=itcolrt>" + vDerQtyAccepted + "</td>";
                    vString += "<td class=itcolrt>" + vDerQtyScrapped + "</td>";
                    vString += "<td class=itcolrt>" + vDerScrapPercent + "</td>";
                    vString += "<td class=itcol>" + vwhse + "</td>";
                    vString += "<td class=itcolnw>" + vRcvLoc + "</td>";
                    vString += "<td class=itcol>" + vRcvName + "</td>";
                    vString += "<td class=itcol>" + vAnpNum + "</td>";
                    vString += "<td class=itcol>" + vAnpScrap + "</td>";
                    vString += "<td class=itcol>" + vVendName + "</td>";
                    vString += "<td class=itcol>" + vCheckerName + "</td>";
                    vString += "<td class=itcol>" + vNote + "</td>";

                    $("[id*=GridViewData]").append("<tr>" + vString + "</tr>");

                });
            }
            else {
                $("[id*=GridViewData]").append("<tr><td colspan=23 class=itcolct>Нет данных, удовлетворяющих условию фильтрации.</td></tr>");
            }

            $("#tabs").tabs("option", "active", 0);

        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        } finally {
            $.unblockUI();
        }
    }

    function returnError(jqXHR, textStatus, errorThrown) {
        try {
            var responseText, errDate = new Date(), errType, errCode, errMessage,
                errSource = "", errParameters = "", errHelpLink = "", textError = "Ошибка\n\n";

            if (jqXHR != null && jqXHR.responseText != "") {
                try {
                    responseText = JSON.parse(jqXHR.responseText);
                    errDate = new Date(parseInt(responseText.Date.substr(6)));
                    errType = responseText.Type;
                    errCode = responseText.Code;
                    errMessage = responseText.Message;
                    errSource = responseText.Source;
                    errParameters = responseText.Parameters;
                    errHelpLink = responseText.HelpLink;
                } catch (e) {
                    alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
                }
            }

            textError += "Дата: " + zKdDateTimeFormat(errDate) + "\n";
            textError += "Тип: " + errType + "\n";
            textError += "Код: " + errCode + "\n";
            textError += "Сообщение: " + errMessage + "\n";
            textError += "Источник: " + errSource + "\n";
            textError += "Параметры: [" + errParameters + "]\n";
            textError += "Ссылка: " + errHelpLink + "\n\n";

            textError += "readyState: " + jqXHR.readyState + "\n";
            textError += "status: " + jqXHR.status + "\n";
            textError += "statusText: " + jqXHR.statusText + "\n";
            textError += "responseXML: " + jqXHR.responseXML + "\n";
            textError += "textStatus: " + textStatus + "\n";
            textError += "errorThrown: " + errorThrown + "\n\n";

            alert(textError);
        } finally {
            doEndLoad();
        }
    }

    function doExportExcel() {
        var pShowCooperate = 1;
        var pShowBuy = 1;
        var pDateTransferFrom = "";
        var pDateTransferTo = "";
        var pDateAcceptFrom = "";
        var pDateAcceptTo = "";
        var pDateTransferFrom2 = "";
        var pDateTransferTo2 = "";
        var pDateAcceptFrom2 = "";
        var pDateAcceptTo2 = "";
        var pItem = "";
        var pDescription = "";
        var pRepeated = "";
        var pTemaNIOKR = "";
        var pVend = "";
        var pVendN = "";
        var pChecker = "";
        var pScrap = "";
        var pLot = "";
        var pWaitWork = 0;
        var pWaitANP = 0;
        var pWaitWorkDay = 0;
        var pWaitANPDay = 0;
        var pShowOnlyLocQCD = 0;
        var pShowOnlyLocWork = 0;
        var pUM = "";
        var pShowRecordset_primary = 1;
        var pShowRecordset_secondary = 0;
        var pShowRecordset_details = 0;
        var pShowRecordset_vendors = 0;

        //каталог временных файлов
        var temp_folder = "";
        var oWshShell = new ActiveXObject("WScript.Shell");
        var oEnvUser = oWshShell.Environment("User");
        var oEnvProcess = oWshShell.Environment("Process");
        if (temp_folder == "")
            temp_folder = oWshShell.ExpandEnvironmentStrings("%TEMP%");
        if (temp_folder == "")
            temp_folder = oWshShell.ExpandEnvironmentStrings("%TMP%");
        if (temp_folder == "")
            temp_folder = oEnvUser("TEMP");
        if (temp_folder == "")
            temp_folder = oEnvUser("TMP");
        if (temp_folder == "")
            temp_folder = oEnvProcess("TEMP");
        if (temp_folder == "")
            temp_folder = oEnvProcess("TMP");
        if (temp_folder == "") {
            alert("Файл не может быть создан, так как в переменных окружения не найден временный каталог. Обратитесь за помощью к системному администратору.");
            return (1);
        }
        oEnvProcess = null;
        oEnvUser = null;

        //маска файла
        var cur_date = new Date();
        var d = cur_date.getDate();
        var m = cur_date.getMonth() + 1;
        var y = cur_date.getFullYear();
        var s = '' + y + '' + (m <= 9 ? '0' + m : m) + '' + (d <= 9 ? '0' + d : d);
        y = null;
        m = null;
        d = null;
        cur_date = null;

        //перенос файла
        var filename = temp_folder + "\\QCD_" + s + ".xlsm";
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var i = 0;
        while (fso.FileExists(filename)) {
            i += 1;
            if (i > 9999) {
                alert("Превышен счетчик документов.");
                return (2);
            }
            filename = temp_folder + "\\QCD_" + s + "_(" + i + ").xlsm";
        }
        i = null;
        s = null;
        //alert("the filename is <"+filename+">");
        fso.CopyFile("N:\\Installs\\Elektron\\Common\\SyteLine\\QCDStatisticsA.xlsm", filename);

        //открытие файла
        var xl = new ActiveXObject("Excel.Application");
        xl.visible = true;
        xl.DisplayAlerts = false;
        xl.UserControl = false;

        success = oWshShell.AppActivate(xl);
        if (success) {
            oWshShell.sendkeys("% r")  //...restore window
            oWshShell.sendkeys("%")  //...send ALT to close system window
        }
        var wb = xl.Workbooks.Open(filename);
        wb.Sheets(1).Name = "Общая База";
        wb.Sheets(1).Cells(1, 1).Select;

        //передача параметров
        if (wb.Sheets.Count > 1) {
            wb.Sheets.Item("params").Cells(1, 2).Value = pShowCooperate;//@pShowCooperate
            wb.Sheets.Item("params").Cells(2, 2).Value = pShowBuy;//@pShowBuy
            wb.Sheets.Item("params").Cells(3, 2).Value = format_date(pDateTransferFrom);//@pDateTransferFrom
            wb.Sheets.Item("params").Cells(4, 2).Value = format_date(pDateTransferTo);//@pDateTransferTo
            wb.Sheets.Item("params").Cells(5, 2).Value = format_date(pDateAcceptFrom);//@pDateAcceptFrom
            wb.Sheets.Item("params").Cells(6, 2).Value = format_date(pDateAcceptTo);//@pDateAcceptTo
            wb.Sheets.Item("params").Cells(7, 2).Value = format_date(pDateTransferFrom2);//@pDateTransferFrom
            wb.Sheets.Item("params").Cells(8, 2).Value = format_date(pDateTransferTo2);//@pDateTransferTo
            wb.Sheets.Item("params").Cells(9, 2).Value = format_date(pDateAcceptFrom2);//@pDateAcceptFrom
            wb.Sheets.Item("params").Cells(10, 2).Value = format_date(pDateAcceptTo2);//@pDateAcceptTo
            wb.Sheets.Item("params").Cells(11, 2).Value = pItem;//@pItem
            wb.Sheets.Item("params").Cells(12, 2).Value = pDescription;//@pDescription
            wb.Sheets.Item("params").Cells(13, 2).Value = pRepeated;//@pRepeated
            wb.Sheets.Item("params").Cells(14, 2).Value = pTemaNIOKR;//@pTemaNIOKR
            wb.Sheets.Item("params").Cells(15, 2).Value = pVend;//@pVend
            wb.Sheets.Item("params").Cells(16, 2).Value = pVendN;//@pVendN
            wb.Sheets.Item("params").Cells(17, 2).Value = pChecker;//@pChecker
            wb.Sheets.Item("params").Cells(18, 2).Value = pScrap;//@pScrap
            wb.Sheets.Item("params").Cells(19, 2).Value = pLot;//@pLot
            wb.Sheets.Item("params").Cells(20, 2).Value = pWaitWork;//@pWaitWork
            wb.Sheets.Item("params").Cells(21, 2).Value = pWaitANP;//@pWaitANP
            wb.Sheets.Item("params").Cells(22, 2).Value = pWaitWorkDay;//@pWaitWorkDay
            wb.Sheets.Item("params").Cells(23, 2).Value = pWaitANPDay;//@pWaitANPDay
            wb.Sheets.Item("params").Cells(24, 2).Value = pShowOnlyLocQCD;//@pShowOnlyLocQCD
            wb.Sheets.Item("params").Cells(25, 2).Value = pShowOnlyLocWork;//@pShowOnlyLocWork
            wb.Sheets.Item("params").Cells(26, 2).Value = pUM;//@pUM
            wb.Sheets.Item("params").Cells(27, 2).Value = pShowRecordset_primary;//@pShowRecordset_primary
            wb.Sheets.Item("params").Cells(28, 2).Value = pShowRecordset_secondary;//@pShowRecordset_secondary
            wb.Sheets.Item("params").Cells(29, 2).Value = pShowRecordset_details;//@pShowRecordset_details
            wb.Sheets.Item("params").Cells(30, 2).Value = pShowRecordset_vendors;//@pShowRecordset_vendors
        }

        //запуск макроса
        xl.run("JIIViewer");
        //xl.run("DeleteModule");
        wb = null;
        xl = null;

        filename = null;
        fso = null;
        oWshShell = null;
        temp_folder = null;
    }

    function rangeValidator(value, minimumValue, maximumValue, errorMessage) {
        if ((value < minimumValue) || (value > maximumValue)) {
            alert(errorMessage);
        }
        else {

        }
    }

    function loadDirUMs() {
        $('#UMs option').remove();
        $('#UMs').append($("<option></option>").attr("value", "все").text("все"));
        dirUMs = dirLoadStatus_process;

        try {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/getQCDUMsRows",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    dirUMs = dirLoadStatus_error;
                    try {
                        //$('#UMs option:not([value="все"])').remove();
                        if (data.length > 0) {
                            $.each(data, function (kRow, vRow) {
                                $.each(this, function (kField, vField) {
                                    if (kField === "Um") {
                                        $('#UMs')
                                            .append($("<option></option>")
                                            .attr("value", vField)
                                            .text(vField));
                                    }
                                });
                            });
                        }
                        dirUMs = dirLoadStatus_success;

                    } catch (e) {
                        alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
                    } finally {
                        doEndLoad();
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    dirUMs = dirLoadStatus_error;
                    returnError(jqXHR, textStatus, errorThrown);
                }
            });

            if (event)
                event.preventDefault ? event.preventDefault() : (event.returnValue = false); //убрать реакцию браузера на событие W3C / IE 
            return false;
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function loadDirTemaNIOKR() {
        $('#TemaNIOKR option').remove();
        $('#TemaNIOKR').append($("<option></option>").attr("value", "все").text("все"));
        $('#TemaNIOKR').append($("<option></option>").attr("value", "не НИОКР").text("не НИОКР"));
        $('#TemaNIOKR').append($("<option></option>").attr("value", "только НИОКР").text("только НИОКР"));
        dirTemaNIOKR = dirLoadStatus_process;

        try {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/getQCDTemaNIOKRRows",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    try {
                        //$('#TemaNIOKR option:not([value="все"], [value="не НИОКР"], [value="только НИОКР"])').remove();
                        if (data.length > 0) {
                            $.each(data, function (kRow, vRow) {
                                $.each(this, function (kField, vField) {
                                    if (kField === "TemaNIOKR") {
                                        $('#TemaNIOKR')
                                            .append($("<option></option>")
                                            .attr("value", vField)
                                            .text(vField));
                                    }
                                });
                            });
                        }
                        dirTemaNIOKR = dirLoadStatus_success;

                    } catch (e) {
                        alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
                    } finally {
                        doEndLoad();
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    dirTemaNIOKR = dirLoadStatus_error;
                    returnError(jqXHR, textStatus, errorThrown);
                }
            });

            if (event)
                event.preventDefault ? event.preventDefault() : (event.returnValue = false); //убрать реакцию браузера на событие W3C / IE 
            return false;
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function loadDirChecker() {
        $('#Checker option').remove();
        $('#Checker').append($("<option></option>").attr("value", "все").text("все"));
        dirChecker = dirLoadStatus_process;

            try {
                $.ajax({
                    url: "../Services/WCFService.svc/ajax/getQCDCheckerNameRows",
                    type: "POST",
                    datatype: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        try {
                            //$('#Checker option:not([value="все"])').remove();
                            if (data.length > 0) {
                                $.each(data, function (kRow, vRow) {
                                    $.each(this, function (kField, vField) {
                                        if (kField === "CheckerName") {
                                            $('#Checker')
                                                .append($("<option></option>")
                                                .attr("value", vField)
                                                .text(vField));
                                        }
                                    });
                                });
                            }
                            dirChecker = dirLoadStatus_success;

                        } catch (e) {
                            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
                        } finally {
                            doEndLoad();
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        dirChecker = dirLoadStatus_error;
                        returnError(jqXHR, textStatus, errorThrown);
                    }
                });

                if (event)
                    event.preventDefault ? event.preventDefault() : (event.returnValue = false); //убрать реакцию браузера на событие W3C / IE 
                return false;
            } catch (e) {
                alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
            }
        }

    function blockUItxt(txt) {
        $.blockUI({
            css: {
                padding: 0,
                margin: 0,
                width: '30%',
                top: '40%',
                left: '35%',
                textAlign: 'center',
                color: '#000000',
                border: '3px solid #aaa',
                backgroundColor: '#ffffff',
                cursor: 'wait'
            },
            overlayCSS: {
                backgroundColor: '#000',
                opacity: 0.6
            },
            message: '<img src=../Image/busy.gif style="vertical-align:middle;">  <b style="vertical-align:middle; font-size:larger;">' + txt + '</b>'
        });
    }

    function doEndLoad() {
        var dirs_success = dirUMs === dirLoadStatus_success
                && dirTemaNIOKR === dirLoadStatus_success
                && dirChecker === dirLoadStatus_success;

        if (dirUMs === dirLoadStatus_error
             || dirTemaNIOKR === dirLoadStatus_error
             || dirChecker === dirLoadStatus_error
             || dirs_success) {
            $.unblockUI();
        }

        if (dirs_success) {
            initFilterFields();
        }
    }

})(window);