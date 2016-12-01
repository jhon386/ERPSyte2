<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ERPSyte2._Default" MasterPageFile="~/Site.Master" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="margin: 30px 20px 10px 20px">
        <asp:HyperLink ID="hlIntSrv" runat="server" NavigateUrl="http://int-srv/">int-srv</asp:HyperLink>
        <br />
        <br />
        <asp:HyperLink ID="hlQCDViewer" runat="server" NavigateUrl="~/QCDViewer.aspx">Журнал входного контроля</asp:HyperLink>
        <br />
        <br />
        <a href="N:\ОТК\Журнал Испытаний\Журнал испытаний 2011-2014.xlsx">Журнал ПСИ</a>
        <br />
        <br />
        <asp:HyperLink ID="hlUserIdentity" runat="server" NavigateUrl="~/UserIdentity.aspx">Пользователь</asp:HyperLink>
        <br />
        <br />
        <asp:HyperLink ID="hlTestAjax" runat="server" NavigateUrl="~/TestAjax.aspx">Test Ajax</asp:HyperLink>
    </div>
</asp:Content>