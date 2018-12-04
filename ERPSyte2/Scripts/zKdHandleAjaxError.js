// this unit must be first into the declaration scripts of the html file

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