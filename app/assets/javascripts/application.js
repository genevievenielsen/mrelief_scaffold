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

  //Trigger popover code
  $(function (){
    $("[data-toggle='popover']").popover();
  });

  // close pover on click
  $('body').on('click', function (e) {
      $('[data-toggle="popover"]').each(function () {
          //the 'is' for buttons that trigger popups
          //the 'has' for icons within a button that triggers a popup
          if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
              $(this).popover('hide');
          }
      });
  });

  // popover close button
  $(".popover-body").popover({
      placement: 'right',
      html: 'true',
      title : '<button type="button" id="close" class="close popover-close pull-left" onclick="$(&quot;p&quot;).popover(&quot;hide&quot;);">&times;</button>'
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


  var initCalculator = function(keySelector, screenSelector) {

    // Get all the keys from document
    var keys = document.querySelectorAll(keySelector);
    var operators = ['+', '-', 'x', '÷'];
    var decimalAdded = false;

    // Add onclick event to all the keys and perform operations
    for(var i = 0; i < keys.length; i++) {
      keys[i].onclick = function(e) {
        // Get the input and button values
        var input = document.querySelector(screenSelector);
        var inputVal = input.innerHTML;
        var btnVal = this.innerHTML;
        
        // Now, just append the key values (btnValue) to the input string and finally use javascript's eval function to get the result
        // If clear key is pressed, erase everything
        if(btnVal == 'C') {
          input.innerHTML = '';
          decimalAdded = false;
        }
        
        // If eval key is pressed, calculate and display the result
        else if(btnVal == '=') {
          var equation = inputVal;
          var lastChar = equation[equation.length - 1];
          
          // Replace all instances of x and ÷ with * and / respectively. This can be done easily using regex and the 'g' tag which will replace all instances of the matched character/substring
          equation = equation.replace(/x/g, '*').replace(/÷/g, '/');
          
          // Final thing left to do is checking the last character of the equation. If it's an operator or a decimal, remove it
          if(operators.indexOf(lastChar) > -1 || lastChar == '.')
            equation = equation.replace(/.$/, '');
          
          if(equation)
            input.innerHTML = eval(equation);
            console.log(equation);
            
          decimalAdded = false;
        }
        
        // Basic functionality of the calculator is complete. But there are some problems like 
        // 1. No two operators should be added consecutively.
        // 2. The equation shouldn't start from an operator except minus
        // 3. not more than 1 decimal should be there in a number
        
        // We'll fix these issues using some simple checks
        
        // indexOf works only in IE9+
        else if(operators.indexOf(btnVal) > -1) {
          // Operator is clicked
          // Get the last character from the equation
          var lastChar = inputVal[inputVal.length - 1];
          
          // Only add operator if input is not empty and there is no operator at the last
          if(inputVal != '' && operators.indexOf(lastChar) == -1) 
            input.innerHTML += btnVal;
          
          // Allow minus if the string is empty
          else if(inputVal == '' && btnVal == '-') 
            input.innerHTML += btnVal;
          
          // Replace the last operator (if exists) with the newly pressed operator
          if(operators.indexOf(lastChar) > -1 && inputVal.length > 1) {
            // Here, '.' matches any character while $ denotes the end of string, so anything (will be an operator in this case) at the end of string will get replaced by new operator
            input.innerHTML = inputVal.replace(/.$/, btnVal);
          }
          
          decimalAdded =false;
        }
        
        // Now only the decimal problem is left. We can solve it easily using a flag 'decimalAdded' which we'll set once the decimal is added and prevent more decimals to be added once it's set. It will be reset when an operator, eval or clear key is pressed.
        else if(btnVal == '.') {
          if(!decimalAdded) {
            input.innerHTML += btnVal;
            decimalAdded = true;
          }
        }
        
        // if any other key is pressed, just append it
        else {
          input.innerHTML += btnVal;
        }
        
        // prevent page jumps
        e.preventDefault();
      } 
    }
  };
  initCalculator('#js-calculator span', '#screen-default');
  initCalculator('#js-calculator-popover span', '#screen-popover');



});

