(function (window, undefined) {
    "use strict";

    $("document").ready(addButtonEvent); //docReady(addButtonEvent); //document.addEventListener("DOMContentLoaded", addButtonEvent);

    function addButtonEvent() {
        //var bApplyFilter = document.getElementById("bApplyFilter");
        //if (bApplyFilter)
        //    bApplyFilter.addEventListener("click", doApplyFilter);
        $("#bApplyFilter").bind("click", doApplyFilter);
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
                beforeSend: function () {
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
                        message: '<img src=../Image/busy.gif style="vertical-align:middle;">  <b style="vertical-align:middle; font-size:larger;">Подождите, идет&nbsp;запрос&nbsp;данных.</b>'
                    });
                },
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
            var cItem = document.getElementById('Item');
            var cDescription = document.getElementById('Description');
            var cDateCode004From = document.getElementById('DateCode004From');
            var cDateCode004To = document.getElementById('DateCode004To');
            var cIsAnalogRegistered = document.getElementById('IsAnalogRegistered');
            var cIsAnalogApproved = document.getElementById('IsAnalogApproved');
            var cIsEquivalentPush = document.getElementById('IsEquivalentPush');
            var cIsVersionAdvance = document.getElementById('IsVersionAdvance');
            var cIsApplyClosed = document.getElementById('IsApplyClosed');
            var cIsLeadTime999 = document.getElementById('IsLeadTime999');
            //логин в паралельной процедуре может придти позже или паралельно, тогда права подвиснут до следующего запуска. проверить перед запуском
            var cLogin = document.getElementById("ftUserDataLogin").value;

            var filterData = [];
            filterData[0] = cItem.value;
            filterData[1] = cDescription.value;
            filterData[2] = (cDateCode004From.value == "") ? "" : cDateCode004From.value.split('.').reverse().join('');
            filterData[3] = (cDateCode004To.value == "") ? "" : cDateCode004To.value.split('.').reverse().join('');
            filterData[4] = cIsAnalogRegistered.options[cIsAnalogRegistered.selectedIndex].value;
            filterData[5] = cIsAnalogApproved.options[cIsAnalogApproved.selectedIndex].value;
            filterData[6] = cIsEquivalentPush.options[cIsEquivalentPush.selectedIndex].value;
            filterData[7] = cIsVersionAdvance.options[cIsVersionAdvance.selectedIndex].value;
            filterData[8] = cIsApplyClosed.options[cIsApplyClosed.selectedIndex].value;
            filterData[9] = cIsLeadTime999.options[cIsLeadTime999.selectedIndex].value;
            filterData[10] = cLogin;
            var postData = '{ "aData":' + JSON.stringify(filterData) + '}';
            
            $.ajax({
                url: "../Services/WCFService.svc/ajax/getProcessNotBuyRows",
                type: "POST",
                data: postData,
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                beforeSend: function () {
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
                        message: '<img src=../Image/busy.gif style="vertical-align:middle;">  <b style="vertical-align:middle; font-size:larger;">Подождите, идет&nbsp;запрос&nbsp;данных.</b>'
                    });
                },
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

                var vItem, vDescription, vDateCode004, vIsAnalogRegistered, vIsAnalogApproved,
                    vIsEquivalentPush, vIsVersionAdvance, vIsApplyClosed, vIsLeadTime999,
                    vAccessRight, vEquivalentPush_Grant, vVersionAdvance_Grant, vString;

                $.each(data, function (kRow, vRow) {

                    vItem = "&nbsp;";
                    vDescription = "&nbsp;";
                    vDateCode004 = "&nbsp;";
                    vIsAnalogRegistered = "&nbsp;";
                    vIsAnalogApproved = "&nbsp;";
                    vIsEquivalentPush = "&nbsp;";
                    vIsVersionAdvance = "&nbsp;";
                    vIsApplyClosed = "&nbsp;";
                    vIsLeadTime999 = "&nbsp;";
                    vAccessRight = 0;
                    vEquivalentPush_Grant = false;
                    vVersionAdvance_Grant = false;
                    vString = "";

                    $.each(this, function (kField, vField) {
                        if (kField === "Item") {
                            vItem = vField;
                        } else if (kField === "Description") {
                            vDescription = vField;
                        } else if (kField === "DateCode004" && vField !== null && vField != "") {
                            vDateCode004 = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "IsAnalogRegistered") {
                            vIsAnalogRegistered = (vField === 1) ? "Да" : "&nbsp;";
                        } else if (kField === "IsAnalogApproved") {
                            vIsAnalogApproved = (vField === 1) ? "Да" : "&nbsp;";
                        } else if (kField === "IsEquivalentPush") {
                            vIsEquivalentPush = vField;
                        } else if (kField === "IsVersionAdvance") {
                            vIsVersionAdvance = vField;
                        } else if (kField === "IsApplyClosed") {
                            vIsApplyClosed = (vField === 1) ? "Да" : "&nbsp;";
                        } else if (kField === "IsLeadTime999") {
                            vIsLeadTime999 = (vField === 1) ? "Да" : "&nbsp;";
                        } else if (kField === "AccessRight") {
                            vAccessRight = vField;
                        }
                    });

                    vEquivalentPush_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight
                    vVersionAdvance_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight

                    vString += "<td class=itcolnw>" + vItem + "</td>";
                    vString += "<td class=itcol>" + vDescription + "</td>";
                    vString += "<td class=itcolct>" + vDateCode004 + "</td>";
                    vString += "<td class=itcolct>" + vIsAnalogRegistered + "</td>";
                    vString += "<td class=itcolct>" + vIsAnalogApproved + "</td>";
                    if (vEquivalentPush_Grant) {
                        vString += "<td class=itcolct><a href='#' " +
                            "data-proc=\"EquivalentPush\" data-item=\"" + vItem + "\" data-value=" + vIsEquivalentPush + " " +
                            "title='" + (vIsEquivalentPush === 1 ? "Нажмите, чтобы снять метку" : "Нажмите, чтобы установить метку") + "' " +
                            "class='" + (vIsEquivalentPush === 1 ? "aButton1" : "aButton0") + "'>" +
                            (vIsEquivalentPush === 1 ? "Да" : "Нет") + "</a></td>";
                    } else
                        vString += "<td class=itcolct>" + (vIsEquivalentPush === 1 ? "Да" : "&nbsp;") + "</td>";
                    if (vVersionAdvance_Grant) {
                        vString += "<td class=itcolct><a href='#' " +
                            "data-proc=\"VersionAdvance\" data-item=\"" + vItem + "\" data-value=" + vIsVersionAdvance + " " +
                            "title='" + (vIsVersionAdvance === 1 ? "Нажмите, чтобы снять метку" : "Нажмите, чтобы установить метку") + "' " +
                            "class='" + (vIsVersionAdvance === 1 ? "aButton1" : "aButton0") + "'>" +
                            (vIsVersionAdvance === 1 ? "Да" : "Нет") + "</a></td>";
                    } else
                        vString += "<td class=itcolct>" + (vIsVersionAdvance === 1 ? "Да" : "&nbsp;") + "</td>";
                    vString += "<td class=itcolct>" + vIsApplyClosed + "</td>";
                    vString += "<td class=itcolct>" + vIsLeadTime999 + "</td>";

                    $("[id*=GridViewData]").append("<tr>" + vString + "</tr>");

                });
            }
            else {
                $("[id*=GridViewData]").append("<tr><td colspan=9 class=itcolct>Нет данных, удовлетворяющих условию фильтрации.</td></tr>");
            }

            $(".aButton0, .aButton1").bind("click", doApplyChoice);
            $("#tabs").tabs("option", "active", 0);

        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        } finally {
            $.unblockUI();
        }
    }

    function returnError(jqXHR, textStatus, errorThrown) {
        try{
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
            $.unblockUI();
        }
    }

})(window);