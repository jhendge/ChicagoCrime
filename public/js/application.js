//---------------- Bar Chart ------------------------/

// Ready the document using jQuery

$("#d3graph").ready(function() {

var width = $("#d3graph").width();

var margin = {top: 10, right: 30, bottom: 20, left: 40},
    width = width - margin.left - margin.right,
    height = 300 - margin.top - margin.bottom;

var formatPercent = d3.format(".%");

var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1, 1);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickFormat(formatPercent);

var svg = d3.select("#show_history").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// 

var data = window.temperature_data;

  x.domain(data.map(function(d) { return d.temperature; }));
  y.domain([0, d3.max(data, function(d) { return d.homicides; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    .append("text")
      .attr("transform", "rotate(0)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Temp(ºF)");

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Homicides");

  svg.selectAll(".bar")
      .data(data)
      .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.temperature); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.homicides); })
      .attr("height", function(d) { return height - y(d.homicides); });

  d3.select("input").on("change", change);

  var sortTimeout = setTimeout(function() {
    d3.select("input").property("checked", true).each(change);
  }, 2000);

  function change() {
    clearTimeout(sortTimeout);

    // Copy-on-write since tweens are evaluated after a delay.
    var x0 = x.domain(data.sort(this.checked
        ? function(a, b) { return b.homicides - a.homicides; }
        : function(a, b) { return d3.ascending(a.temperature, b.temperature); })
        .map(function(d) { return d.temperature; }))
        .copy();

    var transition = svg.transition().duration(750),
        delay = function(d, i) { return i * 50; };

    transition.selectAll(".bar")
        .delay(delay)
        .attr("x", function(d) { return x0(d.temperature); });

    transition.select(".x.axis")
        .call(xAxis)
      .selectAll("g")
        .delay(delay);
  }

});



//---------------- Color Clipping Graph ------------------------/


$("#color_clipping").ready(function() {

var width = $("#color_clipping").width();

var margin = {top: 20, right: 20, bottom: 30, left: 50},
    width = width - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

// var parseDate = d3.time.format("%Y%m%d").parse;

var x = d3.scale.linear()
    .range([0, width]);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

var line = d3.svg.line()
    .interpolate("basis")
    .x(function(d) { return x(d.district); })
    .y(function(d) { return y(d.homicide_total); });

var svg = d3.select("#district_count").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");



  var data = window.homicide_count;

function draw(data) {
    console.log(data); // this is your data
}

draw(data);

  x.domain([data[0].district, data[data.length - 1].district]);
  y.domain(d3.extent(data, function(d) { return d.homicide_total; }));

  svg.append("clipPath")
      .attr("id", "clip-above")
    .append("rect")
      .attr("width", width)
      .attr("height", y(20));

  svg.append("clipPath")
      .attr("id", "clip-below")
    .append("rect")
      .attr("y", y(20))
      .attr("width", width)
      .attr("height", height - y(20));

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    .append("text")
      .attr("transform", "rotate(0)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("District");

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Homicides");

  svg.selectAll(".line")
      .data(["above", "below"])
    .enter().append("path")
      .attr("class", function(d) { return "line " + d; })
      .attr("clip-path", function(d) { return "url(#clip-" + d + ")"; })
      .datum(data)
      .attr("d", line);
});



