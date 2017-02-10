/* global $ */
/**
 * Style buttons
 */
function addClassToSystemElements() {
	$('.magicWrapper').each(function() {
		var btnWrapper    = $(this);
		var elementsCount = 0;
		var classesCount  = 0;
		var idsCount      = 0;
		var classArray, idsArray, elemsArray;

		if((btnWrapper.data('class') !== null) && (typeof btnWrapper.data('class') !== 'undefined')) {
			classArray   = btnWrapper.data('class').split(';');
			classesCount = classArray.length;
		}

		if(btnWrapper.data('id') !== null && (typeof btnWrapper.data('id') !== 'undefined')) {
			idsArray = btnWrapper.data('id').split(';');
			idsCount = idsArray.length;
		}

		if(btnWrapper.data('elements') !== null && (typeof btnWrapper.data('elements') !== 'undefined')) {
			elemsArray    = btnWrapper.data('elements').split(';');
			elementsCount = elemsArray.length;
		}

		if(elementsCount !== 0) {
			if(classesCount !== 0) {
				if(classesCount == elementsCount) {
					for (var i = 0; i < classesCount; i++) {
						btnWrapper.find($.trim(elemsArray[i])).addClass($.trim(classArray[i]));
					}
				} else {
					console.log(btnWrapper);
					throw new Error('Number of given classes and elements must match!');
				}
			}

			if(idsCount !== 0) {
				if(idsCount == elementsCount) {
					for (var j = 0; j < idsCount; j++) {
						btnWrapper.find($.trim(elemsArray[j])).attr('id', $.trim(idsArray[j]));
					}
				} else {
					console.log(btnWrapper);
					throw new Error('Number of given ids and elements must match!');
				}
			}
		} else {
			console.log('No elements to edit! ↓');
			console.log(btnWrapper);
		}
	});
}

function removeSystemNBSP() {
	$('.removeNBSP').each(function() {
		var thisWrapper = $(this);
		thisWrapper.html(thisWrapper.html().replace(/&nbsp;/g, ''));
	});
}

// Main onLoad function
function onLoad() {
	addClassToSystemElements();
	removeSystemNBSP();    
    // Search Form 
    if ($(".search-tour").length) {
        initSFDatepicker();
        changeFormBySeason();
        initStarRating();
        initPriceSlider();
    } 
}

// pridani addremove cart icons
if($(".cart-addremove-buttons").length) {
  $(".cart-addremove-buttons").each(function(index, el) {
    $(this).find("a").eq(0).append("<span class='favourites__add-icon'>+</span>");
    $(this).find("a").eq(1).append("<span class='favourites__remove-icon'>-</span>");
  }); // konec each  
}// konec addremove cart icons


// vypis oblibenych odmazava online odebirane polozky z view  
$(".isfavourites .item-row").each(function(el) {
  
   $(this).find(".cart-addremove-buttons a").eq(1).on('click', function() {
   
     $(this).closest(".item-row").remove();
     checkFavouriteProductCount();   
 
   });

});

// fce ktera neco udela, pri odmazani posledni polozky
function checkFavouriteProductCount() {
 // oblibenych produktu 0
 if (!$(".isfavourites .item-row").length) {
   // do somethin
 } 
} // konec checkFavouriteProductCount


/** SearchForm Helpers */
/**
 * Search form has different look for season (summer vs winter).
 * SF uses a class (.sf-winter-disabled). This class indicates that a control has to be hidden for winter season.
 *   
 */
function changeFormBySeason(){
    var $searchForm = $(".search-tour"), /*search form*/
    $seasonInputs = $searchForm.find(".season input"), /*radio buttons for season change*/
    $winterDisabledEls = $searchForm.find(".sf-winter-disabled"),    
    season = "summer";
    
    /**
     * Get name of selected season (from season input value). Name can be "winter" or "summer". 
     */
    var getSeason =  function(){
      return $seasonInputs.filter(":checked").val() || "";  
    };
                        
    /**
     * Hide or show controls in search form by season name     
     */
    var toggleControlsBySeason = function(){
        if (season === "winter") {
            //hide elements disabled for winter
            $winterDisabledEls.hide();
            //clear all values 
            $winterDisabledEls.find("select").prop('selectedIndex',0);
            $winterDisabledEls.find("input").val("");
            var selectit = $winterDisabledEls.find("select").data("selectBox-selectBoxIt");
            if (typeof selectit !== 'undefined') selectit.refresh();            
        } else {
            $winterDisabledEls.show();                                                                
        }        
    };
    
    //Init form 
    season = getSeason();
    toggleControlsBySeason();
    
    //React to season change            
    $seasonInputs.on("ifChanged", function(e){
        season = getSeason();    
        toggleControlsBySeason();
        if (season === "winter") {
            $searchForm.addClass("winter");
        } else {
            $searchForm.removeClass("winter");
        }
    });                        
}

