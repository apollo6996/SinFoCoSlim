function checkDB () {
  $.ajax({
    url:  '/eye_testers',
    type: 'GET',
    cache: false,
    success: function () {
      $('#testers').load('/eye_testers');
    }
  });
  
};

function formRestore () {
  $.ajax({
    type: 'GET',
    cache: false,
    success: function () {
      $(thisModal).load('/getsignupform');
    }
  });
};

function prevent (form) {
  $(form).submit(function(event) {
  event.preventDefault()
  }); // End of submit event
};

function FormAJAX (form, modal) {
  prevent(form);
  thisModal = modal;
  var url = $(form).attr("action");
  var formData = $(form).serialize();
    $.ajax(url, {
      type :    "POST",
      data :    formData,
      success : function () {
        $(thisModal).html('<p class="flash">Спасибо! Ваша заявка принята!</p>' 
                              + '<a class="close-reveal-modal">&#215;</a>'
                              ); 
        $('#testers').load('/eye_testers');
      }, 
      complete : function () {
        setTimeout('formRestore()', 5000);
      }
    }) // End of AJAX request
};

$(document).ready(function() {





 // checkDB();
 // setInterval('checkDB()', 100000);

}); //End of Ready