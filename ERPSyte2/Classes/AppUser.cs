using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace ERPSyte2.Classes
{
    public class HCCurrentUser
    {
        public static string Name { get { return HttpContext.Current.User.Identity.Name; } }
        public static bool IsAuthenticated { get { return HttpContext.Current.User.Identity.IsAuthenticated; } }
        public static string AuthenticationType { get { return HttpContext.Current.User.Identity.AuthenticationType; } }
        public static string Login { get {
                string s = Name;
                int i = s.LastIndexOf("\\");
                if ((i > -1) && (i < s.Length))
                {
                    s = s.Substring(i + 1).ToLower();
                }
                return s; 
            } 
        }
    }

    public class ADsUser
    {
        private static string ADsObject(int ADsPath)
        {
            ActiveDs.NameTranslate nameTranslate = new ActiveDs.NameTranslate();
            nameTranslate.Set((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_NT4, HCCurrentUser.Name);
            return nameTranslate.Get(ADsPath);
        }

        public static string ADS_1779 { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_1779);} }
        public static string ADS_CANONICAL { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_CANONICAL); } }
        public static string ADS_CANONICAL_EX { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_CANONICAL_EX); } }
        public static string ADS_DISPLAY { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_DISPLAY); } }
        public static string ADS_DOMAIN_SIMPLE { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_DOMAIN_SIMPLE); } }
        public static string ADS_ENTERPRISE_SIMPLE { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_ENTERPRISE_SIMPLE); } }
        public static string ADS_GUID { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_GUID); } }
        public static string ADS_NT4 { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_NT4); } }
        public static string ADS_USER_PRINCIPAL_NAME { get { return ADsObject((int)ActiveDs.ADS_NAME_TYPE_ENUM.ADS_NAME_TYPE_USER_PRINCIPAL_NAME); } }

    }

    public class ERPUser
    {
        public static bool IsAuthenticated { get { return UID != 0; } }
        public static string Name
        {
            get
            {
                string u = string.Empty;

                using (SqlConnection con = new SqlConnection(dbCon.csERP))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("zKdcm_GetUser", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@login", SqlDbType.NVarChar, 30).Value = HCCurrentUser.Login;
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                u = string.Format("{0}", rdr["UserDesc"]);
                            }

                            if (u == "")
                                u = HCCurrentUser.Name;

                            if (rdr != null && !rdr.IsClosed)
                                rdr.Close();
                        }
                        if (cmd != null)
                            cmd.Dispose();
                    }
                    if (con != null && con.State == ConnectionState.Open)
                        con.Close();
                }

                return u;
            }
        }
        public static int UID
        {
            get
            {
                int u = 0;

                using (SqlConnection con = new SqlConnection(dbCon.csERP))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "zKdcm_GetUser";
                        cmd.Parameters.Add("@login", SqlDbType.NVarChar, 30).Value = HCCurrentUser.Login;
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            //rdr.Read();
                            //if ((rdr.HasRows) && (!rdr.IsDBNull(rdr.GetOrdinal("UID"))))
                            //if ((rdr.HasRows) && (rdr["UID"] != DBNull.Value))
                            //if ((rdr.HasRows) && (!DBNull.Value.Equals(rdr["UID"])))
                            //if (rdr.HasRows)
                            if (rdr.Read())
                                u = Convert.ToInt32(rdr["UID"]);
                            //    u = rdr["UID"] as int? ?? default(int);
                            //    u = (int)rdr["UID"];
                            //    u = (int)rdr.GetValue(rdr.GetOrdinal("UID"));
                            
                            //while (rdr.Read())
                            //{
                            //    u = Convert.ToInt32(rdr["UID"]);
                            //    u = ((int)rdr.["UID"].Value);
                            //}

                            //if (read.Read())
                            //{
                            //    int colIndex = rdr.GetOrdinal("UID");
                            //    maskedTextBox2.Text = rdr.IsDBNull(colIndex) ?
                            //                   string.Empty :
                            //                   rdr.GetDateTime(colIndex).ToString("MM/dd/yyyy");
                            //}

                            if (rdr != null && !rdr.IsClosed)
                                rdr.Close();
                        }
                        if (cmd != null)
                            cmd.Dispose();
                    }
                    if (con != null && con.State == ConnectionState.Open)
                        con.Close();
                }

                return u;
            }
        }
    }
}