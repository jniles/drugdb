function show_hide_zero_count(){
	$(".zero-count").toggle();
}

function setup_display(){
	var last_displayed = localStorage.getItem('selected_center');
	$("#hc_select").val(last_displayed);
	if (last_displayed != null){
		$(".hidden").hide();
		$("#"+last_displayed).show();
	}else{
		change_displayed_center(); //do the default instead
	}
}


function change_displayed_center(){
	var selected_center = $("#hc_select").val();
	$(".hidden").hide();
	$("#"+selected_center).show();
	localStorage.setItem('selected_center',selected_center);
}

function add_chart_row(cpt,hc_id){
	var new_row = "<tr colspan='5' id='display_chart_"+hc_id+"_"+cpt+"'><td><p>WOOF</p></td></tr>";
	$("#view_chart_"+hc_id+"_"+cpt).parent().parent().after($(new_row)); //go up from <a> to <td> to <tr>, then append
}


$(document).on("ready",setup_display);
$("#hc_select").on("change",change_displayed_center);



$(".zero_count_hide").on("click",show_hide_zero_count);

