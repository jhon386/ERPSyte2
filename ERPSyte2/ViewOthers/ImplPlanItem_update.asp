<!DOCTYPE html>
<html>
<head>
  <title>План по реализации</title>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <!--#include file="../include/ConnectERPDBAnonym.inc"-->
</head>
<body>
  <div>
<%
  Function msgToString(msg)
    msg = Trim(msg)
    if not IsNull(msg) and msg <> "" then
      msgToString = msg
    else
      msgToString = "null"
    end if
  End Function

  Function cllToString(cll)
    if not IsNull(cll) and cll <> "" then
      cllToString = "'"&cll&"'"
    else
      cllToString = "null"
    end if
  End Function

  Function cllToDate(cll)
    if not IsNull(cll) and cll <> "" and IsDate(cll) then
      cllToString = "'"&cll&"'"
    else
      cllToString = "null"
    end if
  End Function

  Function cllToNumber(AValue)
    if not IsNull(AValue) and AValue <> "" and IsNumeric(AValue) then
      cllToNumber = AValue
    else
      cllToNumber = "null"
    end if
  End Function
  
  Function ValToSrting(AElementName)
    Dim AValue
    AValue = Trim(Request.Form(AElementName))

    if not IsNull(AValue) and AValue <> "" then
      ValToSrting = AValue
    else
      ValToSrting = null
    end if
  End Function
  
  Function ValToNumber(AElementName)
    Dim AValue
    AValue = Trim(Request.Form(AElementName))
    AValue = Replace(Replace(AValue," ",""),",",".")

    if not IsNull(AValue) and AValue <> "" and IsNumeric(AValue) then
      ValToNumber = AValue
    else
      ValToNumber = null
    end if
  End Function
  
  prm_ID =               ValToNumber("cll_ID")
  prm_Type =             ValToSrting("cll_Type")
  prm_Comment1 =         ValToSrting("cll_Comment1")
  prm_Item =             ValToSrting("cll_Item")
  prm_OrderFromManager = ValToSrting("cll_OrderFromManager")
  prm_ser_num =          ValToSrting("cll_ser_num")
  prm_DateInContract =   ValToSrting("cll_DateInContract")
  prm_DateInGK =         ValToSrting("cll_DateInGK")
  prm_DateDesired =      ValToSrting("cll_DateDesired")
  prm_DateInOKO =        ValToSrting("cll_DateInOKO")
  prm_DateVrHran =       ValToSrting("cll_DateVrHran")
  prm_Comment4 =         ValToSrting("cll_Comment4")
  prm_QforImport =       ValToSrting("cll_QforImport")
  prm_QforRus =          ValToSrting("cll_QforRus")
  prm_PImport =          ValToSrting("cll_PImport")
  prm_PRus1 =            ValToSrting("cll_PRus1")
  prm_PRus2 =            ValToSrting("cll_PRus2")
  prm_PRus3 =            ValToSrting("cll_PRus3")
  prm_PRus4 =            ValToSrting("cll_PRus4")
  prm_DateToWhsePlan =   ValToSrting("cll_DateToWhsePlan")
  prm_Comment2 =         ValToSrting("cll_Comment2")
  prm_DateShipPlan =     ValToSrting("cll_DateShipPlan")
  prm_DateShipFact =     ValToSrting("cll_DateShipFact")
  prm_TypeShip =         ValToSrting("cll_TypeShip")
  prm_TravelTimePlan =   ValToSrting("cll_TravelTimePlan")
  prm_DateDelivery =     ValToSrting("cll_DateDelivery")
  prm_DateDeliveryFact = ValToSrting("cll_DateDeliveryFact")
  prm_DateKabinetReady = ValToSrting("cll_DateKabinetReady")
  prm_DateMontagStart =  ValToSrting("cll_DateMontagStart")
  prm_DateMontagEnd =    ValToSrting("cll_DateMontagEnd")
  prm_Comment5 =         ValToSrting("cll_Comment5")
  prm_LPU =              ValToSrting("cll_LPU")
  prm_NumbProject =      ValToSrting("cll_NumbProject")
  prm_CostContract =     ValToNumber("cll_CostContract")
  prm_CostMontage =      ValToNumber("cll_CostMontage")
  prm_Comment3 =         ValToSrting("cll_Comment3")
  prm_stat =             ValToSrting("cll_stat")
  prm_RowPointer =       ValToSrting("cll_RowPointer")

  prm_Login =            Session("userLogin")
  prm_returnValue =      16   
  prm_outID =            0        
  prm_Infobar = ""

  set cmd = Server.CreateObject("ADODB.Command")
  with cmd
    .ActiveConnection = erp_ConnectDB
    .CommandType = 4 'adCmdStoredProc
    .CommandText = "zKdx_IP_Update"
                       'CreateParameter(Name, Type, Direction, Size, Value)                   
    .Parameters.Append .CreateParameter("@returnValue",        3, 4, 0,   NULL) 'adInteger=3 'adParamReturnValue=4
    .Parameters.Append .CreateParameter("@ID",                 3, 3, 0,   prm_ID) 'adInteger=3 'adParamInputOutput=3	int = null
    .Parameters.Append .CreateParameter("@Type",             202, 1, 16,  prm_Type) 'AdVarWChar=202 'adParamInput=1 nvarchar(16) = null
    .Parameters.Append .CreateParameter("@Comment1",         202, 1, 150, prm_Comment1) 'AdVarWChar=202 'adParamInput=1 nvarchar(150) = null
    .Parameters.Append .CreateParameter("@Item",             202, 1, 30,  prm_Item) 'AdVarWChar=202 'adParamInput=1 nvarchar(30) = null
    .Parameters.Append .CreateParameter("@OrderFromManager", 202, 1, 40,  prm_OrderFromManager) 'AdVarWChar=202 'adParamInput=1 nvarchar(40) = null
    .Parameters.Append .CreateParameter("@ser_num",          202, 1, 30,  prm_ser_num) 'AdVarWChar=202 'adParamInput=1	nvarchar(30) = null
    .Parameters.Append .CreateParameter("@DateInContract",   202, 1, 180, prm_DateInContract) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateInGK",         202, 1, 180, prm_DateInGK) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateDesired",      202, 1, 180, prm_DateDesired) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateInOKO",        202, 1, 180, prm_DateInOKO) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateVrHran",       202, 1, 180, prm_DateVrHran) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@Comment4",         202, 1, 400, prm_Comment4) 'AdVarWChar=202 'adParamInput=1 nvarchar(400) = null
    .Parameters.Append .CreateParameter("@QforImport",       202, 1, 180, prm_QforImport) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@QforRus",          202, 1, 180, prm_QforRus) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@PImport",          202, 1, 180, prm_PImport) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@PRus1",            202, 1, 180, prm_PRus1) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@PRus2",            202, 1, 180, prm_PRus2) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@PRus3",            202, 1, 180, prm_PRus3) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@PRus4",            202, 1, 180, prm_PRus4) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateToWhsePlan",   202, 1, 180, prm_DateToWhsePlan) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@Comment2",         202, 1, 150, prm_Comment2) 'AdVarWChar=202 'adParamInput=1 nvarchar(150) = null
    .Parameters.Append .CreateParameter("@DateShipPlan",     202, 1, 180, prm_DateShipPlan) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateShipFact",     202, 1, 180, prm_DateShipFact) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@TypeShip",         202, 1, 80,  prm_TypeShip) 'AdVarWChar=202 'adParamInput=1 nvarchar(80) = null
    .Parameters.Append .CreateParameter("@TravelTimePlan",   202, 1, 180, prm_TravelTimePlan) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateDelivery",     202, 1, 180, prm_DateDelivery) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateDeliveryFact", 202, 1, 180, prm_DateDeliveryFact) 'AdVarWChar=202 'adParamInput=1 nvarchar(180) = null
    .Parameters.Append .CreateParameter("@DateKabinetReady", 202, 1, 20,  prm_DateKabinetReady) 'AdVarWChar=202 'adParamInput=1 nvarchar(20) = null
    .Parameters.Append .CreateParameter("@DateMontagStart",  202, 1, 20,  prm_DateMontagStart) 'AdVarWChar=202 'adParamInput=1 nvarchar(20) = null
    .Parameters.Append .CreateParameter("@DateMontagEnd",    202, 1, 20,  prm_DateMontagEnd) 'AdVarWChar=202 'adParamInput=1 nvarchar(20) = null
    .Parameters.Append .CreateParameter("@Comment5",         202, 1, 400, prm_Comment5) 'AdVarWChar=202 'adParamInput=1 nvarchar(400) = null
    .Parameters.Append .CreateParameter("@LPU",              202, 1, 400, prm_LPU) 'AdVarWChar=202 'adParamInput=1 nvarchar(400) = null
    .Parameters.Append .CreateParameter("@NumbProject",      202, 1, 40,  prm_NumbProject) 'AdVarWChar=202 'adParamInput=1 nvarchar(40) = null
    .Parameters.Append .CreateParameter("@CostContract",      14, 1, 0,   prm_CostContract) 'adDecimal=14 'adParamInput=1 decimal(18,8) = null
                            .Parameters("@CostContract").Precision = 18
                            .Parameters("@CostContract").NumericScale = 8
    .Parameters.Append .CreateParameter("@CostMontage",       14, 1, 0,   prm_CostMontage) 'adDecimal=14 'adParamInput=1 decimal(18,8) = null
                            .Parameters("@CostMontage").Precision = 18
                            .Parameters("@CostMontage").NumericScale = 8
    .Parameters.Append .CreateParameter("@Comment3",         202, 1, 400, prm_Comment3) 'AdVarWChar=202 'adParamInput=1 nvarchar(400) = null
    .Parameters.Append .CreateParameter("@stat",             202, 1, 1,   prm_stat) 'AdVarWChar=202 'adParamInput=1 nvarchar(1) = null
    .Parameters.Append .CreateParameter("@RowPointer",       202, 1, 38,  prm_RowPointer) 'AdVarWChar=202 'adParamInput=1 nvarchar(38) = null

    .Parameters.Append .CreateParameter("@Login",            202, 1, 128, prm_Login) 'AdVarWChar=202 'adParamInput=1	nvarchar(128) = null
    .Parameters.Append .CreateParameter("@Infobar",          202, 2, 2800,NULL) 'AdVarWChar=202 'adParamOutput=2 nvarchar(2800) = null output

    .Execute

    if not IsNull(.Parameters(0).Value) then 
      prm_returnValue = CInt(.Parameters(0).Value)
    end if 

    if not IsNull(.Parameters(1).Value) then 
      prm_outID = CInt(.Parameters(1).Value)
    end if 

    if not IsNull(.Parameters(40).Value) then 
      prm_Infobar = CStr(.Parameters(40).Value) 
    end if 
  end with 
  set cmd = nothing
 
  if prm_returnValue <> 0 then
    Response.Write "<div style=""text-align: left; background-color: InfoBackground; padding: 20px;"">"
    Response.Write "<h3>Ошибка:</h3>"
    Response.Write "<b>код:</b> " + CStr(prm_returnValue)
    Response.Write "<br>"
    Response.Write "<b>текст:</b> " + msgToString(prm_Infobar) 
    Response.Write "<br><br>"
    Response.Write "<h4>параметры:</h4>"
    Response.Write "prm_ID: " + cllToNumber(prm_ID) + "<br />"
    Response.Write "prm_Type: " + cllToString(prm_Type) + "<br />"
    Response.Write "prm_Comment1: " + cllToString(prm_Comment1) + "<br />"
    Response.Write "prm_Item: " + cllToString(prm_Item) + "<br />"
    Response.Write "prm_OrderFromManager: " + cllToString(prm_OrderFromManager) + "<br />"
    Response.Write "prm_ser_num: " + cllToString(prm_ser_num) + "<br />"
    Response.Write "prm_DateInContract: " + cllToString(prm_DateInContract) + "<br />"
    Response.Write "prm_DateInGK: " + cllToString(prm_DateInGK) + "<br />"
    Response.Write "prm_DateDesired: " + cllToString(prm_DateDesired) + "<br />"
    Response.Write "prm_DateInOKO: " + cllToString(prm_DateInOKO) + "<br />"
    Response.Write "prm_DateVrHran: " + cllToString(prm_DateVrHran) + "<br />"
    Response.Write "prm_Comment4: " + cllToString(prm_Comment4) + "<br />"
    Response.Write "prm_QforImport: " + cllToString(prm_QforImport) + "<br />"
    Response.Write "prm_QforRus: " + cllToString(prm_QforRus) + "<br />"
    Response.Write "prm_PImport: " + cllToString(prm_PImport) + "<br />"
    Response.Write "prm_PRus1: " + cllToString(prm_PRus1) + "<br />"
    Response.Write "prm_PRus2: " + cllToString(prm_PRus2) + "<br />"
    Response.Write "prm_PRus3: " + cllToString(prm_PRus3) + "<br />"
    Response.Write "prm_PRus4: " + cllToString(prm_PRus4) + "<br />"
    Response.Write "prm_DateToWhsePlan: " + cllToString(prm_DateToWhsePlan) + "<br />"
    Response.Write "prm_Comment2: " + cllToString(prm_Comment2) + "<br />"
    Response.Write "prm_DateShipPlan: " + cllToString(prm_DateShipPlan) + "<br />"
    Response.Write "prm_DateShipFact: " + cllToString(prm_DateShipFact) + "<br />"
    Response.Write "prm_TypeShip: " + cllToString(prm_TypeShip) + "<br />"
    Response.Write "prm_TravelTimePlan: " + cllToString(prm_TravelTimePlan) + "<br />"
    Response.Write "prm_DateDelivery: " + cllToString(prm_DateDelivery) + "<br />"
    Response.Write "prm_DateDeliveryFact: " + cllToString(prm_DateDeliveryFact) + "<br />"
    Response.Write "prm_DateKabinetReady: " + cllToString(prm_DateKabinetReady) + "<br />"
    Response.Write "prm_DateMontagStart: " + cllToString(prm_DateMontagStart) + "<br />"
    Response.Write "prm_DateMontagEnd: " + cllToString(prm_DateMontagEnd) + "<br />"
    Response.Write "prm_Comment5: " + cllToString(prm_Comment5) + "<br />"
    Response.Write "prm_LPU: " + cllToString(prm_LPU) + "<br />"
    Response.Write "prm_NumbProject: " + cllToString(prm_NumbProject) + "<br />"
    Response.Write "prm_CostContract: " + cllToNumber(prm_CostContract) + "<br />"
    Response.Write "prm_CostMontage: " + cllToNumber(prm_CostMontage) + "<br />"
    Response.Write "prm_Comment3: " + cllToString(prm_Comment3) + "<br />"
    Response.Write "prm_stat: " + cllToString(prm_stat) + "<br />"
    Response.Write "prm_RowPointer: " + cllToString(prm_RowPointer) + "<br />"
    Response.Write "prm_Login: " + cllToString(prm_Login) + "<br />"
    Response.Write "prm_returnValue: " + CStr(prm_returnValue) + "<br />"
    Response.Write "</div>"
  else
    anchor = ""
    if prm_outID <> 0 then
      anchor = "#A" + CStr(prm_outID)
    end if
    Response.redirect ("ImplPlan.asp" + anchor)
  end if

%>
  </div>
</body>
</html>
