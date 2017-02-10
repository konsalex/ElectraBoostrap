/* 
  detailZ.js (11348)
  global jQuery 
  
*/
var electra = window.electra || {};

 /* Electra Namespace */
  (function( electra, $, undefined ) {
                 
     	/* Construct Images List
         * @param images : list of images (image is object with two properties - href and title)
         * @param opts : object with options for image formats
         */
        function _constructImagesList(images, opts){                          
          var defaults = {
            "bigFormatID": 24,						/* Image format for big photo */
            "smallFormatID": 23, 					/* Image format for thumbnails */
            "formatIDparametrName" :"FormatID", 	/* Format Parametr name, will be instered into url */
            "formatIDPlaceholder": /Original=True/g, /* Placeholder in image url which will be replaced with right format */
            "format": "small"
			};
          var options = $.extend({}, defaults, opts);
                              
          var imagesList = "<ul class='slides'>";        
  
          $.each(images, function(key, value) {    	  
            imagesList += "<li><img src='" + value.href + "' title='" + value.title + "' /></li>";
          });
          
          imagesList += "</ul>";
          
          if (options.format === "small") {
            imagesList = imagesList.replace(options.formatIDPlaceholder,options.formatIDparametrName + "=" + options.smallFormatID);
          } else {
            imagesList = imagesList.replace(options.formatIDPlaceholder,options.formatIDparametrName + "=" + options.bigFormatID);
          }

          return imagesList;
        }
        
        /* Grab all images from Gallery Object (DownloadList) 
         * @param sourceImagesContainer: jquery object with image links inside
         */
        function _grabImages($sourceImagesContainer){
          var images = []; /* Hold all images like objects with two atributes - href and title */                       
          $sourceImagesContainer.find(".item").each(function(e){
            var $imageItem = $(this).find("a");
            var imageHref = $imageItem.attr("href");
            var imageTitle = $imageItem.attr("title");
            images.push({
              "title" : imageTitle,
              "href" : imageHref
            });        
          });
          
          return images;
		}
    
    /*
     * Init Gallery on product page
     */
      electra.initGallery = function(){
       var images = _grabImages($("#data-images"));        
       var galleryHtml = "<div class='slider-block'><div id='slider' class='flexslider hotel-slider'></div><div id='carousel' class='flexslider'></div></div>";
            
        //construct lists for gallery
        $("#data-images").after(galleryHtml);
        $(".slider-block").find("#slider").append(_constructImagesList(images, {"format": "big"}));
        $(".slider-block").find("#carousel").append(_constructImagesList(images, {"format": "small"}));
	}; 
          
      
      
     /* User can select room in terms table, coresponding price and reservation button is shown
     *
     */    	
    electra.initRoomTypeSelector = function(){
	  var $termsTable = $(".terms-table");
	  var changeRoomText = $termsTable.data("localizedchangeroomtext");
      var termsTableSelectors = {
        "room" : ".terms-table__room-type", 		//all room types
        "price" : ".terms-table__price", 			//prices to room types
        "button" : ".terms-table__reservation-btn", //buttons for selected room type
        "changeRoom" : ".terms-table__change-link",	//class for generate link
        "popup" : ".terms-table__room-popup"		//class of generated popup
      };
      
      //Changle room type link template
      var changeTypeLinkHTML = "<a class='" + termsTableSelectors.changeRoom.split('.').join("") + "' href='#change-type'>" + changeRoomText + "</a>";
                  
      //Construct link for changing room type
      $termsTable.find("tr").each(function(){
        var $tr = $(this);
        
        //only one room type -> continue on next row
        if ($tr.find(termsTableSelectors.room).length <= 1) {          
          return true;
        } 
        
		//construct link to change room type
        $tr.find(termsTableSelectors.room).closest("td").append(changeTypeLinkHTML);                         
	  });      
      
      //Init romm type selection popup
      $(termsTableSelectors.changeRoom).on("click", function(e){
        e.preventDefault();
        var $td = $(this).closest("td"); 
        
        $termsTable.find("td").not($td).find(termsTableSelectors.popup).hide(); //hide other room popups
        
        //construct popup, or use the existing one
        if ($td.find(termsTableSelectors.popup).length > 0) {         
          $td.find(termsTableSelectors.popup).remove();
        }
        
        //popup need to be created
        $td.append(_constructRoomTypePopup($td)).find(termsTableSelectors.popup).toggle();        	
          
        //user selects room type
        $td.find(termsTableSelectors.popup + " li").on("click", function(e){
			var roomTypeID = $(this).data("unitplantypeid");
            var $currentTr = $(this).closest("tr");
            //hide all
            $currentTr.find(termsTableSelectors.room).hide();
            $currentTr.find(termsTableSelectors.price).hide();
            $currentTr.find(termsTableSelectors.button).hide();
            //show selected            
            $currentTr.find("[data-unitplantypeid=" + roomTypeID +"]").fadeIn();
            $termsTable.find("tr.changed").removeClass("changed");
            $currentTr.addClass("changed");
            //close popup            
            $(this).closest(termsTableSelectors.popup).toggle();
		});
                        
	  });  
                
    };                         
    
    /* Create room type popup */
     function _constructRoomTypePopup($td){            
       var roomTypes = $td.find(".terms-table__room-type").not(":visible");            
       var popupHtml = "<div class='terms-table__room-popup' style='display: none;'><div class='room-popup'><ul>";            
       roomTypes.each(function(){              
         var roomID = $(this).data("unitplantypeid");
         popupHtml += "<li data-unitplantypeid='" + roomID + "'>";
         popupHtml += "<span class='room-popup__text'>" + $(this).text() + "</span>";
         popupHtml += "<span class='room-popup__price'>" + $(this).closest("tr").find(".terms-table__price[data-unitplantypeid=" + roomID + "]").text() + "</span>";
         popupHtml += "</li>";                     
       });       	
       popupHtml += "</ul></div></div>";
       return popupHtml;              
     } 
    
      
  }( window.electra = window.electra || {}, jQuery ));             
          
  electra.initGallery();  
