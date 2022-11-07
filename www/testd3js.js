// get the data from shiny with Shiny.addCustomMessgroupHandler
// 'phonedata' is what we have specified in server and it must match here

Shiny.addCustomMessageHandler("r-data2-d3",d3jschart);
function d3jschart(d3Dataa){
  
  
  

	// to store the data
	var r2d3Data = d3Dataa;
  let MyData = r2d3Data[0]; // single data
  var data = r2d3Data
	console.log(MyData)
	console.log(MyData.group)
	console.log(MyData.slider)
	console.log(MyData.variable)
	//console.log(MyData['group'])
	//console.log(MyData['weight'])

	console.log("*************************")
	console.log("*************************")
	//console.log(d3Data['head...']) // direct pass from R now is called head 
	//console.log(d3Data[0]['d3Data'].group)

;

	
	// to remove previous chart
	d3.selectAll("svg").remove();
	
	// decide the margin
	var margin = {top: 50, right: 50, bottom: 50, left: 50},
	width = 850 - margin.left - margin.right,
	height = 550 - margin.top - margin.bottom;
	
	// create svg element and provide height and weight attributes
	var svg = d3.select("#D3Plot")
		.append("svg")
		.attr("width", width + margin.left + margin.right)
		.attr("height", height + margin.top + margin.bottom)
		.append("g")
  .attr("transform",
        "translate(" + margin.left + "," + margin.top + ")");
		
		



 var myGroup = d3.map(data, function(d){return d.group;}).keys()
  var myVars = d3.map(data, function(d){return d.variable;}).keys()

  // Build X scales and axis:
  var x = d3.scaleBand()
    .range([ 0, width ])
    .domain(myGroup)
    .padding(0.05);
  svg.append("g")
    .style("font-size", 15)
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).tickSize(0))
    .select(".domain").remove()

  // Build Y scales and axis:
  var y = d3.scaleBand()
    .range([ height, 0 ])
    .domain(myVars)
    .padding(0.05);
  svg.append("g")
    .style("font-size", 15)
    .call(d3.axisLeft(y).tickSize(0))
    .select(".domain").remove()

  // Build color scale
  var myColor = d3.scaleSequential()
    .interpolator(d3.interpolateInferno)
    .domain([1,100])

  // create a tooltip
  var Tooltip = d3.select("#div_template")
    .append("div")
    .style("opacity", 0)
    .attr("class", "tooltip")
    .style("background-color", "white")
    .style("border", "solid")
    .style("border-width", "2px")
    .style("border-radius", "5px")
    .style("padding", "5px")

  // Three function that change the tooltip when user hover / move / leave a cell
  var mouseover = function(d) {
    Tooltip
      .style("opacity", 1)
    d3.select(this)
      .style("stroke", "black")
      .style("opacity", 1)
  }
  var mousemove = function(d) {
    Tooltip
      .html("The exact value of<br>this cell is: " + d.value)
      .style("left", (d3.mouse(this)[0]+70) + "px")
      .style("top", (d3.mouse(this)[1]) + "px")
  }
  var mouseleave = function(d) {
    Tooltip
      .style("opacity", 0)
    d3.select(this)
      .style("stroke", "none")
      .style("opacity", 0.8)
  }


  // add the squares
  svg.selectAll()
    .data(data, function(d) {return d.group+':'+d.variable;})
    .enter()
    .append("rect")
      .attr("x", function(d) { return x(d.group) })
      .attr("y", function(d) { return y(d.variable) })
      .attr("rx", 4)
      .attr("ry", 4)
      .attr("width", x.bandwidth() )
      .attr("height", y.bandwidth() )
      .style("fill", function(d) { return myColor(d.value)} )
      .style("stroke-width", 4)
      .style("stroke", "none")
      .style("opacity", 0.8)
    .on("mouseover", mouseover)
    .on("mousemove", mousemove)
    .on("mouseleave", mouseleave)
    
    
    
    
    // controlling Shiny style from d3 

d3.select('.well').style("background-color", "white")

};