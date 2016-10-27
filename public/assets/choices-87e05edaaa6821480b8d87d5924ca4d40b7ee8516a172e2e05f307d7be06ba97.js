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
  
  all_checked = true;
  $('input[name="s_ids[]"]').each(function(){
    if(!$(this).prop('checked')){
      all_checked = false;
      return false;
    }
  });
  
  $('input[name="s_ids[]"]').each(function(){
    $(this).prop('checked', !all_checked);
  });

});

$('.dropdown-menu a').on('click', function() {
  $(this).parent().toggleClass('open');
  var checkbox = $(this).find('input')
  checkbox.prop("checked", !checkbox.prop("checked"));
  return false;
});
