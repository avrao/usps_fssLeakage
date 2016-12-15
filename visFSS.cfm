
<!doctype html>
<cfset ivdata = 'iv_spduser'>
<cfajaxproxy cfc="visFSS" jsclassname="TDF">
<cfajaximport>

<cfsetting showdebugoutput="no">

<html>
<head>
<meta charset="utf-8">
<title>FSS Leakage Visualization</title></title>
<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<script language="javascript" src="jscripts/Lance.js"></script>
<script src='jscripts/d3.min.js'></script>
<script src='jscripts/crossfilter.min.js'></script>
<script src='jscripts/dc.min.js'></script>
<script src='jscripts/d3keybindings.js'></script>

<style>
.darkrow td
{
background-color:#C8C8C8;
}
.lightrow td
{
background-color:#f3f3f3;
}

body {
background-color:#f3f3f3;
}

tspan {
white-space:normal;
} 

tspan:nth-child(2n)
{
display:block;
}

.slct {
font-size:14px;
line-height: 1.3333333;
padding: 5px 16px;
margin: 0px 3px;
-webkit-border-radius:6px;
-moz-border-radius:6px;
border-radius:6px;
-webkit-box-shadow: 0 3px 5px #cFcFcF;
-moz-box-shadow: 0 3px 5px #cFcFcF;
box-shadow: 0 3px 5px #cFcFcF;
background-image: linear-gradient(to bottom, #ffffff, #C0C0C0);
background-image: -ms-linear-gradient(top, #ffffff 0%, #C0C0C0 100%);   
/*border:solid  gray 1px;*/

/*background-color: buttonface;*/
box-sizing: border-box;

border: 2px outset buttonface;
}

.slctSmall {
font-size:12px;
line-height: 1.3333333;
padding: 5px 8px;
margin: 0px 3px;
-webkit-border-radius:6px;
-moz-border-radius:6px;
border-radius:6px;
-webkit-box-shadow: 0 3px 5px #cFcFcF;
-moz-box-shadow: 0 3px 5px #cFcFcF;
box-shadow: 0 3px 5px #cFcFcF;
background-image: linear-gradient(to bottom, #ffffff, #C0C0C0);
background-image: -ms-linear-gradient(top, #ffffff 0%, #C0C0C0 100%);   
/*border:solid  gray 1px;*/

/*background-color: buttonface;*/
box-sizing: border-box;

border: 2px outset buttonface;
}

.fset
{
display:inline-block;
border:none;
padding:0px;
margin:0px;	
font-size:16px;	
}

.smallFnt {
font-size:12px;
line-height: 1.3333333;
padding: 5px 8px;
margin: 0px 3px;
border: solid 1px gray;
}

.hyperFont {
font-size:12px;
color:blue;
text-decoration: underline;
text-variant: small-caps;
font-family: times, Times New Roman;
cursor: pointer;
background: transparent;
-webkit-border-radius:6px;
-moz-border-radius:6px;
border-radius:6px;
}

#wrapper 
{
	margin-top:10px;
padding-left: 0px;
position: absolute;	
transition: all .8s ease 0s;
height: 90%
}

#sidebar-wrapper 
{
margin-left: -150px;
left: 0px;
width: 150px;
background: #21435F;
position: absolute;
height: 100%;
z-index: 10000;
transition: all .4s ease 0s;
}

.sidebar-nav {
display: block;
float: left;
width: 150px;
list-style: none;
margin: 0;
padding: 0;
}

#page-content-wrapper 
{
padding-left: 20px;
margin-left: 0;
width: 100%;
height: auto;
}

#wrapper.active 
{
padding-left: 150px;
}

#wrapper.active #sidebar-wrapper 
{
left: 150px;
}

eset
#page-content-wrapper 
{
width: 100%;
}

#sidebar_menu li a, .sidebar-nav li a 
{
color: #999;
display: block;
float: left;
text-decoration: none;
width: 150px;
background: #21435F;
border-top: 1px solid #373737;
border-bottom: 1px solid #1A1A1A;
-webkit-transition: background .5s;
-moz-transition: background .5s;
-o-transition: background .5s;
-ms-transition: background .5s;
transition: background .5s;
}

.sidebar_name {
padding-top: 25px;
color: #fff;
opacity: .7;
}

.sidebar-nav li {
line-height: 40px;
text-indent: 20px;
}

.sidebar-nav li a {
color: #999999;
display: block;
text-decoration: none;
}

.sidebar-nav li a:hover {
color: #fff;
background: rgba(255,255,255,0.2);
text-decoration: none;
}

.sidebar-nav li a:active,.sidebar-nav li a:focus {
text-decoration: none;
}

.sidebar-nav > .sidebar-brand {
height: 65px;
line-height: 60px;
font-size: 18px;
}

.sidebar-nav > .sidebar-brand a {
color: #999999;
}

.sidebar-nav > .sidebar-brand a:hover {
color: #fff;
background: none;
}

#main_icon
{
float:right;
padding-right: 65px;
padding-top:20px;
}

.sub_icon
{
float:right;
padding-right: 65px;
padding-top:10px;
}

.content-header {
height: 65px;
line-height: 65px;
}

.content-header h1 {
margin: 0;
margin-left: 20px;
line-height: 65px;
display: inline-block;
}

.overall {
margin: 0px auto;
font-size: 13px;
padding: 8px 0px;
border-radius: 10px;
box-sizing: border-box;
color: white;
text-shadow: #676767 2px 2px 4px;
height: 30px;
width: 100px;
font-weight: bold;
}

@media (max-width:767px) {
#wrapper 
{
padding-left: 0px;
transition: all .4s ease 0s;
}

#sidebar-wrapper 
{
left: 0px;
}

#wrapper.active 
{
padding-left: 150px;
}

#wrapper.active #sidebar-wrapper 
{
left: 150px;
width: 150px;
transition: all .4s ease 0s;
}
}

</style>

<script>
var csa_dataset = [];  
var csa_hdr = [];
var fp_dataset = [];  
var fp_hdr = [];
var fp_datasetindv= [];  
var fp_dtindv=[];	
var fp_sub= [];  	
var fp_hdrindv = [];
var trendDataset = [];
var trendId = 0;	
var current_failed_pieces = 10000;
var yAxis2, yAxisTot, yAxisCall;

//this is the counter that determines when all charts have been loaded (counting down)
var loadInit = 3; //set to number of charts
var loadCnt = loadInit;

var date_rng = [];
var initLoader = loader({width: 480, height: 150, container: "#mainDiv", id: "initLoader",msg:"Loading . . . "});
var myLoader = loader({width: 480, height: 150, container: "#loaderDiv", id: "loader",msg:"Retrieving . . . "});
var AreaLoader = loader2({width: 175, height: 175, container: "#AreaFSSLeakage", id: "AreaLoader",msg:""});
var DistrictLoader = loader2({width: 175, height: 175, container: "#DistrictFSSLeakage", id: "DistrictLoader",msg:""});
var FacilityLoader = loader2({width: 175, height: 175, container: "#FacilityNested", id: "FacilityLoader",msg:""});
var MailClassLoader = loader2({width: 175, height: 175, container: "#MailClassFSSLeakage", id: "MailClassLoader",msg:""});
var EntPntDiscLoader = loader2({width: 175, height: 175, container: "#EntPntDiscFSSLeakage", id: "EntPntDiscLoader",msg:""});
var SortationLevelLoader = loader2({width: 175, height: 175, container: "#SortationLevelFSSLeakage", id: "SortationLevelLoader",msg:""});
var EntryLoader = loader2({width: 175, height: 175, container: "#chart-EOD", id: "EODLoader",msg:""});
var DOWLoader = loader2({width: 175, height: 175, container: "#chart-DOW", id: "DOWLoader",msg:""});
var ClassLoader = loader2({width: 175, height: 175, container: "#chart-Class", id: "ClassLoader",msg:""});
var ShapeLoader = loader2({width: 175, height: 175, container: "#chart-Shape", id: "ShapeLoader",msg:""});

var filterHds = ['Area: ','District: ','Range: ','Week: ','FSS Site: ','SV Site: '];
var filterArgs = ['National','','Week','04/23/2016','Combined','Combined'];

function disp_fpcont(res,r,c)
{
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_dataset.length;	
//if (cnt-30 < r) r=cnt-30;
if (r < 0)
	r = 0;
//res = fp_dataset.slice(r,c+r);      
var pc = res.shift();
var pc_hdr = pc.shift();

var cntr = res.shift();
var cntr_hdr = cntr.shift();

var temp_rc = 'darkrow';	
d3.select("fpcontdiv").remove

var div = d3.select('body')
	.append('div')
	.attr('id','fpcontdiv')
	.style('position','absolute')
	.style('top','150px')
	.style('left','150px')
	;

div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));

div.style('display','');
div.selectAll('#fpconttable').remove();
var tb = div.append('table')
	.attr('id','fpconttable')
	.style('margin','auto')
	.style('font-size','12px')
	.style('border','double 6px') 
	.style('background','#d3d3d3')
	.style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
	.attr('class','pbTable');
var thead = tb.append('thead');
var t = thead.append('tr')
	.append('th')
	.attr('colspan',pc_hdr.length);
t.append('input')
	.attr('type','button')
	.attr('value','X')
	.style('float','right')
	.on('click', function() {d3.select('#fpcontdiv').remove()});
/*
t.append('input')
.attr('type','button')
.attr('value','Excel')
.style('float','right')
.on('click', function() {excel_out('#zip3table')});
*/		
t.append('label')		
	.text('Use Mouse Wheel to scroll or Page-Up/Page-Down')
	.style('text-align','center');
var t = thead.append('tr')
	.append('th')
	.attr('colspan',pc_hdr.length)
	.style('text-align','center')
	.text('CONTAINER-TRAY DETAILED INFORMATION');
var t =thead.append('tr')
	.append('th')
	.attr('colspan',pc_hdr.length)
	.style('text-align','center')
	.text('Piece Level Information');
var hdrcell = thead.append('tr')
	.selectAll('th')
	.data(pc_hdr)
	.enter()
	.append('th')
	.style('position','relative')
	.text(function(d) {return d.replace(/_/g,' ')});

tb.append('tbody')
//    .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	.selectAll("tr") 
		.data(pc)
		.enter()
		.append('tr')
		.attr('class',function(d,i) {
			if (i % 3 == 0)
				{  
				if (temp_rc == 'darkrow')
					temp_rc = 'lightrow'
				else  
					temp_rc = 'darkrow'; 
				}
			return temp_rc;
			})
	  .selectAll("td") 
			.data(function(d){return d})
			.enter()	  
			.append('td')	  
				//.on('click',function(d,i) {xx_fprpt(this,i)})
				.style('padding','4px')	  
				.style('cursor','pointer')	  	  
				.style('text-align',function(d,i) {return 'center'})	  
				.text(function(d,i) {return  d});

//xxx
var tb = div.append('table')
	.attr('id','fpcontlist')
	.style('margin','auto')
	.style('font-size','12px')
	.style('border','double 6px') 
	.style('background','#d3d3d3')
	.style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
	.attr('class','pbTable');
var thead = tb.append('thead');
var t = thead.append('tr')
	t.append('th')
		.attr('colspan',cntr_hdr.length-5)
		.style('text-align','center')
		.text('Container Level Information');
	t.append('th')
		.attr('colspan',cntr_hdr.length-5)
		.style('text-align','center')
		.text('Container Scan Information');
var hdrcell = thead.append('tr')
	.selectAll('th')
		.data(cntr_hdr)
		.enter()
		.append('th')
		.style('position','relative')
		.text(function(d) {return d.replace(/_/g,' ')});
var btr = tb.append('tbody')
//    .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	.selectAll("tr") 
	.data(cntr)
	.enter()
	.append('tr')
	.attr('class',function(d,i) {
		if (i % 3 == 0)
			{  
			if (temp_rc == 'darkrow')
				temp_rc = 'lightrow'
			else  
				temp_rc = 'darkrow'; 
			}
		return temp_rc;
		})
	.selectAll("td") 
	.data(function(d){return d})
	.enter()	  
	.append('td')	  
	//.on('click',function(d,i) {xx_fprpt(this,i)})
		.style('padding','4px')	  
		.style('cursor','pointer')	  	  
		.style('text-align',function(d,i) {return 'center'})	  
		.text(function(d,i) {return  d});
if (cntr.length == 0)
	{
	btr.append('tr')
	.append('td')
	.attr('colspan',cntr_hdr.length)
	.style('text-align','center')
	.text('Orphan Handling Unit: This piece is not associated with any container-level induction information.');
	}

 d3.select('#loader').remove();
}

	function fpcont_ret(res)
	{
       disp_fpcont(res,0,1)
		d3.select('#loader').remove();
	}


function fpcont(h,v)
{ 
 var td = v[0][0].getElementsByTagName('td');
 var imb = td[h.indexOf('IMB_CODE')].title;
 myLoader();
		var e=new TDF();
		e.setCallbackHandler(fpcont_ret);	
		e.setErrorHandler(area_data_err);
		e.getfpcont('<cfoutput>#ivdata#</cfoutput>',imb,fp_dtindv);
}


function open_pdf()
{
 window.open('ProcessingVisualization_ReportNotes.pdf');	
}

function vcnt(v)
{

  var x =document.getElementById(v).value;
  if (x != '')
   x = x.split(',').length
  else x=0;   
  return x	
}

function mhts_imb(f, t, a)
{
var tt = new Date();
var dt = new Date(a);
t = t.substr(1,20);
if (parseInt((tt - dt) / (1000 * 60 * 60 * 24)))
	x = 1
else
	x = '';
var h= "visMHTS_dlg.cfm?facility="+f+"&tracking="+t+'&all_days='+x;
window.open(h,null,'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );
}

function mhts(f,idtag)
{
var h= "visMHTS_dlg.cfm?facility="+f+"&id_tag="+idtag;
window.open(h,null,'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );
}

function csvfp_all()
{
var bdy = d3.select('body');
bdy.selectAll('#outform').remove();
var frm = bdy.append('form').attr('id','outform').attr('name','outform').attr('action','vis10csv.cfm').attr('method','post');
frm.append('input').attr('type','hidden').attr('name','dsn').attr('value','<CFOUTPUT>#ivdata#</CFOUTPUT>');
frm.append('input').attr('type','hidden').attr('name','rluvp').attr('value','1'); 
frm.append('input').attr('type','hidden').attr('name','selDir').attr('value', function () {return getEleVal('selDir')});  
frm.append('input').attr('type','hidden').attr('name','selEod').attr('value', function () {return getEleVal('selEod')});  
frm.append('input').attr('type','hidden').attr('name','selDOW').attr('value', function () {return getEleVal('selDOW')});   
frm.append('input').attr('type','hidden').attr('name','bg_date').attr('value', function () {return getEleVal('selfpdate')});   
frm.append('input').attr('type','hidden').attr('name','ed_date').attr('value','');    
frm.append('input').attr('type','hidden').attr('name','selArea').attr('value', function () {return getEleVal('selArea')});    
frm.append('input').attr('type','hidden').attr('name','selDistrict').attr('value', function () {return getEleVal('selDistrict')}); 
frm.append('input').attr('type','hidden').attr('name','selClass').attr('value', function () {return getEleVal('selClass')});      
frm.append('input').attr('type','hidden').attr('name','selCategory').attr('value', function () {return getEleVal('selCategory')});       
frm.append('input').attr('type','hidden').attr('name','selFSS').attr('value', function () {return getEleVal('selFSS')});        
frm.append('input').attr('type','hidden').attr('name','selMode').attr('value', function () {return getEleVal('selMode')});         
frm.append('input').attr('type','hidden').attr('name','selAir').attr('value',function () {return getEleVal('selAir')});        
frm.append('input').attr('type','hidden').attr('name','selCntrLvl').attr('value',function () {return getEleVal('selCntrLvl')});         
frm.append('input').attr('type','hidden').attr('name','selCert').attr('value', function () {return getEleVal('selCert')});     
frm.append('input').attr('type','hidden').attr('name','selPol').attr('value', function () {return getEleVal('selPol')});  
frm.append('input').attr('type','hidden').attr('name','selHybStd').attr('value', function () {return getEleVal('selHybStd')});  
frm.append('input').attr('type','hidden').attr('name','sortby').attr('value', '');   
frm.append('input').attr('type','hidden').attr('name','selDOW').attr('value', function () {return getEleVal('selDOW')}); 
frm.append('input').attr('type','hidden').attr('name','selFacility').attr('value', function () {return getEleVal('selFacility')});  
frm.append('input').attr('type','hidden').attr('name','selRange').attr('value', function () {return getEleVal('selRange')}); 
frm.append('input').attr('type','hidden').attr('name','selMailer').attr('value', function () {return getEleVal('selMailer')});  
frm.append('input').attr('type','hidden').attr('name','selImbZip3').attr('value', function () {return getEleVal('selfpzip3')});  
frm.append('input').attr('type','hidden').attr('name','selOrgFac').attr('value', function () {return getEleVal('selfporg3')});   
frm.append('input').attr('type','hidden').attr('name','selEntType').attr('value', function () {return getEleVal('selEntType')});    
frm.append('input').attr('type','hidden').attr('name','selInduct').attr('value', function () {return getEleVal('selInduct')}); 
frm.append('input').attr('type','hidden').attr('name','selState').attr('value', function () {return getEleVal('selState')});           
frm.append('input').attr('type','hidden').attr('name','selUR').attr('value', function () {return getEleVal('selUR')});            
frm.append('input').attr('type','hidden').attr('name','selurbk').attr('value', function () {return getEleVal('selurbk')});    
      
document.outform.submit();
bdy.selectAll('#outform').remove();
}
	
function sortit(t,db,r)
{
var asc = t.id.substr(0,7)=='uparrow'; 	
var cell =  t.id.substr(t.id.indexOf('-')+1);
var totals =  (cell > 5000)
db.sort(function(a,b)
	{
	if (totals)
		{
		var namea = addit(a,cell);
		var nameb = addit(b,cell);
		}
	else
		{
		var namea = a[cell];
		var nameb = b[cell];	
		}
	if (namea == 'notfound')
		return 1;
	if (nameb == 'notfound')
		return -1;
	if (asc)
		{
		if (namea < nameb)
			return-1;
		if (namea > nameb)
			return 1;  
		}
	else
		{
		if (namea > nameb)
			return-1;
		if (namea < nameb)
			return 1;  
		}	 
	return 0;
	}
)
if (d3.select('#datatable2').empty())  
	disp_table(0,r)
else   
	disp_table2(0,r);
}
	
function loader(config)
{
return function()
	{
	d3.select('#'+config.id).remove();
	var radius = Math.min(config.width, config.height) / 2;
	var tau = 2 * Math.PI;
	
	var arc = d3.svg.arc()
	.innerRadius(radius*0.79)
	.outerRadius(radius*0.9)
	.startAngle(0);
	var arc2 = d3.svg.arc()
	.innerRadius(radius*0.59)
	.outerRadius(radius*0.8)
	.startAngle(0);
	var arc3 = d3.svg.arc()
	.innerRadius(radius*0.39)
	.outerRadius(radius*0.6)
	.startAngle(0);
	
	var svg = d3.select(config.container).append("svg")
	.attr("id", config.id)
	.attr("width", config.width)
	.attr("height", config.height)
	.style('position','absolute')
	.style('z-index',3)
	.style('left','50%')
	.style('transform','translate(-50%, 0)')
	.append("g")
	.attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")
	
	var background = svg.append("path")
	.datum({endAngle: 0.80*tau})
	.style("fill", "#21435F")
	.attr("d", arc)
	.attr("opacity", 0.75+0.25*(1-Math.random()))
	.call(spin, 1600)
	
	var background2 = svg.append("path")
	.datum({endAngle: 0.80*tau})
	.style("fill", "#21435F")
	.attr("d", arc2)
	.attr("opacity", 0.75+0.25*(1-Math.random()))
	.call(spinRev, 1500)
	
	var background3 = svg.append("path")
	.datum({endAngle: 0.80*tau})
	.style("fill", "#21435F")
	.attr("d", arc3)
	.attr("opacity", 0.75+0.25*(1-Math.random()))
	.call(spin, 1400)
	
	svg.append('rect').attr('x',-5).attr('y',-18).attr('width',200).attr('height',30).attr('fill','#000').attr('opacity',0.5);
	svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','Arial, Arial, Helvetica, sans-serif').style('font-variant','<!---small-caps--->').style('font-weight','bold').attr('textLength',180);
	
	function spin(selection, duration) {
	selection.transition()
	.ease("linear")
	.duration(duration)
	.attrTween("transform", function() {
	return d3.interpolateString("rotate(0)", "rotate(360)");
	});
	
	setTimeout(function() { spin(selection, Math.min(Math.max(duration*(Math.random()+0.51),500),2500)); }, duration);
	}
	
	function spinRev(selection, duration) {
		selection.transition()
			.ease("linear")
			.duration(duration)
			.attrTween("transform", function() {
				return d3.interpolateString("rotate(360)", "rotate(0)");
			});
	
		setTimeout(function() { spinRev(selection, duration); }, duration);
	}
	
	function transitionFunction(path) {
		path.transition()
			.duration(7500)
			.attrTween("stroke-dasharray", tweenDash)
			.each("end", function() { d3.select(this).call(transition); });
	}
	
	};
	}
	
function loader2(config)
{
return function()
	{
	d3.select('#'+config.id).remove();
	var radius = Math.min(config.width, config.height) / 2;
	var tau = 2 * Math.PI;
	
	var arc = d3.svg.arc()
		.innerRadius(radius*0.79)
		.outerRadius(radius*0.9)
		.startAngle(0);
	var arc2 = d3.svg.arc()
		.innerRadius(radius*0.59)
		.outerRadius(radius*0.8)
		.startAngle(0);
	var arc3 = d3.svg.arc()
		.innerRadius(radius*0.39)
		.outerRadius(radius*0.6)
		.startAngle(0);
	
	var svg = d3.select(config.container).append("svg")
	.attr("id", config.id)
	.attr("width", config.width)
	.attr("height", config.height)
	.style('position','relative')
	.style('z-index',3)
	.style('left','175px')
	.style('top','-300px')
	//.style('transform','translate(-50%, 0)')
	.append("g")
	.attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")
	
	var background = svg.append("path")
		.datum({endAngle: 0.80*tau})
		.style("fill", "#21435F")
		.attr("d", arc)
		.attr("opacity", 0.75+0.25*(1-Math.random()))
		.call(spin, 1600)
		
	var background2 = svg.append("path")
		.datum({endAngle: 0.80*tau})
		.style("fill", "#21435F")
		.attr("d", arc2)
		.attr("opacity", 0.75+0.25*(1-Math.random()))
		.call(spinRev, 1500)
	
	var background3 = svg.append("path")
		.datum({endAngle: 0.80*tau})
		.style("fill", "#21435F")
		.attr("d", arc3)
		.attr("opacity", 0.75+0.25*(1-Math.random()))
		.call(spin, 1400)
		
	svg.append('rect').attr('x',-5).attr('y',-18).attr('width',200).attr('height',30).attr('fill','#000').attr('opacity',0.5);
	svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',180);
		
	function spin(selection, duration) {
	selection.transition()
		.ease("linear")
		.duration(duration)
		.attrTween("transform", function() {
			return d3.interpolateString("rotate(0)", "rotate(360)");
		});
	
	setTimeout(function() { spin(selection, Math.min(Math.max(duration*(Math.random()+0.51),500),2500)); }, duration);
	}
	
	function spinRev(selection, duration) {
	selection.transition()
		.ease("linear")
		.duration(duration)
		.attrTween("transform", function() {
			return d3.interpolateString("rotate(360)", "rotate(0)");
		});
	
	setTimeout(function() { spinRev(selection, duration); }, duration);
	}
	
	function transitionFunction(path) {
	path.transition()
		.duration(7500)
		.attrTween("stroke-dasharray", tweenDash)
		.each("end", function() { d3.select(this).call(transition); });
	}

	};
}


function area_data_err(res)
{
d3.select('#loader').remove();
alert(res);
}

function updateGraphs(val,id)
{
//if(val =='Others')
//	return;
val = "'" + val + "'";
var chk = false;
var n = d3.select('#' + id).node();
if(n.value == '')
	{
	n.value = val;
	d3.select('#RAll').style('color','blue');
	cfrm_sub();
	return;
	}
var arg = n.value.split(',');
var hold = [];
arg.forEach(function(d,i){
	if (d == val)
		chk=true;
	else
		hold.push(d);
	}
)
if (!chk)
	hold.push(val);
n.value = hold.toString();
if (n.value == '')	
	d3.select('#RAll').style('color','silver');
else
	d3.select('#RAll').style('color','blue');

cfrm_sub();
}

function streamLineChart(res, paramId, contId, chartId, cTitle, loaderId, range)
{	
var maxRows = 10;    
var len = res.length;
var selParam = d3.select('#'+paramId).node().value;
if (loadCnt > 0 && selParam != '')
	{
	res.forEach(function(d,i)
		{
		if (selParam.search(d[0]) >= 0)
			{
			range = len - i - 1;
			}
		}
		)
	if (range == undefined)
		{
		d3.select('#' + paramId).node().value = '';
		cfrm_sub()
		}
	}

if (!range || res.length < 11)
	range = 0;
else if (res.length - range < 10)
	{
	range = res.length - 10;
	}
else if (res.length - range >= res.length)
	{
	range = 0;
	}

loadCnt--;
if(loadCnt <= 0)
	{
	d3.select('#' + loaderId).remove();
	<!---
	if (ReqId > 0)
		d3.select('#undobtn').node().disabled = false
	else
		d3.select('#undobtn').node().disabled = true;
	d3.select('#undobtn').node().disabled = (ReqId <= 0);
	--->
	}

var w = 350;
var h = 350;
var padding = 50;

var high = d3.max(res, function(d){return d[2];});
var low = 0;
var diff = high - low;

var mult = res.length / 10;
//Create scale functions
yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);
xScale = d3.scale.linear()
	.domain([0,1])
	.range([padding, w - padding]);

xScale2 = d3.scale.linear()
	.domain([low,high])
	.range([padding, w - padding]);
	 
var cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	

var perF = d3.format('.1%');
var sigF = d3.format('.3g');
var comF = d3.format(',');
var siF = d3.format('.3s');

function pdg(v)
{
var s = '';
for (var i = 0; i < v; i++)
	s += String.fromCharCode(160);	
return s;
}

var order = [];
var holdData = res.slice(0);
res = res.slice(Math.max(res.length -10 - range, 0), res.length - range);
res.forEach(function(d, i)
	{
	order.push(d[1] + pdg(i))
	}
);

yScale.domain(order);

var formatAsPercentage = d3.format("%");

//Define X axis
var yAxis = d3.svg.axis()
  .scale(yScale)
  .orient("right");

//Define Y axis
var xAxis = d3.svg.axis()
  .scale(xScale)
  .orient("top")
  //.innerTickSize(-(w-padding*2))
  .ticks(5)
  .tickFormat(formatAsPercentage);
  
xAxis2 = d3.svg.axis()
  .scale(xScale2)
  .orient("bottom")
  //.innerTickSize(-(w-padding*2))
  .ticks(5)
  .tickFormat(siF);

var rdiv = (h - (padding * 2)) / ((res.length < 10) ? res.length : 10) / 2;
var rw = 210 / ((res.length < 10) ? res.length : 10);

var zoomed;

var zoom = d3.behavior.zoom()
	.scaleExtent([1, 10])
	.on("zoom." + paramId, null);

zoomed = (function(AR,pID,cID,chID,title,LID,rng,zm)
	{
	return function zoomed()
		{
		if (loadCnt > 0)
			return;
		var len = AR.length;
		if (d3.event.sourceEvent.wheelDelta)
			{
			if (d3.event.sourceEvent.wheelDelta < 0)
				{
				rng+=1;
				if (len-rng < 10)
					rng = len-10;
					//zm.translate([0, 0]);
				}
			if (d3.event.sourceEvent.wheelDelta > 0)
				{
				rng -= 1;
				if (rng < 0)
					rng=0;
				zm.translate([0, 0]);
				}
			}
		else
			{
			if(d3.event.translate[1] < 0)
				{
				rng+=1;
				if (len - rng < 10)
					rng = len - 10;
				//zm.translate([0, 0]);
				}
			if(d3.event.translate[1] > 0)
				{
				rng -= 1;
				if(rng < 0)
					rng=0;
				zm.translate([0, 0]);
				}
			}
		streamLineChart(AR,pID,cID,chID,title,LID,rng);
		} //end of inner function zoomed()
	} //end of outer function zoomed()
) (holdData,paramId,contId,chartId,cTitle,loaderId,range,zoom)

zoom.on("zoom." + paramId, zoomed);

var scheck = (d3.select('#' + chartId).node() != null);

if (scheck)
	{
	svg = d3.select('#'+chartId)
	container=svg.select("#mainContainer");
	svg.select('.x.axis').call(xAxis);
	svg.select('.x2.axis').call(xAxis2);
	svg.select("#loadShield")
		.attr("fill",'none');
	svg.select('g')
		.call(zoom);
	svg.select('#magnifier')
		.on('click', (function(AR,pID,cID,chID,title,LID,rng)
			{
			return function doSe()
				{
				d3.select('#searchBlock').style('display','').style('top', window.innerHeight / 3 + window.pageYOffset + 'px');
				d3.select('#searchTarget').node().value = '';
				d3.select('#searchTarget').node().focus();
				d3.select('#commitSearch').on('click', function()
					{					
					d3.select("#searchBlock").style("display","none");
					var n=d3.select('#'+pID).node();
					var nar = [];
					var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
					var len = AR.length;
					AR.forEach(function(d,i)
						{
						if(chID != 'svgMailer')
							{    
							if (d[1].search(targetSearch) >= 0)
								rng=len-i-1;
							}
						else
							{
							if(d[1].search(targetSearch) == 0 && targetSearch != "")
								nar.push("'"+ d[0] + "'"); 
							}
						}
					) //forEach
					if (chID == 'svgMailer') 
						{
						n.value =  nar.toString();
						if (n.value != '') 						 
							{
							selMlrFlg.value ='Y';
							cfrm_sub();
							}
						}
					streamLineChart(AR,pID,cID,chID,title,LID,rng);
					}
					) //CommitSearch onClick
				} //function doSe
			}
			)(holdData,paramId,contId,chartId,cTitle,loaderId,range) //magnifier onClick function
		) //magnifier onClick
	if (len > maxRows)
		{
		scrolly = (function(AR,pID,cID,chID,title,LID,rng)
			{
			return function()
				{
				if(loadCnt > 0)
					return;
				var len = AR.length;
				var hr = 15;
				rng += d3.event.dy * ((len - maxRows) / (h - padding * 2 - hr));
				if (len-rng < maxRows)
					rng = len-maxRows;
				if (rng < 0)
					rng = 0;
				streamLineChart(AR,pID,cID,chID,title,LID,rng);
				} //inner function
			} //scrolly function
		) (holdData,paramId,contId,chartId,cTitle,loaderId,range)
		
		var scrDrag = d3.behavior.drag()
			.on("drag", scrolly);
		
		var hr = 15;
		var hx = (h - padding * 2 - hr) * (range / (len - maxRows));
		d3.select('#' + contId).select("#scroll-rect").style('display', '')
			.attr("transform", "translate(" + (w - padding + 3) + ", " + (padding + hx) + ") scale(" + (9 / 32) + "," + (15 / 32) + ")")
		//.attr("y", padding+hx)
			.call(scrDrag);
		d3.select('#' + contId).select("#scroll-track").style('display', '');
		}
	else
		{
		d3.select('#'+contId).select("#scroll-rect").style('display','none');
		d3.select('#'+contId).select("#scroll-track").style('display','none');
		}
	}
else //!scheck
	{
	//Create SVG element
	svg = d3.select('#' + contId)
		.append("svg")
		.attr("width", w)
		.attr("height", h)
		.style("margin", '0px 0px 30px 30px')
		.attr("id", chartId)
		.append("g")
		.attr("transform", "translate(" + 0 + "," + 0 + ")")
		.call(zoom);	

	var defs = svg.append("defs");

	defs.append("svg:clipPath")
		.attr("id","clip")
		.append("svg:rect")
		.attr("id","clip-rect")
		.style("fill", "black")
		.attr("x", padding)
		.attr("y", padding)
		.attr("width", w - padding * 2)
		.attr("height", h - padding * 2);

	var lg = defs.append('linearGradient')
		.attr("id","shadeV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lg.append('stop').attr('offset','0%').style('stop-color','#DDD').style('stop-opacity',1)
	lg.append('stop').attr('offset','100%').style('stop-color','#CCC').style('stop-opacity',1)

	var lgg=defs.append('linearGradient')
		.attr("id","shadeGV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lgg.append('stop').attr('offset','0%').style('stop-color','#ADA').style('stop-opacity',1)
	lgg.append('stop').attr('offset','100%').style('stop-color','#7C7').style('stop-opacity',1)

	var lg2=defs.append('linearGradient')
		.attr("id","shadeIV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lg2.append('stop').attr('offset','0%').style('stop-color','#AAA').style('stop-opacity',1)
	lg2.append('stop').attr('offset','100%').style('stop-color','#777').style('stop-opacity',1)		

	svg.append("rect")
		.attr("width", w)
		.attr("height", h)
		.attr("x", 0)
		.attr("y", 0)
		.attr("rx", 20)
		.attr("ry", 20)
		.attr("fill", "white")
		.attr("opacity", 0.2);

	//Create X axis
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + (padding) + ")")
		.call(xAxis);

	//Create X axis
	svg.append("g")
		.attr("class", "x2 axis")
		.attr("transform", "translate(0," + (h-padding) + ")")
		.call(xAxis2);

	container = svg.append("g")
		.attr("clip-path",  "url(#clip)")
		.attr("id",  "mainContainer");

	svg.append("text")
		.attr("class", "x label")
		.attr("text-anchor", "middle")
		.attr("x", w/2)
		.attr("y", h - 12)
		.text('FSS Leakage Pieces.').style('font-size','10px');

	svg.append("text")
		.attr("class", "gTitle")
		.attr("text-anchor", "middle")
		.attr("x",  2*w/3)
		.attr("y", padding/2)
		.text("% FSS Leakage ").style('font-size','10px')
		.append("tspan")
		.attr("id","gphName");

	svg.append("text")
		.attr("class", "y label")
		.attr("x", padding-10)
		.attr("y", padding/3)
		.text(cTitle)
		.style('font-weight','bold')
		.attr('fill','#000');

	svg.append("g").attr('id','magnifier')
		.on('click', (function(AR,pID,cID,chID,title,LID,rng)
			{
			return function doSe()
				{
				d3.select('#searchBlock').style('display','').style('top',window.innerHeight / 3 + window.pageYOffset + 'px');
				d3.select('#commitSearch').on('click',function()
					{					
					d3.select("#searchBlock").style("display","none");
					var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
					var len = AR.length;
					AR.forEach(function(d,i)
						{
						if (d[1].search(targetSearch) >= 0)
							rng = len - i - 1;
						}
					) //forEach
					streamLineChart(AR,pID,cID,chID,title,LID,rng);
					} //onClick function
				) //onClick
				} //doSe
			} //magnifier onclick function
		) (holdData,paramId,contId,chartId,cTitle,loaderId,range)
		) //magnifier onclick
		.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('stroke','blue');})
		.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('stroke','silver');})
		.attr('transform','translate('+(w-padding-18)+' '+(7)+')')
		.append("path")
		.attr('d',"M0 16 L16 16 L10 10 a4.5,4.5 0 1 0 -1,1 L10 10")
		.attr('stroke','silver')
		.attr('stroke-width','2px')
		.attr('fill','transparent')
		.attr('stroke-dasharray','75,16')
		.attr('stroke-dashoffset','75')
		.attr('stroke-linejoin','round')
		.attr('transition','stroke-dasharray .6s cubic-bezier(0,.5,.5,1), stroke-dashoffset .6s cubic-bezier(0,.5,.5,1)')

	svg.append("rect")
		.style("fill", "black")
		.style("opacity",0.75)
		.attr('id','scroll-track')					
		.attr("x", w-padding+7)
		.attr("y", padding)
		.attr("width", 1)
		.attr("height", h-padding*2)

	scrolly = (function(AR,pID,cID,chID,title,LID,rng)
		{
		return function()
			{
			if(loadCnt > 0)
				return;
			var len = AR.length;
			var hr = 15;
			rng += d3.event.dy * ((len - maxRows) / (h - padding * 2 - hr));
			if(len-rng < maxRows)
				rng = len-maxRows;
			if(rng<0)
				rng=0;
			streamLineChart(AR,pID,cID,chID,title,LID,rng);
			} //inner function
		} //scrolly function
	)(holdData,paramId,contId,chartId,cTitle,loaderId,range)

	var scrDrag = d3.behavior.drag()
		.on("drag",scrolly);

	var hr = (h - padding * 2)/(len-maxRows);
	var sr = d3.select('#' + contId)
		.select("svg").append("g")
		.attr("id","scroll-rect")
		.attr('draggable','true')
		.style("fill", "black")					
		.style("opacity", "0.75")
		.attr("transform","translate("+ (w-padding+3)+","+padding+") scale("+(9/32)+","+(15/32)+")")
		.attr("width", 15)
		.attr("height", (hr<15)?15:hr)
		.call(scrDrag);
	sr.append('rect')
		.style("fill", "#777")					
		.style("opacity", "0.75")
		.attr("width", 32)
		.attr("height", 32)
		.attr("rx", 5)
		.attr("ry", 5)
		.attr("x", 4)
		.attr("y", 4);
	sr.append('rect')
		.style("fill", "url(#shadeV)")	
		.attr("stroke", "url(#shadeIV)")
		.attr('stroke-width',1.5)
		.style("opacity", "0.95")
		.attr("width", 32)
		.attr("height", 32)
		.attr("rx", 5)
		.attr("ry", 5)
		.attr("x", 0)
		.attr("y", 0)
		.on("mouseover", function()
			{
			d3.select(this).transition()
				.style("fill", "url(#shadeGV)")
			}
		)
		.on("mouseout", function()
			{
			d3.select(this).transition()
				.style("fill", "url(#shadeV)")
			}
		);

	if (len <= maxRows)
		{
		d3.select('#'+contId).select("#scroll-rect").style('display','none');
		d3.select('#'+contId).select("#scroll-track").style('display','none');
		}
	} //end of if (scheck)?

if(holdData.length <= 11)
	svg.select('#magnifier').style('display','none');
else
	svg.select('#magnifier').style('display','');
var fdb = container
	.selectAll(".failDropBars")
	.data(res);

fdb.enter()
	.append("rect")
	.attr("class", function(d,i) { return "failDropBars r"+i;})
	.attr("x", function(d,i) { return xScale2(d[2]);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", 1)
	.attr("height",function(d,i) { return Math.abs(h-padding-yScale(d[1]+pdg(i))+rdiv-rw/2+2);} )
	.attr("fill",  'silver')
	.attr("opacity", 0.25);

fdb.transition().duration(500).attr("class", function(d,i) { return "failDropBars r" + i;})
	.attr("x", function(d,i) { return xScale2(d[2]);})
	.attr("y", function(d,i) { return yScale(d[1] + pdg(i)) + rdiv - rw / 2 + 2;})
	.attr("width", 1)
	.attr("height", function(d,i) { return Math.abs(h - padding - yScale(d[1] + pdg(i)) + rdiv - rw / 2 + 2);} )
	.attr("fill",  'silver')
	.attr("opacity", 0.25);

//fdb.transition();

fdb.exit().transition().remove();

var fpie=container
	.selectAll(".failPie")
	.data(res);

var tle = fpie.enter()
	.append("rect")
	.attr("class", "failPie")
	.attr("x", function(d,i) { return xScale2(low);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
	.attr("height", rw-4)
	.attr("fill", function(d)
		{
		if (selParam == '' || selParam.search("'" + d[0] + "'") >= 0)
			return cScale2(Math.floor(d[3] * 100) / 100);
		return 'silver';
		}
	)
	.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
	.append('title');

fpie.transition().duration(500).attr("x", function(d,i) { return xScale2(low);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
	.attr("height", rw-4)
	.attr("fill", function(d)
		{
		if (selParam == '' || selParam.search("'" + d[0] + "'") >= 0)
			return cScale2(Math.floor(d[3] * 100) / 100);
		return 'silver';
		}
	);

var tle = fpie.on('mouseover',function(d,i)
	{
	d3.select(this).attr('opacity',0.5).style('cursor','pointer');
	d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
	}
	)
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
	.select('title');
tle.selectAll('tspan').remove();	
tle.append("tspan").text(function(d) {return 'FSS Leakage Pieces: ' + comF(d[2]);})
tle.append("tspan").text(function(d) {return '\nTotal Pieces: ' + comF(d[4]);})
tle.append("tspan").text(function(d) {return '\nPercent: '+ perF(d[3]);})	

//fpie.transition();

fpie.exit().transition().remove();

var pdb=container
	.selectAll(".perDropBars")
	.data(res);

pdb.enter()
	.append("rect")
	.attr("class", function(d,i) { return "perDropBars c"+i;})
	.attr("x", function(d,i) {	return xScale(d[3])-0.5;})
	.attr("y", padding)
	.attr("width", 1)
	.attr("height",function(d,i) { return Math.abs(yScale(d[1]+pdg(i))+rdiv-padding);})
	.attr("fill", 'silver')
	.attr("opacity", 0.25);

pdb.transition().duration(500).attr("class", function(d,i) { return "perDropBars c"+i;})
	.attr("x", function(d,i) {	return xScale(d[3])-0.5;})
	.attr("y", padding)
	.attr("width", 1)
	.attr("height",function(d,i) { return Math.abs(yScale(d[1]+pdg(i))+rdiv-padding);})
	.attr("fill", 'silver')
	.attr("opacity", 0.25);

//pdb.transition();

pdb.exit().transition().remove();

var fpc=container
	.selectAll(".failPer")
	.data(res);

tle = fpc.enter()
	.append("circle")
	.attr("class", "failPer")
	.attr("cx", function(d,i) {	return xScale(d[3]);})
	.attr("cy", function(d,i) { return yScale(d[1]+pdg(i))+rdiv;})
	.attr("r", 5)
	.attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
	.attr("stroke-width", 2)
	.attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';})
	.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
	.append('title');

fpc.transition().duration(500).attr("class", "failPer")
	.attr("cx", function(d,i) {	return xScale(d[3]);})
	.attr("cy", function(d,i) { return yScale(d[1]+pdg(i))+rdiv;})
	.attr("r", 5)
	.attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
	.attr("stroke-width", 2)
	.attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});

tle = fpc.on('mouseover',function(d,i)
	{
	d3.select(this).attr('opacity',0.5).style('cursor','pointer');
	d3.selectAll('#' + chartId + ' .perDropBars').filter(".c" + i).attr('opacity',1).attr('stroke','cyan');
	}
	)
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
	.select('title');

tle.selectAll('tspan').remove();	
tle.append("tspan").text(function(d) {return 'FSS Leakage Pieces: '+comF(d[2]);})
tle.append("tspan").text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
tle.append("tspan").text(function(d) {return '\nPercent: '+perF(d[3]);})	

fpc.exit().transition().remove();

if(!scheck)
	{
	var legend = svg.append("g")
		.attr("class", "Legend")
		.attr("transform", "translate(" + (w - padding) + ","+padding+")");
	
	legend.append('text')
		.attr("x", 5)
		.attr("y", 5)
		.text("")
		.style("font-size", 8);
	
	//Create Y axis
	svg.append("g")
	.attr("class", "y axis")
	.attr("transform", "translate(" + padding + ",0)")
	.call(yAxis)
	.selectAll('text').attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
	.on('mouseover',function(d,i)
		{
		d3.select(this).attr('opacity',0.5).style('cursor','pointer');
		d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
		}
	)
	.on('click',function(d,i){updateGraphs(res[i][0],paramId)})//id
	.on('mouseout',function(d,i)
		{
		d3.select(this).attr('opacity',1).style('cursor','');
		d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',0.25).attr('stroke','');
		}
	)
	.append('title')
	.text(function(d,i) {return 'FSS Leakage Pieces: '+comF(res[i][2]);});
	
	svg.append("text")
		.attr("class", "y label")
		.attr("x", w-padding)
		.attr("y", padding/3)
		.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','times, Times New Roman')
		.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
		.attr('id','resetLink')
		.on('click',function()
			{
			d3.select('#' + paramId).node().value = '';
			cfrm_sub();
			}
		);
	}
else
	{
	var Ytext = svg.select('.y.axis').call(yAxis).selectAll('text');
	Ytext.selectAll('title').remove();
	Ytext.attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
		.on('mouseover', function(d,i)
			{
			d3.select(this).attr('opacity',0.5).style('cursor','pointer');
			d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
			}
		)
		.on('click', function(d,i){updateGraphs(res[i][0],paramId)})//id
		.on('mouseout', function(d,i)
			{
			d3.select(this).attr('opacity',1).style('cursor','');
			d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',0.25).attr('stroke','');
			}
		)
		.append('title')
		.text(function(d,i) {return 'FSS Leakage Pieces: ' + comF(res[i][2]);});
		
	svg.select('#resetLink').transition().attr('fill', function(){if(selParam == '')return 'silver';return 'blue'})
	}
container.select("#loadShield").remove();

var ldShd = container
	.append("rect")
	.attr("id","loadShield")
	.attr("opacity",0.75)
	.attr("fill",'none')
	.attr("width", w)
	.attr("height",h);
}

function rawChart(res, paramId, contId, chartId, cTitle, loaderId, strTitle, range)
//this is the same as streamLineChart except it shows only raw numbers, no percentages
{	
var maxRows = 10;    
var len = res.length;
var selParam = d3.select('#'+paramId).node().value;
if (loadCnt > 0 && selParam != '')
	{
	res.forEach(function(d,i)
		{
		if (selParam.search(d[0]) >= 0)
			{
			range = len - i - 1;
			}
		}
		)
	if (range == undefined)
		{
		d3.select('#' + paramId).node().value = '';
		cfrm_sub()
		}
	}

if (!range || res.length < 11)
	range = 0;
else if (res.length - range < 10)
	{
	range = res.length - 10;
	}
else if (res.length - range >= res.length)
	{
	range = 0;
	}

loadCnt--;
if(loadCnt <= 0)
	{
	d3.select('#' + loaderId).remove();
	<!---
	if (ReqId > 0)
		d3.select('#undobtn').node().disabled = false
	else
		d3.select('#undobtn').node().disabled = true;
	d3.select('#undobtn').node().disabled = (ReqId <= 0);
	--->
	}

var w = 350;
var h = 350;
var padding = 50;

var high = d3.max(res, function(d){return d[2];});
var low = 0;
var diff = high - low;

var mult = res.length / 10;
//Create scale functions
yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);
xScale = d3.scale.linear()
	.domain([low,high])
	.range([padding, w - padding]);
	 
var cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);
<!---	
var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	
var cScale2 = d3.scale.linear().domain([low, high]).range(["#ddccdd","#ddccdd"]);	
--->
var sigF = d3.format('.3g');
var comF = d3.format(',');
var siF = d3.format('.3s');

function pdg(v)
{
var s = '';
for (var i = 0; i < v; i++)
	s += String.fromCharCode(160);	
return s;
}

var order = [];
var holdData = res.slice(0);
res = res.slice(Math.max(res.length -10 - range, 0), res.length - range);
res.forEach(function(d, i)
	{
	order.push(d[1] + pdg(i))
	}
);

yScale.domain(order);

var formatAsPercentage = d3.format("%");

//Define X axis
var yAxis = d3.svg.axis()
  .scale(yScale)
  .orient("right");

//Define Y axis
var xAxis = d3.svg.axis()
  .scale(xScale)
  .orient("top")
  //.innerTickSize(-(w-padding*2))
  .ticks(5)
  .tickFormat(siF);
  
xAxis2 = d3.svg.axis()
  .scale(xScale)
  .orient("bottom")
  //.innerTickSize(-(w-padding*2))
  .ticks(5)
  .tickFormat(siF);
  //.tickFormat(formatAsPercentage);

var rdiv = (h - (padding * 2)) / ((res.length < 10) ? res.length : 10) / 2;
var rw = 210 / ((res.length < 10) ? res.length : 10);

var zoomed;

var zoom = d3.behavior.zoom()
	.scaleExtent([1, 10])
	.on("zoom." + paramId, null);

zoomed = (function(AR,pID,cID,chID,title,LID,rng,ttl,zm)
	{
	return function zoomed()
		{
		if (loadCnt > 0)
			return;
		var len = AR.length;
		if (d3.event.sourceEvent.wheelDelta)
			{
			if (d3.event.sourceEvent.wheelDelta < 0)
				{
				rng+=1;
				if (len-rng < 10)
					rng = len-10;
					//zm.translate([0, 0]);
				}
			if (d3.event.sourceEvent.wheelDelta > 0)
				{
				rng -= 1;
				if (rng < 0)
					rng=0;
				zm.translate([0, 0]);
				}
			}
		else
			{
			if(d3.event.translate[1] < 0)
				{
				rng+=1;
				if (len - rng < 10)
					rng = len - 10;
				//zm.translate([0, 0]);
				}
			if(d3.event.translate[1] > 0)
				{
				rng -= 1;
				if(rng < 0)
					rng=0;
				zm.translate([0, 0]);
				}
			}
		rawChart(AR,pID,cID,chID,title,LID,ttl,rng);
		} //end of inner function zoomed()
	} //end of outer function zoomed()
) (holdData,paramId,contId,chartId,cTitle,loaderId,strTitle,range,zoom)

zoom.on("zoom." + paramId, zoomed);

var scheck = (d3.select('#' + chartId).node() != null);
if (scheck)
	{
	svg = d3.select('#'+chartId)
	container=svg.select("#mainContainer");
	svg.select('.x.axis').call(xAxis);
	svg.select('.x2.axis').call(xAxis2);
	svg.select("#loadShield")
		.attr("fill",'none');
	svg.select('g')
		.call(zoom);
	svg.select('#magnifier')
		.on('click', (function(AR,pID,cID,chID,title,LID,rng,ttl)
			{
			return function doSe()
				{
				d3.select('#searchBlock').style('display','').style('top', window.innerHeight / 3 + window.pageYOffset + 'px');
				d3.select('#searchTarget').node().value = '';
				d3.select('#searchTarget').node().focus();
				d3.select('#commitSearch').on('click', function()
					{					
					d3.select("#searchBlock").style("display","none");
					var n=d3.select('#'+pID).node();
					var nar = [];
					var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
					var len = AR.length;
					AR.forEach(function(d,i)
						{
						if(chID != 'svgMailer')
							{    
							if (d[1].search(targetSearch) >= 0)
								rng=len-i-1;
							}
						else
							{
							if(d[1].search(targetSearch) == 0 && targetSearch != "")
								nar.push("'"+ d[0] + "'"); 
							}
						}
					) //forEach
					if (chID == 'svgMailer') 
						{
						n.value =  nar.toString();
						if (n.value != '') 						 
							{
							selMlrFlg.value ='Y';
							cfrm_sub();
							}
						}
					rawChart(AR,pID,cID,chID,title,LID,ttl,rng);
					}
					) //CommitSearch onClick
				} //function doSe
			}
			)(holdData,paramId,contId,chartId,cTitle,loaderId,strTitle,range) //magnifier onClick function
		) //magnifier onClick
	if (len > maxRows)
		{
		scrolly = (function(AR,pID,cID,chID,title,LID,ttl,rng)
			{
			return function()
				{
				if(loadCnt > 0)
					return;
				var len = AR.length;
				var hr = 15;
				rng += d3.event.dy * ((len - maxRows) / (h - padding * 2 - hr));
				if (len-rng < maxRows)
					rng = len-maxRows;
				if (rng < 0)
					rng = 0;
				rawChart(AR,pID,cID,chID,title,LID,ttl,rng);
				} //inner function
			} //scrolly function
		) (holdData,paramId,contId,chartId,cTitle,loaderId,strTitle,range)
		
		var scrDrag = d3.behavior.drag()
			.on("drag", scrolly);
		
		var hr = 15;
		var hx = (h - padding * 2 - hr) * (range / (len - maxRows));
		d3.select('#' + contId).select("#scr-rect").style('display', '')
			.attr("transform", "translate(" + (w - padding + 3) + ", " + (padding + hx) + ") scale(" + (9 / 32) + "," + (15 / 32) + ")")
		//.attr("y", padding+hx)
			.call(scrDrag);
		d3.select('#' + contId).select("#scr-track").style('display', '');
		}
	else
		{
		d3.select('#'+contId).select("#scr-rect").style('display','none');
		d3.select('#'+contId).select("#scr-track").style('display','none');
		}
	}
else //!scheck
	{
	//Create SVG element
	svg = d3.select('#' + contId)
		.append("svg")
		.attr("width", w)
		.attr("height", h)
		.style("margin", '0px 0px 30px 30px')
		.attr("id", chartId)
		.append("g")
		.attr("transform", "translate(" + 0 + "," + 0 + ")")
		.call(zoom);	

	var defs = svg.append("defs");

	defs.append("svg:clipPath")
		.attr("id","clip")
		.append("svg:rect")
		.attr("id","clip-rect")
		.style("fill", "black")
		.attr("x", padding)
		.attr("y", padding)
		.attr("width", w - padding * 2)
		.attr("height", h - padding * 2);

	var lg = defs.append('linearGradient')
		.attr("id","shadeV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lg.append('stop').attr('offset','0%').style('stop-color','#DDD').style('stop-opacity',1)
	lg.append('stop').attr('offset','100%').style('stop-color','#CCC').style('stop-opacity',1)

	var lgg=defs.append('linearGradient')
		.attr("id","shadeGV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lgg.append('stop').attr('offset','0%').style('stop-color','#ADA').style('stop-opacity',1)
	lgg.append('stop').attr('offset','100%').style('stop-color','#7C7').style('stop-opacity',1)

	var lg2=defs.append('linearGradient')
		.attr("id","shadeIV")
		.attr('x1','0%')
		.attr('x2','0%')
		.attr('y1','0%')
		.attr('y2','100%');

	lg2.append('stop').attr('offset','0%').style('stop-color','#AAA').style('stop-opacity',1)
	lg2.append('stop').attr('offset','100%').style('stop-color','#777').style('stop-opacity',1)		

	svg.append("rect")
		.attr("width", w)
		.attr("height", h)
		.attr("x", 0)
		.attr("y", 0)
		.attr("rx", 20)
		.attr("ry", 20)
		.attr("fill", "white")
		.attr("opacity", 0.2);

	//Create X axis
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + (padding) + ")")
		.call(xAxis);

	//Create X axis
	svg.append("g")
		.attr("class", "x2 axis")
		.attr("transform", "translate(0," + (h-padding) + ")")
		.call(xAxis2);

	container = svg.append("g")
		.attr("clip-path",  "url(#clip)")
		.attr("id",  "mainContainer");

//	svg.append("text")
//		.attr("class", "x label")
//		.attr("text-anchor", "middle")
//		.attr("x", w/2)
//		.attr("y", h - 12)
//		.text(strTitle).style('font-size','10px');

	svg.append("text")
		.attr("class", "gTitle")
		.attr("text-anchor", "middle")
		.attr("x", w/2)
		.attr("y", padding/2)
		.text(strTitle).style('font-size','10px')
		.append("tspan")
		.attr("id","gphName");

	svg.append("text")
		.attr("class", "y label")
		.attr("x", padding-10)
		.attr("y", padding/3)
		.text(cTitle)
		.style('font-weight','bold')
		.attr('fill','#000');

	svg.append("g").attr('id','magnifier')
		.on('click', (function(AR,pID,cID,chID,title,LID,rng)
			{
			return function doSe()
				{
				d3.select('#searchBlock').style('display','').style('top',window.innerHeight / 3 + window.pageYOffset + 'px');
				d3.select('#commitSearch').on('click',function()
					{					
					d3.select("#searchBlock").style("display","none");
					var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
					var len = AR.length;
					AR.forEach(function(d,i)
						{
						if (d[1].search(targetSearch) >= 0)
							rng = len - i - 1;
						}
					) //forEach
					rawChart(AR,pID,cID,chID,title,LID,ttl,rng);
					} //onClick function
				) //onClick
				} //doSe
			} //magnifier onclick function
		) (holdData,paramId,contId,chartId,cTitle,loaderId,range,strTitle)
		) //magnifier onclick
		.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('stroke','blue');})
		.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('stroke','silver');})
		.attr('transform','translate('+(w-padding-18)+' '+(7)+')')
		.append("path")
		.attr('d',"M0 16 L16 16 L10 10 a4.5,4.5 0 1 0 -1,1 L10 10")
		.attr('stroke','silver')
		.attr('stroke-width','2px')
		.attr('fill','transparent')
		.attr('stroke-dasharray','75,16')
		.attr('stroke-dashoffset','75')
		.attr('stroke-linejoin','round')
		.attr('transition','stroke-dasharray .6s cubic-bezier(0,.5,.5,1), stroke-dashoffset .6s cubic-bezier(0,.5,.5,1)')

	svg.append("rect")
		.style("fill", "black")
		.style("opacity",0.75)
		.attr('id','scr-track')					
		.attr("x", w-padding+7)
		.attr("y", padding)
		.attr("width", 1)
		.attr("height", h-padding*2)

	scrolly = (function(AR,pID,cID,chID,title,LID,ttl,rng)
		{
		return function()
			{
			if(loadCnt > 0)
				return;
			var len = AR.length;
			var hr = 15;
			rng += d3.event.dy * ((len - maxRows) / (h - padding * 2 - hr));
			if (len-rng < maxRows)
				rng = len-maxRows;
			if (rng<0)
				rng=0;
			rawChart(AR,pID,cID,chID,title,LID,ttl,rng);
			} //inner function
		} //scrolly function
	)(holdData,paramId,contId,chartId,cTitle,loaderId,strTitle,range)

	var scrDrag = d3.behavior.drag()
		.on("drag",scrolly);

	var hr = (h - padding * 2)/(len-maxRows);
	var sr = d3.select('#' + contId)
		.select("svg").append("g")
		.attr("id","scr-rect")
		.attr('draggable','true')
		.style("fill", "black")					
		.style("opacity", "0.75")
		.attr("transform","translate("+ (w-padding+3)+","+padding+") scale("+(9/32)+","+(15/32)+")")
		.attr("width", 15)
		.attr("height", (hr<15)?15:hr)
		.call(scrDrag);
	sr.append('rect')
		.style("fill", "#777")					
		.style("opacity", "0.75")
		.attr("width", 32)
		.attr("height", 32)
		.attr("rx", 5)
		.attr("ry", 5)
		.attr("x", 4)
		.attr("y", 4);
	sr.append('rect')
		.style("fill", "url(#shadeV)")	
		.attr("stroke", "url(#shadeIV)")
		.attr('stroke-width',1.5)
		.style("opacity", "0.95")
		.attr("width", 32)
		.attr("height", 32)
		.attr("rx", 5)
		.attr("ry", 5)
		.attr("x", 0)
		.attr("y", 0)
		.on("mouseover", function()
			{
			d3.select(this).transition()
				.style("fill", "url(#shadeGV)")
			}
		)
		.on("mouseout", function()
			{
			d3.select(this).transition()
				.style("fill", "url(#shadeV)")
			}
		);

	if (len <= maxRows)
		{
		d3.select('#'+contId).select("#scr-rect").style('display','none');
		d3.select('#'+contId).select("#scr-track").style('display','none');
		}
	} //end of if (scheck)?

if(holdData.length <= 11)
	svg.select('#magnifier').style('display','none');
else
	svg.select('#magnifier').style('display','');
var fdb = container
	.selectAll(".failDropBars")
	.data(res);

fdb.enter()
	.append("rect")
	.attr("class", function(d,i) { return "failDropBars r"+i;})
	.attr("x", function(d,i) { return xScale(d[2]);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", 1)
	.attr("height",function(d,i) { return Math.abs(h-padding-yScale(d[1]+pdg(i))+rdiv-rw/2+2);} )
	.attr("fill",  'silver')
	.attr("opacity", 0.25);

fdb.transition().duration(500).attr("class", function(d,i) { return "failDropBars r" + i;})
	.attr("x", function(d,i) { return xScale(d[2]);})
	.attr("y", function(d,i) { return yScale(d[1] + pdg(i)) + rdiv - rw / 2 + 2;})
	.attr("width", 1)
	.attr("height", function(d,i) { return Math.abs(h - padding - yScale(d[1] + pdg(i)) + rdiv - rw / 2 + 2);} )
	.attr("fill",  'silver')
	.attr("opacity", 0.25);

//fdb.transition();

fdb.exit().transition().remove();

var fpie=container
	.selectAll(".failPie")
	.data(res);

var tle = fpie.enter()
	.append("rect")
	.attr("class", "failPie")
	.attr("x", function(d,i) { return xScale(low);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", function(d) {return Math.abs(xScale(d[2])-xScale(low));})
	.attr("height", rw-4)
	.attr("fill", function(d)
		{
		if (selParam == '' || selParam.search("'" + d[0] + "'") >= 0)
			return '#ddccdd';
		return 'silver';
		}
	)
	.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
	.append('title');

fpie.transition().duration(500).attr("x", function(d,i) { return xScale(low);})
	.attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
	.attr("width", function(d) {return Math.abs(xScale(d[2])-xScale(low));})
	.attr("height", rw-4)
	.attr("fill", function(d)
		{
		if (selParam == '' || selParam.search("'" + d[0] + "'") >= 0)
			return '#ddccdd';
		return 'silver';
		}
	);

var tle = fpie.on('mouseover',function(d,i)
	{
	d3.select(this).attr('opacity',0.5).style('cursor','pointer');
	d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
	}
	)
	.on('click',function(d){updateGraphs(d[0],paramId)})//id
	.on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
	.select('title');
tle.selectAll('tspan').remove();	
tle.append("tspan").text(function(d) {return strTitle + ': ' + comF(d[2]);})
//tle.append("tspan").text(function(d) {return '\nTotal FS  Bundles: ' + comF(d[4]);})
//tle.append("tspan").text(function(d) {return '\nPercent: '+ perF(d[3]);})	

//fpie.transition();

fpie.exit().transition().remove();

if(!scheck)
	{
	var legend = svg.append("g")
		.attr("class", "Legend")
		.attr("transform", "translate(" + (w - padding) + ","+padding+")");
	
	legend.append('text')
		.attr("x", 5)
		.attr("y", 5)
		.text("")
		.style("font-size", 8);
	
	//Create Y axis
	svg.append("g")
	.attr("class", "y axis")
	.attr("transform", "translate(" + padding + ",0)")
	.call(yAxis)
	.selectAll('text').attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
	.on('mouseover',function(d,i)
		{
		d3.select(this).attr('opacity',0.5).style('cursor','pointer');
		d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
		}
	)
	.on('click',function(d,i){updateGraphs(res[i][0],paramId)})//id
	.on('mouseout',function(d,i)
		{
		d3.select(this).attr('opacity',1).style('cursor','');
		d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',0.25).attr('stroke','');
		}
	)
	.append('title')
	.text(function(d,i) {return strTitle + ': ' + comF(res[i][2]);});
	
	svg.append("text")
		.attr("class", "y label")
		.attr("x", w-padding)
		.attr("y", padding/3)
		.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','times, Times New Roman')
		.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
		.attr('id','resetLink')
		.on('click',function()
			{
			d3.select('#' + paramId).node().value = '';
			cfrm_sub();
			}
		);
	}
else
	{
	var Ytext = svg.select('.y.axis').call(yAxis).selectAll('text');
	Ytext.selectAll('title').remove();
	Ytext.attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
		.on('mouseover', function(d,i)
			{
			d3.select(this).attr('opacity',0.5).style('cursor','pointer');
			d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',1).attr('stroke','cyan');
			}
		)
		.on('click', function(d,i){updateGraphs(res[i][0],paramId)})//id
		.on('mouseout', function(d,i)
			{
			d3.select(this).attr('opacity',1).style('cursor','');
			d3.selectAll('#' + chartId + ' .failDropBars').filter(".r" + i).attr('opacity',0.25).attr('stroke','');
			}
		)
		.append('title')
		.text(function(d,i) {return strTitle + ': ' + comF(res[i][2]);});
		
	svg.select('#resetLink').transition().attr('fill', function(){if(selParam == '')return 'silver';return 'blue'})
	}
container.select("#loadShield").remove();

var ldShd = container
	.append("rect")
	.attr("id","loadShield")
	.attr("opacity",0.75)
	.attr("fill",'none')
	.attr("width", w)
	.attr("height",h);
}
	

function AreaFSSLeakage(res)
{	
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].AreaFSSLeakage = (function(data,v){
	return function(){
	d3.select('#selArea').node().value=v;
	streamLineChart(data,'selArea','AreaFSSLeakage','svgArea','Area','loader');
	}
})(res, d3.select('#selArea').node().value)

if (ReqId != rp)
	return;

streamLineChart(res, 'selArea', 'AreaFSSLeakage', 'svgArea', 'Area', 'loader');
}

function DistrictFSSLeakage(res)
{
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].DistrictFSSLeakage = (function(data,v)
	{
	return function()
		{
		d3.select('#selDistrict').node().value = v;
		streamLineChart(data,'selDistrict','DistrictFSSLeakage','svgDistrict','District','loader');		
		}
	}
) (res, d3.select('#selDistrict').node().value);

if(ReqId != rp)
	return;

streamLineChart(res,'selDistrict','DistrictFSSLeakage','svgDistrict','District','loader');		
}

function FacilityFSSLeakage(res)
{	
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].FacilityFSSLeakage = (function(data,v)
	{
	return function()
		{
		d3.select('#selFacility').node().value = v;
		streamLineChart(res,'selFacility','FacilityFSSLeakage','svgFacility','Facility','loader');		
		}
	}
) (res, d3.select('#selFacility').node().value);

if(ReqId != rp)
	return;

streamLineChart(res,'selFacility','FacilityFSSLeakage','svgFacility','Facility','loader');		
}

function MailClassFSSLeakage(res)
{	
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].MailClassFSSLeakage = (function(data,v){
	return function(){
	d3.select('#selMailClass').node().value=v;
	streamLineChart(data,'selMailClass','MailClassFSSLeakage','svgMailClass','Mail Class','loader');
	}
})(res, d3.select('#selMailClass').node().value)

if (ReqId != rp)
	return;

streamLineChart(res, 'selMailClass', 'MailClassFSSLeakage', 'svgMailClass', 'Mail Class', 'loader');
}

