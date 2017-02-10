/* global jQuery */
var searchFromFilterForm = false;
var sortOrder = 'asc';

jQuery(document).ready(function($){

  $('.home-slider').flexslider({
    controlNav: false,
    slideshow: false
  });

  $("select").selectBoxIt();

  $('input[type="radio"], input[type="checkbox"]').iCheck({
    checkboxClass: 'icheckbox_minimal',
    radioClass: 'iradio_minimal',
    increaseArea: '0%' // optional
  });

  $('#carousel').flexslider({
    animation: "slide",
    controlNav: false,
    animationLoop: false,
    slideshow: false,
    itemWidth: 78,
    itemMargin: 5,
    asNavFor: '#slider'
  });

  $('#slider').flexslider({
    animation: "slide",
    controlNav: false,
    directionNav: false,
    animationLoop: false,
    slideshow: false,
    sync: "#carousel"
  });

  $( "#tabs" ).tabs();

  $(".fancybox").fancybox({
    maxWidth    : 800,
    fitToView   : false,
    width       : '70%',
    height      : '100%',
    autoSize    : false,
    closeClick  : false,
    openEffect  : 'none',
    closeEffect : 'none'
  });
});


function selectCategory(categoryId)
{
  jQuery('.filter-block a').removeClass('current');
  jQuery('.category-'+categoryId).addClass('current');
  // jQuery('.flexslider').html('');
  jQuery.ajax({
    type:'post',
    url:'?ajax_slider',
    data:{
      categoryId:categoryId
    },
    success:function(data)
    {

      jQuery('.flexslider').removeData("flexslider");

      jQuery('.flexslider').html(data);
      jQuery('.flexslider').flexslider({
        controlNav: false,
        slideshow: false
      });

      //            jQuery.smoothScroll({
      //                scrollTarget: '#filter-block'
      //            });

      var $container = jQuery('.flexslider');
      var $newItems = jQuery(data);



      //            $container.flexslider({
      //                controlNav: false,
      //                slideshow: false,
      //                start: function(slider){
      //                    $container.append($newItems);
      //                    slider.addSlide(".step1", 1);
      //                }
      //            });






      //            jQuery(data).appendTo('.flexslider');
      //
      //            setTimeout(function () {

      //            },500);
      //jQuery('.flexslider .slides li').css('width', jQuery('body').width());



      //
    }
  });
}


function selectChidrensCount(childrensCount)
{
  jQuery('.child-ages-select').hide();
  jQuery('.child-ages-label').hide();
  if(childrensCount == 3)
  {
    jQuery('.child_3, .child_2, .child_1').show();
    jQuery('.child-ages-label').show();
  }
  if(childrensCount == 2)
  {
    jQuery('.child_1, .child_2').show();
    jQuery('.child-ages-label').show();
  }

  if(childrensCount == 1)
  {
    jQuery('.child_1').show();
    jQuery('.child-ages-label').show();
  }
}

function ajaxSearch(params)
{
  searchFromFilterForm = true
  jQuery('.offers').html('');
  jQuery('.search-process').show();


  jQuery.ajax({
    type:'post',
    url:'/?ajaxSearch&'+params+'&order='+sortOrder,
    data:{
    lang:icl_lang,
    reviewRaitingSteps:reviewRaitingSteps
  },
              //cache: true,
              dataType: 'json',
              success:function(json)
  {
    jQuery('.param-wrap').show().html(json.params);
    jQuery("div#infinitescroll").infinitescroll('destroy');
    jQuery('#found-post-count').html(json.post_count)
    if(json.post_count>0)
    {
      var html = parseJsonHotels(json.post_data)
      jQuery('.search-process').css('display','none');
      setTimeout(function(){
        jQuery('.offers').html(html);
        var pagesCount = json.pagesCount;
        var paginate = '';
        if(pagesCount>1)
        {
          for(var i=1;i<pagesCount;i++)
          {
            paginate =+'<a class="next" href="?currPage='+i+'">'+i+'</a>';
          }
          paginate =+'<a class="next" href="?currPage=2"></a>'
        }
        jQuery('.paginate').html(paginate);
        jQuery('div#infinitescroll').infinitescroll({
          state: {
            isDestroyed: false,
            isDone: false,
            isDuringAjax : false
          }
        }).infinitescroll('bind');
        startInfinitescroll(pagesCount);
      },1000)
    }
    else
    {
      jQuery('.offers').html('<p>'+nothingFound+'</p>');
    }


  }
})
}


