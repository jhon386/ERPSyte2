using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Configuration;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.ServiceModel.Web;

namespace ERPSyte2.Services
{
    //
    // Обработка ошибок в WCF при использовании REST подхода. 
    // http://mrdragon-den.blogspot.ru/2009/10/wcf-rest.html
    //
    public class WCFErrorHandle
    {
        //
        // Во вторых реализовать два класса ClientError и ServerError, они будут содержать подробное описание ошибки, к 
        // примеру, дата ошибки и сообщения об ошибке для разработчика и конечного пользователя. Т.е. разработчик клиента 
        // для нашего сервиса может не придумывать сообщения для пользователя, а использовать готовое сообщение.
        //
        [DataContract]
        public class WCFCustomError
        {
            //
            // Рекомендации. Управление версиями контракта данных
            // https://msdn.microsoft.com/ru-ru/library/ms733832(v=vs.110).aspx
            // Для всех элементов данных, добавленных в версии 2 контракта данных, свойство Order должно иметь значение 2.
            // Для свойства IsRequired всегда следует сохранять значение по умолчанию false. 
            //
            [DataMember]
            public DateTime Date { get; set; }

            public string Type {
                get {
                    return GetType().Name;
                }
            }

            [DataMember(Name = "Type")]
            private string TypeForSerialization { get; set; }

            [OnSerializing]
            void OnSerializing(StreamingContext ctx)
            {
                //if (Type == null)
                //    TypeForSerialization = "Type == null";
                //else
                    TypeForSerialization = Type;
            }

            [DataMember]
            public int Code { get; set; }

            [DataMember]
            public string Message { get; set; }

            [DataMember]
            public string Source { get; set; }

            [DataMember]
            public string Parameters { get; set; }

            [DataMember]
            public string HelpLink { get; set; }

            #region constructors
            public WCFCustomError()
                : this(0)
            {
            }
            public WCFCustomError(int code)
                : this(code, "")
            {
            }
            public WCFCustomError(int code, string message)
                : this(code, message, "")
            {
            }
            public WCFCustomError(int code, string message, string source)
                : this(code, message, source, "")
            {
            }
            public WCFCustomError(int code, string message, string source, string parameters)
                : this(code, message, source, parameters, "")
            {
            }
            public WCFCustomError(int code, string message, string source, string parameters, string helpLink)
            {
                Date = DateTime.Now;
                Code = code;
                Message = message;
                Source = source;
                Parameters = parameters;
                HelpLink = helpLink;
            }
            #endregion

            public void Assign(WCFCustomError sender)
            {
                if (sender != null)
                {
                    Date = sender.Date;
                    Code = sender.Code;
                    Message = sender.Message;
                    Source = sender.Source;
                    Parameters = sender.Parameters;
                    HelpLink = sender.HelpLink;
                }
            }
        }
/*
        public class WCFCustomError<TDetail> : WCFCustomError //where TDetail : WCFCustomError
        {
            TDetail detail;

            public WCFCustomError(TDetail detail) 
                : base()
            {
                this.detail = detail;
            }

            public TDetail Detail
            {
                get { return detail; }
            }

        }
*/
        //
        // Ошибки, в которых виноват клиент (неполные/неверные данные ...)
        //
        public class WCFClientError : WCFCustomError
        {
            public WCFClientError()
                : base()
            {
            }
            public WCFClientError(int code)
                : base(code)
            {
            }
            public WCFClientError(int code, string message)
                : base(code, message)
            {
            }
            public WCFClientError(int code, string message, string source)
                : base(code, message, source)
            {
            }
            public WCFClientError(int code, string message, string source, string parameters)
                : base(code, message, source, parameters)
            {
            }
            public WCFClientError(int code, string message, string source, string parameters, string helpLink)
                : base(code, message, source, parameters, helpLink)
            {
            }
        }

