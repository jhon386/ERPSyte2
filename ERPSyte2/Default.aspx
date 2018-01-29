<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ERPSyte2._Default" MasterPageFile="~/ViewOthers/Site.Master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="margin: 30px 20px 10px 20px">
        <asp:HyperLink ID="hlIntSrv" runat="server" NavigateUrl="http://int-srv/">int-srv</asp:HyperLink>
        <br />
        <br />
        <hr />
        <asp:HyperLink ID="hlProcNotBuy" runat="server" NavigateUrl="~/ViewOthers/ProcNotBuy.aspx">Информация по процессу незакупаемая номенклатура</asp:HyperLink>
        <br />
        <br />
        <a href="ViewOthers/ProcNotBuyItems.html">ProcNotBuyItems</a>
        <br />
        <br />
        <hr />
        <asp:HyperLink ID="hlQCDViewer" runat="server" NavigateUrl="~/ViewOthers/QCDViewer.aspx">Журнал входного контроля</asp:HyperLink>
        <br />
        <br />
        <a href="ViewOthers/QCDjournal.html">QCDjournal</a>
        <br />
        <br />
        <a href="ViewOthers/QCDtest.html">QCDtest</a>
        <br />
        <br />
        <a href="N:\ОТК\Журнал Испытаний\Журнал испытаний 2011-2014.xlsx">Журнал ПСИ</a>
        <br />
        <br />
        <hr />
        <asp:HyperLink ID="hlUserIdentity" runat="server" NavigateUrl="~/ViewOthers/UserIdentity.aspx">Пользователь</asp:HyperLink>
        <br />
        <br />
        <asp:HyperLink ID="hlTestAjax" runat="server" NavigateUrl="~/TestPages/TestAjax.aspx">Test Ajax AspNet</asp:HyperLink>
        <br />
        <asp:HyperLink ID="s" runat="server" NavigateUrl="~/TestPages/TestAjaxWOAspNet.html">Test Ajax with out AspNet</asp:HyperLink>
        <br />
        <a href="TestPages/TestPage1.html">TestPage1</a>
        <br />
        <a href="TestPages/HTML5CanvasGoogleBouncingBalls.html">TestPages/HTML5CanvasGoogleBouncingBalls.html</a>
    </div>
</asp:Content>