function EntPntDiscFSSLeakage(res)
{	
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].EntPntDiscFSSLeakage = (function(data,v){
	return function(){
	d3.select('#selEntPntDisc').node().value=v;
	streamLineChart(data,'selEntPntDisc','EntPntDiscFSSLeakage','svgEntPntDisc','Entry Point Discount','loader');
	}
})(res, d3.select('#selEntPntDisc').node().value)

if (ReqId != rp)
	return;

streamLineChart(res, 'selEntPntDisc', 'EntPntDiscFSSLeakage', 'svgEntPntDisc', 'Entry Point Discount', 'loader');
}

function SortationLevelFSSLeakage(res)
{	
var rp = res.pop()[0];  
res.shift();
chartHistory[rp].SortationLevelFSSLeakage = (function(data,v){
	return function(){
	d3.select('#selSortLvl').node().value=v;
	streamLineChart(data,'selSortLvl','SortationLevelFSSLeakage','svgSortLvel','Sortation Level','loader');
	}
})(res, d3.select('#selSortLvl').node().value)

if (ReqId != rp)
	return;

streamLineChart(res, 'selSortLvl', 'SortationLevelFSSLeakage', 'svgSortLvel', 'Sortation Level', 'loader');
}
function trend_Chart_FSS(res)
{	
var rp = res.pop()[0];  
if(ReqId != rp || res.length == 1)
	return;
if (trendId != ReqId)
	{
	trendDataset.length=0;
	trendId = ReqId;
	}

trendDataset.push(res[1]);

if (trendDataset.length == 8 || getEleVal('selRange') != 'WEEK')
	{
	var aryCols = res.shift();
	var sortIdx = aryCols.indexOf('SORTDATE');
	trendDataset.sort(function(a, b)
		{
		return d3.ascending(a[sortIdx], b[sortIdx]);
		}
		);
	Load_Trend_Graph(trendDataset, aryCols); 
	}
}

