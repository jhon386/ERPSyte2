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

namespace ERPSyte2.Services
{
    [ServiceContract(Namespace = "")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AJAXService
    {
        [OperationContract]
        [WebInvoke(ResponseFormat = WebMessageFormat.Json)]
        public string HelloWorld()
        {
            return "Hello, world!";
        }

        [OperationContract]
        [WebInvoke(ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Hello"//"/Hello?name={name}"
        public string Hello(string name)
        {
            return string.Format("You sended {0}", name);
        }

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //, UriTemplate = "Add"//"Add?n1={n1}&n2={n2}"
        public double Add(double n1, double n2)
        {
            return Math.Round(n1 + n2, 1);
        }

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)] //[WebGet(UriTemplate = "/GetMessage/?header={header}&?body={body}", ResponseFormat = WebMessageFormat.Json)]
        public Message ComposeMessage(string header, string body)
        {
            Message message = new Message() { Header = header, Body = body };

            return message;
        }

        [OperationContract]
        public void SayHello()
        {
            var serializer = new JavaScriptSerializer();

            SimpleMessage message = new SimpleMessage() { SMMessage = "Hello World" };
            string json = serializer.Serialize(message); //JsonConvert. 
            HttpContext.Current.Response.ContentType = "application/json; charset=utf-8";
            HttpContext.Current.Response.Write(json);
        }

        [OperationContract]
        [WebInvoke(BodyStyle = WebMessageBodyStyle.WrappedRequest, RequestFormat = WebMessageFormat.Json)]
        public void SayHelloBy(string name)
        {
            var serializer = new JavaScriptSerializer();

            SimpleMessage message = new SimpleMessage() { SMMessage = string.Format("Hello {0}", name) };
            string json = serializer.Serialize(message);
            HttpContext.Current.Response.ContentType = "application/json; charset=utf-8";
            HttpContext.Current.Response.Write(json);
        }

        [OperationContract, WebGet]
        public Stream GetValue()
        {
            string result = "Hello world";
            byte[] resultBytes = Encoding.UTF8.GetBytes(result);
            return new MemoryStream(resultBytes);
        }

        [OperationContract]
        public void DoWork()
        {
            // Add your operation implementation here
            return;
        }

    }
}
