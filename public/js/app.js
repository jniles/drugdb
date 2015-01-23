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

    // set up listeners for this module
    $(win.document).on('ready', setupDisplay);
    $('.zero_count_hide').on('click', toggleZeroCounts);
    $('#hc_select').on('change', changeDisplayedCenter);

    $('.hc_table').bind('click', function (event) {
      if (event.target.className == 'chart_link') {
        var split_id = event.target.id.split('_');
        addChartRow(split_id[0],split_id[2],split_id[3]);
      }
    });	

    // Toggles the zero count records
    function toggleZeroCounts() {
      $('.zero-count').toggle();
    }

    function setupDisplay() {
      var last_displayed = localStorage.getItem('selected_center');

      $('#hc_select').val(last_displayed);

      if (last_displayed !== null) {
        $('.hidden').hide();
        $('#'+last_displayed).show();
      } else {
        changeDisplayedCenter(); //do the default instead
      }
    }

    function changeDisplayedCenter() {
      var selected_center = $('#hc_select').val();
      $('.hidden').hide();
      $('#'+selected_center).show();
      localStorage.setItem('selected_center',selected_center);
    }

    function addChartRow(chart_type, hc_id, cpt) {

      var chartString = chart_type + '_chart_'+hc_id+'_'+cpt;
      if ($('#display_'+chartString).is(':visible')) {
        $('#display_'+chartString).remove();
        return;
      }

      var newRow = '<tr id=\'display_'+chartString+'\'><td colspan=\'5\'></td></tr>';

      // get the drug name from this same row...
      var drugName = $('#'+chartString).parent().parent().find('.drugName').html();

      // go up from <a> to <td> to <tr>, then append
      $('#'+chartString).parent().parent().after($(newRow));

      // we decide what to use in the function, then call this one with different args on each td
      drawGraph(cpt, hc_id, chart_type, drugName);
    }

    function drawGraph(cpt,hc_id,chart_type,drugName) {

      // Draws graph with whatever charting library we have.
      $.getJSON('/data/'+chart_type+'/'+hc_id+'/'+cpt, function renderChart(chartData) {
        // hack - need the 0 cause this uses regular DOM element objects, not jQuery objects
        var obj = $('#display_'+chart_type+'_chart_'+hc_id+'_'+cpt+' td');

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
