using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI;

namespace ERPSyte2
{
    public partial class ProcessNotBuy : System.Web.UI.Page
    {
        #region Private Variables
        protected DataSet dsDataSet = new DataSet();
        protected DataTable dtViewerData;
        #endregion

        private string conERPString
        {
            get { return dbCon.conERPString(Classes.HCCurrentUser.Name); }//get { return dbCon.conERPString(Request.LogonUserIdentity.Name); }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "Информация по процессу не закупаемая номенклатура";
            SqlConnection con = new SqlConnection(conERPString);
            con.Open();
            try
            {
                #region if (!IsPostBack)
                if (!IsPostBack)
                {
                    IsAnalogRegistered.Items.Add("все");
                    IsAnalogRegistered.Items.Add("Да");
                    IsAnalogRegistered.Items.Add("Нет");
                    IsAnalogApproved.Items.Add("все");
                    IsAnalogApproved.Items.Add("Да");
                    IsAnalogApproved.Items.Add("Нет");
                    IsEquivalentPush.Items.Add("все");
                    IsEquivalentPush.Items.Add("Да");
                    IsEquivalentPush.Items.Add("Нет");
                    IsVersionAdvance.Items.Add("все");
                    IsVersionAdvance.Items.Add("Да");
                    IsVersionAdvance.Items.Add("Нет");
                    IsApplyClosed.Items.Add("все");
                    IsApplyClosed.Items.Add("Да");
                    IsApplyClosed.Items.Add("Нет");
                    IsLeadTime999.Items.Add("все");
                    IsLeadTime999.Items.Add("Да");
                    IsLeadTime999.Items.Add("Нет");
                    IsLeadTime999.SelectedIndex = 1;
                }
                #endregion
                else
                {
                    //if (!ClientScript.IsStartupScriptRegistered("showWaitPanel"))
                    //Page.ClientScript.RegisterStartupScript(GetType(), "showWaitPanel", "showWaitPanel();", true);

                    //System.Threading.Thread.Sleep(2000);
                    DoApplyFilter(con);

                    //if (!ClientScript.IsStartupScriptRegistered("removeWaitPanel"))
                    //Page.ClientScript.RegisterStartupScript(GetType(), "removeWaitPanel", "removeWaitPanel();", true);
                }
                Page.DataBind();
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }

        private Byte TextToByte(String s)
        {
            return (Byte)((s == "Да") ? 1 : 0);
        }

        private void ShowMessage(String s)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "myalert", "alert('" + s + "');", true);
        }

