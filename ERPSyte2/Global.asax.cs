using System;

namespace ERPSyte2
{
    public class Global : System.Web.HttpApplication
    {
        protected static string _DomainName = "ELEKTRON";
        protected static string _RoleAdminName = "el_test_admin";
        protected static string _RoleUserName = "el_test_user";

        public static string gloDomainName { get { return _DomainName; } }
        public static string gloRoleAdminName { get { return _RoleAdminName; } }
        public static string gloRoleUserName { get { return _RoleUserName; } }
        public static string gloRoleDomainAdminName { get { return _DomainName + "\\" + _RoleAdminName; } }
        public static string gloRoleDomainUserName { get { return _DomainName + "\\" + _RoleUserName; } }

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {
            //Response.Write("<b>Возникла ошибка: </b><hr/>");
            //Response.Write(Server.GetLastError().Message.ToString() + "<hr/>" + Server.GetLastError().ToString());
            //Server.ClearError();
        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}