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
      if (thisModal == $('.div:contains("firstModal")')) {
        $(thisModal).load('/geteyetest_form');
      }
      else {
        $(thisModal).load('/getcallmeback_form');
      }
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
        $(thisModal).load('/thankyou'); 
        $('#testers').load('/eye_testers');
      }, 
      complete : function () {
        setTimeout('formRestore()', 5000);
      }
    }) // End of AJAX request
};

$(".royalSlider").royalSlider({
  imageScaleMode: 'fill',
});


            var map;

            DG.then(function () {
                map = DG.map('map', {
                    "center": [54.98, 82.89],
                    "zoom": 13
                });

                DG.marker([54.98, 82.89]).addTo(map).bindPopup('Вы кликнули по мне!');
            });


$(document).ready(function() {





 // checkDB();
 // setInterval('checkDB()', 100000);

}); //End of Ready