        private void DoApplyFilter(SqlConnection Acon)
        {
            //Response.Write("<script>alert('DoApplyFilter');</script>");
            #region Private Variables
            string cItem = Item.Text;
            string cDescription = Description.Text;

            string cDateCode004From = "";
            DateTime dDateCode004From;
            if (DateTime.TryParse(DateCode004From.Text, out dDateCode004From))
                cDateCode004From = dDateCode004From.ToString("yyyyMMdd");

            string cDateCode004To = "";
            DateTime dDateCode004To;
            if (DateTime.TryParse(DateCode004To.Text, out dDateCode004To))
                cDateCode004To = dDateCode004To.ToString("yyyyMMdd");

            string cIsAnalogRegistered = IsAnalogRegistered.Text;
            string cIsAnalogApproved = IsAnalogApproved.Text;
            string cIsEquivalentPush = IsEquivalentPush.Text;
            string cIsVersionAdvance = IsVersionAdvance.Text;
            string cIsApplyClosed = IsApplyClosed.Text;
            string cIsLeadTime999 = IsLeadTime999.Text;
            string cLogin = Classes.HCCurrentUser.Login;
            #endregion

            SqlConnection con = Acon;
            if (con == null)
                con = new SqlConnection(conERPString);
            if (con.State != ConnectionState.Open)
                con.Open();
            try
            {
                SqlDataAdapter da = new SqlDataAdapter("zKdx_ProcessNotBuy_Show", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                #region Parameters SqlDataAdapter
                da.SelectCommand.Parameters.Add("@Item", SqlDbType.NVarChar, 30).Value = cItem;
                da.SelectCommand.Parameters.Add("@Description", SqlDbType.NVarChar, 150).Value = cDescription;
                da.SelectCommand.Parameters.Add("@pDateCode004From", SqlDbType.NVarChar, 50).Value = cDateCode004From;
                da.SelectCommand.Parameters.Add("@pDateCode004To", SqlDbType.NVarChar, 50).Value = cDateCode004To;
                da.SelectCommand.Parameters.Add("@pIsAnalogRegistered", SqlDbType.NVarChar, 50).Value = cIsAnalogRegistered;
                da.SelectCommand.Parameters.Add("@pIsAnalogApproved", SqlDbType.NVarChar, 50).Value = cIsAnalogApproved;
                da.SelectCommand.Parameters.Add("@pIsEquivalentPush", SqlDbType.NVarChar, 50).Value = cIsEquivalentPush;
                da.SelectCommand.Parameters.Add("@pIsVersionAdvance", SqlDbType.NVarChar, 50).Value = cIsVersionAdvance;
                da.SelectCommand.Parameters.Add("@pIsApplyClosed", SqlDbType.NVarChar, 50).Value = cIsApplyClosed;
                da.SelectCommand.Parameters.Add("@pIsLeadTime999", SqlDbType.NVarChar, 50).Value = cIsLeadTime999;
                da.SelectCommand.Parameters.Add("@Login", SqlDbType.NVarChar, 128).Value = cLogin;
                da.SelectCommand.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);
                #endregion

                dsDataSet.Clear();
                da.Fill(dsDataSet, "ViewerData");
                dtViewerData = dsDataSet.Tables["ViewerData"];

                Int32 dAccessRight = 0;
                if (dtViewerData.Rows.Count > 0) 
                {
                    dAccessRight = (Int32)dtViewerData.Rows[0]["AccessRight"];
                }
                Boolean EquivalentPush_Grant = (dAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight
                Boolean VersionAdvance_Grant = (dAccessRight & 32) == 32; //ProcessNotBuy. Начальник КБ (или лицо его заменяющее). dbo.zKd_UserRight

                this.GridViewData.Columns[5].Visible = !EquivalentPush_Grant;
                this.GridViewData.Columns[6].Visible = EquivalentPush_Grant;
                this.GridViewData.Columns[7].Visible = !VersionAdvance_Grant;
                this.GridViewData.Columns[8].Visible = VersionAdvance_Grant;

                try
                {
                    GridViewData.DataSource = dtViewerData;
                    GridViewData.DataBind();
                }
                catch (Exception x)
                {
                    throw new ApplicationException(x.GetBaseException().ToString());
                    //MessageBox.Show(x.GetBaseException().ToString(), "Error",
                    //        MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                finally
                {
                    if (da != null)
                    {
                        da.Dispose();
                    }
                }
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open && Acon == null)
                {
                    con.Close();
                }
            }

        }



        protected int GetFieldValue(object dataItem, string fieldName)
        {
            int value;
            if (!Int32.TryParse(DataBinder.Eval(dataItem, fieldName).ToString(), out value))
                value = 0;
            return value;
        }

        protected Color GetBackColor(object dataItem, string fieldName)
        {
            return GetFieldValue(dataItem, fieldName) == 1 ? Color.FromArgb(102, 255, 102) : Color.FromArgb(255, 102, 102);
        }

        protected string GetStatusText(object dataItem, string fieldName)
        {
            return GetFieldValue(dataItem, fieldName) == 1 ? "Да" : "Нет";
        }

        protected string GetToolTipText(object dataItem, string fieldName)
        {
            return GetFieldValue(dataItem, fieldName) == 1 ? "Нажмите, чтобы снять метку" : "Нажмите, чтобы установить метку";
        }



        protected void SaveOper(string procName, string item, byte value)
        {
            using (SqlConnection con = new SqlConnection(conERPString))
            {
                using (SqlCommand cmd = new SqlCommand(procName, con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@Item", SqlDbType.NVarChar, 30).Value = item;
                    cmd.Parameters.Add("@Value", SqlDbType.TinyInt, 0).Value = value;
                    cmd.Parameters.Add("@Login", SqlDbType.NVarChar, 128).Value = Classes.HCCurrentUser.Login;
                    SqlParameter infobarParameter = cmd.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);
                    infobarParameter.Direction = ParameterDirection.Output;
                    SqlParameter returnParameter = cmd.Parameters.Add("@ReturnValue", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    con.Open();
                    cmd.ExecuteNonQuery();
                    string Infobar = Convert.ToString(infobarParameter.Value);
                    int result = Convert.ToInt32(returnParameter.Value);
                    if (result != 0)
                        ShowMessage(String.Format("Код: {0}. Ошибка: {1}", result.ToString(), Infobar));
                    else
                        DoApplyFilter(null);
                }
            }
        }

        protected void GridViewData_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            String[] Argument = Convert.ToString(e.CommandArgument.ToString()).Split(',');
            String item = Argument[0];
            byte value;
            if (!byte.TryParse(Argument[1], out value))
                value = 0;
            if (e.CommandName == "IsEquivalentPush")
                SaveOper("zKdx_ProcessNotBuy_EquivalentPushOper", item, value);
            if (e.CommandName == "IsVersionAdvance")
                SaveOper("zKdx_ProcessNotBuy_VersionAdvanceOper", item, value);
        }

    }
}