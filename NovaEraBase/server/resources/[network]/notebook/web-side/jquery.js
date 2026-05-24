$(document).ready(() => {
	updateSlider();

	$("#savebtn").click(function(){
		$.post("http://"+GetParentResourceName()+"/save",JSON.stringify(getSliderValues()));
		menuToggle(false,true);
	});

	window.addEventListener("message",function(event){
		if (event.data.type == "togglemenu"){
			menuToggle(event.data.state,false);

			document.getElementById("driveinertia").max = 2;
			if (parseFloat(event.data.driveinertiavalue.toFixed(2)) > 2) {
				document.getElementById("driveinertia").max = parseFloat(event.data.driveinertiavalue.toFixed(2));
			}
			document.getElementById("driveinertia").value = parseFloat(event.data.driveinertiavalue.toFixed(2));
			document.getElementById("valuerangedriveinertia").innerHTML = parseFloat(event.data.driveinertiavalue.toFixed(2));
			
			document.getElementById("steeringlock").value = parseFloat(event.data.steeringlockvalue.toFixed(2));
			document.getElementById("valuerangesteeringlock").innerHTML = parseFloat(event.data.steeringlockvalue.toFixed(2));
			
			document.getElementById("tractioncurvemax").max = 3;
			if (parseFloat(event.data.tractioncurvemaxvalue.toFixed(2)) > 3) {
				document.getElementById("tractioncurvemax").max = parseFloat(event.data.tractioncurvemaxvalue.toFixed(2));
			}
			document.getElementById("tractioncurvemax").value = parseFloat(event.data.tractioncurvemaxvalue.toFixed(2));
			document.getElementById("valuerangetractioncurvemax").innerHTML = parseFloat(event.data.tractioncurvemaxvalue.toFixed(2));
			
			document.getElementById("tractioncurvemin").max = 3;
			if (parseFloat(event.data.tractioncurveminvalue.toFixed(2)) > 3) {
				document.getElementById("tractioncurvemin").max = parseFloat(event.data.tractioncurveminvalue.toFixed(2));
			}
			document.getElementById("tractioncurvemin").value = parseFloat(event.data.tractioncurveminvalue.toFixed(2));
			document.getElementById("valuerangetractioncurvemin").innerHTML = parseFloat(event.data.tractioncurveminvalue.toFixed(2));
			
			document.getElementById("tractioncurvelateral").value = parseFloat(event.data.tractioncurvelateralvalue.toFixed(2));
			document.getElementById("valuerangetractioncurvelateral").innerHTML = parseFloat(event.data.tractioncurvelateralvalue.toFixed(2));
			
			document.getElementById("lowspeedtractionlossmult").max = 1;
			if (parseFloat(event.data.lowspeedtractionlossmultvalue.toFixed(2)) > 1) {
				document.getElementById("lowspeedtractionlossmult").max = parseFloat(event.data.lowspeedtractionlossmultvalue.toFixed(2));
			}
			document.getElementById("lowspeedtractionlossmult").value = parseFloat(event.data.lowspeedtractionlossmultvalue.toFixed(2));
			document.getElementById("valuerangelowspeedtractionlossmult").innerHTML = parseFloat(event.data.lowspeedtractionlossmultvalue.toFixed(2));
			if (event.data.data != null){
				setSliderValues(event.data.data);
			}
		}
	});

	function getSliderValues(){
		return {
			driveinertia: $("#driveinertia").val(),
			steeringlock: $("#steeringlock").val(),
			tractioncurvemax: $("#tractioncurvemax").val(),
			tractioncurvemin: $("#tractioncurvemin").val(),
			tractioncurvelateral: $("#tractioncurvelateral").val(),
			lowspeedtractionlossmult: $("#lowspeedtractionlossmult").val(),
			initialdragcoeff: $("#lowspeedtractionlossmult").val(),
		};
	}

	function menuToggle(bool,send=false){
		if (bool){
			$("body").fadeIn(300).css("display","flex");
			$(".vignette").fadeIn(300).css("display","flex");
		} else {
			$("body").fadeOut(300).css("display","none");
			$(".vignette").fadeOut(300).css("display","none");
		}

		if (send){
			$.post("http://"+GetParentResourceName()+"/togglemenu",JSON.stringify({ state: false }));
		}
	}

	function setSliderValues(values){
		$(".styled-slider").each(function(){
			if(values[this.id] != null){
				$(this).val(values[this.id]);
			}
		});

		updateSlider();
	}

	function updateSlider(){
		for (let e of document.querySelectorAll("input[type='range'].slider-progress")){
			e.style.setProperty("--value",e.value);
			e.style.setProperty("--min",e.min == "" ? "0" : e.min);
			e.style.setProperty("--max",e.max == "" ? "100" : e.max);
			e.addEventListener("input",() => e.style.setProperty("--value",e.value));
		}
	}

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://"+GetParentResourceName()+"/exit");
			menuToggle(false,true);
		}
		if (data.which == 9){
			$.post("http://"+GetParentResourceName()+"/save",JSON.stringify(getSliderValues()));
			menuToggle(false,true);
		}
	};
})

var slider = document.getElementById("driveinertia");
var output = document.getElementById("valuerangedriveinertia");

output.innerHTML = slider.value;

slider.oninput = function() {
    output.innerHTML = this.value;
}

var slider2 = document.getElementById("steeringlock");
var output2 = document.getElementById("valuerangesteeringlock");

output2.innerHTML = slider2.value;

slider2.oninput = function() {
    output2.innerHTML = this.value;
}

var slider3 = document.getElementById("tractioncurvemax");
var output3 = document.getElementById("valuerangetractioncurvemax");

output3.innerHTML = slider3.value;

slider3.oninput = function() {
    output3.innerHTML = this.value;
}

var slider4 = document.getElementById("tractioncurvemin");
var output4 = document.getElementById("valuerangetractioncurvemin");

output4.innerHTML = slider4.value;

slider4.oninput = function() {
    output4.innerHTML = this.value;
}

var slider5 = document.getElementById("tractioncurvelateral");
var output5 = document.getElementById("valuerangetractioncurvelateral");

output5.innerHTML = slider5.value;

slider5.oninput = function() {
    output5.innerHTML = this.value;
}

var slider6 = document.getElementById("lowspeedtractionlossmult");
var output6 = document.getElementById("valuerangelowspeedtractionlossmult");

output6.innerHTML = slider6.value;

slider6.oninput = function() {
    output6.innerHTML = this.value;
}