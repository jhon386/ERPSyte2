<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProcNotBuy.aspx.cs" Inherits="ERPSyte2.ViewOthers.ProcNotBuy" MasterPageFile="~/ViewOthers/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">
    <link href="../Content/themes/base/jquery-ui.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.6.4.min.js"></script>
    <script src="../Scripts/jquery-ui-1.10.4.min.js"></script>
    <script src="../Scripts/jquery.blockUI.min.js"></script>
    <script src="../Scripts/DatePickerReady.js"></script>
    <script src="../Scripts/zKdDateFormatUnit.js"></script>
    <style type="text/css">
        .bar {
            fill: steelblue;
        }

            .bar:hover {
                fill: brown;
            }

        .axis {
            font: 10px sans-serif;
        }

            .axis path,
            .axis line {
                fill: none;
                stroke: #000;
                shape-rendering: crispEdges;
            }

        .x.axis path {
            display: none;
        }

        .arc path {
            stroke: #fff;
        }

        .bar1 {
            fill: steelblue;
        }

        .bar2 {
            fill: orange;
        }
        .auto-style1 {
            width: 18px;
            height: 20px;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server"></asp:UpdatePanel>
    <div id="tabs" style="width: auto; margin-left: 0px;">
        <h3 style="text-align:center; margin-bottom:10px;">Информация по процессу незакупаемая номенклатура
        </h3>
        <ul>
            <li><a href="#tabs-1">Данные</a></li>
            <li><a href="#tabs-2">Фильтр</a></li>
        </ul>
        <div id="tabs-1">
            <asp:GridView ID="GridViewData" runat="server" AutoGenerateColumns="False" BorderStyle="Solid" BorderWidth="1px" CssClass="cgrid" PageSize="50" EnableViewState="False" OnRowCommand="GridViewData_RowCommand">
                <Columns>
                    <asp:BoundField HeaderText="Код ERP" DataField="Item" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolnw" />
                    <asp:BoundField HeaderText="Название" DataField="Description" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcol" />
                    <asp:BoundField HeaderText="Дата присвоения группы 004" DataField="DateCode004" DataFormatString="{0:dd.MM.yyyy}" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct" />
                    <asp:TemplateField HeaderText="Процесс «Регистрация аналога» запущен" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsAnalogRegistered").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Аналог утвержден" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsAnalogApproved").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Введение эквивалентных замен" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsEquivalentPush").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Введение эквивалентных замен" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <%--<asp:Label ID="Label4" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsEquivalentPush").ToString()=="1") ? "Да ": "" %>'></asp:Label>--%>
                            <asp:Button ID="EquivalentPushButton" runat="server" 
                                BackColor='<%# GetBackColor(Container.DataItem, "IsEquivalentPush") %>' 
                                CommandName="IsEquivalentPush"
                                CommandArgument='<%# Eval("Item") + "," + Eval("IsEquivalentPush") %>'
                                Text='<%# GetStatusText(Container.DataItem, "IsEquivalentPush") %>' 
                                ToolTip='<%# GetToolTipText(Container.DataItem, "IsEquivalentPush") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ИИ проведены" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsVersionAdvance").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ИИ проведены" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <%--<asp:Label ID="Label6" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsVersionAdvance").ToString()=="1") ? "Да ": "" %>'></asp:Label>--%>
                            <asp:Button ID="VersionAdvanceButton" runat="server" 
                                BackColor='<%# GetBackColor(Container.DataItem, "IsVersionAdvance") %>'
                                CommandName="IsVersionAdvance"
                                CommandArgument='<%# Eval("Item") + "," + Eval("IsVersionAdvance") %>' 
                                Text='<%# GetStatusText(Container.DataItem, "IsVersionAdvance") %>'
                                ToolTip='<%# GetToolTipText(Container.DataItem, "IsVersionAdvance") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Применяемость закрыта" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label7" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsApplyClosed").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Срок опережения 999" HeaderStyle-CssClass="hdcol" ItemStyle-CssClass="itcolct">
                        <ItemTemplate>
                            <asp:Label ID="Label8" runat="server" Text='<%# (DataBinder.Eval(Container.DataItem, "IsLeadTime999").ToString()=="1") ? "Да": "" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div id="tabs-2">
            <table style="background-color: ButtonFace;">
                <tr>
                    <td>Код ERP</td>
                    <td colspan="4">
                        <asp:TextBox ID="Item" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Название</td>
                    <td colspan="4">
                        <asp:TextBox ID="Description" runat="server" Style="width: 100%;"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Дата присвоения группы 004</td>
                    <td>с</td>
                    <td>
                        <asp:TextBox ID="DateCode004From" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                    <td>по</td>
                    <td>
                        <asp:TextBox ID="DateCode004To" runat="server" CssClass="datefield"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td>Процесс «Регистрация аналога» запущен</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsAnalogRegistered" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>Аналог утвержден</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsAnalogApproved" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>Введение эквивалентных замен</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsEquivalentPush" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>ИИ проведены</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsVersionAdvance" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>Применяемость закрыта</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsApplyClosed" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <td>Срок опережения 999</td>
                    <td colspan="4">
                        <asp:DropDownList ID="IsLeadTime999" runat="server" Style="width: 100%;"></asp:DropDownList>
                    </td>
                </tr>


                <tr>
                    <td colspan="5" class="tdcntr" style="padding-top: 20px; padding-bottom: 30px;">
                        <asp:Button ID="ApplyFilter" runat="server" Text="Применить (server side)" />
                        <br />
                        <input type="button" id="buttonApplyFilter" onclick="return ajaxApplyFilter();" value="Применить (ajax)" />
                        <%--&nbsp;&nbsp;&nbsp;--%>
                        <%--<input type="button" id="btnExport3" value="Экспорт в Excel" onclick="GetParamAndExport()" /> --%>
                        <%--<a style ="font-size: 10px; font-family:Arial, sans-serif; vertical-align:super " href ="http://int-srv/Help/HelpExcel/HelpExcel.html">Настройка экспорта</a>--%>
                    </td>
                </tr>

                <tr style="border-style: solid; border-width: 1px; border-color: #666666;">
                    <td colspan="5" class="tdcntr" style="padding-top: 5px; padding-bottom: 10px; background-color: #FFFFDB;">
                        <h3 style="color: #666666;">Совет:</h3>
                        <strong style="color: #666666">Применяйте * для нечеткого поиска по обозначению и/или наименованию.
                        </strong>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr style="border-style: solid; border-width: 1px; border-color: #666666;">
                    <td colspan="5" class="tdcntr" style="padding-top: 5px; padding-bottom: 10px; background-color: #FFFFDB;">
                        <h3 style="color: #FF6666;">Внимание!</h3>
                        <strong style="color: #666666">В связи с большим временем обработки запроса,
                            <br />
                            всегда старайтесь максимально ограничить получаемую выборку,
                            <br />
                            применяя все возможные доступные фильтры.
                        </strong>
                    </td>
                </tr>
            </table>
<%--            <asp:ValidationSummary runat="server" ID="Summary" DisplayMode="BulletList"
                HeaderText="Пожалуйста, исправьте следующие ошибки:" ShowSummary="true" ShowMessageBox="true" />--%>
        </div>
    </div>
    <script type="text/javascript">
        $("#tabs").tabs({ cookie: { expires: 1 } });

        $("#ApplyFilter").button();
    </script>
    <script type="text/javascript">
        function ajaxApplyFilter() {
            try {
                var cItem = document.getElementById('<%= Item.ClientID %>');
                var cDescription = document.getElementById('<%= Description.ClientID %>');
                var cDateCode004From = document.getElementById('<%= DateCode004From.ClientID %>');
                var cDateCode004To = document.getElementById('<%= DateCode004To.ClientID %>');
                var cIsAnalogRegistered = document.getElementById('<%= IsAnalogRegistered.ClientID %>');
                var cIsAnalogApproved = document.getElementById('<%= IsAnalogApproved.ClientID %>');
                var cIsEquivalentPush = document.getElementById('<%= IsEquivalentPush.ClientID %>');
                var cIsVersionAdvance = document.getElementById('<%= IsVersionAdvance.ClientID %>');
                var cIsApplyClosed = document.getElementById('<%= IsApplyClosed.ClientID %>');
                var cIsLeadTime999 = document.getElementById('<%= IsLeadTime999.ClientID %>');
                var cLogin = '<%= @HttpContext.Current.User.Identity.Name.Split('\\')[1] %>';

                var filterData = [];
                filterData[0] = cItem.value;
                filterData[1] = cDescription.value;
                filterData[2] = (cDateCode004From.value == "") ? "" : cDateCode004From.value.split('.').reverse().join('');
                filterData[3] = (cDateCode004To.value == "") ? "" : cDateCode004To.value.split('.').reverse().join('');
                filterData[4] = cIsAnalogRegistered.options[cIsAnalogRegistered.selectedIndex].value;
                filterData[5] = cIsAnalogApproved.options[cIsAnalogApproved.selectedIndex].value;
                filterData[6] = cIsEquivalentPush.options[cIsEquivalentPush.selectedIndex].value;
                filterData[7] = cIsVersionAdvance.options[cIsVersionAdvance.selectedIndex].value;
                filterData[8] = cIsApplyClosed.options[cIsApplyClosed.selectedIndex].value;
                filterData[9] = cIsLeadTime999.options[cIsLeadTime999.selectedIndex].value;
                filterData[10] = cLogin;
                var postData = '{ "aData":' + JSON.stringify(filterData) + '}';
            
                $.ajax({
                    url: "../Services/WCFService.svc/ajax/getProcessNotBuyRows",
                    type: "POST",
                    data: postData,
                    datatype: "json",
                    contentType: "application/json; charset=utf-8",
                    beforeSend: function () { $.blockUI(); },
                    complete: function () { $.unblockUI(); },
                    success: returnData,
                    error: returnError
                });

                return false;
            } catch (e) {
                alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
            }
        }
        
        function returnData(data) {
            try {
                //var row = $("[id*=GridViewData] tr:last-child").clone(true);
                $("[id*=GridViewData] tr").not($("[id*=GridViewData] tr:first-child")).remove();

                var vItem = "",
                vDescription = "",
                vDateCode004 = "",
                vIsAnalogRegistered = "",
                vIsAnalogApproved = "",
                vIsEquivalentPush = "",
                vIsVersionAdvance = "",
                vIsApplyClosed = "",
                vIsLeadTime999 = "";

                $.each(data, function (k, v) {

                    vItem = "&nbsp;";
                    vDescription = "&nbsp;";
                    vDateCode004 = "&nbsp;";
                    vIsAnalogRegistered = "&nbsp;";
                    vIsAnalogApproved = "&nbsp;";
                    vIsEquivalentPush = "&nbsp;";
                    vIsVersionAdvance = "&nbsp;";
                    vIsApplyClosed = "&nbsp;";
                    vIsLeadTime999 = "&nbsp;";

                    $.each(this, function (k1, v1) {
                        if (k1 === "Item") {
                            vItem = v1;
                        } else if (k1 === "Description") {
                            vDescription = v1;
                        } else if (k1 === "DateCode004" && v1 !== null && v1 != "") {
                            vDateCode004 = zKdDateFormat(new Date(parseInt(v1.substr(6))));
                        } else if (k1 === "IsAnalogRegistered") {
                            vIsAnalogRegistered = (v1 === 1) ? "Да" : "&nbsp;";
                        } else if (k1 === "IsAnalogApproved") {
                            vIsAnalogApproved = (v1 === 1) ? "Да" : "&nbsp;";
                        } else if (k1 === "IsEquivalentPush") {
                            vIsEquivalentPush = (v1 === 1) ? "Да" : "&nbsp;";
                        } else if (k1 === "IsVersionAdvance") {
                            vIsVersionAdvance = (v1 === 1) ? "Да" : "&nbsp;";
                        } else if (k1 === "IsApplyClosed") {
                            vIsApplyClosed = (v1 === 1) ? "Да" : "&nbsp;";
                        } else if (k1 === "IsLeadTime999") {
                            vIsLeadTime999 = (v1 === 1) ? "Да" : "&nbsp;";
                        }

                    });

                    $("[id*=GridViewData]").append("<tr><td>" +
                    vItem + "</td><td>" +
                    vDescription + "</td><td>" +
                    vDateCode004 + "</td><td>" +
                    vIsAnalogRegistered + "</td><td>" +
                    vIsAnalogApproved + "</td><td>" +
                    vIsEquivalentPush + "</td><td>" +
                    vIsVersionAdvance + "</td><td>" +
                    vIsApplyClosed + "</td><td>" +
                    vIsLeadTime999 + "</td></tr>");

                    //$("[id*=GridViewData]").append(row);
                    //row = $("[id*=GridViewData] tr:last-child").clone(true);

                });

            } catch (e) {
                alert(' Произошла ошибка: ' + e.name + ' ' + e.message);
            } finally {
                $.unblockUI();
            }
        }

        function returnError(jqXHR, textStatus, errorThrown) {
            try{
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
            } finally {
                $.unblockUI();
            }
        }

    </script>
</asp:Content>
