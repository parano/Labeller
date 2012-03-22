var st = 'unknow'

if(!window.Parano){
  Parano = {};
}

Parano.Selector = {};
Parano.Selector.getSelected = function(){
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

Parano.Selector.select = function(){
  st = Parano.Selector.getSelected();
  if(st == ''){
    st = 'unknow';
  }
}

$(document).ready(function(){
  $(document).bind("mouseup", Parano.Selector.select);
  $(document).bind("mousedown", Parano.Selector.select);
  // $(document).bind.mouseup(function(){
  //   //get the id , and see if the st is a substring of text#{id}
  // });

  $(".label_word").mouseover(function(){
    var s = $(this).attr("href");
    var id = "#text" + $(this).attr("id").substring(6);

    if ($(this).text()!="undo" && $(id).text().indexOf(st) != -1){
      $(this).attr("href",s.substring(0,s.indexOf('='))+'='+st);
      if (st != "unknow"){
        $(this).text("label as :"+st);
        $(this).addClass("btn-info");
      }
    } else {
      $(this).attr("href",s.substring(0,s.indexOf('='))+'=unknow');
    }
  });
  $(".label_word").mouseout(function(){
    if ($(this).text()!="undo"){
      $(this).text("label");
    }
    $(this).removeClass("btn-info");
  });
});

