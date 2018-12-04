<%
  ' �������� ������
  sub showError(ACode, AMessage)
    Response.Write "<div style=""text-align: left; background-color: InfoBackground; padding: 20px;"">"
    Response.Write "<h3>������:</h3>"
    Response.Write "���: " + CStr(ACode)
    Response.Write "<br>"
    Response.Write "�����: " + CStr(AMessage) 
    Response.Write "</div>"
  end sub
  
  ' �������� ����������
  sub showInfo(ACaption, AText)
    Response.Write "<div style=""text-align: left; background-color: InfoBackground; padding: 20px;"">"
    Response.Write "<h3>" + CStr(ACaption) + "</h3>"
    Response.Write CStr(AText) 
    Response.Write "</div>"
  end sub
  
  ' �������� � ��������
  function valToHTML(AValue)
    if not IsNull(AValue) and Trim(AValue) <> "" then
      valToHTML = AValue
    else
      valToHTML = "<br />"
    end if
  end function

  ' ����������
  function valRound(AValue)
    if not IsNull(AValue) and AValue <> "" then
      AValue = Replace(Replace(AValue," ",""),",",".")
      if IsNumeric(AValue) then
        valRound = Replace(FormatNumber(Round(AValue, 0), 0, false, false, true), "'", " ") 
      else
        valRound = AValue
      end if
    else
      valRound = AValue
    end if
  end function
  
  ' ��� � �����
  function valToAnchor(AValue)
    valToAnchor = ""

    if not IsNull(AValue) and Trim(AValue) <> "" then
      AValue = Replace(AValue," ","")
      if IsNumeric(AValue) then
        valToAnchor = "id = ""A" + CStr(AValue) + """"
      end if
    end if
  end function
%>