using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace ERPSyte2.ViewOthers
{
    public partial class WebIdentity : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            #region user output
            string s = "<br/>";

            //s += "<p><b>ADS_NAME_TYPE_CANONICAL:</b> " + ADsUser.ADS_CANONICAL + "</p>";
            //s += "<p><b>ADS_NAME_TYPE_DISPLAY:</b> " + ADsUser.ADS_DISPLAY + "</p>";
            ////s += "<p><b>ADS_NAME_TYPE_DOMAIN_SIMPLE:</b> " + nameTranslate.Get((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_DOMAIN_SIMPLE) + "</p>";
            ////s += "<p><b>ADS_NAME_TYPE_ENTERPRISE_SIMPLE:</b> " + nameTranslate.Get((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_ENTERPRISE_SIMPLE) + "</p>";
            ////s += "<p><b>ADS_NAME_TYPE_GUID:</b> " + nameTranslate.Get((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_GUID) + "</p>";
            //s += "<p><b>ADS_NAME_TYPE_NT4:</b> " + ADsUser.ADS_NT4 + "</p>";
            //s += "<p><b>ADS_NAME_TYPE_USER_PRINCIPAL_NAME:</b> " + ADsUser.ADS_USER_PRINCIPAL_NAME + "</p>";

            s += "<br/>---<br/>";
            s += "<p><b>Name:</b> " + Classes.HCCurrentUser.Name + "</p>";
            s += "<p><b>Login:</b> " + Classes.HCCurrentUser.Login + "</p>";
            //s += "<p><b>AuthenticationType:</b> " + HttpContext.Current.User.Identity.AuthenticationType + "</p>";
            s += "<p><b>IsAuthenticated:</b> " + HttpContext.Current.User.Identity.IsAuthenticated.ToString() + "</p>";
            //s += "<p><b>Is role admin:</b> " + HttpContext.Current.User.IsInRole("admin").ToString() + "</p>";
            //s += "<p><b>Is role user:</b> " + HttpContext.Current.User.IsInRole("user").ToString() + "</p>";
            //s += "<p><b>Is role " + Global.gloRoleDomainAdminName + ":</b> " + HttpContext.Current.User.IsInRole(Global.gloRoleDomainAdminName).ToString() + "</p>";
            //s += "<p><b>Is role " + Global.gloRoleDomainUserName + ":</b> " + HttpContext.Current.User.IsInRole(Global.gloRoleDomainUserName).ToString() + "</p>";
            s += "<p><b>Is role " + Global.gloRoleAdminName + ":</b> " + HttpContext.Current.User.IsInRole(Global.gloRoleAdminName).ToString() + "</p>";
            s += "<p><b>Is role " + Global.gloRoleUserName + ":</b> " + HttpContext.Current.User.IsInRole(Global.gloRoleUserName).ToString() + "</p>";
            s += "<br/>";
            Response.Write(s);

            //ERPSyte2.Classes.LogonUserText.SaveToFile(Response, Request);
            #endregion

            tbUser.Text=Classes.ERPUser.Name;

        }

    }
}