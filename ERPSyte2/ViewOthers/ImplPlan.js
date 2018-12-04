function deficitFromAPS_XLS(obj) {
  var cSN = obj.getAttribute("data-SN");
  if ((cSN) && (cSN !== '') && (cSN !== 'нет')) {
    var Wsh;
    Wsh = new ActiveXObject('WScript.Shell');
    Wsh.Run("\\\\elektron.spb.su\\DFS-Root\\Installs\\Elektron\\Common\\SyteLine\\DeficitFromAPS.vbs " + cSN + " ");
  }
}

function scrollUp() {
  // плавная прокрутка, тормозит при переносе шапки, отключено
  //var t, s;
  //s = document.body.scrollTop || window.pageYOffset;
  //t = setInterval(function () {
  //  if (s > 0)
  //    window.scroll(0, s -= 500);
  //  else clearInterval(t)
  //}, 5);
  window.scroll(0, 0);
}

function filterApply() {
  var filter = '';
  $('#tableImplPlan > thead > tr#HeaderRow3 > th > .input-find').each(function (index, element) {
    filter += '{' + $(element).data('field_name') + ':' + $(element).val() + '}';
  });

  requestData("-all", 0, filter);
}

function filterClear() {
  $('#tableImplPlan > thead > tr#HeaderRow3 > th > .input-find').each(function (index, element) {
    $(element).val('');
  });

  filterApply();
}

function requestData(ser_num, id, filter) {
  try {

    var params = [];
    params[0] = ser_num;
    params[1] = id;
    params[2] = filter;
    var postData = '{ "aData":' + JSON.stringify(params) + '}';

    //url: "../Services/WCFService.svc/ajax/getImplPlan",
    $.ajax({
      async: false,
      url: "../Services/WCFService.svc/ajax/getImplPlan", 
      type: "POST",
      data: postData,
      datatype: "json",
      contentType: "application/json; charset=utf-8",
      success: responseData,
      error: handleAjaxErrorFunction
    });

    return false;
  } catch (e) {
    alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
  }
}

function removeData() {
  $("[id*=tableBody] tr").remove();
}

