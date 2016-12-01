using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace ERPSyte2
{
    public partial class QCDViewer : System.Web.UI.Page
    {
        #region Private Variables
        protected DataSet dsDataSet = new DataSet();
        protected DataTable dtViewerData;
        protected DataTable dtViewerDetails;
        protected DataTable dtViewerVendors;
        protected DataTable dtViewerVendors2;
        #endregion

        private string conERPString 
        {
            get { return dbCon.conERPString(Classes.HCCurrentUser.Name); }//get { return dbCon.conERPString(Request.LogonUserIdentity.Name); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "Журнал верификации закупленной продукции";
            SqlConnection con = new SqlConnection(conERPString);
            con.Open();
            try
            {
                // Выполнить инициализацию, только если страница запрашивается впервые. 
                // После этого данная информация отслеживается в состоянии представления
                #region if (!IsPostBack)
                if (!IsPostBack)
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader rdr = null;
                    try
                    {
                        #region инициализация справочников и временнЫх границ
                        //DateRecordTo.Text = DateTime.Now.ToShortDateString();
                        DateTransferTo.Text = DateTime.Now.ToShortDateString();
                        //DateAcceptTo.Text = DateTime.Now.ToShortDateString();

                        //DateRecordFrom.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
                        DateTransferFrom.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
                        //DateAcceptFrom.Text = DateTime.Now.AddMonths(-1).ToShortDateString();

                        int dtpwidth = 150;

                        //DateRecordTo.Width = dtpwidth;
                        DateTransferTo.Width = dtpwidth;
                        DateAcceptTo.Width = dtpwidth;

                        //DateRecordFrom.Width = dtpwidth;
                        DateTransferFrom.Width = dtpwidth;
                        DateAcceptFrom.Width = dtpwidth;

                        //DateRecordTo2.Width = dtpwidth;
                        DateTransferTo2.Width = dtpwidth;
                        DateAcceptTo2.Width = dtpwidth;

                        //DateRecordFrom2.Width = dtpwidth;
                        DateTransferFrom2.Width = dtpwidth;
                        DateAcceptFrom2.Width = dtpwidth;


                        Repeated.Items.Add("все");
                        Repeated.Items.Add("повторные");
                        Repeated.Items.Add("первичные");

                        VendN.Items.Add("все");
                        VendN.Items.Add("Электрон");
                        VendN.Items.Add("внешние");

                        Scrap.Items.Add("все");
                        Scrap.Items.Add("с браком");
                        Scrap.Items.Add("без брака");

                        ShowTo.Items.Add("все");
                        ShowTo.Items.Add("Кооперация");
                        ShowTo.Items.Add("Закупка");
                        ShowTo.Text = "Кооперация";
                        #endregion

                        #region инициализация справочника Единицы измерения
                        UMs.Items.Add("все");

                        cmd.CommandText = "zKdx_QCD_UMsSp";
                        try
                        {
                            rdr = cmd.ExecuteReader();
                            while (rdr.Read())
                            {
                                UMs.Items.Add(String.Format("{0}", rdr["u_m"]));
                            }
                        }
                        catch
                        {
                            throw new ApplicationException("Ошибка получения данных Единицы измерения");
                        }
                        finally
                        {
                            if (rdr != null && !rdr.IsClosed)
                            {
                                rdr.Close();
                            }
                        }
                        #endregion

                        #region инициализация справочника Тема НИОКР
                        TemaNIOKR.Items.Add("все");
                        TemaNIOKR.Items.Add("не НИОКР");
                        TemaNIOKR.Items.Add("только НИОКР");

                        cmd.CommandText = "zKdx_QCD_TemaNIOKRSp";
                        try
                        {
                            rdr = cmd.ExecuteReader();
                            while (rdr.Read())
                            {
                                TemaNIOKR.Items.Add(String.Format("{0}", rdr["TemaNIOKR"]));
                            }
                        }
                        catch
                        {
                            throw new ApplicationException("Ошибка получения данных Тема НИОКР");
                        }
                        finally
                        {
                            if (rdr != null && !rdr.IsClosed)
                            {
                                rdr.Close();
                            }
                        }
                        #endregion

                        #region инициализация справочника Контролер
                        Checker.Items.Add("все");

                        cmd.CommandText = "zKdx_QCD_CheckerNameSp";
                        try
                        {
                            //con.Open();
                            rdr = cmd.ExecuteReader();
                            //Checker.DataSource = rdr;
                            //Checker.DataBind();
                            while (rdr.Read())
                            {
                                Checker.Items.Add(String.Format("{0}", rdr["CheckerName"]));
                            }
                        }
                        catch
                        {
                            throw new ApplicationException("Ошибка получения данных Контролер");
                        }
                        finally
                        {
                            if (rdr != null && !rdr.IsClosed)
                            {
                                rdr.Close();
                            }
                        }
                        #endregion
                    }
                    finally
                    {
                        if (cmd != null)
                        {
                            cmd.Dispose();
                        }
                    }
                    //Response.Write("<script>alert('Page_Load !!!IsPostBack');</script>");
                }
                #endregion
                //else
                //    Response.Write("<script>alert('Page_Load IsPostBack');</script>");

                DoApplyFilter(con);
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

        protected void ApplyFilter_Click(object sender, EventArgs e)
        {
//            DoApplyFilter(null);
        }

        protected string gStrField(DataTable ATable, int ARow, string AColName)
        {
            return "'" + ATable.Rows[ARow][AColName].ToString() + "'";
        }

        protected int intgIntField(DataTable ATable, int ARow, string AColName)
        {
            return Convert.ToInt32(ATable.Rows[ARow][AColName]);
        }

        protected string gIntField(DataTable ATable, int ARow, string AColName)
        {
            return String.Format("{0:G0}", intgIntField(ATable,ARow,AColName));
        }

        protected int intRemainderFrom100(DataTable ATable, int ARow, string AColName)
        {
            return 100 - intgIntField(ATable, ARow, AColName);
        }

        protected string gRmnd100IntField(DataTable ATable, int ARow, string AColName)
        {
            return String.Format("{0:G0}", intRemainderFrom100(ATable, ARow, AColName));
        }

        protected void DoApplyFilter(SqlConnection Acon)
        {
            #region Private Variables
            //DateTime dDateRecordFrom;
            //DateTime dDateRecordTo;
            DateTime dDateTransferFrom;
            DateTime dDateTransferTo;
            DateTime dDateAcceptFrom;
            DateTime dDateAcceptTo;

            //string cDateRecordFrom = "";
            //string cDateRecordTo = "";
            string cDateTransferFrom = "";
            string cDateTransferTo = "";
            string cDateAcceptFrom = "";
            string cDateAcceptTo = "";

            //if (DateTime.TryParse(DateRecordFrom.Text, out dDateRecordFrom))
            //    cDateRecordFrom = dDateRecordFrom.ToString("yyyyMMdd");
            //if (DateTime.TryParse(DateRecordTo.Text, out dDateRecordTo))
            //    cDateRecordTo = dDateRecordTo.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateTransferFrom.Text, out dDateTransferFrom))
                cDateTransferFrom = dDateTransferFrom.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateTransferTo.Text, out dDateTransferTo))
                cDateTransferTo = dDateTransferTo.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateAcceptFrom.Text, out dDateAcceptFrom))
                cDateAcceptFrom = dDateAcceptFrom.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateAcceptTo.Text, out dDateAcceptTo))
                cDateAcceptTo = dDateAcceptTo.ToString("yyyyMMdd");

            //DateTime dDateRecordFrom2;
            //DateTime dDateRecordTo2;
            DateTime dDateTransferFrom2;
            DateTime dDateTransferTo2;
            DateTime dDateAcceptFrom2;
            DateTime dDateAcceptTo2;

            //string cDateRecordFrom2 = "";
            //string cDateRecordTo2 = "";
            string cDateTransferFrom2 = "";
            string cDateTransferTo2 = "";
            string cDateAcceptFrom2 = "";
            string cDateAcceptTo2 = "";

            //if (DateTime.TryParse(DateRecordFrom2.Text, out dDateRecordFrom2))
            //    cDateRecordFrom2 = dDateRecordFrom2.ToString("yyyyMMdd");
            //if (DateTime.TryParse(DateRecordTo2.Text, out dDateRecordTo2))
            //    cDateRecordTo2 = dDateRecordTo2.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateTransferFrom2.Text, out dDateTransferFrom2))
                cDateTransferFrom2 = dDateTransferFrom2.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateTransferTo2.Text, out dDateTransferTo2))
                cDateTransferTo2 = dDateTransferTo2.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateAcceptFrom2.Text, out dDateAcceptFrom2))
                cDateAcceptFrom2 = dDateAcceptFrom2.ToString("yyyyMMdd");
            if (DateTime.TryParse(DateAcceptTo2.Text, out dDateAcceptTo2))
                cDateAcceptTo2 = dDateAcceptTo2.ToString("yyyyMMdd");

            string cItem = Item.Text;
            string cDescription = Description.Text;
            string cRepeated = Repeated.Text;
            string cTemaNIOKR = TemaNIOKR.Text;
            string cVend = Vend.Text;
            string cVendN = VendN.Text;
            string cChecker = Checker.Text;
            string cScrap = Scrap.Text;
            string cLot = Lot.Text;
            string cUM = UMs.Text;

            Byte cWaitWork = (Byte)((cbWaitWork.Checked) ? 1 : 0);
            Byte cWaitANP = (Byte)((cbWaitANP.Checked) ? 1 : 0);
            string cWaitWorkDay = tbWaitWork.Text;
            string cWaitANPDay = tbWaitANP.Text;

            Byte cShowCooperate;
            Byte cShowBuy;
            string cShowTo = ShowTo.Text;
            switch (cShowTo)
            {
                case "все":
                    cShowCooperate = 1;
                    cShowBuy = 1;
                    break;
                case "Кооперация":
                    cShowCooperate = 1;
                    cShowBuy = 0;
                    break;
                case "Закупка":
                    cShowCooperate = 0;
                    cShowBuy = 1;
                    break;
                default:
                    cShowCooperate = 0;
                    cShowBuy = 0;
                    break;
            }
            Byte cShowOnlyLocQCD = (Byte)((cbShowOnlyLocQCD.Checked) ? 1 : 0);
            Byte cShowOnlyLocWork = (Byte)((cbShowOnlyLocWork.Checked) ? 1 : 0);
            #endregion

            //dtViewerData.Clear();
            //dtViewerDetails.Clear();
            //dtViewerVendors.Clear();
            //dtViewerVendors2.Clear();

            SqlConnection con = Acon;
            if (con == null)
                con = new SqlConnection(conERPString);
            if (con.State != ConnectionState.Open)
                con.Open();
            try
            {
                SqlDataAdapter da = new SqlDataAdapter("zKdx_QCD_JIIViewer", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                #region Parameters SqlDataAdapter
                da.SelectCommand.Parameters.Add("@pShowCooperate", SqlDbType.Bit).Value = cShowCooperate;
                da.SelectCommand.Parameters.Add("@pShowBuy", SqlDbType.Bit).Value = cShowBuy;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateRecordTo", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateTransferFrom", SqlDbType.NVarChar, 50).Value = cDateTransferFrom;
                da.SelectCommand.Parameters.Add("@pDateTransferTo", SqlDbType.NVarChar, 50).Value = cDateTransferTo;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom", SqlDbType.NVarChar, 50).Value = cDateAcceptFrom;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo", SqlDbType.NVarChar, 50).Value = cDateAcceptTo;

                da.SelectCommand.Parameters.Add("@pItem", SqlDbType.NVarChar, 50).Value = cItem;
                da.SelectCommand.Parameters.Add("@pDescription", SqlDbType.NVarChar, 50).Value = cDescription;
                da.SelectCommand.Parameters.Add("@pRepeated", SqlDbType.NVarChar, 50).Value = cRepeated;
                da.SelectCommand.Parameters.Add("@pTemaNIOKR", SqlDbType.NVarChar, 50).Value = cTemaNIOKR;
                da.SelectCommand.Parameters.Add("@pVend", SqlDbType.NVarChar, 50).Value = cVend;
                da.SelectCommand.Parameters.Add("@pVendN", SqlDbType.NVarChar, 50).Value = cVendN;
                da.SelectCommand.Parameters.Add("@pChecker", SqlDbType.NVarChar, 50).Value = cChecker;
                da.SelectCommand.Parameters.Add("@pScrap", SqlDbType.NVarChar, 50).Value = cScrap;
                da.SelectCommand.Parameters.Add("@pLot", SqlDbType.NVarChar, 50).Value = cLot;

                da.SelectCommand.Parameters.Add("@pWaitWork", SqlDbType.Bit).Value = cWaitWork;
                da.SelectCommand.Parameters.Add("@pWaitANP", SqlDbType.Bit).Value = cWaitANP;
                da.SelectCommand.Parameters.Add("@pWaitWorkDay", SqlDbType.NVarChar, 50).Value = cWaitWorkDay;
                da.SelectCommand.Parameters.Add("@pWaitANPDay", SqlDbType.NVarChar, 50).Value = cWaitANPDay;

                da.SelectCommand.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);

                da.SelectCommand.Parameters.Add("@pShowOnlyLocQCD", SqlDbType.Bit).Value = cShowOnlyLocQCD;
                da.SelectCommand.Parameters.Add("@pShowOnlyLocWork", SqlDbType.Bit).Value = cShowOnlyLocWork;
                da.SelectCommand.Parameters.Add("@pUM", SqlDbType.NVarChar, 50).Value = cUM;
                #endregion

                da.Fill(dsDataSet, "ViewerData");
                dtViewerData = dsDataSet.Tables["ViewerData"];
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

                da = new SqlDataAdapter("zKdx_QCD_JIIViewerDetails", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                #region Parameters SqlDataAdapter
                da.SelectCommand.Parameters.Add("@pShowCooperate", SqlDbType.Bit).Value = cShowCooperate;
                da.SelectCommand.Parameters.Add("@pShowBuy", SqlDbType.Bit).Value = cShowBuy;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateRecordTo", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateTransferFrom", SqlDbType.NVarChar, 50).Value = cDateTransferFrom;
                da.SelectCommand.Parameters.Add("@pDateTransferTo", SqlDbType.NVarChar, 50).Value = cDateTransferTo;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom", SqlDbType.NVarChar, 50).Value = cDateAcceptFrom;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo", SqlDbType.NVarChar, 50).Value = cDateAcceptTo;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom2", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateRecordTo2", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateTransferFrom2", SqlDbType.NVarChar, 50).Value = cDateTransferFrom2;
                da.SelectCommand.Parameters.Add("@pDateTransferTo2", SqlDbType.NVarChar, 50).Value = cDateTransferTo2;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom2", SqlDbType.NVarChar, 50).Value = cDateAcceptFrom2;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo2", SqlDbType.NVarChar, 50).Value = cDateAcceptTo2;

                da.SelectCommand.Parameters.Add("@pItem", SqlDbType.NVarChar, 50).Value = cItem;
                da.SelectCommand.Parameters.Add("@pDescription", SqlDbType.NVarChar, 50).Value = cDescription;
                da.SelectCommand.Parameters.Add("@pRepeated", SqlDbType.NVarChar, 50).Value = cRepeated;
                da.SelectCommand.Parameters.Add("@pTemaNIOKR", SqlDbType.NVarChar, 50).Value = cTemaNIOKR;
                da.SelectCommand.Parameters.Add("@pVend", SqlDbType.NVarChar, 50).Value = cVend;
                da.SelectCommand.Parameters.Add("@pVendN", SqlDbType.NVarChar, 50).Value = cVendN;
                da.SelectCommand.Parameters.Add("@pChecker", SqlDbType.NVarChar, 50).Value = cChecker;
                da.SelectCommand.Parameters.Add("@pScrap", SqlDbType.NVarChar, 50).Value = cScrap;
                da.SelectCommand.Parameters.Add("@pLot", SqlDbType.NVarChar, 50).Value = cLot;

                da.SelectCommand.Parameters.Add("@pWaitWork", SqlDbType.Bit).Value = cWaitWork;
                da.SelectCommand.Parameters.Add("@pWaitANP", SqlDbType.Bit).Value = cWaitANP;
                da.SelectCommand.Parameters.Add("@pWaitWorkDay", SqlDbType.NVarChar, 50).Value = cWaitWorkDay;
                da.SelectCommand.Parameters.Add("@pWaitANPDay", SqlDbType.NVarChar, 50).Value = cWaitANPDay;

                da.SelectCommand.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);

                da.SelectCommand.Parameters.Add("@pShowOnlyLocQCD", SqlDbType.Bit).Value = cShowOnlyLocQCD;
                da.SelectCommand.Parameters.Add("@pShowOnlyLocWork", SqlDbType.Bit).Value = cShowOnlyLocWork;
                da.SelectCommand.Parameters.Add("@pUM", SqlDbType.NVarChar, 50).Value = cUM;
                #endregion

                da.Fill(dsDataSet, "ViewerDetails");
                dtViewerDetails = dsDataSet.Tables["ViewerDetails"];
                try
                {
                    GridViewDataDetails.DataSource = dtViewerDetails;
                    GridViewDataDetails.DataBind();

                    LabelPie1.Text = "";
                    LabelBar1.Text = "";
                    if (dtViewerDetails.Rows.Count > 0)
                    {
                        LabelPie1.Text = dtViewerDetails.Rows[0]["rangeTransfer"].ToString();
                        LabelBar1.Text = "Распределение потоков бракованных ДСЕ (шт.)";
                    }
                    LabelPie2.Text = "";
                    LabelBar2.Text = "";
                    if (dtViewerDetails.Rows.Count > 1)
                    {
                        LabelPie2.Text = dtViewerDetails.Rows[1]["rangeTransfer"].ToString();
                        LabelBar2.Text = "Распределение потоков бракованных ДСЕ (шт.)";
                    }
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

                da = new SqlDataAdapter("zKdx_QCD_JIIViewerVendors", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                #region Parameters SqlDataAdapter
                da.SelectCommand.Parameters.Add("@pShowCooperate", SqlDbType.Bit).Value = cShowCooperate;
                da.SelectCommand.Parameters.Add("@pShowBuy", SqlDbType.Bit).Value = cShowBuy;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateRecordTo", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateTransferFrom", SqlDbType.NVarChar, 50).Value = cDateTransferFrom;
                da.SelectCommand.Parameters.Add("@pDateTransferTo", SqlDbType.NVarChar, 50).Value = cDateTransferTo;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom", SqlDbType.NVarChar, 50).Value = cDateAcceptFrom;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo", SqlDbType.NVarChar, 50).Value = cDateAcceptTo;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom2", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateRecordTo2", SqlDbType.NVarChar, 50).Value = "";
                da.SelectCommand.Parameters.Add("@pDateTransferFrom2", SqlDbType.NVarChar, 50).Value = cDateTransferFrom2;
                da.SelectCommand.Parameters.Add("@pDateTransferTo2", SqlDbType.NVarChar, 50).Value = cDateTransferTo2;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom2", SqlDbType.NVarChar, 50).Value = cDateAcceptFrom2;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo2", SqlDbType.NVarChar, 50).Value = cDateAcceptTo2;

                da.SelectCommand.Parameters.Add("@pItem", SqlDbType.NVarChar, 50).Value = cItem;
                da.SelectCommand.Parameters.Add("@pDescription", SqlDbType.NVarChar, 50).Value = cDescription;
                da.SelectCommand.Parameters.Add("@pRepeated", SqlDbType.NVarChar, 50).Value = cRepeated;
                da.SelectCommand.Parameters.Add("@pTemaNIOKR", SqlDbType.NVarChar, 50).Value = cTemaNIOKR;
                da.SelectCommand.Parameters.Add("@pVend", SqlDbType.NVarChar, 50).Value = cVend;
                da.SelectCommand.Parameters.Add("@pVendN", SqlDbType.NVarChar, 50).Value = cVendN;
                da.SelectCommand.Parameters.Add("@pChecker", SqlDbType.NVarChar, 50).Value = cChecker;
                da.SelectCommand.Parameters.Add("@pScrap", SqlDbType.NVarChar, 50).Value = cScrap;
                da.SelectCommand.Parameters.Add("@pLot", SqlDbType.NVarChar, 50).Value = cLot;

                da.SelectCommand.Parameters.Add("@pWaitWork", SqlDbType.Bit).Value = cWaitWork;
                da.SelectCommand.Parameters.Add("@pWaitANP", SqlDbType.Bit).Value = cWaitANP;
                da.SelectCommand.Parameters.Add("@pWaitWorkDay", SqlDbType.NVarChar, 50).Value = cWaitWorkDay;
                da.SelectCommand.Parameters.Add("@pWaitANPDay", SqlDbType.NVarChar, 50).Value = cWaitANPDay;

                da.SelectCommand.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);

                da.SelectCommand.Parameters.Add("@pShowOnlyLocQCD", SqlDbType.Bit).Value = cShowOnlyLocQCD;
                da.SelectCommand.Parameters.Add("@pShowOnlyLocWork", SqlDbType.Bit).Value = cShowOnlyLocWork;
                da.SelectCommand.Parameters.Add("@pUM", SqlDbType.NVarChar, 50).Value = cUM;
                #endregion

                da.Fill(dsDataSet);
                dsDataSet.Tables[dsDataSet.Tables.Count - 2].TableName = "ViewerVendors";
                dsDataSet.Tables[dsDataSet.Tables.Count - 1].TableName = "ViewerVendors2";
                dtViewerVendors = dsDataSet.Tables["ViewerVendors"];
                dtViewerVendors2 = dsDataSet.Tables["ViewerVendors2"];
                try
                {
                    GridViewDataVendors.DataSource = dtViewerVendors;
                    GridViewDataVendors.DataBind();
                    GridViewDataVendors2.DataSource = dtViewerVendors2;
                    GridViewDataVendors2.DataBind();

                    LabelDataVendors.Text = "";
                    BarScrapDataVendorsLabel.Text = "";
                    BarScrapDataVendorsPartLabel.Text = "";
                    if (dtViewerVendors.Rows.Count > 0)
                    {
                        LabelDataVendors.Text = dtViewerVendors.Rows[0]["rangeTransfer"].ToString();
                        BarScrapDataVendorsLabel.Text = "По % брака";
                        BarScrapDataVendorsPartLabel.Text = "Доля брака к поставленным";
                    }
                    LabelDataVendors2.Text = "";
                    BarScrapDataVendorsLabel2.Text = "";
                    BarScrapDataVendorsPartLabel2.Text = "";
                    if (dtViewerVendors2.Rows.Count > 0)
                    {
                        LabelDataVendors2.Text = dtViewerVendors2.Rows[0]["rangeTransfer"].ToString();
                        BarScrapDataVendorsLabel2.Text = "По % брака";
                        BarScrapDataVendorsPartLabel2.Text = "Доля брака к поставленным";
                    }

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

        public override void VerifyRenderingInServerForm(Control control)
        {
            /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
               server control at run time. */

        }

    }
}