/**
 * Apply jQuery UI Datepicker on search form inputs (inputs inside .date wrapper)
 */
function initSFDatepicker(){
    var $searchForm = $('.search-tour');
    var $dateFrom = $searchForm.find(".date input").eq(0);
    var $dateTo = $searchForm.find(".date input").eq(1);
      
    /* Date From */   
    $dateFrom.datepicker({
        dateFormat: "dd.mm.yy",        
        minDate:0,    
        defaultDate: "+1w",
        onClose: function( selectedDate ) {        
          if (selectedDate !== "" && selectedDate !== "Od:" && selectedDate !== "From:") {
            console.log(selectedDate);
            $dateTo.datepicker( "option", "minDate", selectedDate );
          }        
        }
    });

    /* Date To */
    $dateTo.datepicker({
        dateFormat: "dd.mm.yy",
        defaultDate: "+1w",
        minDate:0,    
        onClose: function( selectedDate ) {
          if (selectedDate !== "" && selectedDate !== "Do:" && selectedDate !== "To:") {
            console.log(selectedDate);
            $dateFrom.datepicker( "option", "maxDate", selectedDate );
          }
        }
    });    

}

// Returns the index of the value if it exists, or undefined if not
Object.defineProperty(Object.prototype, "keyOf", { 
    value: function(value) {
        for (var key in this) if (this[key] == value) return key;
        return undefined;
    }
});

/**
 * Star rating with hover effects 
 */
  function initStarRating() {	
    
    //Map number of stars to FacilityCategoryID (key presents star count, value is array containing values of facilitycategoryid)
    var starsToCategoryMapping = {0:[1078],1:[999], 2: [1076,399], 2.5: [1075,625], 3: [1073,395], 3.5: [1072,626], 4: [1074,397], 4.5: [1071,627], 5: [1077,541]};
    //Search form rating
    var $ratingContainer = $(".search-tour .rating");
    var $facilityCategoryIDInput = $ratingContainer.find('#facility-category-id').find("input");
    
    // Star rating icon - after click, mark selected stars with special class
    $('.star-pol').click(function(event) {
        var $starContainer = $(this).closest(".stars-wrap");
        $starContainer.find(".star-pol").removeClass('star-pol-active2');
        var $target = $(event.target);
        $target.parent().addClass('star-pol-active2');
        $target.parent().prevAll().addClass('star-pol-active2');
    });
    
    //temporarily highlight stars when user hover them
    $('.star-pol a').hover(function(event) {
      var $target = $(event.target);
      $target.parent().addClass('star-pol-active');
      $target.parent().prevAll().addClass('star-pol-active');           
    },
    function() {
        //remove temporarily highlight
        var $starContainer = $(this).closest(".stars-wrap");
        $starContainer.find('.star-pol').removeClass('star-pol-active');         
    });
    
    
    /**
     * Null facility category input
     *  */               
    var resetFacilityCategory = function () {
     $facilityCategoryIDInput.val("");        
    };
    
   // Build FacilityCategoryID param by min and max star selection
   $('.star-pol').click(function(e) {      	
     resetFacilityCategory();                  	
     var $starRatings = $ratingContainer.find(".stars-wrap");
     var minStars = $starRatings.eq(0).find(".star-pol-active2").length || 0;
     var maxStars = $starRatings.eq(1).find(".star-pol-active2").length || 5;
     var min = (minStars < maxStars) ? minStars : maxStars;
     var max = (minStars < maxStars) ? maxStars : minStars;                      
     //console.log("Min:" + minStars + ", Max: " + maxStars);                 
     //console.log("-----------");
     var facilityCategoryIDParamValues = [];
     //map stars to parameter value
     for (var key in starsToCategoryMapping) {         
         if (starsToCategoryMapping.hasOwnProperty(key)) {
             if (key >= min && key <= max) {
                facilityCategoryIDParamValues.push(starsToCategoryMapping[key].join("-"));    
             }                           
         }
     }     
     $facilityCategoryIDInput.val(facilityCategoryIDParamValues.join("-"));                              
      
    });
    
    //Set stars by parameter FacilityCategoryID
    if ($facilityCategoryIDInput.length && $facilityCategoryIDInput.val() !== "") {        
        var categories = $facilityCategoryIDInput.val().split("-");
        var starIndexes = [];        
        for (var index = 0; index < categories.length; index++) {
            var category = parseInt(categories[index]);
            for (var key in starsToCategoryMapping) {
              var starArray = starsToCategoryMapping[key];                            
              if (starArray.indexOf(category) > -1) {
                  var starNumber = parseInt(key);
                  if (starIndexes.indexOf(starNumber) === -1) starIndexes.push(starNumber);
              }      
            }           
        }
        
        var min = Math.min.apply(null, starIndexes);
        var max = Math.max.apply(null, starIndexes);
        //console.log("Min:" + min + "- Max:" +  max);
        var $starRatings = $ratingContainer.find(".stars-wrap");                          
        $starRatings.eq(0).find(".star-pol").eq(min-1).addClass("star-pol-active2").prevAll().addClass('star-pol-active2');
        $starRatings.eq(1).find(".star-pol").eq(max-1).addClass("star-pol-active2").prevAll().addClass('star-pol-active2');                 
    }        
                             
  } // konec fce initStarRating
  
 /**
  * Style select elements
  */
  function initSelects(){
    $("select").selectBoxIt();    
  }   

