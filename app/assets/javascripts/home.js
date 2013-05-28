
    $(document).foundation();

    //$('#aviso').foundation('reveal', 'open');

    	$(function() {
			
				var Page = (function() {

					var $nav = $( '#nav-dots > span' ),
						slitslider = $( '#slider' ).slitslider( {
							onBeforeChange : function( slide, pos ) {

								$nav.removeClass( 'nav-dot-current' );
								$nav.eq( pos ).addClass( 'nav-dot-current' );

							}
						} ),

						init = function() {

							initEvents();
							
						},
						initEvents = function() {

							$nav.each( function( i ) {
							
								$( this ).on( 'click', function( event ) {
									
									var $dot = $( this );
									
									if( !slitslider.isActive() ) {

										$nav.removeClass( 'nav-dot-current' );
										$dot.addClass( 'nav-dot-current' );
									
									}
									
									slitslider.jump( i + 1 );
									return false;
								
								} );
								
							} );

						};

						return { init : init };

				})();

				Page.init();			
			});

    	$('.logo').click(function(){
			$('body').scrollTo( 0, 1000, {offset: {top:-50} });
			activeItem(this);
		});



		$('.top-bar ul li').click(function(){
			var element = $(this).attr('class');
			$('body').scrollTo( '.'+element+'-move', 1000, {offset: {top:-50} });
			activeItem(this);
		});

		function activeItem (value) {
			$('.top-bar ul li').each(function() {
				$(this).removeClass('active');
			});
			$(value).addClass('active');
		}

		$('.empreendimento').mouseenter(function () {
			$('.d-1').animate({
			    opacity: 0.25,
			    left: '-=200',
			  }, 100);
			$('.d-2').animate({
			    opacity: 0.25,
			    left: '+=200',
			  }, 100);
		}).mouseleave(function () {
			$('.d-1').animate({
			    opacity: 1,
			    left: '0',
			  }, 100);
			$('.d-2').animate({
			    opacity: 1,
			    left: '0',
			  }, 100);
		});

		$("#client_cpf, #client_conjugue_cpf").mask("999.999.999-99");
   		$("#client_telefone").mask("(99)9999-9999");

   		$('.conjugue').hide();

   		$('.estado_civil').change(function(){
   			if($(this).val() == 'casado'){
   				$('.conjugue').fadeIn();
   				console.log('cas');
   			}else{
   				$('.conjugue').fadeOut();
   				console.log('sol');
   			}   				
   		});

   		if($('#error_explanation')){
   			$('body').scrollTo('#error_explanation', 1000, {offset: {top:-50} });
   		}

   		
			
		