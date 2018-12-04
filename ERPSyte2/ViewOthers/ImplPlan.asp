<!DOCTYPE html>
<html>
<head>
  <title>���� �� ����������</title>
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
  ' ������� ��������� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  prm_ser_num = "-all"
  prm_ID = 0
  prm_Login = Session("userLogin")
  prm_filter = ""
  ' /������� ��������� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 

  
  ' ����� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
  fd_returnValue = 16
  fd_Infobar = ""
  fd_canCreateOrder = false ' ����� ������� ����� ��������� (�����)
  fd_canChangeOrder = false ' �������� ������ ���������

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
    
  ' ����� ��������� ������� ����������
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
  ' /����� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 


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
          <h2>���� �� ����������</h2>
          <p>��� ���������/�������������� ����������� ������, �������� ���, �������� ������� �� ������ � ������� "��������� (�����)"</p>
        </td>
      </tr>
      <tr>
        <td>
          <div>
            <%
      if fd_canCreateOrder then
        Response.Write "<div style=""text-align: left; padding: 10px;""><a href=""ImplPlanItem.asp"">������� ����� ��������� (�����)</a></div>"
        Response.Write "</td>"
        Response.Write "</tr>"
        Response.Write "<tr>"
        Response.Write "<td>"
      end if
            %>
            <a href="#filter" class="button-filter-apply" onclick="filterApply();return!1;">�����������</a>
            <a href="#clear" class="button-filter-clear" onclick="filterClear();return!1;">�������� ������</a>
            <table class="tableSection" id="tableImplPlan">
              <thead class="top">
                <tr id="HeaderRow1">
                  <th rowspan="2">�������� ����</th>
                  <th rowspan="2">��������� (�����)</th>
                  <th rowspan="2" id="th_Type">��� �������</th>
                  <th rowspan="2">������������</th>
                  <th rowspan="2">��� �������</th>
                  <th rowspan="2">���</th>

                  <th colspan="6" class="td_commers" style="text-align: center; font-size: 14px; font-weight: bold;">������������ �����������</th>
                  <!--colspan=6 ������������ �����������-->
                  <th colspan="7" class="td_supply" style="text-align: center; font-size: 14px; font-weight: bold;">���������</th>
                  <!--colspan=7 ���������-->
                  <th colspan="3" class="td_defAPS" style="text-align: center; font-size: 14px; font-weight: bold;">������� �� �� �� ��� ������</th>
                  <!--colspan=3 ������� �� �� �� ��� ������-->
                  <th colspan="4" class="td_work" style="text-align: center; font-size: 14px; font-weight: bold;">������������, �����</th>
                  <!--colspan=4 ������������, �����-->
                  <th colspan="5" class="td_trans" style="text-align: center; font-size: 14px; font-weight: bold;">������������ �����</th>
                  <!--colspan=5 ������������ �����-->
                  <th colspan="4" class="td_service" style="text-align: center; font-size: 14px; font-weight: bold;">������ �������</th>
                  <!--colspan=4 ������ �������-->

                  <th rowspan="2">��������/���</th>
                  <th rowspan="2">����� �������</th>
                  <th rowspan="2">����� �������� � ������������</th>
                  <th rowspan="2">��������� �������</th>
                  <th rowspan="2">����������</th>

                  <th rowspan="2">������</th>
                  <th rowspan="2">ID</th>
                  <th rowspan="2">���� ��������</th>

                  <th colspan="13" class="td_sl" style="text-align: center; font-size: 14px; font-weight: bold;">����� �������</th>
                  <!--colspan=13 ����� �������-->
                </tr>
                <tr id="HeaderRow2">
                  <!--colspan=6 ������������ �����������-->
                  <th class="td_commers">���� �� ��������</th>
                  <th class="td_commers">���� �� ��</th>
                  <th class="td_commers">�������� ���� ���������� ������</th>
                  <th class="td_commers">���� �� ������� � ���</th>
                  <th class="td_commers">����������</th>
                  <th class="td_commers">���������� �������</th>

                  <!--colspan=7 ���������-->
                  <th class="td_supply">����������� ��� �������</th>
                  <th class="td_supply">����������� ��� ������� ��������</th>
                  <th class="td_supply">������</th>
                  <th class="td_supply">�������������1</th>
                  <th class="td_supply">�������������2</th>
                  <th class="td_supply">�������������3</th>
                  <th class="td_supply">�������������4</th>

                  <!--colspan=3 ������� �� �� �� ��� ������-->
                  <th class="td_defAPS">����� � �����������</th>
                  <th class="td_defAPS">����� ���������</th>
                  <th class="td_defAPS">�������� � Excel</th>

                  <!--colspan=4 ������������, �����-->
                  <th class="td_work">����� �� ����� ����</th>
                  <th class="td_work">����� �� ����� ����</th>
                  <th class="td_work">����������</th>
                  <th class="td_work">���� �������� ����</th>

                  <!--colspan=5 ������������ �����-->
                  <th class="td_trans">���� �������� ����</th>
                  <th class="td_trans">��� ��������</th>
                  <th class="td_trans">����� � ����</th>
                  <th class="td_trans">�������� �� ��������� ����</th>
                  <th class="td_trans">�������� �� ��������� ����</th>

                  <!--colspan=4 ������ �������-->
                  <th class="td_service">���������� ��������</th>
                  <th class="td_service">������ �������</th>
                  <th class="td_service">��������� �������</th>
                  <th class="td_service">���������� �� ��</th>

                  <!--colspan=13 ����� �������-->
                  <th class="td_sl">��</th>
                  <th class="td_sl">������ ��</th>
                  <th class="td_sl">������� � ��</th>
                  <th class="td_sl">������������ � ��</th>
                  <th class="td_sl">��������</th>
                  <th class="td_sl">���������</th>
                  <th class="td_sl">�/�</th>
                  <th class="td_sl">��������</th>
                  <th class="td_sl">����������</th>
                  <th class="td_sl">��������� �������</th>
                  <th class="td_sl">����.����</th>
                  <th class="td_sl">���� �������� � 1�</th>
                  <th class="td_sl">�������� ���</th>
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
    ' ������ '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    fld_Type = RS("Type") '-- ��� �������
    fld_Comment1 = RS("Comment1") '-- ������������
    fld_Item = RS("Item") '-- ��� �������
    fld_OrderFromManager = RS("OrderFromManager") '-- ��������� (�����)
    fld_ser_num = RS("ser_num") '-- �������� ����
    fld_DateInContract = RS("DateInContract") '-- ���� �� ��������
    fld_DateInGK = RS("DateInGK") '--���� �� ��
    fld_DateDesired = RS("DateDesired") '-- �������� ���� ���������� ������
    fld_DateInOKO = RS("DateInOKO") '--���� �� ������� � ���
    fld_DateVrHran = RS("DateVrHran") '--����������
    fld_Comment4 = RS("Comment4") '--���������� �������
    fld_QforImport = RS("QforImport") '--����������� ��� �������
    fld_QforRus = RS("QforRus") '--����������� ��� ������� ��������
    fld_PImport = RS("PImport") '-- ������ 
    fld_PRus1 = RS("PRus1") '-- �������������1
    fld_PRus2 = RS("PRus2") '-- �������������2
    fld_PRus3 = RS("PRus3") '-- �������������3
    fld_PRus4 = RS("PRus4") '-- �������������4
    fld_DateToWhsePlan = RS("DateToWhsePlan") '-- ����� �� ����� ����
    fld_Comment2 = RS("Comment2") '-- ����������2
    fld_DateShipPlan = RS("DateShipPlan") '-- ���� �������� ����
    fld_DateShipFact = RS("DateShipFact") '--���� �������� ����
    fld_TypeShip = RS("TypeShip") '--��� ��������
    fld_TravelTimePlan = RS("TravelTimePlan") '--����� � ����
    fld_DateDelivery = RS("DateDelivery") '--�������� �� ��������� ����
    fld_DateDeliveryFact = RS("DateDeliveryFact") '--�������� �� ��������� ����
    fld_DateKabinetReady = RS("DateKabinetReady") '-- ���������� ��������
    fld_DateMontagStart = RS("DateMontagStart") '--������ �������
    fld_DateMontagEnd = RS("DateMontagEnd") '-- ��������� �������
    fld_Comment5 = RS("Comment5") '--���������� �� ��
    fld_LPU = RS("LPU") '--��������/���
    fld_NumbProject = RS("NumbProject") '-- ����� �������
    fld_CostContract = RS("CostContract") '--����� �������� � ������������
    fld_CostMontage = RS("CostMontage") '-- ��������� �������
    fld_Comment3 = RS("Comment3") '-- ����������3
    fld_Stat_text = RS("Stat_text") '-- ������
    fld_Stat = RS("Stat") '--����������� �������--
    fld_ID = RS("ID") '-- ID
    fld_CreateDate = RS("CreateDate") '-- ���� ��������
    fld_RowPointer = RS("RowPointer") '--����������� �������--
    fld_stored_ser_num = RS("stored_ser_num") '--����������� �������--

    fld_ItemSL = RS("ItemSL") '-- ������� � ��
    fld_descr = RS("descr") '-- ������������ � ��
    fld_u_m = RS("u_m") '-- �/�
    fld_coi_ser_num = RS("coi_ser_num") '--����������� �������--
    fld_coi_stat = RS("coi_stat") '--����������� �������--
    fld_qty_ordered = RS("qty_ordered") '-- ��������
    fld_qty_shipped = RS("qty_shipped") '-- ���������
    fld_JobNum = RS("JobNum") '-- ���
    fld_Job = RS("Job") '--����������� �������--
    fld_Suffix = RS("Suffix") '--����������� �������--
    fld_cust = RS("cust") '-- ��������
    fld_customer_ship = RS("customer_ship") '-- ����������
    fld_due_date = RS("due_date") '-- ����.����
    fld_date_fact_whse = RS("date_fact_whse") '-- ����� �� ����� ����
    fld_co_num = RS("co_num") '-- ��
    fld_co_line = RS("co_line") '-- ������ ��
    fld_DeficitAPS_rowCount = RS("DeficitAPS_rowCount") '-- ������� �� �� �� ��� ������ -- ����� � �����������
    fld_DeficitAPS_CostAll = RS("DeficitAPS_CostAll") '-- ������� �� �� �� ��� ������ -- ����� ���������
    fld_DateShipFrom1C = RS("DateShipFrom1C") '-- ���� �������� � 1�
    fld_fsi_date = RS("fsi_date") '-- �������� ���
    fld_price_all = RS("price_all") '-- ��������� �������
    ' /������ '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


    ' ���������� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    fld_CostContract = valRound(fld_CostContract)
    fld_CostMontage = valRound(fld_CostMontage) 
    fld_DeficitAPS_CostAll = valRound(fld_DeficitAPS_CostAll) 
    fld_price_all = valRound(fld_price_all) 
    ' /���������� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


    ' ����� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    response.write "<tr>"&vbCrLf
    response.write "<td data-field_name=""ser_num"">"&valToHTML(fld_ser_num)&"</td>"&vbCrLf '-- �������� ����

    response.write "<td>"
    if fld_OrderFromManager <> "" then
      response.write "<a href=""ImplPlanItem.asp?SN="&fld_ser_num&"&ID="&fld_ID&""">"&fld_OrderFromManager&"</a>" '-- ��������� (�����)
    elseif fd_canCreateOrder then
      response.write "<a href=""ImplPlanItem.asp?SN="&fld_ser_num&"&ID="&fld_ID&""">�������</a>" '-- ��������� (�����)
    else
      response.write "<br />"
    end if
    response.write "</td>"&vbCrLf

    response.write "<td "&valToAnchor(fld_ID)&">"&valToHTML(fld_Type)&"</td>"&vbCrLf '-- ��� �������
    response.write "<td>"&valToHTML(fld_Comment1)&"</td>"&vbCrLf '-- ������������
    response.write "<td>"&valToHTML(fld_Item)&"</td>"&vbCrLf '-- ��� �������
    response.write "<td>"&valToHTML(fld_JobNum)&"</td>"&vbCrLf '-- ���

    response.write "<td class=td_commers>"&valToHTML(fld_DateInContract)&"</td>"&vbCrLf '-- ���� �� ��������
    response.write "<td class=td_commers>"&valToHTML(fld_DateInGK)&"</td>"&vbCrLf '-- ���� �� ��
    response.write "<td class=td_commers>"&valToHTML(fld_DateDesired)&"</td>"&vbCrLf '-- �������� ���� ���������� ������
    response.write "<td class=td_commers>"&valToHTML(fld_DateInOKO)&"</td>"&vbCrLf '-- ���� �� ������� � ���
    response.write "<td class=td_commers>"&valToHTML(fld_DateVrHran)&"</td>"&vbCrLf '-- ����������
    response.write "<td class=td_commers>"&valToHTML(fld_Comment4)&"</td>"&vbCrLf '-- ���������� �������

    response.write "<td class=td_supply>"&valToHTML(fld_QforImport)&"</td>"&vbCrLf '-- ����������� ��� �������
    response.write "<td class=td_supply>"&valToHTML(fld_QforRus)&"</td>"&vbCrLf '-- ����������� ��� ������� ��������
    response.write "<td class=td_supply>"&valToHTML(fld_PImport)&"</td>"&vbCrLf '-- ������ 
    response.write "<td class=td_supply>"&valToHTML(fld_PRus1)&"</td>"&vbCrLf '-- �������������1
    response.write "<td class=td_supply>"&valToHTML(fld_PRus2)&"</td>"&vbCrLf '-- �������������2
    response.write "<td class=td_supply>"&valToHTML(fld_PRus3)&"</td>"&vbCrLf '-- �������������3
    response.write "<td class=td_supply>"&valToHTML(fld_PRus4)&"</td>"&vbCrLf '-- �������������4

    response.write "<td class=td_defAPS>"&valToHTML(fld_DeficitAPS_rowCount)&"</td>"&vbCrLf '-- ������� �� �� �� ��� ������ -- ����� � �����������
    response.write "<td class=td_defAPS style=""white-space: nowrap"">"&valToHTML(fld_DeficitAPS_CostAll)&"</td>"&vbCrLf '-- ������� �� �� �� ��� ������ -- ����� ���������
    if IsNull(fld_DeficitAPS_rowCount) then
      response.write "<td class=td_defAPS><br /></td>"&vbCrLf
    else
      response.write "<td class=td_defAPS><input type=button onClick='deficitFromAPS_XLS(this)' data-SN='"&fld_ser_num&"' value='��������'></td>"&vbCrLf
    end if

    response.write "<td class=td_work>"&valToHTML(fld_DateToWhsePlan)&"</td>"&vbCrLf '-- ����� �� ����� ����
    response.write "<td class=td_work>"&valToHTML(fld_date_fact_whse)&"</td>"&vbCrLf '-- ����� �� ����� ����
    response.write "<td class=td_work>"&valToHTML(fld_Comment2)&"</td>"&vbCrLf '-- ����������2
    response.write "<td class=td_work>"&valToHTML(fld_DateShipPlan)&"</td>"&vbCrLf '-- ���� �������� ����

    response.write "<td class=td_trans>"&valToHTML(fld_DateShipFact)&"</td>"&vbCrLf '-- ���� �������� ����
    response.write "<td class=td_trans>"&valToHTML(fld_TypeShip)&"</td>"&vbCrLf '-- ��� ��������
    response.write "<td class=td_trans>"&valToHTML(fld_TravelTimePlan)&"</td>"&vbCrLf '-- ����� � ����
    response.write "<td class=td_trans>"&valToHTML(fld_DateDelivery)&"</td>"&vbCrLf '-- �������� �� ��������� ����
    response.write "<td class=td_trans>"&valToHTML(fld_DateDeliveryFact)&"</td>"&vbCrLf '-- �������� �� ��������� ����

    response.write "<td class=td_service>"&valToHTML(fld_DateKabinetReady)&"</td>"&vbCrLf '-- ���������� ��������
    response.write "<td class=td_service>"&valToHTML(fld_DateMontagStart)&"</td>"&vbCrLf '-- ������ �������
    response.write "<td class=td_service>"&valToHTML(fld_DateMontagEnd)&"</td>"&vbCrLf '-- ��������� �������
    response.write "<td class=td_service>"&valToHTML(fld_Comment5)&"</td>"&vbCrLf '-- ���������� �� ��

    response.write "<td>"&valToHTML(fld_LPU)&"</td>"&vbCrLf '--��������/���
    response.write "<td>"&valToHTML(fld_NumbProject)&"</td>"&vbCrLf '-- ����� �������
    if fd_showCostContract then
    response.write "<td>"&valToHTML(fld_CostContract)&"</td>"&vbCrLf '--����� �������� � ������������
    else
    response.write "<td><br /></td>"&vbCrLf
    end if
    if fd_showCostMontage then
    response.write "<td>"&valToHTML(fld_CostMontage)&"</td>"&vbCrLf '-- ��������� �������
    else
    response.write "<td><br /></td>"&vbCrLf
    end if
    response.write "<td>"&valToHTML(fld_Comment3)&"</td>"&vbCrLf '-- ����������3

    response.write "<td>"&valToHTML(fld_Stat_text)&"</td>"&vbCrLf '-- ������
    response.write "<td>"&valToHTML(fld_ID)&"</td>"&vbCrLf '-- ID
    response.write "<td>"&valToHTML(fld_CreateDate)&"</td>"&vbCrLf '-- ���� ��������

    response.write "<td class=td_sl>"&valToHTML(fld_co_num)&"</td>"&vbCrLf '-- ��
    response.write "<td class=td_sl>"&valToHTML(fld_co_line)&"</td>"&vbCrLf '-- ������ ��
    response.write "<td class=td_sl>"&valToHTML(fld_ItemSL)&"</td>"&vbCrLf '-- ������� � ��
    response.write "<td class=td_sl>"&valToHTML(fld_descr)&"</td>"&vbCrLf '-- ������������ � ��
    response.write "<td class=td_sl>"&valToHTML(fld_qty_ordered)&"</td>"&vbCrLf '-- ��������
    response.write "<td class=td_sl>"&valToHTML(fld_qty_shipped)&"</td>"&vbCrLf '-- ���������
    response.write "<td class=td_sl>"&valToHTML(fld_u_m)&"</td>"&vbCrLf '-- �/�
    response.write "<td class=td_sl>"&valToHTML(fld_cust)&"</td>"&vbCrLf '-- ��������
    response.write "<td class=td_sl>"&valToHTML(fld_customer_ship)&"</td>"&vbCrLf '-- ����������
    if fd_showprice_all then
    response.write "<td class=td_sl>"&valToHTML(fld_price_all)&"</td>"&vbCrLf '-- ��������� �������
    else
    response.write "<td class=td_sl><br /></td>"&vbCrLf
    end if
    response.write "<td class=td_sl>"&valToHTML(fld_due_date)&"</td>"&vbCrLf '-- ����.����
    response.write "<td class=td_sl>"&valToHTML(fld_DateShipFrom1C)&"</td>"&vbCrLf '-- ���� �������� � 1�
    response.write "<td class=td_sl>"&valToHTML(fld_fsi_date)&"</td>"&vbCrLf '-- �������� ���
    response.write "</tr>"&vbCrLf
    ' /����� '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    RS.MoveNext
  Loop
                %>
              </tbody>
            </table>
            <a href="#top" class="button-top" onclick="scrollUp();return!1;">������</a>
            <%
      if fd_canCreateOrder then
        Response.Write "</td>"
        Response.Write "</tr>"
        Response.Write "<tr>"
        Response.Write "<td>"
        Response.Write "<div style=""text-align: left; padding: 10px;""><a href=""ImplPlanItem.asp"">������� ����� ��������� (�����)</a></div>"
      end if
            %>
          </div>
        </td>
      </tr>
      <tr>
        <td style="text-align: left; padding: 10px; background-color: InfoBackground;">
          <div>
            <h4>��������</h4>
            �������� � Excel �������� <b>������</b> �� �������� Microsoft Internet Explorer, ������ �� ���� 10.
          </div>
        </td>
      </tr>
    </table>
    <%
      else
        showInfo "������", "��� ������, ��������������� �������� ����������"
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