        //
        // Ошибки, в которых виноват сервер (блокировка, соединение, права ...)
        //
        public class WCFServerError : WCFCustomError
        {
            public WCFServerError()
                : base()
            {
            }
            public WCFServerError(int code)
                : base(code)
            {
            }
            public WCFServerError(int code, string message)
                : base(code, message)
            {
            }
            public WCFServerError(int code, string message, string source)
                : base(code, message, source)
            {
            }
            public WCFServerError(int code, string message, string source, string parameters)
                : base(code, message, source, parameters)
            {
            }
            public WCFServerError(int code, string message, string source, string parameters, string helpLink)
                : base(code, message, source, parameters, helpLink)
            {
            }
        }

        // 
        // Осталось научить наш сервис возвращать ошибки в таком виде. Для этого нужно создать класс реализующий IErrorHandler, 
        // атрибут ErrorHandlerBehavior и добавить атрибут в реализацию сервиса.
        //
        public class WCFCustomErrorHandler : IErrorHandler
        {
            private const string InternalErrorCustomerMessage = "We are having technical issuse at the moment, please try again.";

            public void ProvideFault(Exception ex, MessageVersion version, ref Message fault)
            {
                FaultException faultException = CreateFaultException(ex);

                MessageFault messageFault = faultException.CreateMessageFault();
                fault = Message.CreateMessage(version, messageFault, faultException.Action);
            }

            public bool HandleError(Exception error)
            {
                //TODO Add saving error here
                return true;
            }

            internal static FaultException CreateFaultException(Exception ex)
            {
                FaultException faultException = new FaultException<WCFCustomError>(
                      new WCFCustomError(17, ex.Message), InternalErrorCustomerMessage);
                return faultException;
            }

            //internal static FaultException CreateFaultException<T>() where T : WCFCustomError, new()
            //{
            //    FaultException faultException = new FaultException<T>(
            //          new T(), InternalErrorCustomerMessage);
            //    return faultException;
            //}
        }

        public class ErrorHandlerBehaviorAttribute : Attribute, IServiceBehavior
        {
            private IErrorHandler _errorHandler;

            public ErrorHandlerBehaviorAttribute(Type typeErrorHandler)
            {
                if (typeErrorHandler == null)
                {
                    throw new ArgumentNullException();
                }

                _errorHandler = (IErrorHandler)Activator.CreateInstance(typeErrorHandler);
            }

            public void ApplyDispatchBehavior(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
            {
                foreach (ChannelDispatcher dispatcher in serviceHostBase.ChannelDispatchers)
                {
                    dispatcher.ErrorHandlers.Add(_errorHandler);
                }
            }

            public void Validate(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase)
            {
            }

            public void AddBindingParameters(ServiceDescription serviceDescription, ServiceHostBase serviceHostBase, Collection<ServiceEndpoint> endpoints, BindingParameterCollection bindingParameters)
            {
            }
        }

        //
        // Если бы мы работали по SOAP, этого было бы достаточно, но для REST это не работает.
        // Для того что бы и для REST подхода заработала архитектура контрактов ошибок WCF, 
        // нам нужно сделать обработчики ошибок, которые сериализуют ошибку в нужный нам формат.
        // Для того что бы служба знала как возвращать ошибки для различных точек доступа, 
        // также создадим расширения поведения точек доступа.
        // Для начал сделаем два дополнительных обработчика ошибок PoxErrorHandler и JsonErrorHandler:
        public class PoxErrorHandler : IErrorHandler
        {
            public bool HandleError(Exception error)
            {
                return true;
            }

            public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
            {
                FaultException faultException = WCFCustomErrorHandler.CreateFaultException(error);

                // extract the our FaultContract object from the exception object.
                var detail = faultException.GetType().GetProperty("Detail").GetGetMethod().Invoke(faultException, null);
                // create a fault message containing our FaultContract object
                fault = Message.CreateMessage(version, faultException.Action, detail, new DataContractSerializer(detail.GetType()));
                // tell WCF to use XML encoding
                var wbf = new WebBodyFormatMessageProperty(WebContentFormat.Xml);
                fault.Properties.Add(WebBodyFormatMessageProperty.Name, wbf);
            }
        }

