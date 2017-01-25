using ERPSyte2.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace ERPSyte2
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class WCFAjaxService : IWCFAjaxService
    {
        // To use HTTP GET, add [WebGet] attribute. (Default ResponseFormat is WebMessageFormat.Json)
        // To create an operation that returns XML,
        //     add [WebGet(ResponseFormat=WebMessageFormat.Xml)],
        //     and include the following line in the operation body:
        //         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml";
        public void DoWork()
        {
            return;
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

        public Message ComposeMessage(string header, string body)
        {
            Message message = new Message() { Header = header, Body = body };

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
    }

    [ServiceContract]
    public interface IWCFAjaxService
    {
        [OperationContract]
        void DoWork();

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
        Message ComposeMessage(string header, string body);

        [OperationContract]
        void SayHello();

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json)]
        void SayHelloBy(string name);

        [OperationContract, WebGet]
        Stream GetValue();
    }

    
}
