
    $(document).foundation();

    $('#aviso').foundation('reveal', 'open');

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

    (new TimelineLite({onComplete:initScrollAnimations}))

	function initScrollAnimations() {
		var controller = $.superscrollorama({
			triggerAtCenter: false,
			playoutAnimations: true
		});
		//controller.addTween('#scale-it', TweenMax.fromTo( $('#scale-it'), .25, {css:{opacity:0, fontSize:'0.2em'}, immediateRender:true, ease:Quad.easeInOut}, {css:{opacity:1, fontSize:'1em'}, ease:Quad.easeInOut}));
		controller.addTween('#fly-it', TweenMax.from( $('#fly-it'), .3, {css:{right:'1600px'}, ease:Quad.easeInOut}));
		controller.addTween('#fade-it', TweenMax.from( $('#fade-it'), .3, {css:{opacity: 0}, ease:Quad.easeInOut}));
		controller.addTween('#fade-it-1', TweenMax.from( $('#fade-it-1'), .3, {css:{opacity: 0}, ease:Quad.easeInOut}));
	}
		$('.novo-bairro').click(function(){
			$('body').scrollTo( '.novo-bairro-move', 1000, {offset: {top:-100, left:-30} });
		});

		$('.mais-acessivel').click(function(){
			$('body').scrollTo( '.mais-acessivel-move', 1000, {offset: {top:-100, left:-30} });
		});

		$('.mais-planejado').click(function(){
			$('body').scrollTo('.mais-planejado-move', 1000, {offset: {top:-100, left:-30} });
		});

		$('.saiba-mais').click(function(){
			$('body').scrollTo('.saiba-mais-move', 1000, {offset: {top:-100, left:-30} });
		});

		$('.realizacao').click(function(){
			$('body').scrollTo('.realizacao-move', 1000, {offset: {top:-100, left:-30} });
		});

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

		$("#client_cpf").mask("999.999.999-99");
   		$("#client_telefone").mask("(99)9999-9999");
			
		