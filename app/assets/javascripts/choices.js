var enable_search = function(){
  if ($('input[name="s_ids[]"]:checked').length === 0 ||
      $('input[name="p_ids[]"]:checked').length === 0){
    $("#search_btn").prop("disabled", true);
  }else{
    $("#search_btn").prop("disabled", false);
  }
  setTimeout(enable_search, 200)
};

// 検索ボタンの有効／無効化
$(document).ready(function(){
  enable_search();
});

// チェックボックスの選択処理
// イベントバブリングを防止してチェック属性が正常に切り替わるようにする
$('input[name="s_ids[]"]').on('click', function(e) {
  e.stopPropagation();
});
$('input[name="p_ids[]"]').on('click', function(e) {
  e.stopPropagation();
});

// 全選択／全解除処理
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