function sortResult(sort)
{
  sortOrder = sort;
  jQuery('.sort-block a').removeClass('current');
  jQuery('.'+sort).addClass('current');


  if(searchFromFilterForm)
  {
    var url = '/?ajaxSearch&'+jQuery('#sidebar-search-form').serialize()+'&order='+sort;
  }
  else
  {
    var url = '/?ajaxSearch&'+searchParams+'&order='+sort;
  }
  jQuery('.offers').html('');
  jQuery('.search-process').show();
  jQuery.ajax({
    type:'post',
    url:url,
    data:{
      lang:icl_lang,
      reviewRaitingSteps:reviewRaitingSteps
    },
    // cache: true,
    dataType: 'json',
    success:function(json)
    {
      jQuery("div#infinitescroll").infinitescroll('destroy');
      jQuery('#found-post-count').html(json.post_count)
      if(json.post_count>0)
      {
        var html = parseJsonHotels(json.post_data)
        jQuery('.search-process').css('display','none');
        setTimeout(function(){
          jQuery('.offers').html('').html(html);
          var pagesCount = json.pagesCount;
          var paginate = '';
          if(pagesCount>1)
          {
            for(var i=1;i<pagesCount;i++)
            {
              paginate =+'<a class="next" href="?currPage='+i+'">'+i+'</a>';
            }
            paginate =+'<a class="next" href="?currPage=2"></a>'
          }


          jQuery('.paginate').html(paginate);
          //jQuery("div#infinitescroll").infinitescroll("destroy").infinitescroll('bind');
          jQuery('div#infinitescroll').infinitescroll({
            state: {
              isDestroyed: false,
              isDone: false,
              isDuringAjax : false
            }
          }).infinitescroll('bind');
          startInfinitescroll(pagesCount);
        },1000)



      }
      else
      {
        jQuery('.offers').html('<p>'+nothingFound+'</p>');
      }

    }
  })
}


function parseJsonHotels(data)
{
  var html = '';

  for(var i=0;i<data.length;i++)
  {
    // console.log(data[i].reviewsRaiting);

    html=html+ '<div class="item">';
    if(data[i].best_seller){
      html=html+ '<div class="bestseller"></div>';
    }

    html=html+  '<div class="top">'+
      '<a href="'+data[i].permalink+'"><span>'+
        '<img src="'+data[i].post_thumbnail+'" alt=""></span>'+
          '</a>'+
            '</div>'+
              '<div class="mid">'+
                '<h2><a href="'+data[i].permalink+'">'+ data[i].post_title +'</a></h2>'+
                  '<p class="address">'+data[i].address+', '+data[i].city+'</p>'+
                    '<div class="rating-block stars-'+data[i].stars+'">&nbsp;</div>'+
                      '</div>'+
                        '<p class="price price-ai"> <span class="discount">';

    if (data[i].discont!=''){
      html=html+ data[i].discont+' %';
    }

    html=html+   '</span>'+
      '<span class="ai">od '+data[i].price_from+' Kč</span>'+
        '</p>';

    html=html+'<div class="bot">'
    +data[i].reviewsRaiting +
      '<p class="reviews">'+based_on+' <span>'+data[i].reviews+' '+reviews+'</span></p>'+
        '<a class="btn btn-red" href="'+data[i].permalink+'">'+moreDetails+'</a>'+
          '</div>'+
            '</div>';
  }
  return html
}


function emailNewsletter()
{

  var news_email = jQuery('#news_emailwidget').val();
  var data = {
    news_email:news_email,
    news_action:1
  };

  jQuery.ajax({
    type:'post',
    url:'/?addNewsletter',
    data:data,

    success:function(data)
    {
      jQuery('#news_returnwidget').html(data).show();
    }
  })
  return false;
}


var openMap = false;
function loadMap() {

  if(openMap) return;

  var latlng = new google.maps.LatLng(lat, lng);
  zoom = (zoom) ? parseInt(zoom) : 9;

  // map Options
  var myOptions = {
    zoom: zoom,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map"), myOptions);
  var marker = new google.maps.Marker({
    position: latlng,
    map: map
  });
  openMap = true;
}


function getCategoryDestinations(countryId)
{
  if(countryId=='')
  {
    jQuery('#destination-select').html('<option value="">'+destination+'</option>');


    jQuery('#destination-select').selectBoxIt('refresh');

  }
  else
  {
    jQuery.ajax({
      type:'post',
      url:'/?getDestinations',
      data:{
        countryId:countryId
      },
      dataType: 'json',
      success:function(json)
      {
        var html = '';
        for(var i=0;i<json.length;i++)
        {
          html = html+'<option value="'+json[i].value+'">'+json[i].text+'</option>'
        }
        jQuery('#destination-select').html(html);
        jQuery('#destination-select').selectBoxIt({
          populate:html
        });

        jQuery('#destination-select').selectBoxIt('refresh');

      }
    })
  }
}

function startInfinitescroll(pagesCount)
{
  console.log(pagesCount);
  // jQuery("div#infinitescroll").infinitescroll('bind');
  jQuery('div#infinitescroll').infinitescroll({
    navSelector  : '.paginate a',    // selector for the paged navigation
    nextSelector : '.paginate .next',  // selector for the NEXT link (to page 2)
    itemSelector: 'div#infinitescroll div.item',
    debug: true,
    loading: {
      finishedMsg: false,
      img: template_url+'/images/loading.png',
      msgText:'<em>Loading the next set of matches...</em>'
    },
    dataType	 	: 'html',
    maxPage: pagesCount

  });
}
