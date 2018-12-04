<!DOCTYPE html>
<html>
<head>
  <title>План по реализации</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <!--#include file="../include/ConnectERPDBAnonym.inc"-->
  <!--#include file="ImplPlan.inc"-->
  <link rel="stylesheet" type="text/css" href="ImplPlan.css">
  <script type="text/javascript" src="ImplPlan.js"></script>
  <script type="text/javascript">
    function isNumeric(n) {
      return !isNaN(parseFloat(n)) && isFinite(n);
    }

    function checkSend() {
      var oForm = document.getElementById('frm_ImplPlanItem');
      var oID = document.getElementById('cll_ID');
      var oTemp, strErrors = '';

      // проверка только для новых
      if ((oID) && (oID.value != '') && isNumeric(oID.value)) {
        return true;
      }

      oTemp = document.getElementById('cll_OrderFromManager');
      if (oTemp.value == '') {
        strErrors += '- не указан Основание (заказ)\n';
      }

      oTemp = document.getElementById('cll_Comment1');
      if (oTemp.value == '') {
        strErrors += '- не указан Наименование\n';
      }

      oTemp = document.getElementById('cll_Item');
      if (oTemp.value == '') {
        strErrors += '- не указан Код изделия\n';
      }

      if (strErrors) {
        alert('Ошибка ввода данных:\n' + strErrors);
      } else {
        oForm.submit();
      }

    }
  </script>
  <style type="text/css">
    input[type=text] {
      width: 100%;
      background-color: yellow;
      box-sizing: border-box;
    }
  </style>
  <%

	pname="ImplPlanItem"

  ' входные параметры '''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
	prm_ser_num = Trim(Request.Form("SN"))
	prm_ID = Trim(Request.Form("ID"))
  prm_Login = Session("userLogin")
  prm_returnValue = 0
  fld_RowPointer = ""
	
	if isnull(prm_ser_num) or (prm_ser_num = "") then
	prm_ser_num = Trim(Request.QueryString("SN"))
	prm_ID = Trim(Request.QueryString("ID"))
	end if

	if isnull(prm_ID) or (prm_ID = "") then
	prm_ID = 0
	end if
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
       
  ' права редактирования колонок
  fd_editType = false
  fd_editComment1 = false
  fd_editItem = false
  fd_editOrderFromManager = false
  fd_editser_num = false
  fd_editDateInContract = false
  fd_editDateInGK = false
  fd_editDateDesired = false
  fd_editDateInOKO = false
  fd_editDateVrHran = false
  fd_editComment4 = false
  fd_editQforImport = false
  fd_editQforRus = false
  fd_editPImport = false
  fd_editPRus1 = false
  fd_editPRus2 = false
  fd_editPRus3 = false
  fd_editPRus4 = false
  fd_editDateToWhsePlan = false
  fd_editComment2 = false
  fd_editDateShipPlan = false
  fd_editDateShipFact = false
  fd_editTypeShip = false
  fd_editTravelTimePlan = false
  fd_editDateDelivery = false
  fd_editDateDeliveryFact = false
  fd_editDateKabinetReady = false
  fd_editDateMontagStart = false
  fd_editDateMontagEnd = false
  fd_editComment5 = false
  fd_editLPU = false
  fd_editNumbProject = false
  fd_editCostContract = false
  fd_editCostMontage = false
  fd_editComment3 = false

  ' права просмотра колонок стоимостей
  fd_showCostContract = false
  fd_showCostMontage = false
  fd_showprice_all = false

  if not IsNull(fd_RS) and fd_RS.State = 1 then 'adStateOpen

    do while not fd_RS.Eof
      fd_Name = fd_RS("Name")
      fd_CanEdit = CBool(fd_RS("CanEdit"))
    
      if fd_Name = "Type" then
        fd_editType = fd_CanEdit
      elseif fd_Name = "Comment1" then
        fd_editComment1 = fd_CanEdit
      elseif fd_Name = "Item" then
        fd_editItem = fd_CanEdit
      elseif fd_Name = "OrderFromManager" then
        fd_editOrderFromManager = fd_CanEdit
      elseif fd_Name = "ser_num" then
        fd_editser_num = fd_CanEdit
      elseif fd_Name = "DateInContract" then
        fd_editDateInContract = fd_CanEdit
      elseif fd_Name = "DateInGK" then
        fd_editDateInGK = fd_CanEdit
      elseif fd_Name = "DateDesired" then
        fd_editDateDesired = fd_CanEdit
      elseif fd_Name = "DateInOKO" then
        fd_editDateInOKO = fd_CanEdit
      elseif fd_Name = "DateVrHran" then
        fd_editDateVrHran = fd_CanEdit
      elseif fd_Name = "Comment4" then
        fd_editComment4 = fd_CanEdit
      elseif fd_Name = "QforImport" then
        fd_editQforImport = fd_CanEdit
      elseif fd_Name = "QforRus" then
        fd_editQforRus = fd_CanEdit
      elseif fd_Name = "PImport" then
        fd_editPImport = fd_CanEdit
      elseif fd_Name = "PRus1" then
        fd_editPRus1 = fd_CanEdit
      elseif fd_Name = "PRus2" then
        fd_editPRus2 = fd_CanEdit
      elseif fd_Name = "PRus3" then
        fd_editPRus3 = fd_CanEdit
      elseif fd_Name = "PRus4" then
        fd_editPRus4 = fd_CanEdit
      elseif fd_Name = "DateToWhsePlan" then
        fd_editDateToWhsePlan = fd_CanEdit
      elseif fd_Name = "Comment2" then
        fd_editComment2 = fd_CanEdit
      elseif fd_Name = "DateShipPlan" then
        fd_editDateShipPlan = fd_CanEdit
      elseif fd_Name = "DateShipFact" then
        fd_editDateShipFact = fd_CanEdit
      elseif fd_Name = "TypeShip" then
        fd_editTypeShip = fd_CanEdit
      elseif fd_Name = "TravelTimePlan" then
        fd_editTravelTimePlan = fd_CanEdit
      elseif fd_Name = "DateDelivery" then
        fd_editDateDelivery = fd_CanEdit
      elseif fd_Name = "DateDeliveryFact" then
        fd_editDateDeliveryFact = fd_CanEdit
      elseif fd_Name = "DateKabinetReady" then
        fd_editDateKabinetReady = fd_CanEdit
      elseif fd_Name = "DateMontagStart" then
        fd_editDateMontagStart = fd_CanEdit
      elseif fd_Name = "DateMontagEnd" then
        fd_editDateMontagEnd = fd_CanEdit
      elseif fd_Name = "Comment5" then
        fd_editComment5 = fd_CanEdit
      elseif fd_Name = "LPU" then
        fd_editLPU = fd_CanEdit
      elseif fd_Name = "NumbProject" then
        fd_editNumbProject = fd_CanEdit
      elseif fd_Name = "CostContract" then
        fd_showCostContract = true
        fd_editCostContract = fd_CanEdit
      elseif fd_Name = "CostMontage" then
        fd_showCostMontage = true
        fd_editCostMontage = fd_CanEdit
      elseif fd_Name = "Comment3" then
        fd_editComment3 = fd_CanEdit
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

  %>
