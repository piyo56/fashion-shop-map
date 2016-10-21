enable_search = function(){
  if ($('input[name="s_ids[]"]:checked').length === 0){
    $("#search_btn").prop("disabled", true);
  }else{
    $("#search_btn").prop("disabled", false);
  }
  setTimeout(enable_search, 200)
};
$(document).ready(function(){
  enable_search();
});
$('input[name="s_ids[]"]').on('click', function(e) {
  //イベントバブリングを防止してチェック属性が正常に切り替わるようにする
  e.stopPropagation();
});
$('#select_all').on('click', function(e){
  //イベントバブリングを防止してチェック属性が正常に切り替わるようにする
  e.stopPropagation();
  
  //とりあえず全選択だけ行う
  $('input[name="s_ids[]"]').each(function(){
    $(this).prop('checked', true);
  });
});

$('.dropdown-menu a').on('click', function() {
  $(this).parent().toggleClass('open');
  var checkbox = $(this).find('input')
  checkbox.prop("checked", !checkbox.prop("checked"));
  return false;
});