function gettrdate(sd, srng, i)
{
if (srng == 'WEEK')
	{
	var d = new Date(sd);
	d.setDate(d.getDate() - (7 * i));
	var m = (d.getMonth() + 1);
	if (m < 10)
		m = '0' + m;
	var day = d.getDate();
	if (day < 10)
		day = '0' + day;
	d = m + '/' + day + '/' + d.getFullYear();
	return d
	}
if (srng == 'MON' || srng == 'QTR')
	{
	var d = new Date(sd);
	if (srng=='QTR')
		d.setMonth(d.getMonth() + 3);
	d.setMonth(d.getMonth() - (i)); 
	var m = d.getMonth() + 1;
	if (m < 10)
		m = '0' + m;
	var day = d.getDate();
	if (day < 10)
		day = '0' + day;
	d = m + '/' + day + '/' + d.getFullYear();
	return d
	}
}

function getEleVal(v)
{
return document.getElementById(v).value
}

function cfrm()
{
listSelections();		
document.getElementById("subtn").style.border = 'Red 4px solid';
<!---
if (document.getElementById("selDir").value == 'O' && !d3.select('#svgorg').empty())
	{
	d3.select('#svgorg').remove();
	newdiropt = true
	//	   resetAll();
	}
if (document.getElementById("selDir").value == 'D' && !d3.select('#svgzip3').empty())	 
	{
	d3.select('#svgzip3').remove();
	newdiropt = true
	//	   resetAll();
	}
	--->
ReqId = -1;
chartHistory.length = 0;
chartHistory[0] = {};
//instead of using ajax function for now we'll just directly call the function that sets the end date
//getdatethru();
load_thru_Dates();   
}	

