$(document).ready(function(){
  setShareEvent(".facebook a", "facebook", $(".facebook").href);
  setShareEvent(".twitter a", "twitter", $(".twitter").href);
  setShareEvent(".google a", "google", $(".google").href);
  setShareEvent(".hatena a", "hatena", $(".hatena").href);
  setShareEvent(".line a", "line", $(".line").href);
});

/**
 *  シェアボタン押下時にGoogleアナリティクスへイベントを送信する
 *  @param selector イベントを付与するセレクタ
 *  @param snsName SNSの名前（Googleアナリティクス上の表示に使われる）
 *  @param shareUrl シェア対象のURL（Googleアナリティクス上の表示に使われる）
 */
function setShareEvent(selector, snsName, shareUrl) {
  $(selector).on('click', function(e){
    var current = $(this);
    //　*** Googleアナリティクスにイベント送らないなら、以下のコードは不要 ***
    // 'share'の文字列は任意に変えてもよい（Googleアナリティクス上の表示文字列として使われる）
    // 'nonInteraction' : 1にしないと、直帰率がおかしくなる（イベント発行したユーザーは直帰扱いでなくなる）ので注意
    ga('send', 'social', snsName, 'share', shareUrl, {
      'nonInteraction': 1
    });
    // *** Googleアナリティクス送信ここまで ****

    // このあたりは適当に書き換えて下さい
    window.open(current.prop("href"), 'subwin','width=600, height=500, resizable=yes, scrollbars=yes"');
    e.stopPropagation();
    return false;
  }); 
}
;
