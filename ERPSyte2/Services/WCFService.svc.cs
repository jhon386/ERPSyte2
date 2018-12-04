using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using static ERPSyte2.Services.WCFErrorHandle;

namespace ERPSyte2.Services
{

  //[ServiceBehavior(AddressFilterMode = AddressFilterMode.Any)]
  [ErrorHandlerBehavior(typeof(WCFCustomErrorHandler))]
  [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
  public class WCFService : IAJAXService, IJSONService, IXMLService, ISOAPService
  {
    private string conn = ConfigurationManager.ConnectionStrings["ERPcs"].ConnectionString;

    protected T GetValue<T>(object obj)
    {
      if (typeof(DBNull) != obj.GetType())
      {
        return (T)Convert.ChangeType(obj, typeof(T));
      }
      return default(T);
    }

    protected T GetValue<T>(object obj, object defaultValue)
    {
      if (typeof(DBNull) != obj.GetType())
      {
        return (T)Convert.ChangeType(obj, typeof(T));
      }
      return (T)defaultValue;
    }

    private class ResultExecStoredProc
    {
      public int Severity { get; set; }
      public string Infobar { get; set; }
    }

    public string HelloWorld()
    {
      return "Hello, world!";
    }

    public string Hello(string name)
    {
      return string.Format("You sended {0}", name);
    }

    public double Add(double n1, double n2)
    {
      return Math.Round(n1 + n2, 1);
    }

    public HBMessage ComposeMessage(string header, string body)
    {
      HBMessage message = new HBMessage() { Header = header, Body = body };

      return message;
    }

    public void SayHello()
    {
      var serializer = new JavaScriptSerializer();

      SimpleMessage message = new SimpleMessage() { SMMessage = "Hello World" };
      string json = serializer.Serialize(message); //JsonConvert. 
      HttpContext.Current.Response.ContentType = "application/json; charset=utf-8";
      HttpContext.Current.Response.Write(json);
    }

    public void SayHelloBy(string name)
    {
      var serializer = new JavaScriptSerializer();

      SimpleMessage message = new SimpleMessage() { SMMessage = string.Format("Hello {0}", name) };
      string json = serializer.Serialize(message);
      HttpContext.Current.Response.ContentType = "application/json; charset=utf-8";
      HttpContext.Current.Response.Write(json);
    }

    public Stream GetValue()
    {
      string result = "Hello world";
      byte[] resultBytes = Encoding.UTF8.GetBytes(result);
      return new MemoryStream(resultBytes);
    }

    public void DoWork()
    {
      // Add your operation implementation here
      return;
    }

    public List<ProcessNotBuyRow> getProcessNotBuyRows(List<string> aData)
    {
      SqlDataReader dr = null;
      List<ProcessNotBuyRow> processNotBuyRowList = new List<ProcessNotBuyRow>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      string cItem = "";
      string cDescription = "";
      string cDateCode004From = "";
      string cDateCode004To = "";
      string cIsAnalogRegistered = "";
      string cIsAnalogApproved = "";
      string cIsEquivalentPush = "";
      string cIsVersionAdvance = "";
      string cIsApplyClosed = "";
      string cIsLeadTime999 = "";
      string cLogin = "";

      if (aData != null)
      {
        if (aData.Count > 0 && aData[0] != null)
          cItem = aData[0];
        if (aData.Count > 1 && aData[1] != null)
          cDescription = aData[1];
        if (aData.Count > 2 && aData[2] != null)
          cDateCode004From = aData[2];
        if (aData.Count > 3 && aData[3] != null)
          cDateCode004To = aData[3];
        if (aData.Count > 4 && aData[4] != null)
          cIsAnalogRegistered = aData[4];
        if (aData.Count > 5 && aData[5] != null)
          cIsAnalogApproved = aData[5];
        if (aData.Count > 6 && aData[6] != null)
          cIsEquivalentPush = aData[6];
        if (aData.Count > 7 && aData[7] != null)
          cIsVersionAdvance = aData[7];
        if (aData.Count > 8 && aData[8] != null)
          cIsApplyClosed = aData[8];
        if (aData.Count > 9 && aData[9] != null)
          cIsLeadTime999 = aData[9];
        if (aData.Count > 10 && aData[10] != null)
          cLogin = aData[10];
      }

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_ProcessNotBuy_Show";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          cmd.Parameters.Add("@ReturnValue", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
          cmd.Parameters.AddWithValue("@Item", cItem); //SqlDbType.NVarChar, 30).Value = cItem;
          cmd.Parameters.AddWithValue("@Description", cDescription); //SqlDbType.NVarChar, 150).Value = cDescription;
          cmd.Parameters.AddWithValue("@pDateCode004From", cDateCode004From); //SqlDbType.NVarChar, 50).Value = cDateCode004From;
          cmd.Parameters.AddWithValue("@pDateCode004To", cDateCode004To); //SqlDbType.NVarChar, 50).Value = cDateCode004To;
          cmd.Parameters.AddWithValue("@pIsAnalogRegistered", cIsAnalogRegistered); //SqlDbType.NVarChar, 50).Value = cIsAnalogRegistered;
          cmd.Parameters.AddWithValue("@pIsAnalogApproved", cIsAnalogApproved); //SqlDbType.NVarChar, 50).Value = cIsAnalogApproved;
          cmd.Parameters.AddWithValue("@pIsEquivalentPush", cIsEquivalentPush); //SqlDbType.NVarChar, 50).Value = cIsEquivalentPush;
          cmd.Parameters.AddWithValue("@pIsVersionAdvance", cIsVersionAdvance); //SqlDbType.NVarChar, 50).Value = cIsVersionAdvance;
          cmd.Parameters.AddWithValue("@pIsApplyClosed", cIsApplyClosed); //SqlDbType.NVarChar, 50).Value = cIsApplyClosed;
          cmd.Parameters.AddWithValue("@pIsLeadTime999", cIsLeadTime999); //SqlDbType.NVarChar, 50).Value = cIsLeadTime999;
          cmd.Parameters.AddWithValue("@Login", cLogin); //SqlDbType.NVarChar, 128).Value = cLogin;
          cmd.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800).Direction = ParameterDirection.Output;
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            result.Infobar = Convert.ToString(cmd.Parameters["@Infobar"].Value);
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, "getProcessNotBuyRows", string.Join(", ", aData));
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, "getProcessNotBuyRows", string.Join(", ", aData));
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {
              string Item = dr["Item"].ToString();
              string Description = dr["Description"].ToString();
              DateTime? DateCode004 = (dr["DateCode004"] is DBNull) ? (DateTime?)null : (DateTime)dr["DateCode004"];
              byte IsAnalogRegistered = Convert.ToByte(dr["IsAnalogRegistered"]);
              byte IsAnalogApproved = Convert.ToByte(dr["IsAnalogApproved"]);
              byte IsEquivalentPush = Convert.ToByte(dr["IsEquivalentPush"]);
              byte IsVersionAdvance = Convert.ToByte(dr["IsVersionAdvance"]);
              byte IsApplyClosed = Convert.ToByte(dr["IsApplyClosed"]);
              byte IsLeadTime999 = Convert.ToByte(dr["IsLeadTime999"]);
              string UserName = dr["UserName"].ToString();
              int AccessRight = Convert.ToInt32(dr["AccessRight"]);
              DateTime? DateCode004FromChange = (dr["DateCode004FromChange"] is DBNull) ? (DateTime?)null : (DateTime)dr["DateCode004FromChange"];
              DateTime? DateCode004From = (dr["DateCode004From"] is DBNull) ? (DateTime?)null : (DateTime)dr["DateCode004From"];
              DateTime? DateCode004To = (dr["DateCode004To"] is DBNull) ? (DateTime?)null : (DateTime)dr["DateCode004To"];

              processNotBuyRowList.Add(new ProcessNotBuyRow
              {
                Item = Item,
                Description = Description,
                DateCode004 = DateCode004,
                IsAnalogRegistered = IsAnalogRegistered,
                IsAnalogApproved = IsAnalogApproved,
                IsEquivalentPush = IsEquivalentPush,
                IsVersionAdvance = IsVersionAdvance,
                IsApplyClosed = IsApplyClosed,
                IsLeadTime999 = IsLeadTime999,
                UserName = UserName,
                AccessRight = AccessRight,
                DateCode004FromChange = DateCode004FromChange,
                DateCode004From = DateCode004From,
                DateCode004To = DateCode004To
              });
            }
          }
        }
      }

      return processNotBuyRowList;
    }

    public ExecResult setApplyChoice(List<string> aData)
    {
      ExecResult execResult = new ExecResult();
      ResultExecStoredProc result = new ResultExecStoredProc();
      string cProc = "";
      string cItem = "";
      int cValue = 0;
      string cLogin = "";
      string srvLogin = ServiceSecurityContext.Current.PrimaryIdentity.Name.Split(new char[] { '\\' })[1];
      string srvProc = "";

      if (aData != null)
      {
        if (aData.Count > 0 && aData[0] != null)
          cProc = aData[0];
        if (aData.Count > 1 && aData[1] != null)
          cItem = aData[1];
        if (aData.Count > 2 && aData[2] != null)
          cValue = Convert.ToInt32(aData[2]);
        if (aData.Count > 3 && aData[3] != null)
          cLogin = aData[3];
      }

      if (cLogin != srvLogin)
      {
        WCFClientError detail = new WCFClientError(16, "Неверный контекст безопасности", "setApplyChoice", string.Join(", ", aData));
        throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
      }

      if (cProc == "EquivalentPush")
      {
        srvProc = "zKdx_ProcessNotBuy_EquivalentPushOper";
      }
      if (cProc == "VersionAdvance")
      {
        srvProc = "zKdx_ProcessNotBuy_VersionAdvanceOper";
      }

      if (srvProc == "")
      {
        WCFClientError detail = new WCFClientError(16, "Не указана процедура выполнения", "setApplyChoice", string.Join(", ", aData));
        throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
      }

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = srvProc;
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          cmd.Parameters.Add("@ReturnValue", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
          cmd.Parameters.AddWithValue("@Item", cItem); //SqlDbType.NVarChar, 30).Value = cItem;
          cmd.Parameters.AddWithValue("@Value", cValue); //SqlDbType.NVarChar, 50).Value = cIsLeadTime999;
          cmd.Parameters.AddWithValue("@Login", cLogin); //SqlDbType.NVarChar, 128).Value = cLogin;
          cmd.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800).Direction = ParameterDirection.Output;
          try
          {
            con.Open();
            int affected = cmd.ExecuteNonQuery();
            result.Severity = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            result.Infobar = Convert.ToString(cmd.Parameters["@Infobar"].Value);
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, "setApplyChoice", string.Join(", ", aData));
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, "setApplyChoice", string.Join(", ", aData));
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          {
            execResult.Severity = result.Severity;
            execResult.Infobar = result.Infobar;
          }
        }
      }

      return execResult;
    }

    public ServiceUserData getServiceUserData()
    {
      return new ServiceUserData();
    }

    public List<QCDUMsRow> getQCDUMsRows()
    {
      SqlDataReader dr = null;
      List<QCDUMsRow> rowsList = new List<QCDUMsRow>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_QCD_UMsSp";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = 0;
            result.Infobar = "";
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, cmd.CommandText);
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, cmd.CommandText);
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {
              rowsList.Add(new QCDUMsRow
              {
                Um = dr["u_m"].ToString(),
                Description = dr["description"].ToString()
              });
            }
          }
        }
      }

      return rowsList;
    }

    public List<QCDTemaNIOKRRow> getQCDTemaNIOKRRows()
    {
      SqlDataReader dr = null;
      List<QCDTemaNIOKRRow> rowsList = new List<QCDTemaNIOKRRow>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_QCD_TemaNIOKRSp";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = 0;
            result.Infobar = "";
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, cmd.CommandText);
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, cmd.CommandText);
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {
              rowsList.Add(new QCDTemaNIOKRRow
              {
                TemaNIOKR = dr["TemaNIOKR"].ToString()
              });
            }
          }
        }
      }

      return rowsList;
    }

    public List<QCDCheckerNameRow> getQCDCheckerNameRows()
    {
      SqlDataReader dr = null;
      List<QCDCheckerNameRow> rowsList = new List<QCDCheckerNameRow>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_QCD_CheckerNameSp";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = 0;
            result.Infobar = "";
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, cmd.CommandText);
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, cmd.CommandText);
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {
              rowsList.Add(new QCDCheckerNameRow
              {
                CheckerName = dr["CheckerName"].ToString()
              });
            }
          }
        }
      }

      return rowsList;
    }

    public List<QCDjournalRow> getQCDjournalRows(List<string> aData)
    {
      SqlDataReader dr = null;
      List<QCDjournalRow> listQCDjournalRows = new List<QCDjournalRow>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      bool cShowCooperate = false;
      bool cShowBuy = false;

      string cDateTransferFrom = "";
      string cDateTransferTo = "";
      string cDateAcceptFrom = "";
      string cDateAcceptTo = "";

      string cDateTransferFrom2 = "";
      string cDateTransferTo2 = "";
      string cDateAcceptFrom2 = "";
      string cDateAcceptTo2 = "";

      string cItem = "";
      string cDescription = "";
      string cRepeated = "";
      string cTemaNIOKR = "";
      string cVend = "";
      string cVendN = "";
      string cChecker = "";
      string cScrap = "";
      string cLot = "";

      bool cWaitWork = false;
      bool cWaitANP = false;
      string cWaitWorkDay = "";
      string cWaitANPDay = "";

      bool cShowOnlyLocQCD = false;
      bool cShowOnlyLocWork = false;
      string cUM = "";

      bool cShowRecordset_primary = false;
      bool cShowRecordset_secondary = false;
      bool cShowRecordset_details = false;
      bool cShowRecordset_vendors = false;

      if (aData != null)
      {
        if (aData.Count > 0 && aData[0] != null)
          cShowCooperate = aData[0] == "1";
        if (aData.Count > 1 && aData[1] != null)
          cShowBuy = aData[1] == "1";

        if (aData.Count > 2 && aData[2] != null)
          cDateTransferFrom = aData[2];
        if (aData.Count > 3 && aData[3] != null)
          cDateTransferTo = aData[3];
        if (aData.Count > 4 && aData[4] != null)
          cDateAcceptFrom = aData[4];
        if (aData.Count > 5 && aData[5] != null)
          cDateAcceptTo = aData[5];

        if (aData.Count > 6 && aData[6] != null)
          cDateTransferFrom2 = aData[6];
        if (aData.Count > 7 && aData[7] != null)
          cDateTransferTo2 = aData[7];
        if (aData.Count > 8 && aData[8] != null)
          cDateAcceptFrom2 = aData[8];
        if (aData.Count > 9 && aData[9] != null)
          cDateAcceptTo2 = aData[9];

        if (aData.Count > 10 && aData[10] != null)
          cItem = aData[10];
        if (aData.Count > 11 && aData[11] != null)
          cDescription = aData[11];
        if (aData.Count > 12 && aData[12] != null)
          cRepeated = aData[12];
        if (aData.Count > 13 && aData[13] != null)
          cTemaNIOKR = aData[13];
        if (aData.Count > 14 && aData[14] != null)
          cVend = aData[14];
        if (aData.Count > 15 && aData[15] != null)
          cVendN = aData[15];
        if (aData.Count > 16 && aData[16] != null)
          cChecker = aData[16];
        if (aData.Count > 17 && aData[17] != null)
          cScrap = aData[17];
        if (aData.Count > 18 && aData[18] != null)
          cLot = aData[18];

        if (aData.Count > 19 && aData[19] != null)
          cWaitWork = aData[19] == "";
        if (aData.Count > 20 && aData[20] != null)
          cWaitANP = aData[20] == "";
        if (aData.Count > 21 && aData[21] != null)
          cWaitWorkDay = aData[21];
        if (aData.Count > 22 && aData[22] != null)
          cWaitANPDay = aData[22];

        if (aData.Count > 23 && aData[23] != null)
          cShowOnlyLocQCD = aData[23] == "1";
        if (aData.Count > 24 && aData[24] != null)
          cShowOnlyLocWork = aData[24] == "1";
        if (aData.Count > 25 && aData[25] != null)
          cUM = aData[25];

        if (aData.Count > 26 && aData[26] != null)
          cShowRecordset_primary = aData[26] == "1";
        if (aData.Count > 27 && aData[27] != null)
          cShowRecordset_secondary = aData[27] == "1";
        if (aData.Count > 28 && aData[28] != null)
          cShowRecordset_details = aData[28] == "1";
        if (aData.Count > 29 && aData[29] != null)
          cShowRecordset_vendors = aData[29] == "1";
      }

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_QCD_JIIViewerA";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          cmd.Parameters.Add("@ReturnValue", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
          cmd.Parameters.AddWithValue("@pShowCooperate", cShowCooperate);
          cmd.Parameters.AddWithValue("@pShowBuy", cShowBuy);

          cmd.Parameters.AddWithValue("@pDateTransferFrom", cDateTransferFrom);
          cmd.Parameters.AddWithValue("@pDateTransferTo", cDateTransferTo);
          cmd.Parameters.AddWithValue("@pDateAcceptFrom", cDateAcceptFrom);
          cmd.Parameters.AddWithValue("@pDateAcceptTo", cDateAcceptTo);

          cmd.Parameters.AddWithValue("@pDateTransferFrom2", cDateTransferFrom2);
          cmd.Parameters.AddWithValue("@pDateTransferTo2", cDateTransferTo2);
          cmd.Parameters.AddWithValue("@pDateAcceptFrom2", cDateAcceptFrom2);
          cmd.Parameters.AddWithValue("@pDateAcceptTo2", cDateAcceptTo2);

          cmd.Parameters.AddWithValue("@pItem", cItem);
          cmd.Parameters.AddWithValue("@pDescription", cDescription);
          cmd.Parameters.AddWithValue("@pRepeated", cRepeated);
          cmd.Parameters.AddWithValue("@pTemaNIOKR", cTemaNIOKR);
          cmd.Parameters.AddWithValue("@pVend", cVend);
          cmd.Parameters.AddWithValue("@pVendN", cVendN);
          cmd.Parameters.AddWithValue("@pChecker", cChecker);
          cmd.Parameters.AddWithValue("@pScrap", cScrap);
          cmd.Parameters.AddWithValue("@pLot", cLot);

          cmd.Parameters.AddWithValue("@pWaitWork", cWaitWork);
          cmd.Parameters.AddWithValue("@pWaitANP", cWaitANP);
          cmd.Parameters.AddWithValue("@pWaitWorkDay", cWaitWorkDay);
          cmd.Parameters.AddWithValue("@pWaitANPDay", cWaitANPDay);

          cmd.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800).Direction = ParameterDirection.Output;

          cmd.Parameters.AddWithValue("@pShowOnlyLocQCD", cShowOnlyLocQCD);
          cmd.Parameters.AddWithValue("@pShowOnlyLocWork", cShowOnlyLocWork);
          cmd.Parameters.AddWithValue("@pUM", cUM);

          cmd.Parameters.AddWithValue("@pShowRecordset_primary", cShowRecordset_primary);
          cmd.Parameters.AddWithValue("@pShowRecordset_secondary", cShowRecordset_secondary);
          cmd.Parameters.AddWithValue("@pShowRecordset_details", cShowRecordset_details);
          cmd.Parameters.AddWithValue("@pShowRecordset_vendors", cShowRecordset_vendors);
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            result.Infobar = Convert.ToString(cmd.Parameters["@Infobar"].Value);
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, cmd.CommandText, string.Join(", ", aData));
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, cmd.CommandText, string.Join(", ", aData));
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {
              int fjii_num = Convert.ToInt32(dr["jii_num"]);
              int? ftrans_num = (dr["trans_num"] is DBNull) ? (int?)null : Convert.ToInt32(dr["trans_num"]);

              DateTime fDateTransfer = (DateTime)dr["DateTransfer"];
              string fItem = dr["Item"].ToString();
              string fDescription = dr["Description"].ToString();
              string fLot = dr["Lot"].ToString();
              string fPurchase = dr["Purchase"].ToString();
              string fKind = dr["Kind"].ToString();
              string fTemaNIOKR = dr["TemaNIOKR"].ToString();
              string fSerNums = dr["SerNums"].ToString();
              byte fRepeated = Convert.ToByte(dr["Repeated"]);
              string fDocumentIncom = dr["DocumentIncom"].ToString();
              decimal fQty = Convert.ToDecimal(dr["Qty"]);
              string fAnpNum = dr["AnpNum"].ToString();
              string fAnpScrap = dr["AnpScrap"].ToString();
              string fVendNum = dr["VendNum"].ToString();
              string fVendName = dr["VendName"].ToString();
              string fCheckerName = dr["CheckerName"].ToString();
              string fAuthorName = dr["AuthorName"].ToString();
              string fNote = dr["Note"].ToString();

              string fwhse = dr["whse"].ToString();
              decimal fDerQtyAccepted = Convert.ToDecimal(dr["DerQtyAccepted"]);
              decimal fDerQtyScrapped = Convert.ToDecimal(dr["DerQtyScrapped"]);
              decimal fDerScrapPercent = Convert.ToDecimal(dr["DerScrapPercent"]);
              string fDerDocumentNum = dr["DerDocumentNum"].ToString();
              bool fDerManual = Convert.ToBoolean(dr["DerManual"]);
              decimal fDerQtyAvailable = Convert.ToDecimal(dr["DerQtyAvailable"]);

              string fUM = dr["UM"].ToString();

              DateTime? fDerDateAnpScrap = (dr["DerDateAnpScrap"] is DBNull) ? (DateTime?)null : (DateTime)dr["DerDateAnpScrap"];
              DateTime? fDerDateLastAccept = (dr["DerDateLastAccept"] is DBNull) ? (DateTime?)null : (DateTime)dr["DerDateLastAccept"];
              DateTime? fDerDateAccept = (dr["DerDateAccept"] is DBNull) ? (DateTime?)null : (DateTime)dr["DerDateAccept"];

              decimal fDerQty1 = Convert.ToDecimal(dr["DerQty1"]);
              decimal fDerQty2 = Convert.ToDecimal(dr["DerQty2"]);
              decimal fDerQty3 = Convert.ToDecimal(dr["DerQty3"]);
              decimal fDerQty4 = Convert.ToDecimal(dr["DerQty4"]);
              decimal fDerQty5 = Convert.ToDecimal(dr["DerQty5"]);
              decimal fDerQty6 = Convert.ToDecimal(dr["DerQty6"]);
              decimal fDerQty7 = Convert.ToDecimal(dr["DerQty7"]);
              decimal fDerQty8 = Convert.ToDecimal(dr["DerQty8"]);
              decimal fDerQty9 = Convert.ToDecimal(dr["DerQty9"]);

              int? fRcvTransNum = (dr["RcvTransNum"] is DBNull) ? (int?)null : Convert.ToInt32(dr["RcvTransNum"]);
              string fRcvLoc = dr["RcvLoc"].ToString();
              string fRcvName = dr["RcvName"].ToString();

              listQCDjournalRows.Add(new QCDjournalRow
              {
                jii_num = fjii_num,
                trans_num = ftrans_num,

                DateTransfer = fDateTransfer,
                Item = fItem,
                Description = fDescription,
                Lot = fLot,
                Purchase = fPurchase,
                Kind = fKind,
                TemaNIOKR = fTemaNIOKR,
                SerNums = fSerNums,
                Repeated = fRepeated,
                DocumentIncom = fDocumentIncom,
                Qty = fQty,
                AnpNum = fAnpNum,
                AnpScrap = fAnpScrap,
                VendNum = fVendNum,
                VendName = fVendName,
                CheckerName = fCheckerName,
                AuthorName = fAuthorName,
                Note = fNote,

                whse = fwhse,
                DerQtyAccepted = fDerQtyAccepted,
                DerQtyScrapped = fDerQtyScrapped,
                DerScrapPercent = fDerScrapPercent,
                DerDocumentNum = fDerDocumentNum,
                DerManual = fDerManual,
                DerQtyAvailable = fDerQtyAvailable,

                UM = fUM,

                DerDateAnpScrap = fDerDateAnpScrap,
                DerDateLastAccept = fDerDateLastAccept,
                DerDateAccept = fDerDateAccept,

                DerQty1 = fDerQty1,
                DerQty2 = fDerQty2,
                DerQty3 = fDerQty3,
                DerQty4 = fDerQty4,
                DerQty5 = fDerQty5,
                DerQty6 = fDerQty6,
                DerQty7 = fDerQty7,
                DerQty8 = fDerQty8,
                DerQty9 = fDerQty9,

                RcvTransNum = fRcvTransNum,
                RcvLoc = fRcvLoc,
                RcvName = fRcvName
              });
            }
          }
        }
      }

      return listQCDjournalRows;
    }

    public List<ImplPlan> getImplPlan(List<string> aData)
    {
      SqlDataReader dr = null;
      List<ImplPlan> listImplPlan = new List<ImplPlan>();
      ResultExecStoredProc result = new ResultExecStoredProc();

      string cSN = "";
      int cID = 0;
      string cLogin = "";

      if (aData != null)
      {
        if (aData.Count > 0 && aData[0] != null)
          cSN = aData[0];
        if (aData.Count > 1 && aData[1] != null)
          int.TryParse(aData[1], out cID);
        if (aData.Count > 2 && aData[2] != null)
          cLogin = aData[2];
      }

      using (SqlConnection con = new SqlConnection(conn))
      {
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandText = "zKdx_ImplPlan_Show";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          cmd.Parameters.Add("@ReturnValue", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
          cmd.Parameters.AddWithValue("@ser_num", cSN);
          cmd.Parameters.AddWithValue("@ID", cID);
          cmd.Parameters.AddWithValue("@Login", cLogin);
          cmd.Parameters.Add("@Infobar", SqlDbType.NVarChar, 2800).Direction = ParameterDirection.Output;
          try
          {
            con.Open();
            dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            result.Severity = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
            result.Infobar = Convert.ToString(cmd.Parameters["@Infobar"].Value);
          }
          catch (Exception e)
          {
            WCFServerError detail = new WCFServerError(16, e.Message, "getImplPlan", string.Join(", ", aData));
            throw new WebFaultException<WCFServerError>(detail, HttpStatusCode.BadRequest);
          }

          if (result.Severity != 0)
          {
            WCFClientError detail = new WCFClientError(result.Severity, result.Infobar, "getImplPlan", string.Join(", ", aData));
            throw new WebFaultException<WCFClientError>(detail, HttpStatusCode.BadRequest);
          }
          else
          if (dr != null && dr.HasRows)
          {
            while (dr.Read())
            {

              string Type = dr["Type"].ToString();
              string Comment1 = dr["Comment1"].ToString();
              string Item = dr["Item"].ToString();
              string OrderFromManager = dr["OrderFromManager"].ToString();
              string ser_num = dr["ser_num"].ToString();
              string DateInContract = dr["DateInContract"].ToString();
              string DateInGK = dr["DateInGK"].ToString();
              string DateDesired = dr["DateDesired"].ToString();
              string DateInOKO = dr["DateInOKO"].ToString();
              string DateVrHran = dr["DateVrHran"].ToString();
              string Comment4 = dr["Comment4"].ToString();
              string QforImport = dr["QforImport"].ToString();
              string QforRus = dr["QforRus"].ToString();
              string PImport = dr["PImport"].ToString();
              string PRus1 = dr["PRus1"].ToString();
              string PRus2 = dr["PRus2"].ToString();
              string PRus3 = dr["PRus3"].ToString();
              string PRus4 = dr["PRus4"].ToString();
              string DateToWhsePlan = dr["DateToWhsePlan"].ToString();
              string Comment2 = dr["Comment2"].ToString();
              string DateShipPlan = dr["DateShipPlan"].ToString();
              string DateShipFact = dr["DateShipFact"].ToString();
              string TypeShip = dr["TypeShip"].ToString();
              string TravelTimePlan = dr["TravelTimePlan"].ToString();
              string DateDelivery = dr["DateDelivery"].ToString();
              string DateDeliveryFact = dr["DateDeliveryFact"].ToString();
              string DateKabinetReady = dr["DateKabinetReady"].ToString();
              string DateMontagStart = dr["DateMontagStart"].ToString();
              string DateMontagEnd = dr["DateMontagEnd"].ToString();
              string Comment5 = dr["Comment5"].ToString();
              string NumbProject = dr["NumbProject"].ToString();
              decimal? CostMontage = (dr["CostMontage"] != DBNull.Value) ? Convert.ToDecimal(dr["CostMontage"]) : (decimal?)null;
              string Comment3 = dr["Comment3"].ToString();
              string Stat_text = dr["Stat_text"].ToString();
              string Stat = dr["Stat"].ToString();
              int? ID = (dr["ID"] != DBNull.Value) ? Convert.ToInt32(dr["ID"]) : (int?)null;
              DateTime? CreateDate = (dr["CreateDate"] is DBNull) ? (DateTime?)null : (DateTime)dr["CreateDate"];

              string sn_common = dr["sn_common"].ToString();
              string ItemSL = dr["ItemSL"].ToString();
              string descr = dr["descr"].ToString();
              string u_m = dr["u_m"].ToString();
              string coi_ser_num = dr["coi_ser_num"].ToString();
              string coi_stat = dr["coi_stat"].ToString();
              decimal? qty_ordered = (dr["qty_ordered"] != DBNull.Value) ? Convert.ToDecimal(dr["qty_ordered"]) : (decimal?)null;
              decimal? qty_shipped = (dr["qty_shipped"] != DBNull.Value) ? Convert.ToDecimal(dr["qty_shipped"]) : (decimal?)null;
              string JobNum = dr["JobNum"].ToString();
              string Job = dr["Job"].ToString();
              int? Suffix = (dr["Suffix"] != DBNull.Value) ? Convert.ToInt32(dr["Suffix"]) : (int?)null;
              string cust = dr["cust"].ToString();
              string customer_ship = dr["customer_ship"].ToString();
              DateTime? due_date = (dr["due_date"] is DBNull) ? (DateTime?)null : (DateTime)dr["due_date"];
              DateTime? date_fact_whse = (dr["date_fact_whse"] is DBNull) ? (DateTime?)null : (DateTime)dr["date_fact_whse"];
              string co_num = dr["co_num"].ToString();
              int? co_line = (dr["co_line"] != DBNull.Value) ? Convert.ToInt32(dr["co_line"]) : (int?)null;
              int? DeficitAPS_rowCount = (dr["DeficitAPS_rowCount"] != DBNull.Value) ? Convert.ToInt32(dr["DeficitAPS_rowCount"]) : (int?)null;
              decimal? DeficitAPS_CostAll = (dr["DeficitAPS_CostAll"] != DBNull.Value) ? Convert.ToDecimal(dr["DeficitAPS_CostAll"]) : (decimal?)null;
              DateTime? DateShipFrom1C = (dr["DateShipFrom1C"] is DBNull) ? (DateTime?)null : (DateTime)dr["DateShipFrom1C"];
              string fsi_date = dr["fsi_date"].ToString();
              decimal? price_all = (dr["price_all"] != DBNull.Value) ? Convert.ToDecimal(dr["price_all"]) : (decimal?)null;

              listImplPlan.Add(new ImplPlan
              {
                Type = Type,
                Comment1 = Comment1,
                Item = Item,
                OrderFromManager = OrderFromManager,
                ser_num = ser_num,
                DateInContract = DateInContract,
                DateInGK = DateInGK,
                DateDesired = DateDesired,
                DateInOKO = DateInOKO,
                DateVrHran = DateVrHran,
                Comment4 = Comment4,
                QforImport = QforImport,
                QforRus = QforRus,
                PImport = PImport,
                PRus1 = PRus1,
                PRus2 = PRus2,
                PRus3 = PRus3,
                PRus4 = PRus4,
                DateToWhsePlan = DateToWhsePlan,
                Comment2 = Comment2,
                DateShipPlan = DateShipPlan,
                DateShipFact = DateShipFact,
                TypeShip = TypeShip,
                TravelTimePlan = TravelTimePlan,
                DateDelivery = DateDelivery,
                DateDeliveryFact = DateDeliveryFact,
                DateKabinetReady = DateKabinetReady,
                DateMontagStart = DateMontagStart,
                DateMontagEnd = DateMontagEnd,
                Comment5 = Comment5,
                NumbProject = NumbProject,
                CostMontage = CostMontage,
                Comment3 = Comment3,
                Stat_text = Stat_text,
                Stat = Stat,
                ID = ID,
                CreateDate = CreateDate,
                sn_common = sn_common,
                ItemSL = ItemSL,
                descr = descr,
                u_m = u_m,
                coi_ser_num = coi_ser_num,
                coi_stat = coi_stat,
                qty_ordered = qty_ordered,
                qty_shipped = qty_shipped,
                JobNum = JobNum,
                Job = Job,
                Suffix = Suffix,
                cust = cust,
                customer_ship = customer_ship,
                due_date = due_date,
                date_fact_whse = date_fact_whse,
                co_num = co_num,
                co_line = co_line,
                DeficitAPS_rowCount = DeficitAPS_rowCount,
                DeficitAPS_CostAll = DeficitAPS_CostAll,
                DateShipFrom1C = DateShipFrom1C,
                fsi_date = fsi_date,
                price_all = price_all

              });
            }
          }
        }
      }

      return listImplPlan;
    }

  }

  [ServiceContract]
  public interface IAJAXService
  {
    [OperationContract]
    [WebInvoke(ResponseFormat = WebMessageFormat.Json)]
    string HelloWorld();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)] //, UriTemplate = "Hello"//"/Hello?name={name}"
    string Hello(string name);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)] //, UriTemplate = "Add"//"Add?n1={n1}&n2={n2}"
    double Add(double n1, double n2);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)] //[WebGet(UriTemplate = "/GetMessage/?header={header}&?body={body}", ResponseFormat = WebMessageFormat.Json)]
    HBMessage ComposeMessage(string header, string body);

    [OperationContract]
    void SayHello();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json)]
    void SayHelloBy(string name);

    [OperationContract, WebGet]
    Stream GetValue();

    [OperationContract]
    void DoWork();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<ProcessNotBuyRow> getProcessNotBuyRows(List<string> aData);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    ExecResult setApplyChoice(List<string> aData);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json)]
    ServiceUserData getServiceUserData();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<QCDUMsRow> getQCDUMsRows();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<QCDTemaNIOKRRow> getQCDTemaNIOKRRows();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<QCDCheckerNameRow> getQCDCheckerNameRows();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<QCDjournalRow> getQCDjournalRows(List<string> aData);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
    [FaultContract(typeof(WCFClientError))]
    [FaultContract(typeof(WCFServerError))]
    List<ImplPlan> getImplPlan(List<string> aData);
  }

  [ServiceContract(Namespace = "")]
  public interface IJSONService
  {
    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedResponse, ResponseFormat = WebMessageFormat.Json)]
    string HelloWorld();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Hello"//"/Hello?name={name}"
    string Hello(string name);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Add"//"Add?n1={n1}&n2={n2}"
    double Add(double n1, double n2);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //[WebGet(UriTemplate = "/GetMessage/?header={header}&?body={body}", ResponseFormat = WebMessageFormat.Json)]
    HBMessage ComposeMessage(string header, string body);

    [OperationContract]
    void SayHello();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json)]
    void SayHelloBy(string name);

    [OperationContract, WebGet]
    Stream GetValue();

    [OperationContract]
    void DoWork();

  }

  [ServiceContract(Namespace = "")]
  public interface IXMLService
  {
    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedResponse, ResponseFormat = WebMessageFormat.Xml)]
    string HelloWorld();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Xml, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Hello"//"/Hello?name={name}"
    string Hello(string name);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Xml, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Add"//"Add?n1={n1}&n2={n2}"
    double Add(double n1, double n2);

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Wrapped, ResponseFormat = WebMessageFormat.Xml, RequestFormat = WebMessageFormat.Json)] //[WebGet(UriTemplate = "/GetMessage/?header={header}&?body={body}", ResponseFormat = WebMessageFormat.Json)]
    HBMessage ComposeMessage(string header, string body);

    [OperationContract]
    void SayHello();

    [OperationContract]
    [WebInvoke(BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json)]
    void SayHelloBy(string name);

    [OperationContract, WebGet]
    Stream GetValue();

    [OperationContract]
    void DoWork();

  }

  [ServiceContract(Namespace = "")]
  public interface ISOAPService
  {
    [OperationContract]
    [WebInvoke]
    string HelloWorld();

    [OperationContract]
    [WebInvoke]  //(BodyStyle = WebMessageBodyStyle.Bare, ResponseFormat = WebMessageFormat.Xml, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Hello"//"/Hello?name={name}"
    string Hello(string name);

  }


  [DataContract]
  public class ExecResult
  {
    [DataMember]
    public int Severity { get; set; }
    [DataMember]
    public string Infobar { get; set; }

    public ExecResult()
        : this(0, "")
    {
    }
    public ExecResult(int severity, string infobar)
    {
      Severity = severity;
      Infobar = infobar;
    }
  }

  [DataContract]
  public class ServiceUserData
  {
    [DataMember]
    public string Login { get; set; }
    [DataMember]
    public int UID { get; set; }
    [DataMember]
    public string Name { get; set; }
    [DataMember]
    public string sName { get; set; }

    private void GetDBUserData()
    {
      string conn = ConfigurationManager.ConnectionStrings["ERPcs"].ConnectionString;

      using (SqlConnection con = new SqlConnection(conn))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand("zKdcm_GetUser", con))
        {
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add("@login", SqlDbType.NVarChar, 30).Value = Login;
          using (SqlDataReader dr = cmd.ExecuteReader())
          {
            while (dr.Read())
            {
              UID = Convert.ToInt32(dr["UID"]); ;
              Name = dr["Name"].ToString();
              sName = dr["sName"].ToString();
            }
          }
        }
      }
    }

    public ServiceUserData()
    {
      Login = "n/a";
      UID = 0;
      Name = "n/a";
      sName = "n/a";

      if (!ServiceSecurityContext.Current.IsAnonymous)
      {
        Login = ServiceSecurityContext.Current.PrimaryIdentity.Name.Split(new char[] { '\\' })[1];
        GetDBUserData();
      }
    }
  }

  [DataContract]
  public class HBMessage
  {
    [DataMember(Order = 1)]
    public string Header { get; set; }

    [DataMember(Order = 2)]
    public string Body { get; set; }
  }

  [DataContract]
  public class SimpleMessage
  {
    [DataMember]
    public string SMMessage { get; set; }
  }

  [DataContract]
  public class ProcessNotBuyRow
  {
    [DataMember]
    public string Item { get; set; }

    [DataMember]
    public string Description { get; set; }

    [DataMember]
    public DateTime? DateCode004 { get; set; }

    //[DataMember(Name = "DateCode004")]
    //private string DateCode004ForSerialization { get; set; }

    //[OnSerializing]
    //void OnSerializing(StreamingContext ctx)
    //{

    //    if (DateCode004 == null)
    //        DateCode004ForSerialization = "1900-01-01";
    //    else
    //    {
    //        DateTime d = DateCode004 ?? Convert.ToDateTime("1900-01-01");
    //        DateCode004ForSerialization = d.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
    //    }
    //}

    //[OnDeserializing]
    //void OnDeserializing(StreamingContext ctx)
    //{
    //    DateCode004ForSerialization = "1900-01-01";
    //}

    //[OnDeserialized]
    //void OnDeserialized(StreamingContext ctx)
    //{
    //    DateCode004 = DateTime.ParseExact(DateCode004ForSerialization, "MM/dd/yyyy", CultureInfo.InvariantCulture);
    //}

    [DataMember]
    public byte IsAnalogRegistered { get; set; }

    [DataMember]
    public byte IsAnalogApproved { get; set; }

    [DataMember]
    public byte IsEquivalentPush { get; set; }

    [DataMember]
    public byte IsVersionAdvance { get; set; }

    [DataMember]
    public byte IsApplyClosed { get; set; }

    [DataMember]
    public byte IsLeadTime999 { get; set; }

    [DataMember]
    public string UserName { get; set; }

    [DataMember]
    public int AccessRight { get; set; }

    [DataMember]
    public DateTime? DateCode004FromChange { get; set; }

    [DataMember]
    public DateTime? DateCode004From { get; set; }

    [DataMember]
    public DateTime? DateCode004To { get; set; }

  }

  [DataContract]
  public class QCDUMsRow
  {
    [DataMember]
    public string Um { get; set; }

    [DataMember]
    public string Description { get; set; }
  }

  [DataContract]
  public class QCDTemaNIOKRRow
  {
    [DataMember]
    public string TemaNIOKR { get; set; }
  }

  [DataContract]
  public class QCDCheckerNameRow
  {
    [DataMember]
    public string CheckerName { get; set; }
  }

  [DataContract]
  public class QCDjournalRow
  {
    [DataMember]
    public int jii_num { get; set; } // decimal(10,0) not null primary key clustered
    [DataMember]
    public int? trans_num { get; set; } // decimal(10,0) --Транзакция

    [DataMember]
    public DateTime DateTransfer { get; set; } // datetime --Дата передачи на ВК
    [DataMember]
    public string Item { get; set; } // nvarchar(30) --Код ERP
    [DataMember]
    public string Description { get; set; } // nvarchar(150) --Наименование
    [DataMember]
    public string Lot { get; set; } // nvarchar(15) --Номер партии
    [DataMember]
    public string Purchase { get; set; } // nvarchar(20) --Закупка
    [DataMember]
    public string Kind { get; set; } // nvarchar(20) --Признак
    [DataMember]
    public string TemaNIOKR { get; set; } // nvarchar(20) --Серия/Тема НИОКР
    [DataMember]
    public string SerNums { get; set; } // nvarchar(2048) --Серийные номера
    [DataMember]
    public byte Repeated { get; set; } // tinyint --Повторное предъявление
    [DataMember]
    public string DocumentIncom { get; set; } // nvarchar(30) --Номер приходного документа
    [DataMember]
    public decimal Qty { get; set; } // decimal(18,8) --Количество
    [DataMember]
    public string AnpNum { get; set; } // nvarchar(7) --АНП входная с перемещения
    [DataMember]
    public string AnpScrap { get; set; } // nvarchar(7) --АНП на брак выходная
    [DataMember]
    public string VendNum { get; set; } // nvarchar(7) --Поставщик
    [DataMember]
    public string VendName { get; set; } // nvarchar(60)
    [DataMember]
    public string CheckerName { get; set; } // nvarchar(30) --Контролер
    [DataMember]
    public string AuthorName { get; set; } // nvarchar(30) --Автор проводки с учетом DC
    [DataMember]
    public string Note { get; set; } // nvarchar(100) --Примечание

    [DataMember]
    public string whse { get; set; } // nvarchar(4) --Склад
    [DataMember]
    public decimal DerQtyAccepted { get; set; } // decimal(18,8) --Принято
    [DataMember]
    public decimal DerQtyScrapped { get; set; } // decimal(18,8) --Брак
    [DataMember]
    public decimal DerScrapPercent { get; set; } // decimal(18,8) --% брака
    [DataMember]
    public string DerDocumentNum { get; set; } // nvarchar(12) --Номер документа
    [DataMember]
    public bool DerManual { get; set; } // bit    --Ручной ввод
    [DataMember]
    public decimal DerQtyAvailable { get; set; } // decimal(18,8) --Обработать

    [DataMember]
    public string UM { get; set; } // nvarchar(3) --Е/И

    [DataMember]
    public DateTime? DerDateAnpScrap { get; set; } // datetime
    [DataMember]
    public DateTime? DerDateLastAccept { get; set; } // datetime
    [DataMember]
    public DateTime? DerDateAccept { get; set; } // datetime

    [DataMember]
    public decimal DerQty1 { get; set; } // decimal(18,8) --1	Годные(основное место хранения)
    [DataMember]
    public decimal DerQty2 { get; set; } // decimal(18,8) --2	Возврат поставщику
    [DataMember]
    public decimal DerQty3 { get; set; } // decimal(18,8) --3	Использование без доработки
    [DataMember]
    public decimal DerQty4 { get; set; } // decimal(18,8) --4	Доработка на участке
    [DataMember]
    public decimal DerQty5 { get; set; } // decimal(18,8) --5	Доработка при сборке
    [DataMember]
    public decimal DerQty6 { get; set; } // decimal(18,8) --6	В покрытие
    [DataMember]
    public decimal DerQty7 { get; set; } // decimal(18,8) --7	Потребность ПРБ
    [DataMember]
    public decimal DerQty8 { get; set; } // decimal(18,8) --8	Движение полуфабриката
    [DataMember]
    public decimal DerQty9 { get; set; } // decimal(18,8) --9	Списание

    [DataMember]
    public int? RcvTransNum { get; set; } // decimal(10,0) --транзакция получения
    [DataMember]
    public string RcvLoc { get; set; } // nvarchar(15) --МС получения
    [DataMember]
    public string RcvName { get; set; } // nvarchar(50) --имя получателя
  }

  [DataContract]
  public class ImplPlan
  {
    [DataMember]
    public string Type { get; set; }
    [DataMember]
    public string Comment1 { get; set; }
    [DataMember]
    public string Item { get; set; }
    [DataMember]
    public string OrderFromManager { get; set; }
    [DataMember]
    public string ser_num { get; set; }
    [DataMember]
    public string DateInContract { get; set; }
    [DataMember]
    public string DateInGK { get; set; }
    [DataMember]
    public string DateDesired { get; set; }
    [DataMember]
    public string DateInOKO { get; set; }
    [DataMember]
    public string DateVrHran { get; set; }
    [DataMember]
    public string Comment4 { get; set; }
    [DataMember]
    public string QforImport { get; set; }
    [DataMember]
    public string QforRus { get; set; }
    [DataMember]
    public string PImport { get; set; }
    [DataMember]
    public string PRus1 { get; set; }
    [DataMember]
    public string PRus2 { get; set; }
    [DataMember]
    public string PRus3 { get; set; }
    [DataMember]
    public string PRus4 { get; set; }
    [DataMember]
    public string DateToWhsePlan { get; set; }
    [DataMember]
    public string Comment2 { get; set; }
    [DataMember]
    public string DateShipPlan { get; set; }
    [DataMember]
    public string DateShipFact { get; set; }
    [DataMember]
    public string TypeShip { get; set; }
    [DataMember]
    public string TravelTimePlan { get; set; }
    [DataMember]
    public string DateDelivery { get; set; }
    [DataMember]
    public string DateDeliveryFact { get; set; }
    [DataMember]
    public string DateKabinetReady { get; set; }
    [DataMember]
    public string DateMontagStart { get; set; }
    [DataMember]
    public string DateMontagEnd { get; set; }
    [DataMember]
    public string Comment5 { get; set; }
    [DataMember]
    public string NumbProject { get; set; }
    [DataMember]
    public decimal? CostMontage { get; set; }
    [DataMember]
    public string Comment3 { get; set; }
    [DataMember]
    public string Stat_text { get; set; }
    [DataMember]
    public string Stat { get; set; }
    [DataMember]
    public int? ID { get; set; }
    [DataMember]
    public DateTime? CreateDate { get; set; }

    [DataMember]
    public string sn_common { get; set; }
    [DataMember]
    public string ItemSL { get; set; }
    [DataMember]
    public string descr { get; set; }
    [DataMember]
    public string u_m { get; set; }
    [DataMember]
    public string coi_ser_num { get; set; }
    [DataMember]
    public string coi_stat { get; set; }
    [DataMember]
    public decimal? qty_ordered { get; set; }
    [DataMember]
    public decimal? qty_shipped { get; set; }
    [DataMember]
    public string JobNum { get; set; }
    [DataMember]
    public string Job { get; set; }
    [DataMember]
    public int? Suffix { get; set; }
    [DataMember]
    public string cust { get; set; }
    [DataMember]
    public string customer_ship { get; set; }
    [DataMember]
    public DateTime? due_date { get; set; }
    [DataMember]
    public DateTime? date_fact_whse { get; set; }
    [DataMember]
    public string co_num { get; set; }
    [DataMember]
    public int? co_line { get; set; }
    [DataMember]
    public int? DeficitAPS_rowCount { get; set; }
    [DataMember]
    public decimal? DeficitAPS_CostAll { get; set; }
    [DataMember]
    public DateTime? DateShipFrom1C { get; set; }
    [DataMember]
    public string fsi_date { get; set; }
    [DataMember]
    public decimal? price_all { get; set; }

  }

  /*
      [DataContract]
      public class FaultExecStoredProc
      {
          private int _ErrorCode = 0;
          private string _Message = string.Empty;

          public FaultExecStoredProc(int Severity, string Infobar)
          {
              _ErrorCode = Severity;
              _Message = Infobar;
          }

          [DataMember]
          public int ErrorCode
          {
              get { return _ErrorCode; }
              set { _ErrorCode = value; }
          }
          [DataMember]
          public string Message
          {
              get { return _Message; }
              set { _Message = value; }
          }
      }
  */

}