function responseData(data) {
  try {
    removeData();

    if (data.length > 0) {

      var vType, vComment1, vItem, vOrderFromManager, vser_num, vDateInContract, vDateInGK,
          vDateDesired, vDateInOKO, vDateVrHran, vComment4, vQforImport, vQforRus, vPImport,
          vPRus1, vPRus2, vPRus3, vPRus4, vDateToWhsePlan, vComment2, vDateShipPlan, vDateShipFact,
          vTypeShip, vTravelTimePlan, vDateDelivery, vDateDeliveryFact, vDateKabinetReady,
          vDateMontagStart, vDateMontagEnd, vComment5, vNumbProject, vCostMontage, vComment3,
          vStat_text, vStat, vID, vCreateDate, vsn_common, vItemSL, vdescr, vu_m, vcoi_ser_num,
          vcoi_stat, vqty_ordered, vqty_shipped, vJobNum, vJob, vSuffix, vcust, vcustomer_ship,
          vdue_date, vdate_fact_whse, vco_num, vco_line, vDeficitAPS_rowCount, vDeficitAPS_CostAll,
          vDateShipFrom1C, vfsi_date, vprice_all, vString;

      $.each(data, function (kRow, vRow) {

        vType = "&nbsp;";
        vComment1 = "&nbsp;";
        vItem = "&nbsp;";
        vOrderFromManager = "&nbsp;";
        vser_num = "&nbsp;";
        vDateInContract = "&nbsp;";
        vDateInGK = "&nbsp;";
        vDateDesired = "&nbsp;";
        vDateInOKO = "&nbsp;";
        vDateVrHran = "&nbsp;";
        vComment4 = "&nbsp;";
        vQforImport = "&nbsp;";
        vQforRus = "&nbsp;";
        vPImport = "&nbsp;";
        vPRus1 = "&nbsp;";
        vPRus2 = "&nbsp;";
        vPRus3 = "&nbsp;";
        vPRus4 = "&nbsp;";
        vDateToWhsePlan = "&nbsp;";
        vComment2 = "&nbsp;";
        vDateShipPlan = "&nbsp;";
        vDateShipFact = "&nbsp;";
        vTypeShip = "&nbsp;";
        vTravelTimePlan = "&nbsp;";
        vDateDelivery = "&nbsp;";
        vDateDeliveryFact = "&nbsp;";
        vDateKabinetReady = "&nbsp;";
        vDateMontagStart = "&nbsp;";
        vDateMontagEnd = "&nbsp;";
        vComment5 = "&nbsp;";
        vNumbProject = "&nbsp;";
        vCostMontage = "&nbsp;";
        vComment3 = "&nbsp;";
        vStat_text = "&nbsp;";
        vStat = "&nbsp;";
        vID = "&nbsp;";
        vCreateDate = "&nbsp;";
        vsn_common = "&nbsp;";
        vItemSL = "&nbsp;";
        vdescr = "&nbsp;";
        vu_m = "&nbsp;";
        vcoi_ser_num = "&nbsp;";
        vcoi_stat = "&nbsp;";
        vqty_ordered = "&nbsp;";
        vqty_shipped = "&nbsp;";
        vJobNum = "&nbsp;";
        vJob = "&nbsp;";
        vSuffix = "&nbsp;";
        vcust = "&nbsp;";
        vcustomer_ship = "&nbsp;";
        vdue_date = "&nbsp;";
        vdate_fact_whse = "&nbsp;";
        vco_num = "&nbsp;";
        vco_line = "&nbsp;";
        vDeficitAPS_rowCount = "&nbsp;";
        vDeficitAPS_CostAll = "&nbsp;";
        vDateShipFrom1C = "&nbsp;";
        vfsi_date = "&nbsp;";
        vprice_all = "&nbsp;";

        vString = "";

        $.each(this, function (kField, vField) {
          if (kField === "Type") {
            vType = vField;
          } else if (kField === "Comment1") {
            vComment1 = vField;
          } else if (kField === "Item") {
            vItem = vField;
          } else if (kField === "OrderFromManager") {
            vOrderFromManager = vField;
          } else if (kField === "ser_num") {
            vser_num = vField;
          } else if (kField === "DateInContract") {
            vDateInContract = vField;
          } else if (kField === "DateInGK") {
            vDateInGK = vField;
          } else if (kField === "DateDesired") {
            vDateDesired = vField;
          } else if (kField === "DateInOKO") {
            vDateInOKO = vField;
          } else if (kField === "DateVrHran") {
            vDateVrHran = vField;
          } else if (kField === "Comment4") {
            vComment4 = vField;
          } else if (kField === "QforImport") {
            vQforImport = vField;
          } else if (kField === "QforRus") {
            vQforRus = vField;
          } else if (kField === "PImport") {
            vPImport = vField;
          } else if (kField === "PRus1") {
            vPRus1 = vField;
          } else if (kField === "PRus2") {
            vPRus2 = vField;
          } else if (kField === "PRus3") {
            vPRus3 = vField;
          } else if (kField === "PRus4") {
            vPRus4 = vField;
          } else if (kField === "DateToWhsePlan") {
            vDateToWhsePlan = vField;
          } else if (kField === "Comment2") {
            vComment2 = vField;
          } else if (kField === "DateShipPlan") {
            vDateShipPlan = vField;
          } else if (kField === "DateShipFact") {
            vDateShipFact = vField;
          } else if (kField === "TypeShip") {
            vTypeShip = vField;
          } else if (kField === "TravelTimePlan") {
            vTravelTimePlan = vField;
          } else if (kField === "DateDelivery") {
            vDateDelivery = vField;
          } else if (kField === "DateDeliveryFact") {
            vDateDeliveryFact = vField;
          } else if (kField === "DateKabinetReady") {// && vField !== null && vField !== "") {
            vDateKabinetReady = vField; //zKdDateFormat(new Date(parseInt(vField.substr(6))));
          } else if (kField === "DateMontagStart") {
            vDateMontagStart = vField;
          } else if (kField === "DateMontagEnd") {// && vField !== null && vField !== "") {
            vDateMontagEnd = vField; //zKdDateFormat(new Date(parseInt(vField.substr(6))));
          } else if (kField === "Comment5") {
            vComment5 = vField;
          } else if (kField === "NumbProject") {
            vNumbProject = vField;
          } else if (kField === "CostMontage" && vField !== null) {
            vCostMontage = vField;
          } else if (kField === "Comment3") {
            vComment3 = vField;
          } else if (kField === "Stat_text") {
            vStat_text = vField;
          } else if (kField === "Stat") {
            vStat = vField;
          } else if (kField === "ID" && vField !== null) {
            vID = vField;
          } else if (kField === "CreateDate" && vField !== null && vField !== "") {
            vCreateDate = zKdDateFormat(new Date(parseInt(vField.substr(6))));
          } else if (kField === "sn_common") {
            vsn_common = vField;
          } else if (kField === "ItemSL") {
            vItemSL = vField;
          } else if (kField === "descr") {
            vdescr = vField;
          } else if (kField === "u_m") {
            vu_m = vField;
          } else if (kField === "coi_ser_num") {
            vcoi_ser_num = vField;
          } else if (kField === "coi_stat") {
            vcoi_stat = vField;
          } else if (kField === "qty_ordered" && vField !== null) {
            vqty_ordered = vField;
          } else if (kField === "qty_shipped" && vField !== null) {
            vqty_shipped = vField;
          } else if (kField === "JobNum") {
            vJobNum = vField;
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
          } else if (kField === "DeficitAPS_rowCount" && vField !== null) {
            vDeficitAPS_rowCount = vField;
          } else if (kField === "DeficitAPS_CostAll" && vField !== null) {
            vDeficitAPS_CostAll = vField;
          } else if (kField === "DateShipFrom1C" && vField !== null && vField !== "") {
            vDateShipFrom1C = zKdDateFormat(new Date(parseInt(vField.substr(6))));
          } else if (kField === "fsi_date") {
            vfsi_date = vField;
          } else if (kField === "price_all" && vField !== null) {
            vprice_all = vField;
          }

        });

        //vEquivalentPush_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight
        //vVersionAdvance_Grant = (vAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight

        //vString += "<td class=itcolct><a href='#' " +
        //    "data-ser_num=\"" + vser_num + "\" data-ID=" + vID + " " +
        //    "title='" + (vID === "&nbsp;" ? "Нажмите, чтобы создать" : "Нажмите, чтобы изменить") + "' " +
        //    "class='" + (vID === "&nbsp;" ? "aImplPlanCreate" : "aImplPlanUpdate") + "'>" +
        //    vOrderFromManager + "</a></td>";
        //vString += "<td class=itcol>" + vOrderFromManager + "</td>";

        vString += "<td class=itcol>" + vType + "</td>";
        vString += "<td class=itcol>" + vComment1 + "</td>";
        vString += "<td class=itcol>" + vItem + "</td>";
        vString += "<td " +
            "data-SN=\"" + vser_num + "\" data-ID=" + vID + " " +
            "class='" + (vID === "&nbsp;" ? "aImplPlanCreate" : "aImplPlanUpdate") + "'>" +
            vOrderFromManager + "</td>";
        vString += "<td class=itcol>" + vJobNum + "</td>";
        vString += "<td class=itcol>" + vsn_common + "</td>";

        vString += "<td class=td_commers>" + vDateInContract + "</td>";
        vString += "<td class=td_commers>" + vDateInGK + "</td>";
        vString += "<td class=td_commers>" + vDateDesired + "</td>";
        vString += "<td class=td_commers>" + vDateInOKO + "</td>";
        vString += "<td class=td_commers>" + vDateVrHran + "</td>";
        vString += "<td class=td_commers>" + vComment4 + "</td>";

        vString += "<td class=td_supply>" + vQforImport + "</td>";
        vString += "<td class=td_supply>" + vQforRus + "</td>";
        vString += "<td class=td_supply>" + vPImport + "</td>";
        vString += "<td class=td_supply>" + vPRus1 + "</td>";
        vString += "<td class=td_supply>" + vPRus2 + "</td>";
        vString += "<td class=td_supply>" + vPRus3 + "</td>";
        vString += "<td class=td_supply>" + vPRus4 + "</td>";

        vString += "<td class=td_defAPS>" + vDeficitAPS_rowCount + "</td>";
        vString += "<td class=td_defAPS>" + vDeficitAPS_CostAll + "</td>";
        vString += "<td class=td_defAPS><br/></td>";

        vString += "<td class=td_work>" + vDateToWhsePlan + "</td>";
        vString += "<td class=td_work>" + vdate_fact_whse + "</td>";
        vString += "<td class=td_work>" + vComment2 + "</td>";
        vString += "<td class=td_work>" + vDateShipPlan + "</td>";

        vString += "<td class=td_trans>" + vDateShipFact + "</td>";
        vString += "<td class=td_trans>" + vTypeShip + "</td>";
        vString += "<td class=td_trans>" + vTravelTimePlan + "</td>";
        vString += "<td class=td_trans>" + vDateDelivery + "</td>";
        vString += "<td class=td_trans>" + vDateDeliveryFact + "</td>";

        vString += "<td class=td_service>" + vDateKabinetReady + "</td>";
        vString += "<td class=td_service>" + vDateMontagStart + "</td>";
        vString += "<td class=td_service>" + vDateMontagEnd + "</td>";
        vString += "<td class=td_service>" + vComment5 + "</td>";

        vString += "<td class=itcol>" + vNumbProject + "</td>";
        vString += "<td class=itcol>" + vCostMontage + "</td>";
        vString += "<td class=itcol>" + vComment3 + "</td>";
        vString += "<td class=itcol>" + vStat_text + "</td>";
        vString += "<td class=itcol>" + vID + "</td>";
        vString += "<td class=itcol>" + vCreateDate + "</td>";

        vString += "<td class=td_sl>" + vco_num + "</td>";
        vString += "<td class=td_sl>" + vco_line + "</td>";
        vString += "<td class=td_sl>" + vItemSL + "</td>";
        vString += "<td class=td_sl>" + vdescr + "</td>";
        vString += "<td class=td_sl>" + vqty_ordered + "</td>";
        vString += "<td class=td_sl>" + vqty_shipped + "</td>";
        vString += "<td class=td_sl>" + vu_m + "</td>";
        vString += "<td class=td_sl>" + vcust + "</td>";
        vString += "<td class=td_sl>" + vcustomer_ship + "</td>";
        vString += "<td class=td_sl>" + vprice_all + "</td>";
        vString += "<td class=td_sl>" + vdue_date + "</td>";
        vString += "<td class=td_sl>" + vDateShipFrom1C + "</td>";
        vString += "<td class=td_sl>" + vfsi_date + "</td>";

        $("[id*=tableImplPlan]").append("<tr>" + vString + "</tr>");

      });
    }
    else {
      $("[id*=tableImplPlan]").append("<tr><td colspan=9 class=itcolct>Нет данных, удовлетворяющих условию фильтрации.</td></tr>");
    }


  } catch (e) {
    alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
  } finally {
    $.unblockUI();
  }
}

function handleAjaxErrorFunction(jqXHR, textStatus, errorThrown) {
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
}