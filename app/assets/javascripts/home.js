
    $(document).foundation();

    	$('.logo').click(function(){
			$('body').scrollTo( 0, 1000, {offset: {top:-50} });
			activeItem(this);
		});



		$('.top-bar-section ul li').click(function(){
			var element = $(this).attr('class');
			$('body').scrollTo( '.'+element+'-move', 1000, {offset: {top:-50} });
			activeItem(this);
		});

		function activeItem (value) {
			$('.top-bar-section ul li').each(function() {
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

   		
			
		