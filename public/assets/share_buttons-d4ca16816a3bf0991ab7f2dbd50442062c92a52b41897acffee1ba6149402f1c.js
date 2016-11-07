$(document).ready(function(){
  setShareEvent(".facebook", "facebook", $(".facebook").href);
  setShareEvent(".twitter", "twitter", $(".twitter").href);
  setShareEvent(".google", "google", $(".google").href);
  setShareEvent(".hatena", "hatena", $(".hatena").href);
  setShareEvent(".line", "line", $(".line").href);
  console.info('share buttons js loaded.');
});


$(".sns_icon").on("mouseover", function(){
  console.info("mouseover!");
});
  //console.info($(".twitter_back a").href);
  // twitter_url = $(".twitter_back a").prop("href");
  // console.info(twitter_url);
  // window.open($(".twitter_back a").href, 'subwin','width=600, height=500, resizable=yes, scrollbars=yes"');


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
