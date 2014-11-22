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

function add_chart_row(chart_type,hc_id,cpt){
	var chart_string = chart_type + "_chart_"+hc_id+"_"+cpt;
	if($("#"+"display_"+chart_string).is(":visible")){
		$("#"+"display_"+chart_string).remove();
		return;
	}
	var new_row = "<tr id='display_"+chart_string+"'><td colspan='5'></td></tr>";
	var drug_name = $("#"+chart_string).parent().parent().find(".drug_name").html(); //get the drug name from this same row...
	$("#"+chart_string).parent().parent().after($(new_row)); //go up from <a> to <td> to <tr>, then append
	draw_graph(cpt,hc_id,chart_type,drug_name); //we decidfe what to use in the function, then call this one with different args on each td
}

function draw_graph(cpt,hc_id,chart_type,drug_name){
	//Draws graph with whatever charting library we have.
	$.getJSON("/data/"+chart_type+"/"+hc_id+"/"+cpt, function(chart_data){;
	var obj = $("#display_"+chart_type+"_chart_"+hc_id+"_"+cpt+" td"); //hack - need the 0 cause this uses regular DOM element objects, not jQuery objects
	console.log(chart_data['date']);
	console.log(chart_data['count']);
	obj.highcharts({
		title:{
			text:'Consumption for '+drug_name, //drug names are allcaps anyway...
			x: -20
		},
		xAxis:{
			title:'Date',
			categories:chart_data['date']
		},
		yAxis:{
			title:'Sales'
		},
		series:[{
			name:'Sales',
			data:chart_data['count']
			}]
		
	})
	});
}

$(document).on("ready",setup_display);
$("#hc_select").on("change",change_displayed_center);
$(".hc_table").bind('click',function(event){
	if(event.target.className == "chart_link"){
		var split_id = event.target.id.split("_");
		add_chart_row(split_id[0],split_id[2],split_id[3]);
	     }
});	


$(".zero_count_hide").on("click",show_hide_zero_count);

