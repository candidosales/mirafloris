		var geocoder;
		var map;
		var bounds = new google.maps.LatLngBounds();

		var markersArray = [];
		var params = [];

		var destinoIcon = 'https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=D|FF0000|000000';
		var origemIcon = 'https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=O|FFFF00|000000';

		//Posição do empreendimento
		var destino = {
			'latitude': -5.148691,
			'longitude': -42.685361
		}

		//Posição do usuário
		var origem = {
			'latitude': '',
			'longitude': ''
		}

		var styles = [
			{
				featureType: 'water',
				elementType: 'all',
				stylers: [
					{ hue: '#ada4fd' },
					{ saturation: 92 },
					{ lightness: 24 },
					{ visibility: 'on' }
				]
			},{
				featureType: 'landscape',
				elementType: 'all',
				stylers: [
					{ hue: '#94d88c' },
					{ saturation: 31 },
					{ lightness: -22 },
					{ visibility: 'on' }
				]
			}
		];

		get_location();
        
        function get_location() {
        	  GMaps.geolocate({
		        success: function(position){

		          geocoder = new google.maps.Geocoder();

		          origem.latitude = position.coords.latitude;
		          origem.longitude = position.coords.longitude;

		           map = new GMaps({
			        el: '#map',
			        lat: origem.latitude,
			        lng: origem.longitude,
			        zoomControl : true,
			        zoomControlOpt: {
			            style : 'SMALL',
			            position: 'TOP_LEFT'
			        },
			        zoom: 12,
			        panControl : true,
			        streetViewControl : false,
			        mapTypeControl: true,
			        overviewMapControl: false
			      });

		           
				   map.addStyle({
				            styledMapName:"Styled Map",
				            styles: styles,
				            mapTypeId: "map_style"  
				        });
		           map.setStyle("map_style");

		          map.setCenter(origem.latitude, origem.longitude);
		          //route(origem.latitude, origem.longitude);

		          params.origem = new google.maps.LatLng(origem.latitude, origem.longitude);
		          params.destino = new google.maps.LatLng(destino.latitude, destino.longitude);

		          var distance = google.maps.geometry.spherical.computeDistanceBetween (params.origem, params.destino);
		          console.log("Distancia sem percurso: "+distance/1000);

		          $('#distance').html('<h5>'+
		            '<strong>Apenas '+parseFloat(distance/1000).toFixed(2)+' km </strong> <br/>'+
		            '<strong>para começar seu futuro!</strong></h5>');

		          //calculateDistances(params);
		          var path = [[origem.latitude, origem.longitude], [destino.latitude, destino.longitude]];

		          	map.drawPolyline({
				        path: path,
				        strokeColor: '#131540',
				        strokeOpacity: 0.6,
				        strokeWeight: 6
				     });
		          	map.drawOverlay({
					  lat: origem.latitude+0.005080,
					  lng: origem.longitude,
					  content: '<div class="overlay voce">VOCÊ<div class="overlay_arrow above voce"></div></div>',
				      verticalAlign: 'top',
				      horizontalAlign: 'center'
					});

		          	map.drawOverlay({
					  lat: destino.latitude+0.005080,
					  lng: destino.longitude,
					  content: '<div class="overlay">MIRAFLORIS<div class="overlay_arrow above"></div></div>',
				      verticalAlign: 'top',
				      horizontalAlign: 'center'
					});

					$('#distance').show();
		        },
		        error: function(error){
		          //alert('Geolocation failed: '+error.message);
		        },
		        not_supported: function(){
		          //alert("Your browser does not support geolocation");
		        },
		        always: function(){
		          //alert("Done!");
		        }
		      });
		  if (!Modernizr.geolocation) {
		    		 map = new GMaps({
				        el: '#map',
				        lat: destino.latitude,
				        lng: destino.longitude,
				        zoomControl : true,
				        zoom: 12,
				        zoomControlOpt: {
				            style : 'SMALL',
				            position: 'TOP_LEFT'
				        },
				        panControl : false,
				        streetViewControl : false,
				        mapTypeControl: true,
				        overviewMapControl: false
				      });

		    		 map.drawOverlay({
					  lat: destino.latitude+0.005080,
					  lng: destino.longitude,
					  content: '<div class="overlay">MIRAFLORIS<div class="overlay_arrow above"></div></div>',
				      verticalAlign: 'top',
				      horizontalAlign: 'center'
					});

		    		 $('#distance').hide();
		    		 aviso();
		    		 
		  }
	}
		        

		        function aviso(){
		        	var a=localStorage.getItem("fired");"1"!=a&&($('#aviso').foundation('reveal', 'open'),localStorage.setItem("fired","1"))
		        }

		 

		 function route(lat, lgt){
		 	map.drawRoute({
			  origin: [lat, lgt],
			  destination: [destino.latitude, destino.longitude ],
			  travelMode: 'driving',
			  strokeColor: '#131540',
			  strokeOpacity: 0.6,
			  strokeWeight: 6
			});
		 }

		 function calculateDistances(params) {
		  var service = new google.maps.DistanceMatrixService();
		  service.getDistanceMatrix(
		    {
		      origins: [params.origem],
		      destinations: [params.destino],
		      travelMode: google.maps.TravelMode.WALKING,
		      unitSystem: google.maps.UnitSystem.METRIC,
		      avoidHighways: true,
		      avoidTolls: true
		    }, callback);
		}

		function callback(response, status) {
		  if (status != google.maps.DistanceMatrixStatus.OK) {
		    alert('Error was: ' + status);
		  } else {
		    var origins = response.originAddresses;
		    var destinations = response.destinationAddresses;
		    var outputDiv = document.getElementById('distance');
		    outputDiv.innerHTML = '';
		    deleteOverlays();
		      var results = response.rows[0].elements;
		      /*outputDiv.innerHTML += origins[0] + ' to ' + destinations[0]
		            + ': ' + results[0].distance.text + ' in '
		            + results[0].duration.text + '<br>';*/

		            outputDiv.innerHTML += '<h5>'+
		            '<strong>Apenas '+results[0].distance.text+'</strong> <br/>'+
		            '<strong>para iniciar seu sonho!</strong></h5>';
		  }
		}

		function deleteOverlays() {
		  for (var i = 0; i < markersArray.length; i++) {
		    markersArray[i].setMap(null);
		  }
		  markersArray = [];
		}