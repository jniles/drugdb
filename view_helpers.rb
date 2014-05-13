module ViewHelpers

  NUMBER_OF_COLUMNS = 6
  SLIDE_TIME = 1000

  def chart_link(link_name, location, drug_name, element_id)
    %(
      <a href='#' class="button-more-info" id=#{element_id}>#{link_name}</a>
      <script type="text/javascript">
        $(function(){
          var link = $('##{element_id}');
          var this_row = link.closest('tr');
          var chart_row = $('<tr><td colspan="#{NUMBER_OF_COLUMNS}"></tr>');
          var container = $('td', chart_row);

          link.click(function(event){
            event.preventDefault();
            console.debug('sending...');
            container.hide();
            this_row.after(chart_row);
            container.load('/#{location}/#{drug_name}/line_chart', function(data){
              console.debug('got it!');
              var chart = $('div', container);
              chart.hide();
              container.show();
              chart.slideDown('#{SLIDE_TIME}');
              link.unbind('click');
              link.click(function(event){
                event.preventDefault();
                chart.slideToggle('#{SLIDE_TIME}');
              });
            });
          });

        });
      </script>
    )
  end
  


end
