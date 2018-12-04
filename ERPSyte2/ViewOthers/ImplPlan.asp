<!DOCTYPE html>
<html>
<head>
  <title>План по реализации</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!--#include file="../include/ConnectERPDBAnonym.inc"-->
  <!--#include file="ImplPlan.inc"-->
  <link href="../Content/themes/base/jquery-ui.css" rel="stylesheet" />
  <script src="../Scripts/jquery-1.6.4.min.js"></script>
  <script src="../Scripts/jquery-ui-1.10.4.min.js"></script>
  <script src="../Scripts/jquery.blockUI.min.js"></script>
  <script src="../Scripts/DatePickerReady.js"></script>
  <script src="../Scripts/json2.js"></script>
  <link rel="stylesheet" type="text/css" href="ImplPlan.css">
  <style>
    /*input[type=text]*/
    .input-find { 
      width: 100%;
      background-color: InfoBackground;
      box-sizing: border-box;
    }
    .button-top, .button-filter-apply, .button-filter-clear {
      display: block; 
      position: fixed; 
      height: 26px; 
      padding: 12px 10px 2px; 
      font-size: 16px; 
      opacity: 0.7; 
      background: #ddd; 
      -webkit-border-radius: 15px; 
      -moz-border-radius: 15px; 
      border-radius: 15px;
    }
    .button-top {
      bottom: 30px; 
      right: 30px; 
      width: 64px; 
    }
    .button-filter-apply {
      bottom: 30px; 
      right: 298px; 
      width: 96px; 
    }
    .button-filter-clear {
      bottom: 30px; 
      right: 124px; 
      width: 144px; 
    }
    .ui-autocomplete-term { 
      font-weight: bold; 
      color: blue; 
    }
  </style>
  <script type="text/javascript" src="ImplPlan.js"></script>
  <script type="text/javascript" src="ImplPlan_freezesHeaders.js"></script>
  <script type="text/javascript" src="ImplPlan_filterColumn.js"></script>
  <script>
  </script>
  <%
	pname="ImplPlan"

  %>