function keybindt2(r,c,cnt)
{
d3.select('body').call(d3.keybinding()
	.on('page-down', function()
		{
		if (!d3.select('#datatable').empty())
			d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		}
	)	  
	.on('page-up', function()
		{
		if (!d3.select('#datatable').empty())
			d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
		}
	)
	.on('escape', function()
		{
		if (!d3.select('#datatable').empty())
			d3.select('#datatable').remove();  
		}
	)
);	  
}

function toUnique(a,b,c){//array,placeholder,placeholder
b=a.length;
while(c=--b)while(c--)a[b]!==a[c]||a.splice(c,1);
return a // not needed ;)
}

<!---
function column_search(d,i)
{
var a = [];
var col = d.cellIndex;
for (var i = 0;i<fp_datasetindv.length;i++)
	{
	if (fp_datasetindv[i][col] != '')
		a.push(fp_datasetindv[i][col]);
	}
a = toUnique(a);
a.sort();
a.unshift(' ');
var inp = d3.select(d)
var hold =  inp.node().onclick;
if (inp.node().style.color=='yellow')
	{
	disp_table2(0,30,'','');
	return true;	
	}
d3.select('#filtersel').remove();

var sel = inp.append('select');
sel
	.attr('id','filtersel')
	.style('class','slct')
	.style('margin-bottom','10px')
	.on('change',function () {disp_table2(0,30,this.value,col)})
	.on('mousedown', function() {d3.event.stopPropagation()})
	;
var options = sel
	.selectAll('option')
	.data(a).enter()
	.append('option')
	.attr('value',function(d) {return d})
	.text(function(d) {return String(d).replace(/_/,'')});

inp.on('click',null);
sel.node().focus();
}
--->
var t2zoom=1;

