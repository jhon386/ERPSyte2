(function (funcName, baseObj) {
    "use strict";
    // The public function name defaults to window.docReady
    // but you can modify the last line of this function to pass in a different object or method name
    // if you want to put them in a different namespace and those will be used instead of 
    // window.docReady(...)
    funcName = funcName || "docReady";
    baseObj = baseObj || window;
    var readyList = [];
    var readyFired = false;
    var readyEventHandlersInstalled = false;

    // call this when the document is ready
    // this function protects itself against being called more than once
    function ready() {
        if (!readyFired) {
            // this must be set to true before we start calling callbacks
            readyFired = true;
            for (var i = 0; i < readyList.length; i++) {
                // if a callback here happens to add new ready handlers,
                // the docReady() function will see that it already fired
                // and will schedule the callback to run right after
                // this event loop finishes so all handlers will still execute
                // in order and no new ones will be added to the readyList
                // while we are processing the list
                readyList[i].fn.call(window, readyList[i].ctx);
            }
            // allow any closures held by these functions to free
            readyList = [];
        }
    }

    function readyStateChange() {
        if (document.readyState === "complete") {
            ready();
        }
    }

    // This is the one public interface
    // docReady(fn, context);
    // the context argument is optional - if present, it will be passed
    // as an argument to the callback
    baseObj[funcName] = function (callback, context) {
        // if ready has already fired, then just schedule the callback
        // to fire asynchronously, but right away
        if (readyFired) {
            setTimeout(function () { callback(context); }, 1);
            return;
        } else {
            // add the function and context to the list
            readyList.push({ fn: callback, ctx: context });
        }
        // if document already ready to go, schedule the ready function to run
        // IE only safe when readyState is "complete", others safe when readyState is "interactive"
        if (document.readyState === "complete" || (!document.attachEvent && document.readyState === "interactive")) {
            setTimeout(ready, 1);
        } else if (!readyEventHandlersInstalled) {
            // otherwise if we don't have event handlers installed, install them
            if (document.addEventListener) {
                // first choice is DOMContentLoaded event
                document.addEventListener("DOMContentLoaded", ready, false);
                // backup is window load event
                window.addEventListener("load", ready, false);
            } else {
                // must be IE
                document.attachEvent("onreadystatechange", readyStateChange);
                window.attachEvent("onload", ready);
            }
            readyEventHandlersInstalled = true;
        }
    }
})("docReady", window);
// modify this previous line to pass in your own method name 
// and object for the method to be attached to
//https://github.com/jfriend00/docReady/blob/master/docready.js
//docReady is a single plain javascript function that provides a method of 
//scheduling one or more javascript functions to run at some later
//point when the DOM has finished loading.

//It works similarly to jQuery's $(document).ready(), but this is a small
//single standalone function that does not require jQuery in any way.

//These are various forms of usage:

//    // pass a function reference
//docReady(fn);

//    // use an anonymous function
//    docReady(function() {
//        // code here
//    });

//    // pass a function reference and a context
//    // the context will be passed to the function as the first argument
//    docReady(fn, context);

//    // use an anonymous function with a context
//    docReady(function(ctx) {
//        // code here that can use the context argument that was passed to docReady
//    }, context);

//    docReady(fn) can be called as many times as desired and each callback function will be
//    called in order when the DOM is done being parsed and is ready for manipulation.

//    If you call docReady(fn) after the DOM is already ready, the callback with be executed
//        as soon as the current thread of execution finishes by using setTimeout(fn, 1).

//        It has been tested in the following browser configurations:

//            IE6 and up
//        Firefox 3.6 and up
//        Chrome 14 and up
//        Safari 5.1 and up
//        Opera 11.6 and up
//        Multiple iOS devices
//        Multiple Android devices

//        Other discussion can be found here: http://stackoverflow.com/questions/9899372/pure-javascript-equivalent-to-jquerys-ready-how-to-call-a-function-when-the/9899701#9899701
