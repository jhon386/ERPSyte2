<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestAjax.aspx.cs" Inherits="ERPSyte2.TestAjax" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>test ajax</title>
    <script type="text/javascript" src="Scripts/jquery-1.6.4.min.js"></script>
    <script type="text/javascript">

        function sendText() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            //alert("You send text: " + s);
            $.ajax({
                url: "http://localhost:18299/ErpWcfService.svc/GetData?",
                type: "GET",
                data: '{"value"="' + s + '"}',
                contentType: "application/javascript",
                jsonpCallback: "MyCallBack",
                datatype: "jsonp",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }
        function MyCallBack(data) {
            alert('success : ' + data);
        }

        function sendNumber() {
            var n1 = document.getElementById("tNumber1").value;
            var n2 = document.getElementById("tNumber2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/Add",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    document.getElementById("rNumber").value = data.d;
                    document.getElementById("rMathResult").value = data.d;
                    //alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }

        function sendDoubleJSON() {
            var n1 = document.getElementById("tDouble1").value;
            var n2 = document.getElementById("tDouble2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/DoMathJson",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var s = data.d.toString();
                    s = s + "\nsum=" + data.d.sum;
                    s = s + "\ndifference=" + data.d.difference;
                    s = s + "\nproduct=" + data.d.product;
                    s = s + "\nquotient=" + data.d.quotient;
                    document.getElementById("rMathResult").value = s;
                    //alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }

        function sendDoubleXML() {
            var n1 = document.getElementById("tDouble1").value;
            var n2 = document.getElementById("tDouble2").value;
            if (isNaN(n1) || (n1 == ""))
                n1 = 0;
            if (isNaN(n2) || (n2 == ""))
                n2 = 0;
            jQuery.support.cors = true;
            $.ajax({
                type: "POST",
                url: "http://SL-DB-SRV.elektron.spb.su/ErpAppService/ErpAppService.svc/DoMathXml",
                data: '{ "n1":"' + n1 + '", "n2":"' + n2 + '" }',
                datatype: "xml",
                contentType: "text/xml; charset=utf-8",
                success: function (data) {
                    //$(data).find("GetDataResponse").each(function () {
                    //    alert($(this).find("GetDataResult").text());
                    //});
                    //var s = "\ndata=" + data;
                    //s = s + "\ndata.toString()=" + data.toString();
                    //s = s + "\ndata.d=" + data.d;
                    //s = s + "\ndata.d.toString()=" + data.d.toString();
                    //s = s + "\ndata.sum=" + data.sum;
                    //s = s + "\ndata.d.sum=" + data.d.sum;
                    //document.getElementById("rMathResult").value = s;
                    alert("success: " + data.d);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
            //alert("You send numbers: n1=" + n1 + ", n2=" + n2);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>test ajax</h1>
            <br />
            Text&nbsp;
            <input type="text" id="tText" value="9" />
            &nbsp;
            <input type="button" id="bText" value="send Text" onclick="sendText1();" />
            <br />
            <br />
            Number1&nbsp;
            <input type="text" id="tNumber1" value="1.6" />
            &nbsp;
            Number2&nbsp;
            <input type="text" id="tNumber2" value="3.2" />
            &nbsp;
            <input type="button" id="bNumber" value="send Number" onclick="sendNumber();" />
            <br />
            <br />
            Double1&nbsp;
            <input type="text" id="tDouble1" value="5.4" />
            &nbsp;
            Double2&nbsp;
            <input type="text" id="tDouble2" value="7.8" />
            &nbsp;
            <input type="button" id="btnDoMathJson" value="Perform calculation (return JSON)" onclick="sendDoubleJSON();" />
            &nbsp;
            <input type="button" id="btnDoMathXml" value="Perform calculation (return XML)" onclick="sendDoubleXML();" />
            <br />
            <br />
            <h2>results</h2>
            result Text&nbsp;
            <input type="text" id="rText" value="" />
            <br />
            <br />
            result Number&nbsp;
            <input type="text" id="rNumber" value="" />
            <br />
            <br />
            result MathResult&nbsp;
            <textarea id="rMathResult" cols="50" rows="8"></textarea>
            <br />
            <br />
            <h3>WCFAjaxService</h3>
            <br />
            <br />
            <input type="button" value="Hello World" onclick="return callHelloWorld();" />
            <br />
            <br />
            <input type="button" value="Hello #" onclick="callHello();" />
        </div>
    </form>
    <script type="text/javascript">

        function sendText1() {
            var s = document.getElementById("tText").value;
            if (s == "")
                s = "n/a";

            alert("You send text: " + s);
            
            $.ajax({
                url: "http://erp-site/TestWCF/ErpWcfService.svc/GetData?'value'={'" + s + "'}",
                type: "GET",
                //data: '{"value"="' + s + '"}',
                contentType: "application/javascript",
                jsonpCallback: "MyCallBack",
                datatype: "jsonp",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }
        function MyCallBack(data) {
            alert('its MyCallBack : ' + data);
        }

        function callHelloWorld() {
            $.ajax({
                url: "WCFAjaxService.svc/HelloWorld",
                type: "POST",
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

        function callHello() {
            var s = "Bob";
            $.ajax({
                url: "WCFAjaxService.svc/Hello",
                type: "POST",
                data: '{"name"="' + s + '"}',
                datatype: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    //document.getElementById("rText").value = data.d;
                    //document.getElementById("rMathResult").value = data.d;
                    alert("success: " + data);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("error: " + jqXHR.toString() + "\n\njqXHR.status: " + jqXHR.status + "\n\njqXHR.statusText: " + jqXHR.statusText + "\n\nStatus: " + textStatus + "\n\nError: " + errorThrown);
                }
            });
        }

    </script>
</body>
</html>
