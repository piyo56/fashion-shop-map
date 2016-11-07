$(document).ready(function(){
  console.info('share buttons js loaded.');
});

$(".twitter_back").hover(function(){
  console.info("clicked!");
  twitter_url = $(".twitter_back a").prop("href");
  console.info(twitter_url);
  // window.open(this.href, 'subwin','width=600, height=500, resizable=yes, scrollbars=yes"');
  return false;
});

/**
 *  シェアボタン押下時にGoogleアナリティクスへイベントを送信する
 *  @param selector イベントを付与するセレクタ
 *  @param snsName SNSの名前（Googleアナリティクス上の表示に使われる）
 *  @param shareUrl シェア対象のURL（Googleアナリティクス上の表示に使われる）
 */
function setShareEvent(selector, snsName, shareUrl) {
  $(selector).on('click', function(e){
    var current = this;
    //　*** Googleアナリティクスにイベント送らないなら、以下のコードは不要 ***
    // 'share'の文字列は任意に変えてもよい（Googleアナリティクス上の表示文字列として使われる）
    // 'nonInteraction' : 1にしないと、直帰率がおかしくなる（イベント発行したユーザーは直帰扱いでなくなる）ので注意
    ga('send', 'social', snsName, 'share', shareUrl, {
      'nonInteraction': 1
    });
    // *** Googleアナリティクス送信ここまで ****

    // このあたりは適当に書き換えて下さい
    window.open(current.href, '_blank', 'width=600, height=600, menubar=no, toolbar=no, scrollbars=yes');
    e.preventDefault();
  }); 
}
;
