(function (window, undefined) {
  "use strict";

  //https://stackoverflow.com/questions/22251813/freeze-header-column-using-scrolltop-scrollleft-corner-cell
  $(document).ready(function () {
    $(document).scroll(function () {
      if ($('#tableImplPlan').size() > 0) {
        var delta = $(window).scrollTop() - $("#tableImplPlan thead.top tr:first").offset().top;
        //window.console && console.log('delta: ' + delta);
        if (delta > 0) {
          translate($("#tableImplPlan thead.top #HeaderRow1 th"), 0, delta);
          translate($("#tableImplPlan thead.top #HeaderRow2 th"), 0, delta);
          translate($("#tableImplPlan thead.top #HeaderRow3 th"), 0, delta);
        } else {
          translate($("#tableImplPlan thead.top #HeaderRow1 th"), 0, 0);
          translate($("#tableImplPlan thead.top #HeaderRow2 th"), 0, 0);
          translate($("#tableImplPlan thead.top #HeaderRow3 th"), 0, 0);
        };
      };

      if ($('#tableImplPlan').size() > 0) {
        var delta = $(window).scrollLeft() - $("#tableImplPlan td:nth-child(1),#HeaderRow1 th:nth-child(1)").offset().left;

        if (delta > 0) {
          translate($("#tableImplPlan td:nth-child(1)"), delta, 0);
        } else {
          translate($("#tableImplPlan td:nth-child(1)"), 0, 0);
        };
      };

      function translate(element, x, y) {
        var translation = "translate(" + x + "px," + y + "px)"

        element.css({
          "transform": translation,
          "-ms-transform": translation,
          "-webkit-transform": translation,
          "-o-transform": translation,
          "-moz-transform": translation,
        });
      }
    });
  });


  

})(window)