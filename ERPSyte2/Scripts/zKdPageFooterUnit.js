(function (window, undefined) {
    "use strict";

    document.addEventListener("DOMContentLoaded", loadCurrYear);
    document.addEventListener("DOMContentLoaded", loadUserData);

    function loadCurrYear() {
        var cCurrYear = document.getElementById("ftCurrYear");
        if (cCurrYear)
            cCurrYear.innerHTML = new Date().getFullYear();
    }

    function loadUserData() {
        var cUserData = document.getElementById("ftUserData");
        if (cUserData) {
            cUserData.innerHTML = "0: n/a";
            getUserData();
        }
    }

    function getUserData() {
        try {
            $.ajax({
                url: "../Services/WCFService.svc/ajax/getServiceUserData",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: returnData,
                error: returnError
            });
        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnData(data) {
        try {

            var cUserData = document.getElementById("ftUserData");
            if (cUserData) {
                var vUID ="", vName = "";

                $.each(data, function (k, v) {
                    if (k === "UID") {
                        vUID = v;
                    } else if (k === "Name") {
                        vName = v;
                    }
                });

                cUserData.innerHTML = vUID + ": " + vName;
            }

        } catch (e) {
            alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
        }
    }

    function returnError(jqXHR, textStatus, errorThrown) {
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
    }

})(window);