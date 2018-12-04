<%
  ' показать ошибку
  sub showError(ACode, AMessage)
    Response.Write "<div style=""text-align: left; background-color: InfoBackground; padding: 20px;"">"
    Response.Write "<h3>Ошибка:</h3>"
    Response.Write "код: " + CStr(ACode)
    Response.Write "<br>"
    Response.Write "текст: " + CStr(AMessage) 
    Response.Write "</div>"
  end sub
  
  ' показать информацию
  sub showInfo(ACaption, AText)
    Response.Write "<div style=""text-align: left; background-color: InfoBackground; padding: 20px;"">"
    Response.Write "<h3>" + CStr(ACaption) + "</h3>"
    Response.Write CStr(AText) 
    Response.Write "</div>"
  end sub
  
  ' значение в разметку
  function valToHTML(AValue)
    if not IsNull(AValue) and Trim(AValue) <> "" then
      valToHTML = AValue
    else
      valToHTML = "<br />"
    end if
  end function

  ' округление
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
  
  ' код в якорь
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