using System;
using System.Web.Configuration;

namespace ERPSyte2
{
    public class dbCon
    {
        /// <summary>
        /// Возвращает строку соединения с ЕРП 
        /// </summary>
        /// <param name="auth_user">Логин клиента</param>
        /// <returns>
        /// строка соединения 
        /// </returns>
        public static string conERPString(string auth_user)
        {
            string ret_val =
                String.Format("{0}Application Name=ERP viewer", WebConfigurationManager.ConnectionStrings["ERPcs"].ConnectionString);

            if (auth_user != "")
                ret_val += " by " + auth_user;

            return ret_val + ";"; 
        }

        /// <summary>
        /// Возвращает строку соединения с базой ЕРП 
        /// </summary>
        public static string csERP
        {
            get
            {
                string n = Classes.HCCurrentUser.Login;
                string s = string.Format("{0}Application Name=ERP viewer", WebConfigurationManager.ConnectionStrings["ERPcs"].ConnectionString);
                if (n != "")
                {
                    s += " by " + n;
                }
                return s + ";";
            }
        }

        /// <summary>
        /// Возвращает строку соединения с базой командировок
        /// </summary>
        public static string csMS2
        {
            get
            {
                string n = Classes.HCCurrentUser.Login;
                string s = string.Format("{0}Application Name=WebMsViewer", WebConfigurationManager.ConnectionStrings["MS2cs"].ConnectionString);
                if (n != "")
                {
                    s += " by " + n;
                }
                return s + ";";
            }
        }

    }
}