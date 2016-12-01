<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProcessNotBuy.aspx.cs" Inherits="ERPSyte2.ProcessNotBuy" MasterPageFile="~/Site.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server" ID="HeadContent">
    <link type="text/css" rel="Stylesheet" href="Content/themes/base/jquery-ui.css" />
    <script type="text/javascript" src="Scripts/jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery-ui-1.10.4.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.blockUI.min.js"></script>
    <script type="text/javascript" src="Scripts/DatePickerReady.js"></script>
    <script type="text/javascript" src="Scripts/d3.min.js"></script>
    <script type="text/javascript" src="Scripts/QCD_ExportExcel.js"></script>
    <script type="text/javascript">
        function showWaitPanel() {
            $.blockUI({ message: '<h1><img src="Image/49.gif" /> Just a moment...</h1>' });
        }
        function removeWaitPanel() {
            $.unblockUI();
        }
    </script>
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
    <div id="tabs" style="width: auto; margin-left: 0px;">
        <h3 style="text-align:center; margin-bottom:10px;">Информация по процессу незакупаемая номенклатура</h3>
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
                        <asp:Button ID="ApplyFilter" runat="server" Text="Применить" />
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
</asp:Content>
