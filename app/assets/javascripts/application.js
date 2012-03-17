// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

// prepare the form when the DOM is ready 
$(document).ready(function() { 

  // Setup the ajax indicator
  $('.form-actions').append("<div id='ajaxBusy' class='alert alert-info'><p>Plase Wait ......<img src='/loading.gif'>  If your raw data file is too big , it may take some time to deal with</p></div>");

  $('#ajaxBusy').css({
    display:"none",
    margin:"30px",
    paddingLeft:"0px",
    paddingRight:"0px",
    paddingTop:"0px",
    paddingBottom:"0px",
    width:"auto"
  });
});

$("#create").bind("click", function(){ 
  $('#ajaxBusy').show(); 
})
