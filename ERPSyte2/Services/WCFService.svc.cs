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
    
        public string HelloWorld() {
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

            if (aData != null) {
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
