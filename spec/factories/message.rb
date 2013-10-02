FactoryGirl.define do
  factory :message do
    sender { FactoryGirl.singleton_user(:user_stewie) } 
    body 'Message Body'
    subject 'Test Message'
    conversation_id  nil
    recipients { FactoryGirl.singleton_user(:user_ricon) } 
  end
end
