module ViewHelpers

  def chart_link(link_name)
    unique_id = 'xkcd' # make this random later
    erb :line_graph, :locals => {:element_id => unique_id, :link_title => link_name}
  end
  


end
