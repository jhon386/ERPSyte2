(function (window, undefined) {
    "use strict";

    var vSN = getParameterByName('SN');
    var vID = getParameterByName('ID');
    $("document").ready(doAfterLoaded);

    function doAfterLoaded() {
        //$('#SN').val(vSN);
        //$('#ID').val(vID);
        //doLoadData();
    }

    function getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, '\\$&');
        var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }

    function doLoadData(event) {
        try {
            //логин в паралельной процедуре может придти позже или паралельно, тогда права подвиснут до следующего запуска. проверить перед запуском
            var cLogin = $("#ftUserDataLogin").val(); 

            var filterData = [];
            filterData[0] = vSN;
            filterData[1] = vID;
            filterData[2] = cLogin;
            var postData = '{ "aData":' + JSON.stringify(filterData) + '}';

            $.ajax({
                async: false,
                url: "../Services/WCFService.svc/ajax/getImplPlan",
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
                        message: '<img src=../Image/busy.gif style="vertical-align:middle;">  <b style="vertical-align:middle; font-size:larger;">Подождите, идет&nbsp;загрузка&nbsp;данных.</b>'
                    });
                },
                complete: function () { $.unblockUI(); },
                success: returnData,
                error: returnError
            });

            if (event)
                event.preventDefault ? event.preventDefault() : event.returnValue = false; //убрать реакцию браузера на событие W3C / IE 
            return false;
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnData(data) {
        try {
            //removeDataRow();

            if (data.length > 0) {

                var vOrderFromManager, vser_num, vItemManager, vComment1, vComment2, vComment3, vDateKabinetReady, vDateMontagEnd,
                    vStat, vID, vItemSL, vdescr, vu_m, vqty_ordered, vqty_shipped, vJob, vSuffix, vcust, vcustomer_ship,
                    vdue_date, vdate_fact_whse, vco_num, vco_line, vser_num_ord;

                $.each(data, function (kRow, vRow) {

                    vOrderFromManager = "&nbsp;";
                    vser_num = "&nbsp;";
                    vItemManager = "&nbsp;";
                    vComment1 = "&nbsp;";
                    vComment2 = "&nbsp;";
                    vComment3 = "&nbsp;";
                    vDateKabinetReady = "&nbsp;";
                    vDateMontagEnd = "&nbsp;";
                    vStat = "&nbsp;";
                    vID = "&nbsp;";
                    vItemSL = "&nbsp;";
                    vdescr = "&nbsp;";
                    vu_m = "&nbsp;";
                    vqty_ordered = "&nbsp;";
                    vqty_shipped = "&nbsp;";
                    vJob = "&nbsp;";
                    vSuffix = "&nbsp;";
                    vcust = "&nbsp;";
                    vcustomer_ship = "&nbsp;";
                    vdue_date = "&nbsp;";
                    vdate_fact_whse = "&nbsp;";
                    vco_num = "&nbsp;";
                    vco_line = "&nbsp;";
                    vser_num_ord = "&nbsp;";

                    $.each(this, function (kField, vField) {
                        if (kField === "OrderFromManager") {
                            vOrderFromManager = vField;
                        } else if (kField === "ser_num") {
                            vser_num = vField;
                        } else if (kField === "ItemManager") {
                            vItemManager = vField;
                        } else if (kField === "Comment1") {
                            vComment1 = vField;
                        } else if (kField === "Comment2") {
                            vComment2 = vField;
                        } else if (kField === "Comment3") {
                            vComment3 = vField;
                        } else if (kField === "DateKabinetReady") {// && vField !== null && vField !== "") {
                            vDateKabinetReady = vField; //zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "DateMontagEnd") {// && vField !== null && vField !== "") {
                            vDateMontagEnd = vField; //zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "Stat") {
                            vStat = vField;
                        } else if (kField === "ID" && vField !== null) {
                            vID = vField;
                        } else if (kField === "ItemSL") {
                            vItemSL = vField;
                        } else if (kField === "descr") {
                            vdescr = vField;
                        } else if (kField === "u_m") {
                            vu_m = vField;
                        } else if (kField === "qty_ordered" && vField !== null) {
                            vqty_ordered = vField;
                        } else if (kField === "qty_shipped" && vField !== null) {
                            vqty_shipped = vField;
                        } else if (kField === "Job") {
                            vJob = vField;
                        } else if (kField === "Suffix" && vField !== null) {
                            vSuffix = vField;
                        } else if (kField === "cust") {
                            vcust = vField;
                        } else if (kField === "customer_ship") {
                            vcustomer_ship = vField;
                        } else if (kField === "due_date" && vField !== null && vField !== "") {
                            vdue_date = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "date_fact_whse" && vField !== null && vField !== "") {
                            vdate_fact_whse = zKdDateFormat(new Date(parseInt(vField.substr(6))));
                        } else if (kField === "co_num") {
                            vco_num = vField;
                        } else if (kField === "co_line" && vField !== null) {
                            vco_line = vField;
                        } else if (kField === "ser_num_ord") {
                            vser_num_ord = vField;
                        }

                    });

                    //vEquivalentPush_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight
                    //vVersionAdvance_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight

                    $('#cmp_OrderFromManager').val(vOrderFromManager);
                    $('#cmp_ser_num').val(vser_num);
                    $('#cmp_ItemManager').val(vItemManager);
                    $('#cmp_Comment1').val(vComment1);
                    $('#cmp_Comment2').val(vComment2);
                    $('#cmp_Comment3').val(vComment3);
                    $('#cmp_DateKabinetReady').val(vDateKabinetReady);
                    $('#cmp_DateMontagEnd').val(vDateMontagEnd);
                    $('#cmp_Stat').val(vStat);
                    $('#cmp_ID').val(vID);
                    $('#cmp_ItemSL').val(vItemSL);
                    $('#cmp_descr').val(vdescr);
                    $('#cmp_u_m').val(vu_m);
                    $('#cmp_qty_ordered').val(vqty_ordered);
                    $('#cmp_qty_shipped').val(vqty_shipped);
                    $('#cmp_Job').val(vJob);
                    $('#cmp_Suffix').val(vSuffix);
                    $('#cmp_cust').val(vcust);
                    $('#cmp_customer_ship').val(vcustomer_ship);
                    $('#cmp_due_date').val(vdue_date);
                    $('#cmp_date_fact_whse').val(vdate_fact_whse);
                    $('#cmp_co_num').val(vco_num);
                    $('#cmp_co_line').val(vco_line);

                });
            }
            else {
                //$("[id*=GridViewData]").append("<tr><td colspan=9 class=itcolct>Нет данных, удовлетворяющих условию фильтрации.</td></tr>");
            }


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

            if (jqXHR !== null && jqXHR.responseText !== "") {
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