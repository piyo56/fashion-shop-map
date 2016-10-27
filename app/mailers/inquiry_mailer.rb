class InquiryMailer < ActionMailer::Base
  default from: "piyo56.net@gmail.com"   # 送信元アドレス
  default to:   "dhisign.chrome@gmail.com"     # 送信先アドレス
 
  def received_email(inquiry)
    @inquiry = inquiry
    mail(:subject => 'お問い合わせを承りました')
  end
end
