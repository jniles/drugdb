(function (win) {
  'use strict';
  var app = win.app = {};

  // module: users
  app.users = {};

  // sets up listeners for the changing passwords
  app.users.listeners = function changePass() {
    // a small js script to only allow submission once the passwords
    // match.

    var passwd1 = $('#pw1'),
        passwd2 = $('#pw2'),
        valid = false;

    $('input[type=password]').keyup(function () {
      // disabled if not valid
      valid = passwd1.val() === passwd2.val() && passwd1.val() !== '';

      if (valid) {
        $('.prefix').removeClass('secondary').addClass('success');
        $('input[type=submit]').removeClass('warning').addClass('success');
      } else {
        $('.prefix').removeClass('success').addClass('secondary');
        $('input[type=submit]').removeClass('success').addClass('warning');
      }

      $('input[type=submit]').prop('disabled', !valid);
    });
  };


  // MODULE: Drugs
  app.drugs = {};

  // sets up listeners for health center selection
  app.drugs.listeners = function () {

    // TODO
    // These listeners should be written directly in the application
    // Set up listeners for this module
    $(win.document).on('ready', setupDisplay);

    $('.zeroCountToggle').on('click', toggleZeroCounts);

    $('#hc_select').on('change', changeDisplayedCenter);

    $('.hc_table').bind('click', function (event) {
      if (event.target.className == 'chart_link') {
        var splitId = event.target.id.split('_');
        addChartRow(splitId[0],splitId[2],splitId[3]);
      }
    });

    // Shows or hides zero count records
    function toggleZeroCounts() {
      $('.zero-count').toggle();
    }

    // this function will hide every health center,
    // then display the health center with id "id"
    function showHealthCenterTable(id) {
      $('.hidden').hide();
      $('#' + id).show();
    }

    function setupDisplay() {
      var cachedHealthCenter = localStorage.getItem('selectedCenter');

      if (!cachedHealthCenter) {

        // load  a default health center
        changeDisplayedCenter();
      } else {

        // set the <select> to the cached health center
        $('#hc_select').val(cachedHealthCenter);
        showHealthCenterTable(cachedHealthCenter);
      }
    }

    function changeDisplayedCenter() {
      var selectedCenter = $('#hc_select').val();
      showHealthCenterTable(selectedCenter);
      localStorage.setItem('selectedCenter', selectedCenter);
    }

    function addChartRow(chartType, hcId, cpt) {

      var chartString = chartType + '_chart_'+hcId+'_'+cpt;
      if ($('#display_'+chartString).is(':visible')) {
        $('#display_'+chartString).remove();
        return;
      }

      var newRow = '<tr id=\'display_'+chartString+'\'><td colspan=\'5\'></td></tr>';

      // get the drug name from this same row...
      var drugName = $('#'+chartString).parent().parent().find('.drug_name').html();

      // go up from <a> to <td> to <tr>, then append
      $('#'+chartString).parent().parent().after($(newRow));

      // we decide what to use in the function, then call this one with different args on each td
      drawGraph(cpt, hcId, chartType, drugName);
    }

    function drawGraph(cpt, hcId, chartType, drugName) {
      var url = ['data', chartType, hcId, cpt].join('/');

      // Draws graph with whatever charting library we have.
      $.getJSON(url, function renderChart(chartData) {
        // hack - need the 0 cause this uses regular DOM element objects, not jQuery objects
        var obj = $('#display_'+chartType+'_chart_'+hcId+'_'+cpt+' td');

        // Render the chart
        obj.highcharts({
          title : {
            // drug names are all caps anyway...
            text: 'Consumption for ' + drugName,
            x: -20
          },
          xAxis: {
            title: {
              text: 'Dates'
            },
            categories: chartData.date
          },
          yAxis: {
            title: {
              text:'Sales'
            }
          },
          series:[{
            name: 'Sales',
            data: chartData.count,
            showInLegend:false
          }]
        });
      });
    }
  };

})(window);