function disp_table2(r,c,tv,col)
{
d3.select('#zip3table').style('display','none');	
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_datasetindv.length;	

var imb = fp_hdrindv.indexOf('IMB_CODE');
var stc = fp_hdrindv.indexOf('START_THE_CLOCK_DATE');
var fzc = fp_hdrindv.indexOf('FAC_ZIP_CODE');
var tag = fp_hdrindv.indexOf('ID_TAG');
var imcb = fp_hdrindv.indexOf('IMCB_CODE');

if (tv && tv != '')
{
var test = fp_datasetindv.filter(function(d) { if (String(d[col]).substr(0,tv.length).toUpperCase() == tv.toUpperCase()) return d})	;
}


if (r<0) r=0;
if (cnt-c < r) r=cnt-c;
if (test)
 res = test.slice(r,c+r);      
else
 res = fp_datasetindv.slice(r,c+r);      


var temp_rc = 'darkrow';	

   var div = d3.select('#fptable');
   // div.call(d3.behavior.drag().on("drag", move));
   div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));	  
	div.style('display','');
	div.selectAll('#datatable2').remove();
	var tb = div.append('table')
 .style('transform','scale('+t2zoom+','+t2zoom+')')	
 .attr('id','datatable2')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#fff')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');


 var thead = tb.append('thead');
   thead.on('wheel', function() {d3.event.preventDefault();  (d3.event.deltaY <0) ? t2zoom += .02 : t2zoom -=.02; d3.select('#datatable2').style('transform','scale('+t2zoom+','+t2zoom+')')	}) 
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',fp_hdrindv.length)
		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		//.style('position','fixed')
		.on('click', function() {d3.select('#datatable2').remove(); keybindt2(r,c,cnt); d3.select('#zip3table').style('display',''); fp_datasetindv.length=0;});
		
		t.append('label')		
		.text('Use Mouse Wheel/Page-Up/Page-Down to scroll || Click on titles to filter')
		.style('text-align','center');
		
		t.append('input')
		.attr('type','button')
		.attr('value','Excel')
		.style('float','left')
		.on('click', function() {csvfp_all()});


