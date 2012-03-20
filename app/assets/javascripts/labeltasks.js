var st = 'unknow'

if(!window.Kolich){
  Kolich = {};
}

Kolich.Selector = {};
Kolich.Selector.getSelected = function(){
  var t = '';
  if(window.getSelection){
    t = window.getSelection();
  }else if(document.getSelection){
    t = document.getSelection();
  }else if(document.selection){
    t = document.selection.createRange().text;
  }
  return t;
}

Kolich.Selector.select = function(){
  st = Kolich.Selector.getSelected();
  if(st == ''){
    st = 'unknow';
  }
}

$(document).ready(function(){
  $(document).bind("mouseup", Kolich.Selector.select);
  $(document).bind("mousedown", Kolich.Selector.select);
  $(".label_word").mouseover(function(){
    var s = $(this).attr("href");
    $(this).attr("href",s.substring(0,s.indexOf('='))+'='+st);
  });
});

