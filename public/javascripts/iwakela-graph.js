function iwakela$graph$drawUserSummary(options){
	options = $.extend({
		showLegend: true,
		data: {}
	}, options);
	

	var time_set = options.data;
	

	function showTooltip(x, y, contents) {
		$('<div id="graph_tooltip" class="graph-tooltip">' + contents + '</div>').css({
			top: y + 5,
			left: x + 5
		}).appendTo("body").show(200);
	}

	var choiceContainer = options.choiceContainer || $("<div id='_choiceContainer' style='display: none'></div>").appendTo("body:first");
	var legendContainer = options.legendContainer;
	var container = options.container;
	
	$.each(time_set, function(key, value){
		choiceContainer.append('<input type="checkbox" name="' + key +
			'" checked="checked">' + value.label + '</input><br />');
	});

	choiceContainer.find("input").click(plotAccordingToChoices);

	function plotAccordingToChoices() {
		var data = [];

		legendContainer && legendContainer.html("");
		choiceContainer.find("input:checked").each(function () {
			var key = $(this).attr("name");
			if (key && time_set[key])
			data.push(time_set[key]);
		});

		if (data.length > 0) {
			var plot = $.plot(container,
				
			data,
			{
				yaxis: { ticks: 0},
				xaxis: { mode: "time", minTickSize: [2, "day"], timeformat: "%y/%m/%d" },
				lines: { show: true },
				points: { show: true },
				legend: legendContainer ? {
					show: options.showLegend,
					container: legendContainer
				} : { show: options.showLegend },
				grid: { hoverable: true }
			});

			var previousPoint = null;            
			container.bind("plothover", function (event, pos, item) {
				if (!item) {
					$("#graph_tooltip").remove();
					previousPoint = null;
					return;
				}
				
				if (previousPoint != item.datapoint) {
					previousPoint = item.datapoint;
					
					$("#graph_tooltip").remove();
					var x = item.datapoint[0].toFixed(2),
						y = item.datapoint[1].toFixed(2);

					//javascript 把秒數轉成gm time的方法看來不是這樣
					var day = new Date(x*1.0);

					var len = y.length
					if (len == 4) {
						var integer = y.slice(0,1);
					}
					else if (len == 5) {
						var integer = y.slice(0,2);
					}

					var time = ((y*1.0- integer*1).toFixed(2)*60.0).toFixed(0)

					integer = integer%24;

					if (time.length == 1) {
						var tiptime = integer + ":0" + time;
					}
					else {
						var tiptime = integer + ":" + time;
					}

					showTooltip(item.pageX, item.pageY,
						"<div style='font-size:80%;color:#0000DD'>" +
							day.getFullYear() + "年" + (day.getMonth()+1) + "月" + day.getDate() + "日" +
						"</div>" +
						"<div style='color:#000;'>" +
							item.series.label + tiptime +
						"</div>"
						);
				}
			
			});
		}

	}

	plotAccordingToChoices();
}