// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function() {

  //popover code
  $(function (){
    $("[data-toggle='popover']").popover();
  });

  $('body').on('click', function (e) {
      $('[data-toggle="popover"]').each(function () {
          //the 'is' for buttons that trigger popups
          //the 'has' for icons within a button that triggers a popup
          if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
              $(this).popover('hide');
          }
      });
  });

  //Scrolling calculator
  $(window).scroll(function() {
    if($(this).scrollTop() > 310 && $(this).width() > 750) {
      $('.calculator_box').addClass('sticky_calculator');
    } else {
      $('.calculator_box').removeClass('sticky_calculator');
    }
  });

  $(window).scroll(function() {
    if($(this).scrollTop() < 310) {
      $('.calculator_box').removeClass('sticky_calculator');
    }
  });

  $(window).scroll(function() {
    if($(this).width() < 750) {
      $('.calculator').removeClass('sticky_calculator');
    }
  });


});