        public class JsonErrorHandler : IErrorHandler
        {
            public bool HandleError(Exception error)
            {
                return true;
            }

            public void ProvideFault(Exception error, MessageVersion version, ref Message fault)
            {
                FaultException faultException = null;
                object detail = null;

                Type exceptionType = error.GetType();
                if (exceptionType != null && exceptionType.IsGenericType)
                {
                    // Find the type of the generic parameter
                    var genericType = exceptionType.GetProperty("Detail").GetGetMethod().Invoke(error, null);

                    if (genericType != null && genericType is WCFCustomError)
                    {
                        if (genericType is WCFClientError)
                        {
                            detail = new WCFClientError();
                            faultException = new FaultException<WCFClientError>(new WCFClientError());

                        }
                        else if (genericType is WCFServerError)
                        {
                            detail = new WCFServerError();
                            faultException = new FaultException<WCFServerError>(new WCFServerError());
                        }
                        else
                        {
                            detail = new WCFCustomError();
                            faultException = new FaultException<WCFCustomError>(new WCFCustomError());
                        }

                        (detail as WCFCustomError).Assign(genericType as WCFCustomError);
                    }
                }

                if (faultException == null || detail == null)
                {
                    faultException = WCFCustomErrorHandler.CreateFaultException(error);

                    // extract the our FaultContract object from the exception object.
                    detail = faultException.GetType().GetProperty("Detail").GetGetMethod().Invoke(faultException, null);
                }

                // create a fault message containing our FaultContract object
                fault = Message.CreateMessage(version, faultException.Action, detail, new DataContractJsonSerializer(detail.GetType()));

                //  tell WCF to use JSON encoding rather than default XML
                HttpResponseMessageProperty prop = new HttpResponseMessageProperty();
                prop.StatusCode = HttpStatusCode.BadRequest;
                prop.Headers[HttpResponseHeader.ContentType] = "application/json; charset=utf-8";
                //prop.Headers["jsonerror"] = "true";
                fault.Properties.Add(HttpResponseMessageProperty.Name, prop);
                fault.Properties.Add(WebBodyFormatMessageProperty.Name, new WebBodyFormatMessageProperty(WebContentFormat.Json)); // Use JSON format
            }
        }


        #region Теперь создадим два класа расширителя поведения точек доступа
        public class FaultingJsonBehaviorElement : BehaviorExtensionElement
        {
            public override Type BehaviorType
            {
                get { return typeof(FaultingJsonBehavior); }
            }

            protected override object CreateBehavior()
            {
                return new FaultingJsonBehavior();
            }
        }

        public class FaultingJsonBehavior : WebHttpBehavior
        {
            protected override void AddServerErrorHandlers(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
            {
                endpointDispatcher.ChannelDispatcher.ErrorHandlers.Clear();
                endpointDispatcher.ChannelDispatcher.ErrorHandlers.Add(new JsonErrorHandler());
            }

            public override WebMessageFormat DefaultOutgoingResponseFormat
            {
                get
                {
                    return WebMessageFormat.Json;
                }
                set
                {
                    base.DefaultOutgoingResponseFormat = value;
                }
            }
        }

        public class FaultingPoxBehaviorElement : BehaviorExtensionElement
        {
            public override Type BehaviorType
            {
                get { return typeof(FaultingPoxBehavior); }
            }

            protected override object CreateBehavior()
            {
                return new FaultingPoxBehavior();
            }
        }

        public class FaultingPoxBehavior : WebHttpBehavior
        {
            protected override void AddServerErrorHandlers(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
            {
                endpointDispatcher.ChannelDispatcher.ErrorHandlers.Clear();
                endpointDispatcher.ChannelDispatcher.ErrorHandlers.Add(new PoxErrorHandler());
            }
        }
        #endregion
    }
}