var hdrcell = thead.append('tr')
 .selectAll('th')
  .data(fp_hdrindv)
 .enter()
 .append('th')
 .style('position','relative')
 .on('click',function(d,i) {column_search(this,i)})
 .style('color',function(d,i) {return (i===col) ? 'yellow' : ''})	  
 .style('cursor','pointer')	   
 .text(function(d) {return d.replace(/_/g,' ')});
 hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrowfp-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,fp_datasetindv,30)});
 hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrowfp-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,fp_datasetindv,30)});
	;
 

   var tby =tb.append('tbody')
     tby
      .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table2(r-1,c,tv,col) : disp_table2(r+1,c,tv,col);  })
	  .selectAll("tr") 
	  .data(res)
	  .enter()
      .append('tr')
	  .attr('class',function(d,i) {
		  if (i>0 && res[i][0] != res[i-1][0])
		   {
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		   }
		  return temp_rc;
		  })
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  .style('cursor','pointer')	  
	  .style('padding','4px')	  
	  .style('text-align',function(d,i) {return (i==0) ? 'center' : 'center'})	  
	  .style('text-overflow','ellipsis')
	  .style('white-space','nowrap')	  
      .text(function(d,i) {return (d == null) ? '' : String(d).replace(/_/,'').substr(0,17) + ((String(d).length<18) ? '' : '...') })
	  .attr('title',function(d,i) {return (d == null) ? '' : String(d).replace(/_/,'') }) 
	  .on('mouseover',function(d,i) {if (i== imcb || i== imb || (i==tag && d)) this.style.textDecoration='underline'})
	  .on('mouseout',function(d,i) {if (i== imcb || i== imb || (i==tag && d)) this.style.textDecoration=''})	  
	  .on('click',function(d,i) {
		  if (i == imb) 
		  mhts_imb(d3.select(this.parentNode).data()[0][fzc],d,d3.select(this.parentNode).data()[0][stc]);
         if (i == tag && d) 
		  mhts(d3.select(this.parentNode).data()[0][fzc],d);		  
         if (i == imcb) 
		  fpcont(fp_hdrindv,d3.select(this.parentNode));		  
	  })
	  ;
       d3.select('body').call(d3.keybinding()
      .on('page-down', function() {
		  if (!d3.select('#datatable2').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table2(r+c,c,tv,col);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table2(0,c) : disp_table2(r-c,c,tv,col);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
            d3.select('#datatable2').remove();  d3.select('#zip3table').style('display','');
			fp_datasetindv.length=0;
     		keybindt2(r,c,cnt)
	      }
		  })
		  
		  );	  
		  
d3.select('body').node().focus();
 d3.select('#loader').remove();
}

function move()
{
this.parentNode.appendChild(this);
var dragTarget = d3.select(this);
dragTarget.style({left: d3.event.dx + parseInt(dragTarget.style("left")) + "px", top: d3.event.dy + parseInt(dragTarget.style("top")) + "px"});
}

<!---this displays a table of failed piece data, may want to use it later
function disp_table(r,c)
{
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_dataset.length;	
//if (cnt-30 < r) r=cnt-30;
if (r<0) r=0;
	res = fp_dataset.slice(r,c+r);      
var temp_rc = 'darkrow';	
var div = d3.select('#zip3table');
div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));
div.style('display','');
div.selectAll('#datatable').remove();
var tb = div.append('table')
	.attr('id','datatable')
	.style('margin','auto')
	.style('font-size','12px')
	.style('border','double 6px') 
	.style('background','#d3d3d3')
	.style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
	.attr('class','pbTable');

var thead = tb.append('thead');
var t =thead.append('tr')
.append('th')
	.attr('colspan',fp_hdr.length);
t.append('input')
	.attr('type','button')
	.attr('value','X')
	.style('float','right')
	.on('click', function()
		{
		d3.select('#zip3table').style('display','none'); d3.select('#datatable').remove();
		fp_dataset.length = 0;
		}
	);
t.append('label')		
	.text('Use Mouse Wheel to scroll or Page-Up/Page-Down')
	.style('text-align','center');

var hdrcell = thead.append('tr')
	.selectAll('th')
	.data(fp_hdr)
	.enter()
	.append('th')
	.style('position','relative')
	// .style('width',function(d,i) {return (i==2 || i==3 || i==4) ? '150px' : '70px'})	  
	.text(function(d)
		{
		return d.replace(/_/g,' ')
		}
	);

hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrow3-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,fp_dataset,30)});
hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrow3-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,fp_dataset,30)});
; //is this just an orphan semicolon?
tb.append('tbody')
	.on('wheel', function()
		{
		d3.event.preventDefault();
		(d3.event.deltaY < 0) ? disp_table(r-1, c) : disp_table(r + 1, c);
		}
	)
	.selectAll("tr") 
	.data(res)
	.enter()
	.append('tr')
	.attr('class',function(d,i)
		{
		if (i % 3 == 0)
			{  
			if (temp_rc == 'darkrow')
				temp_rc = 'lightrow'
			else  
				temp_rc = 'darkrow'; 
			}
//		   }
		return temp_rc;
		}
	)
	.selectAll("td") 
	.data(function(d){return d})
	.enter()	  
	.append('td')	  
	.on('click', function(d,i)
		{
		fprpt(this,i)
		}
	)
	.style('padding','4px')	  
	.style('cursor','pointer')	  	  
	.style('text-align',function(d,i) {return (i==1 || i == 3) ? 'left' : 'center'})	  
	.text(function(d,i) {return (i==5 || i==6) ? cmaf(d) : (i==7) ? perf(d): d});

d3.select('body').call(d3.keybinding()
	.on('page-down', function()
		{
		if (!d3.select('#datatable').empty())
			d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		}
	)	  
	.on('page-up', function()
		{
		if (!d3.select('#datatable').empty())
			d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
		}
	)
	.on('escape', function()
		{
		if (!d3.select('#datatable').empty())
			{
			d3.select('#datatable').remove();  
			fp_dataset.length = 0;
			}
		}
	)
);	  

d3.select('body').node().focus();
d3.select('#loader').remove();
}
--->

function pieces_data(res)
{
/* 
fp_dataset = res.DATA;  
= res.COLUMNS;
*/
var exc_time = res.pop();  
//alert(exc_time);
fp_hdr = res.shift();  
fp_dataset = res;	

disp_table(0,30); 
d3.select('#loader').remove();
}
		
function chartsperrow(t)
{
document.getElementById('chartsdiv').style.width = (t.value * 380 + 50)+'px';
}

var doInit;

//function init()
// {
// doInit = true;
// var e=new TDF();
// e.setCallbackHandler(load_Dates);	
// e.setErrorHandler(area_data_err);
// e.getDates('<cfoutput>#ivdata#</cfoutput>','');
// }
function init()
{
doInit = true;
var e=new TDF();
e.setCallbackHandler(load_Dates);
e.setErrorHandler(area_data_err);
e.getDates('<cfoutput>#ivdata#</cfoutput>', '');
}