</head>
<body>
  <div style="align-content:center">
    <%
  ' входные параметры '''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  prm_ser_num = "-all"
  prm_ID = 0
  prm_Login = Session("userLogin")
  prm_filter = ""
  ' /входные параметры '''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 

  
  ' права '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  fd_returnValue = 16
  fd_Infobar = ""
  fd_canCreateOrder = false ' может Создать новый Основание (заказ)
  fd_canChangeOrder = false ' доступна кнопка сохранить

  set fd_cmd = CreateObject("ADODB.Command")
  with fd_cmd
    .ActiveConnection = erp_ConnectDB
    .CommandType = 4 'adCmdStoredProc
    .CommandText = "zKdx_IP_FieldsList"
                       'CreateParameter(Name, Type, Direction, Size, Value)                   
    .Parameters.Append .CreateParameter("@returnValue", 3, 4, 0, NULL) 'adInteger=3 'adParamReturnValue=4
    .Parameters.Append .CreateParameter("@Login", 202, 1, 128, prm_Login) 'AdVarWChar=202 'adParamInput=1	nvarchar(128) = null
    .Parameters.Append .CreateParameter("@Infobar", 202, 2, 2800, NULL) 'AdVarWChar=202 'adParamOutput=2	nvarchar(2800) = null output
    .Parameters.Append .CreateParameter("@canCreateOrder", 11, 2, 0, NULL) 'adBoolean=11 'adParamOutput=2	 bit = null output
    .Parameters.Append .CreateParameter("@canChangeOrder", 11, 2, 0, NULL) 'adBoolean=11 'adParamOutput=2	 bit = null output

    set fd_RS = .Execute

    if not IsNull(.Parameters(0).Value) then 
      fd_returnValue = CInt(.Parameters(0).Value)
    end if 

    if not IsNull(.Parameters(2).Value) then 
      fd_Infobar = CStr(.Parameters(2).Value) 
    end if 

    if not IsNull(.Parameters(3).Value) then 
      fd_canCreateOrder = CBool(.Parameters(3).Value) 
    end if 

    if not IsNull(.Parameters(4).Value) then 
      fd_canChangeOrder = CBool(.Parameters(4).Value) 
    end if 
  end with
    
  ' права просмотра колонок стоимостей
  fd_showCostContract = false
  fd_showCostMontage = false
  fd_showprice_all = false

  if not IsNull(fd_RS) and fd_RS.State = 1 then 'adStateOpen
    
    do while not fd_RS.Eof
      fd_Name = fd_RS("Name")
    
      if fd_Name = "CostContract" then
        fd_showCostContract = true
      elseif fd_Name = "CostMontage" then
        fd_showCostMontage = true
      elseif fd_Name = "price_all" then
        fd_showprice_all = true
      end if

      fd_RS.MoveNext
    loop

    fd_RS.Close
  end if

  set fd_RS = nothing
  set fd_cmd = nothing
  ' /права '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 


  if fd_returnValue = 0 then

    prm_returnValue = 16
    prm_Infobar = ""

    set cmd = CreateObject("ADODB.Command")
    with cmd
      .ActiveConnection = erp_ConnectDB
      .CommandType = 4 'adCmdStoredProc
      .CommandText = "zKdx_IP_Show"
                         'CreateParameter(Name, Type, Direction, Size, Value)                   
      .Parameters.Append .CreateParameter("@returnValue", 3, 4, 0, NULL) 'adInteger=3 'adParamReturnValue=4
      .Parameters.Append .CreateParameter("@ser_num", 202, 1, 30, prm_ser_num) 'AdVarWChar=202 'adParamInput=1	nvarchar(30) = null
      .Parameters.Append .CreateParameter("@ID", 3, 1, 0, prm_ID) 'adInteger=3 'adParamInput=1	int = null
      .Parameters.Append .CreateParameter("@Login", 202, 1, 128, prm_Login) 'AdVarWChar=202 'adParamInput=1	nvarchar(128) = null
      .Parameters.Append .CreateParameter("@Infobar", 202, 2, 2800, NULL) 'AdVarWChar=202 'adParamOutput=2	nvarchar(2800) = null output
      .Parameters.Append .CreateParameter("@filter", 202, 1, 4000, prm_filter) 'AdVarWChar=202 'adParamInput=1 nvarchar(4000) = null 

      set RS = .Execute

      if not IsNull(.Parameters(0).Value) then 
        prm_returnValue = CInt(.Parameters(0).Value)
      end if 

      if not IsNull(.Parameters(4).Value) then 
        prm_Infobar = CStr(.Parameters(4).Value) 
      end if 
    end with 

    if prm_returnValue = 0 then
      if not RS.Eof then
    %>
    <table>
      <tr>
        <td style="text-align: left; background-color: #dddddd; padding: 10px;">
          <h2>План по реализации</h2>
          <p>для просмотра/редактирования конкретного заказа, откройте его, выполнив переход по ссылке в колонке "Основание (заказ)"</p>
        </td>
      </tr>
      <tr>
        <td>
          <div>
            <%
      if fd_canCreateOrder then
        Response.Write "<div style=""text-align: left; padding: 10px;""><a href=""ImplPlanItem.asp"">Создать новый Основание (заказ)</a></div>"
        Response.Write "</td>"
        Response.Write "</tr>"
        Response.Write "<tr>"
        Response.Write "<td>"
      end if
            %>
            <a href="#filter" class="button-filter-apply" onclick="filterApply();return!1;">Фильтровать</a>
            <a href="#clear" class="button-filter-clear" onclick="filterClear();return!1;">Сбросить фильтр</a>
            <table class="tableSection" id="tableImplPlan">
              <thead class="top">
                <tr id="HeaderRow1">
                  <th rowspan="2">СерНомер План</th>
                  <th rowspan="2">Основание (заказ)</th>
                  <th rowspan="2" id="th_Type">Тип изделия</th>
                  <th rowspan="2">Наименование</th>
                  <th rowspan="2">Код изделия</th>
                  <th rowspan="2">ЗНП</th>

                  <th colspan="6" class="td_commers" style="text-align: center; font-size: 14px; font-weight: bold;">Коммерческий департамент</th>
                  <!--colspan=6 Коммерческий департамент-->
                  <th colspan="7" class="td_supply" style="text-align: center; font-size: 14px; font-weight: bold;">Снабжение</th>
                  <!--colspan=7 Снабжение-->
                  <th colspan="3" class="td_defAPS" style="text-align: center; font-size: 14px; font-weight: bold;">Дефицит по ГП из АПС отчета</th>
                  <!--colspan=3 Дефицит по ГП из АПС отчета-->
                  <th colspan="4" class="td_work" style="text-align: center; font-size: 14px; font-weight: bold;">Производство, склад</th>
                  <!--colspan=4 Производство, склад-->
                  <th colspan="5" class="td_trans" style="text-align: center; font-size: 14px; font-weight: bold;">Транспортный отдел</th>
                  <!--colspan=5 Транспортный отдел-->
                  <th colspan="4" class="td_service" style="text-align: center; font-size: 14px; font-weight: bold;">Служба сервиса</th>
                  <!--colspan=4 Служба сервиса-->

                  <th rowspan="2">Заказчик/ЛПУ</th>
                  <th rowspan="2">Номер проекта</th>
                  <th rowspan="2">Сумма договора с контрагентом</th>
                  <th rowspan="2">Стоимость монтажа</th>
                  <th rowspan="2">Примечание</th>

                  <th rowspan="2">Статус</th>
                  <th rowspan="2">ID</th>
                  <th rowspan="2">Дата создания</th>

                  <th colspan="13" class="td_sl" style="text-align: center; font-size: 14px; font-weight: bold;">Заказ клиента</th>
                  <!--colspan=13 Заказ клиента-->
                </tr>
                <tr id="HeaderRow2">
                  <!--colspan=6 Коммерческий департамент-->
                  <th class="td_commers">Срок по договору</th>
                  <th class="td_commers">Срок по ГК</th>
                  <th class="td_commers">Желаемый срок исполнения заказа</th>
                  <th class="td_commers">срок по проекту в ОКО</th>
                  <th class="td_commers">ВрХранение</th>
                  <th class="td_commers">Примечание коммерч</th>

                  <!--colspan=7 Снабжение-->
                  <th class="td_supply">Очередность для импорта</th>
                  <th class="td_supply">Очередность для закупок локально</th>
                  <th class="td_supply">Импорт</th>
                  <th class="td_supply">Отечественные1</th>
                  <th class="td_supply">Отечественные2</th>
                  <th class="td_supply">Отечественные3</th>
                  <th class="td_supply">Отечественные4</th>

                  <!--colspan=3 Дефицит по ГП из АПС отчета-->
                  <th class="td_defAPS">Строк в потребности</th>
                  <th class="td_defAPS">Общая стоимость</th>
                  <th class="td_defAPS">Показать в Excel</th>

                  <!--colspan=4 Производство, склад-->
                  <th class="td_work">Сдача на склад План</th>
                  <th class="td_work">Сдача на склад Факт</th>
                  <th class="td_work">Примечание</th>
                  <th class="td_work">Дата отгрузки План</th>

                  <!--colspan=5 Транспортный отдел-->
                  <th class="td_trans">Дата отгрузки Факт</th>
                  <th class="td_trans">Тип отгрузки</th>
                  <th class="td_trans">Время в пути</th>
                  <th class="td_trans">Доставка до заказчика План</th>
                  <th class="td_trans">Доставка до заказчика Факт</th>

                  <!--colspan=4 Служба сервиса-->
                  <th class="td_service">Готовность кабинета</th>
                  <th class="td_service">Начало монтажа</th>
                  <th class="td_service">Окончание монтажа</th>
                  <th class="td_service">Примечание от СС</th>

                  <!--colspan=13 Заказ клиента-->
                  <th class="td_sl">ЗК</th>
                  <th class="td_sl">Строка ЗК</th>
                  <th class="td_sl">Изделие в ЗК</th>
                  <th class="td_sl">Наименование в ЗК</th>
                  <th class="td_sl">Заказано</th>
                  <th class="td_sl">Отгружено</th>
                  <th class="td_sl">Е/И</th>
                  <th class="td_sl">Заказчик</th>
                  <th class="td_sl">Получатель</th>
                  <th class="td_sl">Стоимость изделия</th>
                  <th class="td_sl">План.дата</th>
                  <th class="td_sl">Дата отгрузки в 1С</th>
                  <th class="td_sl">Создание ФСИ</th>
                </tr>
                <tr id="HeaderRow3">
                  <th>
                    <input type="text" class="input-find" data-field_name="ser_num" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="OrderFromManager" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Type" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Comment1" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Item" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="JobNum" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateInContract" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateInGK" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateDesired" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateInOKO" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateVrHran" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Comment4" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="QforImport" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="QforRus" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="PImport" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="PRus1" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="PRus2" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="PRus3" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="PRus4" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DeficitAPS_rowCount" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DeficitAPS_CostAll" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DeficitAPS" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateToWhsePlan" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="date_fact_whse" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Comment2" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateShipPlan" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateShipFact" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="TypeShip" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="TravelTimePlan" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateDelivery" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateDeliveryFact" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateKabinetReady" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateMontagStart" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateMontagEnd" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Comment5" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="LPU" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="NumbProject" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="CostContract" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="CostMontage" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Comment3" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="Stat_text" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="ID" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="CreateDate" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="co_num" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="co_line" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="ItemSL" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="descr" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="qty_ordered" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="qty_shipped" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="u_m" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="cust" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="customer_ship" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="price_all" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="due_date" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="DateShipFrom1C" /></th>
                  <th>
                    <input type="text" class="input-find" data-field_name="fsi_date" /></th>
                </tr>
              </thead>
              <tbody id="tableBody">
                <%
  Do While not RS.Eof
    ' данные '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    fld_Type = RS("Type") '-- Тип изделия
    fld_Comment1 = RS("Comment1") '-- Наименование
    fld_Item = RS("Item") '-- Код изделия
    fld_OrderFromManager = RS("OrderFromManager") '-- Основание (заказ)
    fld_ser_num = RS("ser_num") '-- СерНомер План
    fld_DateInContract = RS("DateInContract") '-- Срок по договору
    fld_DateInGK = RS("DateInGK") '--Срок по ГК
    fld_DateDesired = RS("DateDesired") '-- Желаемый срок исполнения заказа
    fld_DateInOKO = RS("DateInOKO") '--срок по проекту в ОКО
    fld_DateVrHran = RS("DateVrHran") '--ВрХранение
    fld_Comment4 = RS("Comment4") '--Примечание коммерч
    fld_QforImport = RS("QforImport") '--Очередность для импорта
    fld_QforRus = RS("QforRus") '--Очередность для закупок локально
    fld_PImport = RS("PImport") '-- Импорт 
    fld_PRus1 = RS("PRus1") '-- Отечественные1
    fld_PRus2 = RS("PRus2") '-- Отечественные2
    fld_PRus3 = RS("PRus3") '-- Отечественные3
    fld_PRus4 = RS("PRus4") '-- Отечественные4
    fld_DateToWhsePlan = RS("DateToWhsePlan") '-- Сдача на склад План
    fld_Comment2 = RS("Comment2") '-- Примечание2
    fld_DateShipPlan = RS("DateShipPlan") '-- Дата отгрузки План
    fld_DateShipFact = RS("DateShipFact") '--Дата отгрузки Факт
    fld_TypeShip = RS("TypeShip") '--Тип отгрузки
    fld_TravelTimePlan = RS("TravelTimePlan") '--Время в пути
    fld_DateDelivery = RS("DateDelivery") '--Доставка до заказчика План
    fld_DateDeliveryFact = RS("DateDeliveryFact") '--Доставка до заказчика Факт
    fld_DateKabinetReady = RS("DateKabinetReady") '-- Готовность кабинета
    fld_DateMontagStart = RS("DateMontagStart") '--Начало монтажа
    fld_DateMontagEnd = RS("DateMontagEnd") '-- Окончание монтажа
    fld_Comment5 = RS("Comment5") '--Примечание от СС
    fld_LPU = RS("LPU") '--Заказчик/ЛПУ
    fld_NumbProject = RS("NumbProject") '-- Номер проекта
    fld_CostContract = RS("CostContract") '--Сумма договора с контрагентом
    fld_CostMontage = RS("CostMontage") '-- Стоимость монтажа
    fld_Comment3 = RS("Comment3") '-- Примечание3
    fld_Stat_text = RS("Stat_text") '-- Статус
    fld_Stat = RS("Stat") '--техническая колонка--
    fld_ID = RS("ID") '-- ID
    fld_CreateDate = RS("CreateDate") '-- Дата создания
    fld_RowPointer = RS("RowPointer") '--техническая колонка--
    fld_stored_ser_num = RS("stored_ser_num") '--техническая колонка--

    fld_ItemSL = RS("ItemSL") '-- Изделие в ЗК
    fld_descr = RS("descr") '-- Наименование в ЗК
    fld_u_m = RS("u_m") '-- Е/И
    fld_coi_ser_num = RS("coi_ser_num") '--техническая колонка--
    fld_coi_stat = RS("coi_stat") '--техническая колонка--
    fld_qty_ordered = RS("qty_ordered") '-- Заказано
    fld_qty_shipped = RS("qty_shipped") '-- Отгружено
    fld_JobNum = RS("JobNum") '-- ЗНП
    fld_Job = RS("Job") '--техническая колонка--
    fld_Suffix = RS("Suffix") '--техническая колонка--
    fld_cust = RS("cust") '-- Заказчик
    fld_customer_ship = RS("customer_ship") '-- Получатель
    fld_due_date = RS("due_date") '-- План.дата
    fld_date_fact_whse = RS("date_fact_whse") '-- Сдача на склад Факт
    fld_co_num = RS("co_num") '-- ЗК
    fld_co_line = RS("co_line") '-- Строка ЗК
    fld_DeficitAPS_rowCount = RS("DeficitAPS_rowCount") '-- Дефицит по ГП из АПС отчета -- Строк в потребности
    fld_DeficitAPS_CostAll = RS("DeficitAPS_CostAll") '-- Дефицит по ГП из АПС отчета -- Общая стоимость
    fld_DateShipFrom1C = RS("DateShipFrom1C") '-- Дата отгрузки в 1С
    fld_fsi_date = RS("fsi_date") '-- Создание ФСИ
    fld_price_all = RS("price_all") '-- Стоимость изделия
    ' /данные '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


    ' округление '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    fld_CostContract = valRound(fld_CostContract)
    fld_CostMontage = valRound(fld_CostMontage) 
    fld_DeficitAPS_CostAll = valRound(fld_DeficitAPS_CostAll) 
    fld_price_all = valRound(fld_price_all) 
    ' /округление '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


    ' вывод '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    response.write "<tr>"&vbCrLf
    response.write "<td data-field_name=""ser_num"">"&valToHTML(fld_ser_num)&"</td>"&vbCrLf '-- СерНомер План

    response.write "<td>"
    if fld_OrderFromManager <> "" then
      response.write "<a href=""ImplPlanItem.asp?SN="&fld_ser_num&"&ID="&fld_ID&""">"&fld_OrderFromManager&"</a>" '-- Основание (заказ)
    elseif fd_canCreateOrder then
      response.write "<a href=""ImplPlanItem.asp?SN="&fld_ser_num&"&ID="&fld_ID&""">создать</a>" '-- Основание (заказ)
    else
      response.write "<br />"
    end if
    response.write "</td>"&vbCrLf

    response.write "<td "&valToAnchor(fld_ID)&">"&valToHTML(fld_Type)&"</td>"&vbCrLf '-- Тип изделия
    response.write "<td>"&valToHTML(fld_Comment1)&"</td>"&vbCrLf '-- Наименование
    response.write "<td>"&valToHTML(fld_Item)&"</td>"&vbCrLf '-- Код изделия
    response.write "<td>"&valToHTML(fld_JobNum)&"</td>"&vbCrLf '-- ЗНП

    response.write "<td class=td_commers>"&valToHTML(fld_DateInContract)&"</td>"&vbCrLf '-- Срок по договору
    response.write "<td class=td_commers>"&valToHTML(fld_DateInGK)&"</td>"&vbCrLf '-- Срок по ГК
    response.write "<td class=td_commers>"&valToHTML(fld_DateDesired)&"</td>"&vbCrLf '-- Желаемый срок исполнения заказа
    response.write "<td class=td_commers>"&valToHTML(fld_DateInOKO)&"</td>"&vbCrLf '-- срок по проекту в ОКО
    response.write "<td class=td_commers>"&valToHTML(fld_DateVrHran)&"</td>"&vbCrLf '-- ВрХранение
    response.write "<td class=td_commers>"&valToHTML(fld_Comment4)&"</td>"&vbCrLf '-- Примечание коммерч

    response.write "<td class=td_supply>"&valToHTML(fld_QforImport)&"</td>"&vbCrLf '-- Очередность для импорта
    response.write "<td class=td_supply>"&valToHTML(fld_QforRus)&"</td>"&vbCrLf '-- Очередность для закупок локально
    response.write "<td class=td_supply>"&valToHTML(fld_PImport)&"</td>"&vbCrLf '-- Импорт 
    response.write "<td class=td_supply>"&valToHTML(fld_PRus1)&"</td>"&vbCrLf '-- Отечественные1
    response.write "<td class=td_supply>"&valToHTML(fld_PRus2)&"</td>"&vbCrLf '-- Отечественные2
    response.write "<td class=td_supply>"&valToHTML(fld_PRus3)&"</td>"&vbCrLf '-- Отечественные3
    response.write "<td class=td_supply>"&valToHTML(fld_PRus4)&"</td>"&vbCrLf '-- Отечественные4

    response.write "<td class=td_defAPS>"&valToHTML(fld_DeficitAPS_rowCount)&"</td>"&vbCrLf '-- Дефицит по ГП из АПС отчета -- Строк в потребности
    response.write "<td class=td_defAPS style=""white-space: nowrap"">"&valToHTML(fld_DeficitAPS_CostAll)&"</td>"&vbCrLf '-- Дефицит по ГП из АПС отчета -- Общая стоимость
    if IsNull(fld_DeficitAPS_rowCount) then
      response.write "<td class=td_defAPS><br /></td>"&vbCrLf
    else
      response.write "<td class=td_defAPS><input type=button onClick='deficitFromAPS_XLS(this)' data-SN='"&fld_ser_num&"' value='Показать'></td>"&vbCrLf
    end if

    response.write "<td class=td_work>"&valToHTML(fld_DateToWhsePlan)&"</td>"&vbCrLf '-- Сдача на склад План
    response.write "<td class=td_work>"&valToHTML(fld_date_fact_whse)&"</td>"&vbCrLf '-- Сдача на склад Факт
    response.write "<td class=td_work>"&valToHTML(fld_Comment2)&"</td>"&vbCrLf '-- Примечание2
    response.write "<td class=td_work>"&valToHTML(fld_DateShipPlan)&"</td>"&vbCrLf '-- Дата отгрузки План

    response.write "<td class=td_trans>"&valToHTML(fld_DateShipFact)&"</td>"&vbCrLf '-- Дата отгрузки Факт
    response.write "<td class=td_trans>"&valToHTML(fld_TypeShip)&"</td>"&vbCrLf '-- Тип отгрузки
    response.write "<td class=td_trans>"&valToHTML(fld_TravelTimePlan)&"</td>"&vbCrLf '-- Время в пути
    response.write "<td class=td_trans>"&valToHTML(fld_DateDelivery)&"</td>"&vbCrLf '-- Доставка до заказчика План
    response.write "<td class=td_trans>"&valToHTML(fld_DateDeliveryFact)&"</td>"&vbCrLf '-- Доставка до заказчика Факт

    response.write "<td class=td_service>"&valToHTML(fld_DateKabinetReady)&"</td>"&vbCrLf '-- Готовность кабинета
    response.write "<td class=td_service>"&valToHTML(fld_DateMontagStart)&"</td>"&vbCrLf '-- Начало монтажа
    response.write "<td class=td_service>"&valToHTML(fld_DateMontagEnd)&"</td>"&vbCrLf '-- Окончание монтажа
    response.write "<td class=td_service>"&valToHTML(fld_Comment5)&"</td>"&vbCrLf '-- Примечание от СС

    response.write "<td>"&valToHTML(fld_LPU)&"</td>"&vbCrLf '--Заказчик/ЛПУ
    response.write "<td>"&valToHTML(fld_NumbProject)&"</td>"&vbCrLf '-- Номер проекта
    if fd_showCostContract then
    response.write "<td>"&valToHTML(fld_CostContract)&"</td>"&vbCrLf '--Сумма договора с контрагентом
    else
    response.write "<td><br /></td>"&vbCrLf
    end if
    if fd_showCostMontage then
    response.write "<td>"&valToHTML(fld_CostMontage)&"</td>"&vbCrLf '-- Стоимость монтажа
    else
    response.write "<td><br /></td>"&vbCrLf
    end if
    response.write "<td>"&valToHTML(fld_Comment3)&"</td>"&vbCrLf '-- Примечание3

    response.write "<td>"&valToHTML(fld_Stat_text)&"</td>"&vbCrLf '-- Статус
    response.write "<td>"&valToHTML(fld_ID)&"</td>"&vbCrLf '-- ID
    response.write "<td>"&valToHTML(fld_CreateDate)&"</td>"&vbCrLf '-- Дата создания

    response.write "<td class=td_sl>"&valToHTML(fld_co_num)&"</td>"&vbCrLf '-- ЗК
    response.write "<td class=td_sl>"&valToHTML(fld_co_line)&"</td>"&vbCrLf '-- Строка ЗК
    response.write "<td class=td_sl>"&valToHTML(fld_ItemSL)&"</td>"&vbCrLf '-- Изделие в ЗК
    response.write "<td class=td_sl>"&valToHTML(fld_descr)&"</td>"&vbCrLf '-- Наименование в ЗК
    response.write "<td class=td_sl>"&valToHTML(fld_qty_ordered)&"</td>"&vbCrLf '-- Заказано
    response.write "<td class=td_sl>"&valToHTML(fld_qty_shipped)&"</td>"&vbCrLf '-- Отгружено
    response.write "<td class=td_sl>"&valToHTML(fld_u_m)&"</td>"&vbCrLf '-- Е/И
    response.write "<td class=td_sl>"&valToHTML(fld_cust)&"</td>"&vbCrLf '-- Заказчик
    response.write "<td class=td_sl>"&valToHTML(fld_customer_ship)&"</td>"&vbCrLf '-- Получатель
    if fd_showprice_all then
    response.write "<td class=td_sl>"&valToHTML(fld_price_all)&"</td>"&vbCrLf '-- Стоимость изделия
    else
    response.write "<td class=td_sl><br /></td>"&vbCrLf
    end if
    response.write "<td class=td_sl>"&valToHTML(fld_due_date)&"</td>"&vbCrLf '-- План.дата
    response.write "<td class=td_sl>"&valToHTML(fld_DateShipFrom1C)&"</td>"&vbCrLf '-- Дата отгрузки в 1С
    response.write "<td class=td_sl>"&valToHTML(fld_fsi_date)&"</td>"&vbCrLf '-- Создание ФСИ
    response.write "</tr>"&vbCrLf
    ' /вывод '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    RS.MoveNext
  Loop
                %>
              </tbody>
            </table>
            <a href="#top" class="button-top" onclick="scrollUp();return!1;">Наверх</a>
            <%
      if fd_canCreateOrder then
        Response.Write "</td>"
        Response.Write "</tr>"
        Response.Write "<tr>"
        Response.Write "<td>"
        Response.Write "<div style=""text-align: left; padding: 10px;""><a href=""ImplPlanItem.asp"">Создать новый Основание (заказ)</a></div>"
      end if
            %>
          </div>
        </td>
      </tr>
      <tr>
        <td style="text-align: left; padding: 10px; background-color: InfoBackground;">
          <div>
            <h4>Внимание</h4>
            Выгрузка в Excel работает <b>только</b> из браузера Microsoft Internet Explorer, версии не ниже 10.
          </div>
        </td>
      </tr>
    </table>
    <%
      else
        showInfo "Ошибка", "Нет данных, удовлетворяющих условиям фильтрации"
      end if
    else
      showError prm_returnValue, prm_Infobar
    end if  

    if not IsNull(RS) and RS.State = 1 then 'adStateOpen
      RS.Close
    end if

    set RS = nothing
    set cmd = nothing
  else
    showError fd_returnValue, fd_Infobar
  end if  

    %>
  </div>
</body>
</html>
