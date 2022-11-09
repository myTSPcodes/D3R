// get the data from shiny with Shiny.addCustomMessgroupHandler
// 'phonedata' is what we have specified in server and it must match here

Shiny.addCustomMessageHandler("r-data2-d3",d3jschart);
function d3jschart(d3Dataa){
  
  
  

	// to store the data
	var r2d3Data = d3Dataa;
  let MyData = r2d3Data[0]; // single data
  var data = r2d3Data
  console.log(data)
   console.log(data.slice(0,3))
   
   data = data.slice(0,MyData.slider2*10)
	//console.log(MyData.group)
	//console.log(MyData.slider)
	//console.log(MyData.variable)
	//console.log(MyData['group'])
	//console.log(MyData['weight'])
	
	function splitMatrix(matrix) {
  return matrix.reduce(function(acc, x) {
    acc[0].push(x.variable);
    acc[1].push(x.group);
    return acc;
  }, [[],[]]);
}


	// variables
	  //console.log(splitMatrix(data)[0])
	// groups
		//console.log(splitMatrix(data)[1])
 // var myVar = splitMatrix(data)[0]
 // var myGro = splitMatrix(data)[1]


	console.log("*************************")
	console.log("*************************")
	//console.log(d3Data['head...']) // direct pass from R now is called head 
	//console.log(d3Data[0]['d3Data'].group)

 // var myRange = d3.range(MyData.slider2)
 // myRange.forEach( (i) => {
   // console.log("*" + i + "*")
 // });
  //console.log(myRange)
	
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
		
		



 var myGroup = d3.map(data, function(d){
    // console.log(d.group)
   return d.group;})
   .keys()
   
   console.log(myGroup)
   
  var myVars = d3.map(data, function(d){
    return d.variable;}).keys()

   console.log(myVars)

  // Build X scales and axis:
  var x = d3.scaleBand()
    .range([ 0, width ]) //* MyData.slider2/10 ])
    .domain(myGroup)//.slice(0,MyData.slider2))
    .padding(0.05);
  svg.append("g")
    .style("font-size", 15)
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).tickSize(0))
    .select(".domain").remove()

  // Build Y scales and axis:
  var y = d3.scaleBand()
    .range([ height,0 ])//* MyData.slider1/10, 0 ])
    .domain(myVars) //.slice(0,MyData.slider1))
    .padding(0.05);
  svg.append("g")
    .style("font-size", 15)
    .call(d3.axisLeft(y).tickSize(0))
    .select(".domain").remove()

  // Build color scale
  var myColor = d3.scaleSequential()
    .interpolator(d3.interpolateInferno)
    .domain([1,100])

function mouseover(){}
function mousemove(){}
function mouseleave(){}

const tool = () => {
return [alert("hello"), alert("bye")]
   
  
};
  




var selectedOnes = []
var msgs = ""

function currentColor (col){
  if (col == 'white'){
    return 'red';
  }else{
    return 'white';
  }
  
} 
  // add the squares
  svg.selectAll()
    .data(data, function(d) {return d.group+':'+d.variable;})
    //.enter()
    //.append("rect")
    .join("rect")
      .attr("x", function(d) { return x(d.group) })
      .attr("y", function(d) { return y(d.variable) })
        

      .attr("rx", 5)
      .attr("ry", 5)
      .attr("width", x.bandwidth() )
      .attr("height", y.bandwidth() )
      .style("fill", function(d) { return myColor(d.value)} )
      .style("stroke-width", 4)
      .style("stroke", "white")
      .style("opacity", 0.8)
    .on("mouseover", function(d){
      //alert(msg(d))
    //   d3.select(this).style("fill", 'blue' )
    })
    .on("mousemove", mousemove)
    .on("mouseleave", function(d){
      //alert(msg(d))
    })

    
    
    d3.selectAll("rect")
    .on("click", function(d){
   //  alert(msg(d))
            d3.select("#placeholder1").text([d.variable,d.group])

            d3.select(this).style('stroke', currentColor(d3.select(this).style('stroke')))
            
            if (!(selectedOnes.includes(d.variable)) && d3.select(this).style('stroke') == "red" ){
            selectedOnes.push([d.variable,d.group])         
            }
            //console.log(selectedOnes)
            
            // make the following lines happen only once not for evey iteration of data
              
            
            
               Shiny.setInputValue(
              "d3variable", 
              showSelected(selectedOnes));
              

    })
    
    
    
    const showSelected = (s) => {
      msgs = ""
      
      s.forEach((i)=>{
        msgs +=  "(" + i+ ")"
        msgs += ","
      })
        
  
      
      
    
      
    //  });
            return msgs

    }
      
      var  arect = d3.select('rect')
    
    
    




    
    
    
    var arectObjcs = d3.selectAll('rect')
    
    //var singleRect;
    //var index = d3.range(3)
    //arectObjcs.join(index, function (d){
    //  singleRect = d['_groups'][0][0]
    //  console.log(singleRect)
      
   // })


         //   arect
        //      .on("click", function() {
                
                
          
               
          //     Shiny.setInputValue(
         //     "Rectclicked", 
         //     "myClickedValue");
          //    console.log("clicked")
              
         //     tool(1)
              
              
              
              // create a tooltip
  
    
         //     })
       
    
    
    // controlling Shiny style from d3 

d3.select('.well').style("background-color", "white");
//d3.selectAll('.help-block').attr('class', "help-block col-sm-4");


//d3.selectAll('rect').style("margin-left" , 1000*parseInt(MyData.slider))


//const update = () => {d3.selectAll('.col-sm-4').attr('width', 1000*parseInt(MyData.slider))};


function onlyUnique(value, index, self) { 
    return self.indexOf(value) === index;
}

};