function cfrm_sub()
//watered down test version of actual function which is commented out elsewhere
{
d3.select('#mainSvg').remove();
trendDataset.length=0;
myLoader();
d3.select('#csaicon').style('display','none');
//if (newdiropt)
//	newdiropt = false;
d3.selectAll("#loadShield")
	.attr("fill",'gray');
listSelections();
document.getElementById("subtn").style.border = 'none';
chartHistory[++ReqId] = {};

var sd = document.getElementById('selDate').value;
var sdend = getenddate(sd)
var srng = document.getElementById('selRange').value;		
var sarea = document.getElementById('selArea').value;
var sdist = document.getElementById('selDistrict').value;
var sfac = document.getElementById('selFacility').value;
var smailClass = document.getElementById('selMailClass').value;
var sentPntDisc= document.getElementById('selEntPntDisc').value;
var ssortLvl = document.getElementById('selSortLvl').value;

var e=new TDF();
e.setCallbackHandler(Display_Overalls);	
e.setErrorHandler(area_data_err);
e.getOverall(ReqId,'<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea, sdist, sfac, smailClass, sentPntDisc, ssortLvl);
for (var i=0; i < 8; i++)
	{
	var trendDate = gettrdate(sd, srng, i);
	var newrange = srng;
	var trendEnd = getenddate(trendDate); //note for qtr this doesn't get the correct end date so it is adjusted in the CFC
	if (srng == 'QTR')
		newrange='MON';
	var e = new TDF();
	e.setCallbackHandler(trend_Chart_FSS);	
	e.setErrorHandler(area_data_err);
	e.getTrend(ReqId,'<cfoutput>#ivdata#</cfoutput>', trendDate, trendEnd, newrange, sarea, sdist, sfac, smailClass, sentPntDisc, ssortLvl);
	}

	var e=new TDF();
	e.setCallbackHandler(AreaFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getByAreaFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend);

	

	var e=new TDF();
	e.setCallbackHandler(DistrictFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getByDistrictFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea);


	var e=new TDF();
	e.setCallbackHandler(FacilityFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getByFacilityFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea, sdist);


	var e=new TDF();
	e.setCallbackHandler(MailClassFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getByMailClassFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea, sdist, sfac);

	
	var e=new TDF();
	e.setCallbackHandler(EntPntDiscFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getByEntPntDiscFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea, sdist, sfac, smailClass);

	var e=new TDF();
	e.setCallbackHandler(SortationLevelFSSLeakage);	
	e.setErrorHandler(area_data_err);
	e.getBySortLevelFSS(ReqId, '<cfoutput>#ivdata#</cfoutput>', sd, sdend, sarea, sdist, sfac, smailClass, sentPntDisc);
}

function chg_DateRng(n)
{
var e=new TDF();
e.setCallbackHandler(load_Dates);	
e.setErrorHandler(area_data_err);
e.getDates('<cfoutput>#ivdata#</cfoutput>',n);
} 

function to_date(v)
{
var ar = v.split('/');
return new Date(ar[2],ar[0]-1,ar[1]);	 
}

function load_thru_Dates(res)
{
//this function is supposed to get a date from an ajax call (res) but for now we'll just use the date from the end date function
var sd = document.getElementById('selDate').value;	 	 
var ed = getenddate(sd);	 
//if (to_date(res) >= to_date(sd) && to_date(res) < to_date(ed))
	//filterArgs[3] = filterArgs[3].substr(0,10) + '-' + res;
filterArgs[3] = filterArgs[3].substr(0,10) + '-' + ed;
listSelections();
}

function getdatethru()
{
var e=new TDF();
e.setCallbackHandler(load_thru_Dates);	
e.setErrorHandler(area_data_err);
e.getthrudate('<cfoutput>#ivdata#</cfoutput>');
}

function getenddate(v)
{
for (var i = 0 ;i < date_rng.length; i++)
	if (date_rng[i][0] == v)
		return date_rng[i][1];
return v;   
} 
	  
ReqId = -1;
chartHistory = [];
chartHistory[0] = {};
	
function doHistory(dir)
{
d3.select('#loader').remove();
loadCnt = loadInit;
if (dir + ReqId < 0 || dir + ReqId >= chartHistory.length)
	return;
ReqId += dir;
for (var key in chartHistory[ReqId])
	if (chartHistory[ReqId].hasOwnProperty(key))
		chartHistory[ReqId][key]();
loadCnt = loadInit;		
for (var key in chartHistory[ReqId])
	if (chartHistory[ReqId].hasOwnProperty(key))
		chartHistory[ReqId][key]();
}

function Display_Overalls(res)
{
var rp = res.pop()[0];
var aryCol = res.shift();
chartHistory[rp].Display_Overalls = (function(data){
	return function(){
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	
		var toColor = cScale2(res[0][3]);
		var perF = d3.format('.1%');
		//var sigF = d3.format('.3g');
		var comF = d3.format(',');
		//d3.select('#TotalBundles').style('background', toColor).text(comF(res[0][0]));
		}
	}
)(res)

if(ReqId != rp)
	return;
var perF = d3.format('.1%');
//var sigF = d3.format('.3g'); this doesn't seem to be used anywhere
var comF = d3.format(',');
var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	
var idx = aryCol.indexOf('PCT_FSS_CNT');
var toColor = cScale2(res[0][idx]);
d3.select('#pctFSS').style('background',toColor).text(perF(res[0][idx]));

idx = aryCol.indexOf('TOTAL_PIECES');
d3.select('#TotalPieces').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('APPS_CNT');
d3.select('#APPS').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('FSS_CNT');
d3.select('#FSS').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('FSS_AFTER_APPS_CNT');
d3.select('#FSS-APPS').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('FSS_AFTER_AFSM_CNT');
d3.select('#FSS-AFSM').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('AFSM_CNT');
d3.select('#AFSM').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('AFSM_AFTER_FSS_CNT');
d3.select('#AFSM-FSS').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('AFSM_AFTER_APPS_FSS_CNT');
d3.select('#AFSM-APPS-FSS').style('background',toColor).text(comF(res[0][idx]));

idx = aryCol.indexOf('OTHER_CNT');
d3.select('#OTHER').style('background',toColor).text(comF(res[0][idx]));

}

<!--- trendgraph--->
var c0070="#EC9792";
var c7080="#FDBB9B";
var c8090="#fee090";
var c9095="#91bfdb";
var c9510="#7C9FCE";

function Load_Trend_Graph(res, aryCols)
{	
var w = 500;
var h = 160;
var padding = 40;

var rdiv = (w - (padding * 2)) / (8) / 2;
var rw = 300 / 8;

dataset = res;
var dtIdx = aryCols.indexOf('STRDATE');
var nnIdx = aryCols.indexOf('FSS_LEAKAGE_VOL');
var pctIdx = aryCols.indexOf('PCTLEAKAGE');

var high = d3.max(dataset, function(d) { return d[nnIdx]; });
//Create scale functions
xScale = d3.time.scale()
	.domain([d3.min(dataset, function(d) { return new Date(d[dtIdx]); }), new d3.max(dataset, function(d) { return new Date(d[dtIdx]); })])
	.range([padding + rw / 2 - 2, w - padding - rw / 2 + 2]);

yScale = d3.scale.linear()
	.domain([0, high])
	.range([h - padding, padding/2.5]);

yScale2 = d3.scale.linear()
	.domain([0, 1])
	.range([h - padding, padding/2.5]);

var formatAsPercentage = d3.format("%");
var formatAsInt = d3.format("d");		
var siF = d3.format('.3s');
var comF = d3.format(',');

if (getEleVal('selRange') == 'WEEK') 
	{
	var timeF = d3.time.saturday;
	var chartTitle ='8 Week Processing Trend';
	}
//if (getEleVal('selRange') == 'MON' || getEleVal('selRange') == 'QTR') 
else
	{
	var timeF = d3.time.month;
	var chartTitle ='8 Month Processing Trend';
	}
var cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	

var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		

//Define X axis
var xAxis = d3.svg.axis()
	.scale(xScale)
	.orient("bottom")
	//.innerTickSize(-h+padding*2)
	//.ticks(5)
	.ticks(timeF, 1)
	.tickFormat(d3.time.format('%m-%d'));

//Define Y axis
var yAxis = d3.svg.axis()
	.scale(yScale)
	.orient("left")
	//.innerTickSize(-w+padding*3)
	.ticks(5)
	.tickFormat(siF);

var yAxis2 = d3.svg.axis()
	.scale(yScale2)
	.orient("right")
	//.innerTickSize(-w+padding*3)
	.ticks(5)
	.tickFormat(formatAsPercentage);

var line = d3.svg.line()
	.interpolate("cardinal")
	.x(function(d) { return xScale(new Date(d[dtIdx])); })
	.y(function(d) { return yScale(d[nnIdx]); });

var line2 = d3.svg.line()
	//		.interpolate("cardinal")
	.x(function(d) { return xScale(new Date(d[dtIdx])); })
	.y(function(d) { return yScale2(d[pctIdx]); });
//Create SVG element
var svg = d3.select('#trend-Graph').select('#mainSvg');

if(svg.node())
	{
	container=svg.select("#mainContainer");
	svg.select('#chtitle').text(chartTitle);
	svg.select('.x.axis').call(xAxis).selectAll('text')
		.attr("y", 0)
		.attr("x", 9)
		.attr("dy", ".35em")
		.attr("transform", "rotate(45)")
		.style("text-anchor", "start").style('font-size','12px').style('font-family','arial, sans-serif').style('font-variant','small-caps');
	svg.select('.y.axis').call(yAxis).selectAll('text').style('font-size','12px').style('font-family','arial, sans-serif').style('font-variant','small-caps');
	svg.select('.y2.axis').call(yAxis2).selectAll('text').style('font-size','12px').style('font-family','arial, sans-serif').style('font-variant','small-caps');
	
	var fpie = container
		.selectAll(".failPie")
		.data(dataset);
	
	fpie.enter()
	.append("rect")
	.attr("class", "failPie")
	.attr("x", function(d,i) { return xScale(new Date(d[dtIdx]))-rw/2+2;})
	.attr("y", function(d) { return yScale(d[nnIdx]);})
	.attr("height",  function(d) {return Math.abs(yScale(d[nnIdx])-yScale(0));})
	.attr("width",rw-4)
	.style("fill", function(d) {return cScale2(Math.floor(d[pctIdx]*100)/100);}) .append('title')
	.text(function(d) {return 'Non-nested Bundles: '+comF(d[nnIdx]);})
	
	fpie.transition().duration(500).attr("x", function(d,i) { return xScale(new Date(d[dtIdx]))-rw/2+2;})
		.attr("y", function(d) { return yScale(d[nnIdx]);})
		.attr("height",  function(d) {return Math.abs(yScale(d[nnIdx])-yScale(0));})
		.attr("width",rw-4)
		.style("fill", function(d) {return cScale2(Math.floor(d[pctIdx]*100)/100);})
		.select('title').text(function(d) {return 'Non-nested Bundles: '+comF(d[nnIdx]);});
	
	fpie.exit().transition().remove();
	
	var lt2 = container.select(".lineTrend2 path")
	.datum(dataset);
	
	lt2.transition().duration(500).attr("class", "lineV")
	.attr("d",  line2)
	.attr('stroke', 'url(#temperature-gradient)')
	.attr('stroke-width', 2)
	.attr('fill', 'none');
	}
else if(!svg.node())
	{
	svg=d3.select('#trend-Graph')
		.append("svg")
		.attr("width", w)
		.attr("height", h)
		.attr("id", 'mainSvg');
	
	svg.append("rect")
		.attr("width", w)
		.attr("height", h)
		.attr("x", 0)
		.attr("y", 0)
		.attr("rx", 20)
		.attr("ry", 20)
		.style("fill", "white")
		.attr("opacity", 0.2);
	
	svg.append("text")
		.attr("class", "y label")
		.attr("x", padding-10)
		.attr("y", padding/3)
		.text(chartTitle).style('font-size','12px').style('font-family','Arial, sans-serif').style('font-variant','small-caps').attr('id', 'chtitle')
		.attr('fill','#000');
	
	svg.append("linearGradient")
		.attr("id", "temperature-gradient")
		.attr("gradientUnits", "userSpaceOnUse")
		.attr("x1", 0).attr("y1", yScale2(0))
		.attr("x2", 0).attr("y2", yScale2(1))
		.selectAll("stop")
		.data([
			{offset: "0%", color: c0070},
			{offset: "69%", color: c0070},
			{offset: "70%", color: c7080},
			{offset: "79%", color: c7080},
			{offset: "80%", color: c8090},
			{offset: "89%", color: c8090},
			{offset: "90%", color:c9095},
			{offset: "94%", color: c9095},
			{offset: "95%", color: c9510},
			{offset: "100%", color: c9510}
		])
	.enter().append("stop")
		.attr("offset", function(d) { return d.offset; })
		.attr("stop-color", function(d) { return d.color; });
	
	var container = svg.append('g').attr('id','mainContainer');
	var fpie = container
		.selectAll(".failPie")
		.data(dataset);
	//aaa				   
	fpie.enter()
		.append("rect")
		.on('click',function(d) {d3.select('#selDate').node().value=d[dtIdx];filterArgs[3]=d[dtIdx];cfrm_sub()})
		.attr("class", "failPie")
		.attr("x", function(d,i) { return xScale(new Date(d[dtIdx]))-rw/2+2;})
		.attr("y", function(d) { return yScale(d[nnIdx]);})
		.attr("height",  function(d) {return Math.abs(yScale(d[nnIdx])-yScale(0));})
		.attr("width",rw-4)
		.style("fill", function(d) {return cScale2(Math.floor(d[pctIdx]*100)/100);}) .append('title')
		.text(function(d) {return 'Non-nested Bundles: '+comF(d[nnIdx]);})
		
	container.append("g")
		.attr("class", "lineTrend2")
		.append("path")
		.datum(dataset)
		//			.attr("class", "lineV")
		.attr("d", line2)
		//			.attr('stroke', 'url(#temperature-gradient)')
		.attr('stroke','black')
		.attr("opacity",0.50)			
		.attr('stroke-width', 1)
		.attr('fill', 'none');
	
	//Create X axis
	svg.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(0," + (h - padding) + ")")
		.call(xAxis).selectAll('text')
		.attr("y", 0)
		.attr("x", 9)
		.attr("dy", ".35em")
		.attr("transform", "rotate(45)")
		.style("text-anchor", "start").style('font-size','10px').style('font-family','Arial, sans-serif').style('font-variant','small-caps').style('font-weight','bold');
	
	//Create Y axis
	svg.append("g")
		.attr("class", "y axis")
		.attr("transform", "translate(" + padding + ",0)")
		.call(yAxis)
		.selectAll('text').style('font-size','10px').style('font-family','Arial, sans-serif').style('font-variant','small-caps').style('font-weight','bold');
	
	//Create Y axis
	svg.append("g")
		.attr("class", "y2 axis")
		.attr("transform", "translate(" + (w-padding) + ",0)")
		.call(yAxis2)
		.selectAll('text').style('font-size','10px').style('font-family','Arial, sans-serif').style('font-variant','small-caps').style('font-weight','bold');
	}

svg.select("#loadShield").remove();

var ldShd = svg
	.append("rect")
	.attr("id","loadShield")
	.attr("opacity",0.75)
	.style("fill",'none')
	.attr("width", w)
	.attr("height",h);
}	
<!--- trendgraph--->

function listSelections() 
{		
d3.select('#flist').style('display','');
d3.select('#flist').selectAll('span').remove();
var hold =[];
hold.push(filterHds[3]);
var hold2 =[];
hold2.push(filterArgs[3]);
d3.select('#flist').selectAll('span')
	.data(hold)
	.enter()
	.append('span')
	.attr('class','smallFnt')
	.text(function(d,i){return d + hold2[i];});
}

function load_std(res)
{
var sel=document.getElementById('selHybStds')
sel.length=0;
res.forEach(function(d,i){
	sel.options[sel.options.length] = new Option(d[1],d[0]);
});
if(document.getElementById('selClasses').value==3)
	sel.selectedIndex=1;
filterArgs[8]=res[sel.selectedIndex][1];
cfrm();
}

	function std_err(res)
	{
		alert(res);
	}

	function get_std()
	{
		var seod = document.getElementById('selEod').value;
		var sclass = document.getElementById('selClasses').value;

		var e=new TDF();
		e.setCallbackHandler(load_std);	
		e.setErrorHandler(std_err);
		e.getHybStd('<cfoutput>#ivdata#</cfoutput>',sclass,seod);
	}

	function chg_area(t)
	{
		d3.select('#selArea').node().value=t.value;
		load_district();
		cfrm();
	}

	function chg_district()
	{
		cfrm();
	}

	function chg_date()
	{
		cfrm();
	}

	function chg_rng(t)
	{
        d3.select('#subtn').node().disabled=true;
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#ivdata#</cfoutput>',t.value);
		
//		cfrm();
	}


	function cat_sel(n)
	{
		var sc = document.getElementById('selCategory');
		if(sc.value=='')
		{
			sc.value=n;
			return;
		}
		var scAr = sc.value.split(',');
		var chk = false;
		var hold = [];
		scAr.forEach(function(d,i){		
			if(d==n)
				chk=true;
			else
				hold.push(d);
		});
		if(!chk)
			hold.push(n);
		sc.value=hold.toString();
		
	}
	
	function cat_filt(n)
	{
		if(filterArgs[9]=='')
		{
			filterArgs[9]=n;
			return;
		}
		var scAr = filterArgs[9].split(',');
		var chk = false;
		var hold = [];
		scAr.forEach(function(d,i){		
			if(d==n)
				chk=true;
			else
				hold.push(d);
		});
		if(!chk)
			hold.push(n);
		filterArgs[9]=hold.toString();
		
	}

function load_Dates(res)
{
//res.shift();
date_rng = res;
var sel = document.getElementById('selDate');
sel.options.length = 0;
res.forEach(function(d,i){
	sel.options[sel.options.length] = new Option(d[0],d[0]);
	});
filterArgs[3] = sel.options[0].text;
if(doInit)
	{
	doInit = false;
	filterArgs[3] = sel.options[0].text;
	document.getElementById('filtDiv').style.display='none';
	document.getElementById('sFilt').style.display = '';
	cfrm_sub();			
	}
if(d3.select('#subtn').node().disabled)
	{
	d3.select('#subtn').node().disabled = false;
	document.getElementById("subtn").style.border = 'Red 4px solid';
	}
//getdatethru();
//test
var sd = document.getElementById('selDate').value;
var srng = document.getElementById('selRange').value;
//alert(sd);
//alert(srng);
//alert(gettrdate(sd, srng, 1));
}

	var ADHier;
	function load_Area_Dist(res)
	{
		ADHier=d3.nest()
		.key(function(d){return d[1]})
		.key(function(d){return d[3]})
		.entries(res);
		ADHier.forEach(function(d,i){
			d.values.sort(function(a,b){return d3.ascending(a.values[0][2],b.values[0][2])});
		});
		load_area();
	}

	function excel_out(t)
	{
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE "); 

		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
		{
			txtArea1.document.open("txt/html","replace");
			txtArea1.document.write(d3.select(t).node().innerHTML);
			txtArea1.document.close();
			txtArea1.focus(); 
			sa=txtArea1.document.execCommand("SaveAs",true,"Performance.xls");
		}  
		else  
			window.open('data:application/vnd.ms-excel;filename=Performance.xls;base64,'+window.btoa(d3.select(t).node().innerHTML));
	}
	
	function toggle()
	{
	 var t = document.getElementById('wrapper');
	 if (t.className == 'active')
	 t.className = ''
	 else
	 t.className = 'active';
	}
	
	function resetAll()
	{
		d3.select('#RAll').style('color','silver');
		d3.select('#filtDiv').selectAll('[type=hidden]').attr('value','');
		cfrm_sub();
	}
</script>
</head>

<body onload="init()" style="margin:0px;">

<input type="hidden" id="selArea" name="selArea" value="">
<input type="hidden" id="selDistrict" name="selDistrict" value="">
<input type="hidden" id="selFacility" name="selFacility" value="">
<input type="hidden" id="selMailClass" name="selMailClass" value="">
<input type="hidden" id="selEntPntDisc" name="selEntPntDisc" value="">
<input type="hidden" id="selSortLvl" name="selSortLvl" value="">
<div id="banner" style="margin:0px auto; background: #21435F; height:60px; color:#FFFFFF">
<input type='button' value='|||' <!---onclick="toggle()"---> class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:18px;"> Informed Visibility </span><br>
<span  style="font-size:13px;"> The single source for all your mail visibility needs </span>
<label style="font-style:italic; font-size:15px; position:relative; left:+20px; top:-15px">Enterprise Analytics </label>
</div><br>
</div>
<div id="wrapper" class="">
<!-- Page content -->
<div id="page-content-wrapper">
<div style="float: left;">
<fieldset class="fset" style="border: solid 1px blue;padding: 5px 5px"><legend>Filters</legend>
<div id="filtDiv">
	<fieldset class="fset"><legend>Date By:</legend>
		<select class="slct" name="selRange" id="selRange" onchange="filterHds[3]=this.options[this.selectedIndex].text;filterArgs[2]=this.options[this.selectedIndex].text;chg_rng(this);">
		<option value="WEEK">Week</option> 
		<option value="MON">Month</option> 
		<option value="QTR">Quarter</option> 
		</select>
		<select class="slct" name="selDate" id="selDate" onchange="filterArgs[3]=this.options[this.selectedIndex].text;cfrm();">
		</select>
	</fieldset>
	<fieldset class="fset"><legend></legend>
		<input class="slct" id="subtn" type="button" value="Submit Request" onClick="document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
	</fieldset>
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="hideFilt" type = "button" value = "Hide" onClick="document.getElementById('chartsdiv').style.display='inline-block'; document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';d3.select('#flist').style('display','');">        
	</fieldset>   
</div>
	<fieldset class="fset" id="sFilt" style='display:none'><legend></legend>
		<input class ="slctSmall" type = "button" value = "Show Filters" onClick="document.getElementById('chartsdiv').style.display='inline-block'; document.getElementById('filtDiv').style.display='';d3.select('#flist').style('display','none');document.getElementById('sFilt').style.display='none';">
		<div id='flist' style='float:right'></div>
	</fieldset>
</fieldset>

<div id='chRow' style="display:inline-block;margin:5px;">
<input class ="slctSmall" type='button' id="undobtn" value='Undo' onclick='doHistory(-1)' disabled>
<select class ="slctSmall" onchange = "chartsperrow(this)">
<option value = 1>1 Chart Per Row</option>
<option value = 2>2 Charts Per Row</option> 
<option value = 3 selected>3 Charts Per Row</option> 
<option value = 4> 4 Charts Per Row</option> 
<option value = 5>5 Charts Per Row</option> 
<option value = 6>6 Charts Per Row</option> 
<option value = 7>7 Charts Per Row</option> 
</select></div>
<input class ="slctSmall" type='button' id="notes" value='Report Notes' onclick='open_pdf()'>
<div id="color-key" style='margin:0px 50px 20px 50px;display:inline-block; float: right;'>
	<strong>Color Key</strong>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#EC9792"></div>
		<span>Score 60&ndash;100%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#FDBB9B"></div>
		<span>Score 30&ndash;60%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#fee090"></div><span>Score 20&ndash;30%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#91bfdb"></div>
		<span>Score 10&ndash;20%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#7C9FCE"></div><span>Score 0&ndash;10%</span>
	</div>
</div>
<h2>FSS Leakage Visualization</h2><iframe id="txtArea1" style="display:none"></iframe> 
</div>
<div id ="loaderDiv" style="z-index: 3; left:50%;top:50%; position:absolute"> </div>
<br clear="all">
<div style="margin: 0px 10px 0px 10px;">
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">Total Pieces</legend>
	<div id="TotalPieces" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">APPS/APBS</legend>
	<div id="APPS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">Scanned FSS</legend>
	<div id="FSS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">% Scanned </br>FSS</legend>
	<div id="pctFSS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">FSS after </br>APPS/APBS</legend>
	<div id="FSS-APPS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold;font-size: 14px; text-align: center; margin: 0px auto;">FSS </br>after AFSM</legend>
	<div id="FSS-AFSM" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold; font-size: 14px; text-align: center; margin: 0px auto;">Scanned AFSM</legend>
	<div id="AFSM" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold; font-size: 14px; text-align: center; margin: 0px auto;">AFSM </br>After FSS</legend>
	<div id="AFSM-FSS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight:  bold; font-size: 14px; text-align: center; margin: 0px auto;">AFSM </br> after APPS & FSS</legend>
	<div id="AFSM-APPS-FSS" class="overall">
	</div>
	</div>
	<div style="margin:0px 3px 0px 3px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: Arial, Helvetica, sans-serif;">
	<legend style="font-weight: bold; font-size: 14px; text-align: center; margin: 0px auto;">Others</legend>
	<div id="OTHER" class="overall">
	</div>
	</div>
</div>
<input type='button' id="RAll" style="font-size: 10px;border:none;text-decoration:underline;padding:10px 0px;background:transparent;color:silver;height:40px;width:80px;cursor:pointer;" value='Reset All' onClick='resetAll();'/>

</div>
<div id="trend-Graph" style="text-align:center; min-width:80%;"></div>
<div id="chartsdiv" style='width:100%; margin:0 auto'>
	<div id="AreaFSSLeakage" style="display:inline-block;max-width:380px;"></div>
	<div id="DistrictFSSLeakage" style="display:inline-block;max-width:380px;"></div>
	<div id="FacilityFSSLeakage" style="display:inline-block;max-width:380px;"></div>
	<div id="MailClassFSSLeakage" style="display:inline-block;max-width:380px;"></div>
	<div id="EntPntDiscFSSLeakage" style="display:inline-block;max-width:380px;"></div>
	<div id="SortationLevelFSSLeakage" style="display:inline-block;max-width:380px;"></div>
</div>
<div id="zip3table" style="position:absolute; top:200px; left:200px; ;text-align:center; display:none; ">
</div>
<div id="csatable" style="position:absolute; top:100px; left:200px; ;text-align:center; display:none; ">
</div>

<div id="fptable" style="position:absolute; top:100px; left:50px; width:1500px; text-align:center; display:none; <!---overflow-x:scroll;overflow-y:hidden --->">
</div>

<div id='searchBlock' style='padding: 25px;display: none;border: solid 2px blue;background:#f3f3f3;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
Search by Name:
<input id='searchTarget' type='text' onkeyup='if (event.keyCode == 13) {d3.select("#commitSearch").node().click();}'/> <input type='button' id='commitSearch' value='submit' onClick='d3.select("#searchBlock").style("display","none");')/>
</div>
<input class ="hyperFont" type = "button" id='eOut' value = "Excel" onClick="excel_out();" style='display:none;margin:0px 0px 0px 30px;'>
<div id ="tableDiv" style='margin:0px 0px 10px 30px'></div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>