/**
 * Price Slider
 */
function initPriceSlider(){
            
  //Get Min/Max from DB
  var minPriceFromDB = parseInt($('#price-from-val').val());
  var maxPriceFromDB  = parseInt($('#price-to-val').val());            
  //console.log("minPriceFromDB: " + minPriceFromDB);
  //console.log("maxPriceFromDB: " + maxPriceFromDB);

  //Get Real Min/Max from form
  var userMinPrice = parseInt($('#price_from').val()); 
  var userMaxPrice = parseInt($('#price_to').val());
  //console.log("userMinPrice: " + userMinPrice);
  //console.log("userMaxPrice: " + userMaxPrice);
  
  //Array of values for slider handlers 
  var priceValues = [];
  
  //Set Values for Price Slider
  //Set price from handle position  
  if (!isNaN(userMinPrice)) {
    priceValues[0] = userMinPrice; //First try set user price    
  } else if (!isNaN(minPriceFromDB)) {
    priceValues[0] = minPriceFromDB; //Then min from db     
  } else {
    priceValues[0] = 0; //last resort - set 0
  }        
  
  //Set Price To position
  if (!isNaN(userMaxPrice)) {
    priceValues[1] = userMaxPrice; //First try set user price    
  } else if (!isNaN(maxPriceFromDB)) {
    priceValues[1] = maxPriceFromDB; //Then min from db     
  } else {
    priceValues[1] = 100000; //last resort - set 100.000
  }           
  
  //console.log("PriceValues: " + priceValues);
  
  //Show selected price range to user    
  $('#visible_price-from').text(priceValues[0] + ' ');
  $('#visible_price-to').text(priceValues[1] + ' ');    
               
  //Init jQuery UI Slider
  $( "#slider-range" ).slider({
    range: true,
    min: !isNaN(minPriceFromDB)? minPriceFromDB: 0,
    max: !isNaN(maxPriceFromDB)? maxPriceFromDB: 100000,
    step: 5,
    values: priceValues,
    slide: function(event, ui) {

      //Set real form elements      
      $('#price_from').val(ui.values[0]);
      $('#price_to').val(ui.values[1]);
      
      //Set Visual elements for user
      $('#visible_price-from').text(ui.values[0] + ' ');
      $('#visible_price-to').text(ui.values[1] + ' ');             
    }
  });      
  
}//end of price slider init  


  $(document).ready(function() {
      
        $('.set-btn-class input').addClass('wpcf7-form-control wpcf7-submit btn');
        
        
      }); // konec doc rdy
      






$(document).ready(onLoad());