</head>
<body bgcolor="#eeeeee">
  <div align="center">
    <%
  if fd_returnValue = 0 then
    if not((prm_ser_num="") and (prm_ID=0)) then

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

        else
          fld_ser_num = prm_ser_num
        end if
      end if

      if not IsNull(RS) and RS.State = 1 then 'adStateOpen
        RS.Close
      end if

      set RS = nothing
      set cmd = nothing
    end if

    if prm_returnValue = 0 then
    %>
    <form id="frm_ImplPlanItem" action="ImplPlanItem_update.asp" method="post">
      <table border="1" width="1024" bgcolor="#ffffff">
        <tr>
          <td style="text-align: center; font-size: 16px; font-weight: bold; background-color: #dddddd;" colspan="2">
            <b>План по реализации</b>
          </td>
        </tr>

        <tr>
          <td style="text-align: left;">СерНомер План</td>
          <td style="text-align: left;">
          <%
            if fd_editser_num then
              Response.Write "<input type=""text"" id=""cll_ser_num"" name=""cll_ser_num"" maxlength=""30"" class=""input_txt"" value="""&fld_ser_num&""" />"
            else
              Response.Write fld_ser_num
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Основание (заказ)<font color="red">*</font></td>
          <td style="text-align: left;">
          <%
            if fd_editOrderFromManager then
              Response.Write "<input type=""text"" id=""cll_OrderFromManager"" name=""cll_OrderFromManager"" maxlength=""40"" class=""input_txt"" value="""&fld_OrderFromManager&""" />"
            else
              Response.Write "<input type=""hidden"" id=""cll_OrderFromManager"" name=""cll_OrderFromManager"" maxlength=""40"" class=""input_txt"" value="""&fld_OrderFromManager&""" />"
              Response.Write fld_OrderFromManager
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left; width: 250px;">Тип изделия</td>
          <td style="text-align: left;">
          <%
            if fd_editType then
              Response.Write "<input type=""text"" id=""cll_Type"" name=""cll_Type"" maxlength=""16"" class=""input_txt"" value="""&fld_Type&""" />"
            else
              Response.Write fld_Type
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Наименование<font color="red">*</font></td>
          <td style="text-align: left;">
          <%
            if fd_editComment1 then
              Response.Write "<input type=""text"" id=""cll_Comment1"" name=""cll_Comment1"" maxlength=""150"" class=""input_txt"" value="""&fld_Comment1&""" />"
            else
              Response.Write "<input type=""hidden"" id=""cll_Comment1"" name=""cll_Comment1"" maxlength=""150"" class=""input_txt"" value="""&fld_Comment1&""" />"
              Response.Write fld_Comment1
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Код изделия<font color="red">*</font></td>
          <td style="text-align: left;">
          <%
            if fd_editItem then
              Response.Write "<input type=""text"" id=""cll_Item"" name=""cll_Item"" maxlength=""30"" class=""input_txt"" value="""&fld_Item&""" />"
            else
              Response.Write "<input type=""hidden"" id=""cll_Item"" name=""cll_Item"" maxlength=""30"" class=""input_txt"" value="""&fld_Item&""" />"
              Response.Write fld_Item
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">ЗНП</td>
          <td style="text-align: left;" id="cll_JobNum"><%=valToHTML(fld_JobNum)%></td>
        </tr>

        <tr>
          <td class="td_commers" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Коммерческий департамент</td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">Срок по договору</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editDateInContract then
              Response.Write "<input type=""text"" id=""cll_DateInContract"" name=""cll_DateInContract"" maxlength=""180"" class=""input_txt"" value="""&fld_DateInContract&""" />"
            else
              Response.Write fld_DateInContract
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">Срок по ГК</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editDateInGK then
              Response.Write "<input type=""text"" id=""cll_DateInGK"" name=""cll_DateInGK"" maxlength=""180"" class=""input_txt"" value="""&fld_DateInGK&""" />"
            else
              Response.Write fld_DateInGK
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">Желаемый срок исполнения заказа</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editDateDesired then
              Response.Write "<input type=""text"" id=""cll_DateDesired"" name=""cll_DateDesired"" maxlength=""180"" class=""input_txt"" value="""&fld_DateDesired&""" />"
            else
              Response.Write fld_DateDesired
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">срок по проекту в ОКО</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editDateInOKO then
              Response.Write "<input type=""text"" id=""cll_DateInOKO"" name=""cll_DateInOKO"" maxlength=""180"" class=""input_txt"" value="""&fld_DateInOKO&""" />"
            else
              Response.Write fld_DateInOKO
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">ВрХранение</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editDateVrHran then
              Response.Write "<input type=""text"" id=""cll_DateVrHran"" name=""cll_DateVrHran"" maxlength=""180"" class=""input_txt"" value="""&fld_DateVrHran&""" />"
            else
              Response.Write fld_DateVrHran
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_commers" style="text-align: left;">Примечание коммерч</td>
          <td class="td_commers" style="text-align: left;">
          <%
            if fd_editComment4 then
              Response.Write "<input type=""text"" id=""cll_Comment4"" name=""cll_Comment4"" maxlength=""400"" class=""input_txt"" value="""&fld_Comment4&""" />"
            else
              Response.Write fld_Comment4
            end if
          %>
          </td>
        </tr>

        <tr>
          <td class="td_supply" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Снабжение</td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Очередность для импорта</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editQforImport then
              Response.Write "<input type=""text"" id=""cll_QforImport"" name=""cll_QforImport"" maxlength=""180"" class=""input_txt"" value="""&fld_QforImport&""" />"
            else
              Response.Write fld_QforImport
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Очередность для закупок локально</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editQforRus then
              Response.Write "<input type=""text"" id=""cll_QforRus"" name=""cll_QforRus"" maxlength=""180"" class=""input_txt"" value="""&fld_QforRus&""" />"
            else
              Response.Write fld_QforRus
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Импорт</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editPImport then
              Response.Write "<input type=""text"" id=""cll_PImport"" name=""cll_PImport"" maxlength=""180"" class=""input_txt"" value="""&fld_PImport&""" />"
            else
              Response.Write fld_PImport
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Отечественные1</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editPRus1 then
              Response.Write "<input type=""text"" id=""cll_PRus1"" name=""cll_PRus1"" maxlength=""180"" class=""input_txt"" value="""&fld_PRus1&""" />"
            else
              Response.Write fld_PRus1
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Отечественные2</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editPRus2 then
              Response.Write "<input type=""text"" id=""cll_PRus2"" name=""cll_PRus2"" maxlength=""180"" class=""input_txt"" value="""&fld_PRus2&""" />"
            else
              Response.Write fld_PRus2
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Отечественные3</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editPRus3 then
              Response.Write "<input type=""text"" id=""cll_PRus3"" name=""cll_PRus3"" maxlength=""180"" class=""input_txt"" value="""&fld_PRus3&""" />"
            else
              Response.Write fld_PRus3
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_supply" style="text-align: left;">Отечественные4</td>
          <td class="td_supply" style="text-align: left;">
          <%
            if fd_editPRus4 then
              Response.Write "<input type=""text"" id=""cll_PRus4"" name=""cll_PRus4"" maxlength=""180"" class=""input_txt"" value="""&fld_PRus4&""" />"
            else
              Response.Write fld_PRus4
            end if
          %>
          </td>
        </tr>

        <tr>
          <td class="td_work" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Производство, склад</td>
        </tr>
        <tr>
          <td class="td_work" style="text-align: left;">Сдача на склад План</td>
          <td class="td_work" style="text-align: left;">
          <%
            if fd_editDateToWhsePlan then
              Response.Write "<input type=""text"" id=""cll_DateToWhsePlan"" name=""cll_DateToWhsePlan"" maxlength=""180"" class=""input_txt"" value="""&fld_DateToWhsePlan&""" />"
            else
              Response.Write fld_DateToWhsePlan
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_work" style="text-align: left;">Сдача на склад Факт</td>
          <td class="td_work" style="text-align: left;"><%=valToHTML(fld_date_fact_whse)%></td>
        </tr>
        <tr>
          <td class="td_work" style="text-align: left;">Примечание</td>
          <td class="td_work" style="text-align: left;">
          <%
            if fd_editComment2 then
              Response.Write "<input type=""text"" id=""cll_Comment2"" name=""cll_Comment2"" maxlength=""150"" class=""input_txt"" value="""&fld_Comment2&""" />"
            else
              Response.Write fld_Comment2
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_work" style="text-align: left;">Дата отгрузки План</td>
          <td class="td_work" style="text-align: left;">
          <%
            if fd_editDateShipPlan then
              Response.Write "<input type=""text"" id=""cll_DateShipPlan"" name=""cll_DateShipPlan"" maxlength=""180"" class=""input_txt"" value="""&fld_DateShipPlan&""" />"
            else
              Response.Write fld_DateShipPlan
            end if
          %>
          </td>
        </tr>

        <tr>
          <td class="td_trans" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Транспортный отдел</td>
        </tr>
        <tr>
          <td class="td_trans" style="text-align: left;">Дата отгрузки Факт</td>
          <td class="td_trans" style="text-align: left;">
          <%
            if fd_editDateShipFact then
              Response.Write "<input type=""text"" id=""cll_DateShipFact"" name=""cll_DateShipFact"" maxlength=""180"" class=""input_txt"" value="""&fld_DateShipFact&""" />"
            else
              Response.Write fld_DateShipFact
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_trans" style="text-align: left;">Тип отгрузки</td>
          <td class="td_trans" style="text-align: left;">
          <%
            if fd_editTypeShip then
              Response.Write "<input type=""text"" id=""cll_TypeShip"" name=""cll_TypeShip"" maxlength=""80"" class=""input_txt"" value="""&fld_TypeShip&""" />"
            else
              Response.Write fld_TypeShip
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_trans" style="text-align: left;">Время в пути</td>
          <td class="td_trans" style="text-align: left;">
          <%
            if fd_editTravelTimePlan then
              Response.Write "<input type=""text"" id=""cll_TravelTimePlan"" name=""cll_TravelTimePlan"" maxlength=""180"" class=""input_txt"" value="""&fld_TravelTimePlan&""" />"
            else
              Response.Write fld_TravelTimePlan
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_trans" style="text-align: left;">Доставка до заказчика План</td>
          <td class="td_trans" style="text-align: left;">
          <%
            if fd_editDateDelivery then
              Response.Write "<input type=""text"" id=""cll_DateDelivery"" name=""cll_DateDelivery"" maxlength=""180"" class=""input_txt"" value="""&fld_DateDelivery&""" />"
            else
              Response.Write fld_DateDelivery
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_trans" style="text-align: left;">Доставка до заказчика Факт</td>
          <td class="td_trans" style="text-align: left;">
          <%
            if fd_editDateDeliveryFact then
              Response.Write "<input type=""text"" id=""cll_DateDeliveryFact"" name=""cll_DateDeliveryFact"" maxlength=""180"" class=""input_txt"" value="""&fld_DateDeliveryFact&""" />"
            else
              Response.Write fld_DateDeliveryFact
            end if
          %>
          </td>
        </tr>

        <tr>
          <td class="td_service" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Служба сервиса</td>
        </tr>
        <tr>
          <td class="td_service" style="text-align: left;">Готовность кабинета</td>
          <td class="td_service" style="text-align: left;">
          <%
            if fd_editDateKabinetReady then
              Response.Write "<input type=""text"" id=""cll_DateKabinetReady"" name=""cll_DateKabinetReady"" maxlength=""20"" class=""input_txt"" value="""&fld_DateKabinetReady&""" />"
            else
              Response.Write fld_DateKabinetReady
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_service" style="text-align: left;">Начало монтажа</td>
          <td class="td_service" style="text-align: left;">
          <%
            if fd_editDateMontagStart then
              Response.Write "<input type=""text"" id=""cll_DateMontagStart"" name=""cll_DateMontagStart"" maxlength=""20"" class=""input_txt"" value="""&fld_DateMontagStart&""" />"
            else
              Response.Write fld_DateMontagStart
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_service" style="text-align: left;">Окончание монтажа</td>
          <td class="td_service" style="text-align: left;">
          <%
            if fd_editDateMontagEnd then
              Response.Write "<input type=""text"" id=""cll_DateMontagEnd"" name=""cll_DateMontagEnd"" maxlength=""20"" class=""input_txt"" value="""&fld_DateMontagEnd&""" />"
            else
              Response.Write fld_DateMontagEnd
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_service" style="text-align: left;">Примечание от СС</td>
          <td class="td_service" style="text-align: left;">
          <%
            if fd_editComment5 then
              Response.Write "<input type=""text"" id=""cll_Comment5"" name=""cll_Comment5"" maxlength=""400"" class=""input_txt"" value="""&fld_Comment5&""" />"
            else
              Response.Write fld_Comment5
            end if
          %>
          </td>
        </tr>

        <tr>
          <td style="text-align: left;">Заказчик/ЛПУ</td>
          <td style="text-align: left;">
          <%
            if fd_editLPU then
              Response.Write "<input type=""text"" id=""cll_LPU"" name=""cll_LPU"" maxlength=""400"" class=""input_txt"" value="""&fld_LPU&""" />"
            else
              Response.Write fld_LPU
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Номер проекта</td>
          <td style="text-align: left;">
          <%
            if fd_editNumbProject then
              Response.Write "<input type=""text"" id=""cll_NumbProject"" name=""cll_NumbProject"" maxlength=""40"" class=""input_txt"" value="""&fld_NumbProject&""" />"
            else
              Response.Write fld_NumbProject
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Сумма договора с контрагентом</td>
          <td style="text-align: left;">
          <%
            if fd_showCostContract then
              if fd_editCostContract then
                Response.Write "<input type=""text"" id=""cll_CostContract"" name=""cll_CostContract"" maxlength=""13"" class=""input_txt"" value="""&fld_CostContract&""" />"
              else
                Response.Write fld_CostContract
              end if
            else
              Response.Write "<br />"
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Стоимость монтажа</td>
          <td style="text-align: left;">
          <%
            if fd_showCostMontage then
              if fd_editCostMontage then
                Response.Write "<input type=""text"" id=""cll_CostMontage"" name=""cll_CostMontage"" maxlength=""13"" class=""input_txt"" value="""&fld_CostMontage&""" />"
              else
                Response.Write fld_CostMontage
              end if
            else
              Response.Write "<br />"
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Примечание</td>
          <td style="text-align: left;">
          <%
            if fd_editComment3 then
              Response.Write "<input type=""text"" id=""cll_Comment3"" name=""cll_Comment3"" maxlength=""400"" class=""input_txt"" value="""&fld_Comment3&""" />"
            else
              Response.Write fld_Comment3
            end if
          %>
          </td>
        </tr>
        <tr>
          <td style="text-align: left;">Статус</td>
          <td style="text-align: left;" id="cll_Stat_text"><%=valToHTML(fld_Stat_text)%>
            <input type="hidden" id="cll_Stat" name="cll_Stat" value="<%=fld_Stat%>" /></td>
        </tr>
        <tr>
          <td style="text-align: left;">ID</td>
          <td style="text-align: left;" id="cll_ID_cll"><%=valToHTML(fld_ID)%>
            <input type="hidden" id="cll_ID" name="cll_ID" value="<%=fld_ID%>" /></td>
        </tr>
        <tr>
          <td style="text-align: left;">Дата создания</td>
          <td style="text-align: left;" id="cll_CreateDate"><%=valToHTML(fld_CreateDate)%>
          <input type="hidden" id="cll_RowPointer" name="cll_RowPointer" value="<%=fld_RowPointer%>" /></td>
        </tr>

        <tr>
          <td class="td_sl" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Заказ клиента</td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">ЗК</td>
          <td class="td_sl" style="text-align: left;" id="cll_co_num"><%=valToHTML(fld_co_num)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Строка ЗК</td>
          <td class="td_sl" style="text-align: left;" id="cll_co_line"><%=valToHTML(fld_co_line)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Изделие в ЗК</td>
          <td class="td_sl" style="text-align: left;" id="cll_ItemSL"><%=valToHTML(fld_ItemSL)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Наименование в ЗК</td>
          <td class="td_sl" style="text-align: left;" id="cll_descr"><%=valToHTML(fld_descr)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Заказано</td>
          <td class="td_sl" style="text-align: left;" id="cll_qty_ordered"><%=valToHTML(fld_qty_ordered)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Отгружено</td>
          <td class="td_sl" style="text-align: left;" id="cll_qty_shipped"><%=valToHTML(fld_qty_shipped)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Е/И</td>
          <td class="td_sl" style="text-align: left;" id="cll_u_m"><%=valToHTML(fld_u_m)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Заказчик</td>
          <td class="td_sl" style="text-align: left;" id="cll_cust"><%=valToHTML(fld_cust)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Получатель</td>
          <td class="td_sl" style="text-align: left;" id="cll_customer_ship"><%=valToHTML(fld_customer_ship)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Стоимость изделия</td>
          <td class="td_sl" style="text-align: left;" id="cll_price_all">
          <%
            if fd_showprice_all then
              Response.Write valToHTML(fld_price_all)
            else
              Response.Write "<br />"
            end if
          %>
          </td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">План.дата</td>
          <td class="td_sl" style="text-align: left;" id="cll_due_date"><%=valToHTML(fld_due_date)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Дата отгрузки в 1С</td>
          <td class="td_sl" style="text-align: left;" id="cll_DateShipFrom1C"><%=valToHTML(fld_DateShipFrom1C)%></td>
        </tr>
        <tr>
          <td class="td_sl" style="text-align: left;">Создание ФСИ</td>
          <td class="td_sl" style="text-align: left;" id="cll_fsi_date"><%=valToHTML(fld_fsi_date)%></td>
        </tr>

        <tr>
          <td class="td_defAPS" colspan="2" style="text-align: center; font-size: 14px; font-weight: bold;">Дефицит по ГП из АПС отчета</td>
        </tr>
        <tr>
          <td class="td_defAPS" style="text-align: left;">Строк в потребности</td>
          <td class="td_defAPS" style="text-align: left;" id="cll_DeficitAPS_rowCount"><%=valToHTML(fld_DeficitAPS_rowCount)%></td>
        </tr>
        <tr>
          <td class="td_defAPS" style="text-align: left;">Общая стоимость</td>
          <td class="td_defAPS" style="text-align: left;" id="cll_DeficitAPS_CostAll"><%=valToHTML(fld_DeficitAPS_CostAll)%></td>
        </tr>
        <tr>
          <td class="td_defAPS" style="text-align: left;">Показать в Excel</td>
          <% 
    if IsNull(fld_DeficitAPS_rowCount) or (fld_DeficitAPS_rowCount = "") or (fld_DeficitAPS_rowCount = 0) then
      response.write "<td class=td_defAPS><br /></td>"&vbCrLf
    else
      response.write "<td class=td_defAPS style=""text-align:left;""><input type=button onClick='DeficitFromAPS_XLS(this)' data-SN='"&fld_ser_num&"' value='Показать'></td>"&vbCrLf
    end if
          %>
        </tr>
            <%
    if fd_canChangeOrder then
      response.write "<tr>"
      response.write "<td align=""center"" bgcolor=""#dddddd"" colspan=""2"">"
      response.write "<input type=""button"" onclick=""checkSend();"" value=""Сохранить"" />"
      response.write "</td>"
      response.write "</tr>"
    end if
            %>
      </table>
    </form>
    <%
    else
      showError prm_returnValue, prm_Infobar
    end if
  else
    showError fd_returnValue, fd_Infobar
  end if  
    %>
  </div>
</body>
</html>
