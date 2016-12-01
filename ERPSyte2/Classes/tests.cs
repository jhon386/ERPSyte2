using System;
using System.Web;
using Excel = Microsoft.Office.Interop.Excel;
using Microsoft.Vbe.Interop;
using System.Data;
using System.Web.UI;
using System.IO;
using System.Reflection;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace ERPSyte2.Classes
{
    public class tests
    {
        protected void ExportToExcel(object sender, EventArgs e)
        {
            //            string strFilename = "EmpDetails.xls";
            //            UploadDataTableToExcel(dtViewerDetails, strFilename);
        }

        protected void UploadDataTableToExcel(DataTable dtTable, string flName, HttpResponse Response)
        {
            if (dtTable == null) return;

            string attachment = "attachment; filename=" + flName;
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/vnd.ms-excel";
            string tab = string.Empty;
            foreach (DataColumn dtcol in dtTable.Columns)
            {
                Response.Write(tab + dtcol.ColumnName);
                tab = "\t";
            }
            Response.Write("\n");
            foreach (DataRow dr in dtTable.Rows)
            {
                tab = "";
                for (int j = 0; j < dtTable.Columns.Count; j++)
                {
                    Response.Write(tab + Convert.ToString(dr[j]));
                    tab = "\t";
                }
                Response.Write("\n");
            }
            Response.End();

        }

        protected string IntToTwoDigit(int AInt)
        {
            if (AInt < 10)
                return "0" + AInt.ToString();
            else
                return AInt.ToString();
        }

        protected void ExportToExcelGrid(object sender, EventArgs e, GridView GridViewData, HttpResponse Response)
        {//http://www.aspsnippets.com/Articles/Export-GridView-To-Word-Excel-PDF-CSV-Formats-in-ASP.Net.aspx
            string filename = String.Format("QCD {0}{1}{2}.xls", DateTime.Today.Year.ToString(), IntToTwoDigit(DateTime.Today.Month), IntToTwoDigit(DateTime.Today.Day));
            string attachment = "attachment; filename=" + filename;
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", attachment);
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";
            using (StringWriter sw = new StringWriter())
            {
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                //GridViewData.RenderControl(hw);

                //To Export all pages
                //                GridViewData.AllowPaging = false;

                //                GridViewData.HeaderRow.BackColor = Color.White;
                //foreach (TableCell cell in GridViewData.HeaderRow.Cells)
                //{
                //    cell.BackColor = GridViewData.HeaderStyle.BackColor;
                //}
                //foreach (GridViewRow row in GridViewData.Rows)
                //{
                //    row.BackColor = Color.White;
                //    foreach (TableCell cell in row.Cells)
                //    {
                //        if (row.RowIndex % 2 == 0)
                //        {
                //            cell.BackColor = GridViewData.AlternatingRowStyle.BackColor;
                //        }
                //        else
                //        {
                //            cell.BackColor = GridViewData.RowStyle.BackColor;
                //        }
                //        cell.CssClass = "textmode";
                //    }
                //}

                GridViewData.RenderControl(hw);

                //style to format numbers to string
                string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                Response.Write(style);
                Response.Output.Write(sw.ToString());
                //Response.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }

        }

        private void UpdateFormat(string path)
        {
            var application = new Excel.Application();
            var doc = application.Workbooks.Open(path);
            for (int i = 1; i <= doc.Worksheets.Count; i++)
            {
                Excel.Worksheet sheet = (Excel.Worksheet)doc.Worksheets[i];
                for (int j = 1; j <= sheet.Columns.Count; j++)
                {
                    Excel.Range column = (Excel.Range)sheet.Columns[j];
                    column.NumberFormat = "@";
                }
            }
            doc.Save();
            doc.Close();
            application.Quit();
        }

        public void CreateExcel(DataSet ds, string FileName, HttpResponse resp)
        {
            resp.ContentEncoding = System.Text.Encoding.GetEncoding("UTF-8");

            resp.AppendHeader("Content-Disposition", "attachment;filename=" + FileName);

            //string colHeaders= "", ls_item="";  

            // Define table object and row object, and at the same time use DataSet initialize value.

            DataTable dt = ds.Tables[0];

            DataRow[] myRow = dt.Select();//dt.Select("id>10") Data Filer can be used as: dt.Select("id>10")

            //int i = 0;

            int cl = dt.Columns.Count;

            //Get column titles of each DataTable and divided by "t". Press "enter" after the last column title.

            //for(i=0;i<cl;i++) 
            //    colheaders+="dt.Columns[i].Caption.ToString()"+"t"; 
            //            for(i="0;i<cl;i++)" 
            //                if(i="=(cl-1))//(last" +="dt.Columns[i].Caption.ToString()" 
            //                    ls_item+="row[i].ToString()+"t";" 
        }

        public static bool ExportDataTableToExcel(DataTable dt, string filepath)
        {

            Excel.Application oXL;
            Excel.Workbook oWB;
            Excel.Worksheet oSheet;
            Excel.Range oRange;
            Excel.Range oCells;

            try
            {
                // Start Excel and get Application object. 
                oXL = new Excel.Application();

                // Set some properties 
                oXL.Visible = true;
                oXL.DisplayAlerts = false;

                // Get a new workbook. 
                oWB = oXL.Workbooks.Add(Missing.Value);

                // Get the Active sheet 
                oSheet = (Excel.Worksheet)oWB.ActiveSheet;
                oSheet.Name = "Data";

                oCells = (Excel.Range)oSheet.Cells[1, 3];
                oCells.EntireColumn.NumberFormat = "ДД.ММ.ГГГГ";
                oCells = (Excel.Range)oSheet.Cells[1, 4];
                oCells.EntireColumn.NumberFormat = "ДД.ММ.ГГГГ";
                oCells = (Excel.Range)oSheet.Cells[1, 5];
                oCells.EntireColumn.NumberFormat = "ДД.ММ.ГГГГ";
                oCells = (Excel.Range)oSheet.Cells[1, 6];
                oCells.EntireColumn.NumberFormat = "@";
                oCells = null;

                int rowCount = 1;
                foreach (DataRow dr in dt.Rows)
                {
                    rowCount += 1;
                    for (int i = 1; i < dt.Columns.Count + 1; i++)
                    {
                        // Add the header the first time through 
                        if (rowCount == 2)
                        {
                            oSheet.Cells[1, i] = dt.Columns[i - 1].ColumnName;
                        }
                        oSheet.Cells[rowCount, i] = dr[i - 1].ToString();
                    }
                }

                // Resize the columns 
                oRange = oSheet.get_Range(oSheet.Cells[1, 1],
                              oSheet.Cells[rowCount, dt.Columns.Count]);
                oRange.EntireColumn.AutoFit();

                // Save the sheet and close 
                oSheet = null;
                oRange = null;
                oWB.SaveAs(filepath, Excel.XlFileFormat.xlWorkbookNormal,
                    Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                    Excel.XlSaveAsAccessMode.xlExclusive,
                    Missing.Value, Missing.Value, Missing.Value,
                    Missing.Value, Missing.Value);
                oWB.Close(Missing.Value, Missing.Value, Missing.Value);
                oWB = null;
                oXL.Quit();
                //oXL = null;
            }
            catch
            {
                throw;
            }
            finally
            {
                // Clean up 
                // NOTE: When in release mode, this does the trick 
                GC.WaitForPendingFinalizers();
                GC.Collect();
                //GC.WaitForPendingFinalizers();
                //GC.Collect();
            }

            return true;
        }

        private void ExportGridView(GridView GridViewData)
        {//http://stackoverflow.com/questions/15158755/how-do-i-generate-excel-file-with-type-text-not-general-by-default
            var path = @"ExportedFile.xls";
            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);

            // Render grid view control.
            GridViewData.RenderControl(hw);

            // Write the rendered content to a file.
            string renderedGridView = sw.ToString();
            File.WriteAllText(path, renderedGridView);
            //           UpdateFormat(path);
        }

        protected void ExportToExcelGrid2(object sender, EventArgs e, string conERPString, DataSet dsDataSet, HttpResponse Response)
        {
            SqlConnection con = new SqlConnection(conERPString);
            con.Open();
            try
            {

                SqlDataAdapter da = new SqlDataAdapter("zKdx_QCD_JIIViewer", con);
                da.SelectCommand.CommandType = CommandType.StoredProcedure;

                #region Parameters SqlDataAdapter
                da.SelectCommand.Parameters.Add("@pShowCooperate", SqlDbType.Bit).Value = 0;
                da.SelectCommand.Parameters.Add("@pShowBuy", SqlDbType.Bit).Value = 1;

                da.SelectCommand.Parameters.Add("@pDateRecordFrom", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDateRecordTo", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDateTransferFrom", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDateTransferTo", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDateAcceptFrom", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDateAcceptTo", SqlDbType.NVarChar, 50).Value = null;

                da.SelectCommand.Parameters.Add("@pItem", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pDescription", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pRepeated", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pTemaNIOKR", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pVend", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pVendN", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pChecker", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pScrap", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pLot", SqlDbType.NVarChar, 50).Value = null;

                da.SelectCommand.Parameters.Add("@pWaitWork", SqlDbType.Bit).Value = 0;
                da.SelectCommand.Parameters.Add("@pWaitANP", SqlDbType.Bit).Value = 0;
                da.SelectCommand.Parameters.Add("@pWaitWorkDay", SqlDbType.NVarChar, 50).Value = null;
                da.SelectCommand.Parameters.Add("@pWaitANPDay", SqlDbType.NVarChar, 50).Value = null;

                da.SelectCommand.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800);
                #endregion

                da.Fill(dsDataSet, "ViewerData");
                DataTable dt = dsDataSet.Tables["ViewerData"];

                ExportDataTableToExcel(dt, "D:\\TEMP\\qcd.xls");
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
            Response.Write("<script>alert('ExportToExcelGrid2');</script>");
        }

        protected void ExportToExcel2(object sender, EventArgs e,
            TextBox DateTransferFrom,
            TextBox DateTransferTo,
            TextBox DateAcceptFrom,
            TextBox DateAcceptTo,
            TextBox DateTransferFrom2,
            TextBox DateTransferTo2,
            TextBox DateAcceptFrom2,
            TextBox DateAcceptTo2,
            TextBox Item,
            TextBox Description,
            DropDownList Repeated,
            DropDownList TemaNIOKR,
            TextBox Vend,
            DropDownList VendN,
            DropDownList Checker,
            DropDownList Scrap,
            TextBox Lot,
            CheckBox cbWaitWork,
            CheckBox cbWaitANP,
            TextBox tbWaitWork,
            TextBox tbWaitANP,
            DropDownList ShowTo
            )
        {
            ExportToExcelMacro(
            DateTransferFrom,
            DateTransferTo,
            DateAcceptFrom,
            DateAcceptTo,
            DateTransferFrom2,
            DateTransferTo2,
            DateAcceptFrom2,
            DateAcceptTo2,
            Item,
            Description,
            Repeated,
            TemaNIOKR,
            Vend,
            VendN,
            Checker,
            Scrap,
            Lot,
            cbWaitWork,
            cbWaitANP,
            tbWaitWork,
            tbWaitANP,
            ShowTo
                );
        }

        public bool ExportToExcelMacro(
            TextBox DateTransferFrom,
            TextBox DateTransferTo,
            TextBox DateAcceptFrom,
            TextBox DateAcceptTo,
            TextBox DateTransferFrom2,
            TextBox DateTransferTo2,
            TextBox DateAcceptFrom2,
            TextBox DateAcceptTo2,
            TextBox Item,
            TextBox Description,
            DropDownList Repeated,
            DropDownList TemaNIOKR,
            TextBox Vend,
            DropDownList VendN,
            DropDownList Checker,
            DropDownList Scrap,
            TextBox Lot,
            CheckBox cbWaitWork,
            CheckBox cbWaitANP,
            TextBox tbWaitWork,
            TextBox tbWaitANP,
            DropDownList ShowTo
            )
        {
            Excel.Application oXL = null;
            Excel.Workbook oWB = null;
            Excel.Worksheet oSheet = null;
            //Excel.Range oRange = null;
            _VBComponent oModule = null;

            try
            {
                // Start Excel and get Application object. 
                oXL = new Excel.Application();

                // Set some properties 
                oXL.Visible = true;
                oXL.DisplayAlerts = false;
                oXL.UserControl = false;

                // Get a new workbook. 
                oWB = (Excel.Workbook)oXL.Workbooks.Add(Missing.Value);

                // Get the Active sheet 
                oSheet = (Excel.Worksheet)oWB.ActiveSheet;
                oSheet.Name = "Общая База";
                ////Add table headers going cell by cell.
                //oSheet.Cells[1, 1] = "First Name";
                //oSheet.Cells[1, 2] = "Salary(Read Only)";
                ////Format A1:D1 as bold, vertical alignment = center.
                //oSheet.get_Range("A1", "B1").Font.Bold = true;
                //oSheet.get_Range("A1", "B1").VerticalAlignment = Excel.XlVAlign.xlVAlignCenter;

                //// Create an array to multiple values at once.                
                //string[,] saNames = new string[5, 2];
                //saNames[0, 0] = "Naveen";
                //saNames[0, 1] = "10000";
                //saNames[1, 0] = "Girish";
                //saNames[1, 1] = "20000";
                //saNames[2, 0] = "Nandish";
                //saNames[2, 1] = "15000";
                //saNames[3, 0] = "Rashmi";
                //saNames[3, 1] = "40000";

                ////Fill A2:B6 with an array of values (First and Salary).
                //oSheet.get_Range("A2", "B6").Value2 = saNames;

                ////AutoFit columns A:D.
                //oRange = oSheet.get_Range("A1", "B1");
                //oRange.EntireColumn.AutoFit();

                //Create macro in excel
                CreateMacro(oWB, oModule);

                // Run VBA macro "MakeCellReadOnly" on a range                
                //string sRange = "B2:B6";
                //LockRange(oWB, sRange);

                Reference oReference = null;
                for (int i = oWB.VBProject.References.Count; i > 0; i--)
                {
                    oReference = oWB.VBProject.References.Item(i);
                    if (oReference.IsBroken)
                        oWB.VBProject.References.Remove(oReference);
                }
                bool hasADOReference = false;
                string ADOGUID = "{2A75196C-D9EB-4129-B803-931327F72D5C}";
                for (int i = oWB.VBProject.References.Count; i > 0; i--)
                {
                    oReference = oWB.VBProject.References.Item(i);
                    if (oReference.Guid == ADOGUID)
                    {
                        hasADOReference = true;
                        break;
                    }
                }
                if (hasADOReference == false)
                    oWB.VBProject.References.AddFromGuid(ADOGUID, 2, 8);

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
                #endregion
                JIIViewer(oWB, cShowCooperate, cShowBuy
                    , "", ""
                    , cDateTransferFrom, cDateTransferTo
                    , cDateAcceptFrom, cDateAcceptTo
                    , cItem, cDescription, cRepeated, cTemaNIOKR, cVend, cVendN, cChecker, cScrap, cLot
                    , cWaitWork, cWaitANP, cWaitWorkDay, cWaitANPDay);

                //Delete the created Macro
                DeleteMacro(oWB, oModule);

                //Make sure Microsoft.Office.Interop.Excel is visible and give the user control                
                //of Microsoft Microsoft.Office.Interop.Excel's lifetime.
                oXL.Visible = true;
                oXL.UserControl = true;

                //// Save the sheet and close 
                oSheet = null;
                //oRange = null;
                oModule = null;
                //oWB.SaveAs(filepath, Excel.XlFileFormat.xlWorkbookNormal,
                //    Missing.Value, Missing.Value, Missing.Value, Missing.Value,
                //    Excel.XlSaveAsAccessMode.xlExclusive,
                //    Missing.Value, Missing.Value, Missing.Value,
                //    Missing.Value, Missing.Value);
                //oWB.Close(Missing.Value, Missing.Value, Missing.Value);
                oWB = null;
                //oXL.Quit();
                oXL = null;
            }
            catch
            {
                throw;
            }
            finally
            {
                // Clean up 
                // NOTE: When in release mode, this does the trick 
                GC.WaitForPendingFinalizers();
                GC.Collect();
            }

            return true;
        }

        private void DeleteMacro(Excel.Workbook oWB, _VBComponent oModule)
        {
            Object oMissing = System.Reflection.Missing.Value;

            oWB.Application.Run("DeleteModule"
            , oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing);
        }

        private void LockRange(Excel.Workbook oWB, string sRange)
        {
            Object oMissing = System.Reflection.Missing.Value;

            oWB.Application.Run("LockRange"
            , sRange, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing);
        }

        private void DotTreeItemStruc(Excel.Workbook oWB, string AItem)
        {
            Object oMissing = System.Reflection.Missing.Value;

            oWB.Application.Run("DotTreeItemStruc"
            , AItem, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing,
            oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing);
        }

        private void JIIViewer(Excel.Workbook oWB,
            Byte pShowCooperate,
            Byte pShowBuy,
            string pDateRecordFrom,
            string pDateRecordTo,
            string pDateTransferFrom,
            string pDateTransferTo,
            string pDateAcceptFrom,
            string pDateAcceptTo,
            string pItem,
            string pDescription,
            string pRepeated,
            string pTemaNIOKR,
            string pVend,
            string pVendN,
            string pChecker,
            string pScrap,
            string pLot
            , Byte pWaitWork, Byte pWaitANP, string pWaitWorkDay, string pWaitANPDay)
        {
            Object oMissing = System.Reflection.Missing.Value;

            oWB.Application.Run("JIIViewer"
            , pShowCooperate, pShowBuy
            , pDateRecordFrom, pDateRecordTo
            , pDateTransferFrom, pDateTransferTo
            , pDateAcceptFrom, pDateAcceptTo
            , pItem, pDescription, pRepeated, pTemaNIOKR, pVend, pVendN, pChecker, pScrap, pLot
            , pWaitWork, pWaitANP, pWaitWorkDay, pWaitANPDay
            , oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing, oMissing);
        }

        private void CreateMacro(Excel.Workbook oWB, _VBComponent oModule)
        {
            oModule = oWB.VBProject.VBComponents.Add(vbext_ComponentType.vbext_ct_StdModule);
            oModule.Name = "Module1";

            string sCode =
            "  \r\n" + vbesub_JIIViewer +
            "  \r\n" + vbesub_LockRange +
            "  \r\n" + vbesub_DeleteModule;

            oModule.CodeModule.AddFromString(sCode);
        }

        private string vbesub_JIIViewer
        {
            get
            {
                return
                    "Sub JIIViewer(pShowCooperate As Integer, pShowBuy As Integer" +
                    ", pDateRecordFrom As String, pDateRecordTo As String" +
                    ", pDateTransferFrom As String, pDateTransferTo As String" +
                    ", pDateAcceptFrom As String, pDateAcceptTo As String" +
                    ", pItem As String, pDescription As String, pRepeated As String" +
                    ", pTemaNIOKR As String, pVend As String, pVendN As String" +
                    ", pChecker As String, pScrap As String, pLot As String" +
                    ", pWaitWork As Integer, pWaitANP As Integer, pWaitWorkDay As String, pWaitANPDay As String" +
                    ")  \r\n" +

                    "  \r\n" +
                    "    On Error GoTo ERRH\r\n" +

                    "  \r\n" +
                    "    Dim oConnection As ADODB.Connection\r\n" +
                    "    Dim oCommand As ADODB.Command\r\n" +
                    "    Dim oRecordset As ADODB.Recordset\r\n" +
                    "    Dim oParam As ADODB.Parameter\r\n" +

                    "  \r\n" +
                    "    Set oConnection = New ADODB.Connection\r\n" +
                    "    oConnection.Open \"Provider='sqloledb';Data Source='sl-db-srv';Initial Catalog='Erp_App';User ID='report_user';Password='report_user';Application Name='Excel query'\"\r\n" +

                    "  \r\n" +
                    "    Application.ScreenUpdating = False\r\n" +
                    "    Application.EnableEvents = False\r\n" +

                    "  \r\n" +
                    "    Application.StatusBar = \"Получение данных. Запрос...\"\r\n" +

                    "  \r\n" +
                    "    Set oCommand = New ADODB.Command\r\n" +
                    "    Set oRecordset = New ADODB.Recordset\r\n" +

                    "  \r\n" +
                    "    oCommand.ActiveConnection = oConnection\r\n" +

                    "  \r\n" +
                    "    '@pShowCooperate, SqlDbType.Bit).Value = 0\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pShowCooperate\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pShowBuy, SqlDbType.Bit).Value = 1\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pShowBuy\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateRecordFrom, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateRecordFrom\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateRecordTo, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateRecordTo\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateTransferFrom, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateTransferFrom\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateTransferTo, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateTransferTo\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateAcceptFrom, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateAcceptFrom\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDateAcceptTo, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDateAcceptTo\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +


                    "  \r\n" +
                    "    '@pItem, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pItem\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pDescription, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pDescription\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pRepeated, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pRepeated\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pTemaNIOKR, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pTemaNIOKR\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pVend, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pVend\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pVendN, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pVendN\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pChecker, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pChecker\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pScrap, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pScrap\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pLot, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pLot\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pWaitWork, SqlDbType.Bit).Value = 1\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pWaitWork\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pWaitANP, SqlDbType.Bit).Value = 1\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pWaitANP\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pWaitWorkDay, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pWaitWorkDay\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@pWaitANPDay, SqlDbType.NVarChar, 50\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 50\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = pWaitANPDay\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    '@Infobar, SqlDbType.NVarChar, 2800\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 2800\r\n" +
                    "    oParam.Direction = adParamOutput\r\n" +
                    "    oParam.Value = Null\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +

                    "  \r\n" +
                    "    Application.Caption = \"Статистика ЖВК\"\r\n" +

                    "  \r\n" +
                    "    oCommand.CommandText = \"zKdx_QCD_JIIViewer\"\r\n" +
                    "    oCommand.CommandType = adCmdStoredProc\r\n" +
                    "    oCommand.CommandTimeout = 300\r\n" +
                    "    Set oRecordset = oCommand.Execute()\r\n" +
                    "    Application.StatusBar = \"Получение данных. Заполнение страницы...\"\r\n" +

                    "  \r\n" +
                    "    RowCount = 2\r\n" +
                    "        Sheets(1).Cells(RowCount, 2).Value = \"Вх. №\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 3).Value = \"Дата передачи на ВК\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 4).Value = \"Изделие\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 5).Value = \"Наименование\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 6).Value = \"Транзакция\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 7).Value = \"Входное АНП\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 8).Value = \"Дата приемки\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 9).Value = \"Дата оприходования\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 10).Value = \"Номер документа\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 11).Value = \"Признак\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 12).Value = \"Партия\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 13).Value = \"Примечание\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 14).Value = \"Закупка\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 15).Value = \"Количество\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 16).Value = \"Доступно\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 17).Value = \"Принято\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 18).Value = \"Годные\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 19).Value = \"В Покрытие\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 20).Value = \"Потребность ПРБ\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 21).Value = \"Движение полуфабрикатов\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 22).Value = \"Брак\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 23).Value = \"Возврат поставщику\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 24).Value = \"Использование без доработки\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 25).Value = \"Доработка на участке\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 26).Value = \"Доработка при сборке\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 27).Value = \"Списание\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 28).Value = \"% Брака\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 29).Value = \"Повторное предъявление\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 30).Value = \"Серийные номера\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 31).Value = \"Тема НИОКР\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 32).Value = \"Поставщик\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 33).Value = \"Имя\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 34).Value = \"Автор\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 35).Value = \"Контролер\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 36).Value = \"Ручной ввод\"\r\n" +

                    "  \r\n" +
                    "    Columns(\"C:C\").Select\r\n" +
                    "    Selection.NumberFormat = \"m/d/yyyy\"\r\n" +
                    "    Selection.ColumnWidth = 10\r\n" +
                    "    Columns(\"H:H\").Select\r\n" +
                    "    Selection.NumberFormat = \"m/d/yyyy\"\r\n" +
                    "    Selection.ColumnWidth = 10\r\n" +
                    "    Columns(\"I:I\").Select\r\n" +
                    "    Selection.NumberFormat = \"m/d/yyyy\"\r\n" +
                    "    Selection.ColumnWidth = 10\r\n" +
                    "    Columns(\"D:D\").Select\r\n" +
                    "    Selection.NumberFormat = \"@\"\r\n" +
                    "    Selection.ColumnWidth = 20\r\n" +
                    "    Range(\"A1\").Select\r\n" +

                    "  \r\n" +
                    "    Do While oRecordset.EOF = False\r\n" +
                    "        RowCount = RowCount + 1\r\n" +

                    "        Sheets(1).Cells(RowCount, 2).Value = oRecordset.Fields(\"jii_num\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 3).Value = oRecordset.Fields(\"DateTransfer\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 4).Value = oRecordset.Fields(\"Item\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 5).Value = oRecordset.Fields(\"Description\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 6).Value = oRecordset.Fields(\"trans_num\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 7).Value = oRecordset.Fields(\"AnpNum\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 8).Value = oRecordset.Fields(\"DateAccept\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 9).Value = oRecordset.Fields(\"DateRecord\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 10).Value = oRecordset.Fields(\"DerDocumentNum\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 11).Value = oRecordset.Fields(\"Kind\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 12).Value = oRecordset.Fields(\"Lot\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 13).Value = oRecordset.Fields(\"Note\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 14).Value = oRecordset.Fields(\"Purchase\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 15).Value = oRecordset.Fields(\"Qty\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 16).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 17).Value = oRecordset.Fields(\"DerQtyAccepted\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 18).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 19).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 20).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 21).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 22).Value = oRecordset.Fields(\"DerQtyScrapped\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 23).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 24).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 25).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 26).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 27).Value = \"\"\r\n" +
                    "        Sheets(1).Cells(RowCount, 28).Value = oRecordset.Fields(\"DerScrapPercent\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 29).Value = IIf(oRecordset.Fields(\"Repeated\")=1, \"Да\", \"\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 30).Value = oRecordset.Fields(\"SerNums\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 31).Value = oRecordset.Fields(\"TemaNIOKR\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 32).Value = oRecordset.Fields(\"VendNum\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 33).Value = oRecordset.Fields(\"VendName\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 34).Value = oRecordset.Fields(\"AuthorName\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 35).Value = oRecordset.Fields(\"CheckerName\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 36).Value = IIf(oRecordset.Fields(\"DerManual\")=1, \"Да\", \"\")\r\n" +

                    "  \r\n" +
                    "        oRecordset.MoveNext\r\n" +
                    "    Loop\r\n" +

                    "  \r\n" +
                    "    oRecordset.Close\r\n" +
                    "    Set oParam = Nothing\r\n" +
                    "    Set oRecordset = Nothing\r\n" +
                    "    Set oCommand = Nothing\r\n" +

                    "  \r\n" +
                    "    oConnection.Close\r\n" +
                    "    Set oConnection = Nothing\r\n" +

                    "  \r\n" +
                    "    Application.StatusBar = \"\"\r\n" +
                    "    Application.ScreenUpdating = True\r\n" +
                    "    Application.EnableEvents = True\r\n" +

                    "  \r\n" +
                    "    Exit Sub\r\n" +

                    "  \r\n" +
                    "ERRH:\r\n" +
                    "    MsgBox \"ExportItem: \" & Err.Description, vbExclamation\r\n" +
                    "    Err.Clear\r\n" +
                    "    Set oParam = Nothing\r\n" +
                    "    Set oRecordset = Nothing\r\n" +
                    "    Set oCommand = Nothing\r\n" +
                    "    Set oConnection = Nothing\r\n" +

                    "  \r\n" +
                    "End Sub\r\n";
            }
        }

        private string vbesub_DotTreeItemStruc
        {
            get
            {
                return
                    "Sub DotTreeItemStruc(AItem As String)\r\n" +
                    "  \r\n" +
                    "    On Error GoTo ERRH\r\n" +
                    "  \r\n" +
                    "    Dim oConnection As ADODB.Connection\r\n" +
                    "    Dim oCommand As ADODB.Command\r\n" +
                    "    Dim oRecordset As ADODB.Recordset\r\n" +
                    "    Dim oParam As ADODB.Parameter\r\n" +
                    "  \r\n" +
                    "    Set oConnection = New ADODB.Connection\r\n" +
                    "    oConnection.Open \"Provider='sqloledb';Data Source='sl-db-srv';Initial Catalog='Erp_App';User ID='report_user';Password='report_user'\"\r\n" +
                    "  \r\n" +
                    "    Application.ScreenUpdating = False\r\n" +
                    "    Application.EnableEvents = False\r\n" +
                    "  \r\n" +
                    "    Application.StatusBar = \"Импорт данных. Запрос...\"\r\n" +
                    "  \r\n" +
                    "    Set oCommand = New ADODB.Command\r\n" +
                    "    Set oRecordset = New ADODB.Recordset\r\n" +
                    "  \r\n" +
                    "    oCommand.ActiveConnection = oConnection\r\n" +
                    "  \r\n" +
                    "    ' item\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 30\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = AItem\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +
                    "  \r\n" +
                    "    'snp_only\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = Null\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +
                    "  \r\n" +
                    "    'ser_num_job\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adVarWChar\r\n" +
                    "    oParam.Size = 30\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = Null\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +
                    "  \r\n" +
                    "    'phantom_show\r\n" +
                    "    Set oParam = New ADODB.Parameter\r\n" +
                    "    oParam.Type = adTinyInt\r\n" +
                    "    'oParam.Size = 0\r\n" +
                    "    oParam.Direction = adParamInput\r\n" +
                    "    oParam.Value = Null\r\n" +
                    "    oCommand.Parameters.Append oParam\r\n" +
                    "  \r\n" +
                    "  \r\n" +
                    "    Application.Caption = \"Состав \" & AItem & \" на \" & _\r\n" +
                    "      Format(Year(Date), \"0000\") & \"_\" & Format(Month(Date), \"00\") & \"_\" & Format(Day(Date), \"00\")\r\n" +
                    "  \r\n" +
                    "  \r\n" +
                    "  \r\n" +
                    "    oCommand.CommandText = \"zKd_GetItemStrucWeb\"\r\n" +
                    "    oCommand.CommandType = adCmdStoredProc\r\n" +
                    "    oCommand.CommandTimeout = 300\r\n" +
                    "    Set oRecordset = oCommand.Execute()\r\n" +
                    "  \r\n" +
                    "    Application.StatusBar = \"Импорт данных. Заполнение страницы...\"\r\n" +
                    "  \r\n" +
                    "    Dim max_level As Integer\r\n" +
                    "  \r\n" +
                    "    Sheets(1).Rows(\"3:64000\").ClearContents\r\n" +
                    "    'FillHeaders_ rs, oSheet\r\n" +
                    "'    Sheets(1).Range(\"A1\").CopyFromRecordset oRecordset\r\n" +
                    "  \r\n" +
                    "    ' Добавим столбцы для псевдодерева\r\n" +
                    "    If Not oRecordset.EOF Then\r\n" +
                    "          max_level = oRecordset.Fields(\"max_level\") + 1\r\n" +
                    "    End If\r\n" +
                    "    For i = 1 To max_level\r\n" +
                    "        Sheets(1).Columns(i).EntireColumn.Insert\r\n" +
                    "        Sheets(1).Columns(i).ColumnWidth = 2\r\n" +
                    "        Sheets(1).Columns(i).Interior.ColorIndex = -4142   'xlNone\r\n" +
                    "  \r\n" +
                    "        Sheets(1).Cells(1, i).HorizontalAlignment = -4108    'xlCenter\r\n" +
                    "        Sheets(1).Cells(1, i).Formula = i\r\n" +
                    "        Sheets(1).Cells(1, i).Font.Bold = True\r\n" +
                    "  \r\n" +
                    "        'объединим и очертим\r\n" +
                    "        Range(Cells(1, i), Cells(2, i)).Select\r\n" +
                    "        Selection.Merge\r\n" +
                    "        With Selection\r\n" +
                    "            .HorizontalAlignment = xlCenter\r\n" +
                    "            .VerticalAlignment = xlCenter\r\n" +
                    "            .MergeCells = True\r\n" +
                    "        End With\r\n" +
                    "        Selection.Borders(xlDiagonalDown).LineStyle = xlNone\r\n" +
                    "        Selection.Borders(xlDiagonalUp).LineStyle = xlNone\r\n" +
                    "        With Selection.Borders(xlEdgeLeft)\r\n" +
                    "            .LineStyle = xlContinuous\r\n" +
                    "            .ColorIndex = 0\r\n" +
                    "            .TintAndShade = 0\r\n" +
                    "            .Weight = xlThin\r\n" +
                    "        End With\r\n" +
                    "        With Selection.Borders(xlEdgeTop)\r\n" +
                    "            .LineStyle = xlContinuous\r\n" +
                    "            .ColorIndex = 0\r\n" +
                    "            .TintAndShade = 0\r\n" +
                    "            .Weight = xlThin\r\n" +
                    "        End With\r\n" +
                    "        With Selection.Borders(xlEdgeBottom)\r\n" +
                    "            .LineStyle = xlContinuous\r\n" +
                    "            .ColorIndex = 0\r\n" +
                    "            .TintAndShade = 0\r\n" +
                    "            .Weight = xlThin\r\n" +
                    "        End With\r\n" +
                    "        With Selection.Borders(xlEdgeRight)\r\n" +
                    "            .LineStyle = xlContinuous\r\n" +
                    "            .ColorIndex = 0\r\n" +
                    "            .TintAndShade = 0\r\n" +
                    "            .Weight = xlThin\r\n" +
                    "        End With\r\n" +
                    "        Selection.Borders(xlInsideVertical).LineStyle = xlNone\r\n" +
                    "        Selection.Borders(xlInsideHorizontal).LineStyle = xlNone\r\n" +
                    "    Next\r\n" +
                    "  \r\n" +
                    "    RowCount = 2\r\n" +
                    "    Do While oRecordset.EOF = False\r\n" +
                    "        RowCount = RowCount + 1\r\n" +
                    "        'Рисуем псевдодерево\r\n" +
                    "        cur_level = oRecordset.Fields(\"LEVEL\")\r\n" +
                    "        Sheets(1).Cells(RowCount, cur_level + 1).Value = Chr(149)\r\n" +
                    "  \r\n" +
                    "        Sheets(1).Cells(RowCount, 1 + max_level).Value = oRecordset.Fields(\"Item\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 2 + max_level).Value = oRecordset.Fields(\"descEx\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 3 + max_level).Value = oRecordset.Fields(\"phantom_flag\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 4 + max_level).Value = Round(oRecordset.Fields(\"qty\"), 3)\r\n" +
                    "        Sheets(1).Cells(RowCount, 5 + max_level).Value = Round(oRecordset.Fields(\"qty_all\"), 3)\r\n" +
                    "        Sheets(1).Cells(RowCount, 6 + max_level).Value = oRecordset.Fields(\"u_m\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 7 + max_level).Value = oRecordset.Fields(\"lot_tracked\")\r\n" +
                    "        Sheets(1).Cells(RowCount, 8 + max_level).Value = oRecordset.Fields(\"serial_tracked\")\r\n" +
                    "        'Стоимости\r\n" +
                    "        If oRecordset.Fields(\"p_m_t_code\") = \"M\" Then\r\n" +
                    "          Sheets(1).Cells(RowCount, 9 + max_level).Value = Round(oRecordset.Fields(\"cur_u_cost\"), 2)\r\n" +
                    "          Sheets(1).Cells(RowCount, 10 + max_level).Value = Round(oRecordset.Fields(\"cur_u_cost_all\"), 2)\r\n" +
                    "        Else\r\n" +
                    "          Sheets(1).Cells(RowCount, 9 + max_level).Value = Round(oRecordset.Fields(\"unit_cost\"), 2)\r\n" +
                    "          Sheets(1).Cells(RowCount, 10 + max_level).Value = Round(oRecordset.Fields(\"unit_cost_all\"), 2)\r\n" +
                    "        End If\r\n" +
                    "        Sheets(1).Cells(RowCount, 11 + max_level).Value = oRecordset.Fields(\"plan_code\")\r\n" +
                    "        'Время опережения\r\n" +
                    "        e_lead_time = oRecordset.Fields(\"lead_time\")\r\n" +
                    "        If IsNull(e_lead_time) Then\r\n" +
                    "          e_lead_time = 0\r\n" +
                    "        End If\r\n" +
                    "        e_paper_time = oRecordset.Fields(\"paper_time\")\r\n" +
                    "        If IsNull(e_paper_time) Then\r\n" +
                    "          e_paper_time = 0\r\n" +
                    "        End If\r\n" +
                    "        Sheets(1).Cells(RowCount, 12 + max_level).Value = e_paper_time + e_lead_time\r\n" +
                    "'                    If Not IsNull(e_t_TEXT) Then\r\n" +
                    "'                    e_t_TEXT = Replace(e_t_TEXT, \"\"\"\", \"''\")\r\n" +
                    "'                    End If\r\n" +
                    "  \r\n" +
                    "  \r\n" +
                    "        oRecordset.MoveNext\r\n" +
                    "    Loop\r\n" +
                    "  \r\n" +
                    "    oRecordset.Close\r\n" +
                    "    Set oParam = Nothing\r\n" +
                    "    Set oRecordset = Nothing\r\n" +
                    "    Set oCommand = Nothing\r\n" +
                    "  \r\n" +
                    "    oConnection.Close\r\n" +
                    "    Set oConnection = Nothing\r\n" +
                    "  \r\n" +
                    "    Application.StatusBar = \"\"\r\n" +
                    "    Application.ScreenUpdating = True\r\n" +
                    "    Application.EnableEvents = True\r\n" +
                    "  \r\n" +
                    "    Exit Sub\r\n" +
                    "  \r\n" +
                    "ERRH:\r\n" +
                    "    MsgBox \"ExportItem: \" & Err.Description, vbExclamation\r\n" +
                    "    Err.Clear\r\n" +
                    "    Set oParam = Nothing\r\n" +
                    "    Set oRecordset = Nothing\r\n" +
                    "    Set oCommand = Nothing\r\n" +
                    "    Set oConnection = Nothing\r\n" +
                    "  \r\n" +
                    "End Sub\r\n";
            }
        }

        private string vbesub_LockRange
        {
            get
            {
                return
                    "Sub LockRange(oRange As String)\r\n" +
                    "  Range(oRange).Select\r\n" +
                    "  With Selection.Validation \r\n" +
                    "    .Delete\r\n" +
                    "    .Add Type:=xlValidateCustom, AlertStyle:=xlValidAlertStop, Operator:= _\r\n" +
                    "      xlBetween, Formula1:=\"\"\"\"\"\"\r\n" +
                    "    .ErrorTitle = \"Locked Cell\"\r\n" +
                    "    .ErrorMessage = \"This cell is locked for modification.\"\r\n" +
                    "    .ShowError = True\r\n" +
                    "  End With\r\n" +
                    "End Sub\r\n";
            }
        }

        private string vbesub_DeleteModule
        {
            get
            {
                return
                    "Sub DeleteModule()\r\n" +
                    "  Dim vbCom As Object\r\n" +
                    "  \r\n" +
                    "  Set vbCom = Application.VBE.ActiveVBProject.VBComponents\r\n" +
                    "  vbCom.Remove VBComponent:= vbCom.Item(\"Module1\")\r\n" +
                    "End Sub\r\n";
            }
        }

    }
}