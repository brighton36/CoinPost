FactoryGirl.define do
  factory :purchase do
    quantity_purchased 1
   
    factory :ricons_purchase do 
      purchaser { FactoryGirl.singleton_user :user_ricon } 
      item { FactoryGirl.create :item, :title => 'Ricons Purchase Item' }

      factory :ricons_purchase_payment_sent do
        payment_sent_at {Time.now.utc-1800}
        item { FactoryGirl.create :item, :title => 'Ricons Purchase Payment Sent' }

        factory :ricons_purchase_item_sent do
          item_sent_at {Time.now.utc-450}
          item { FactoryGirl.create :item, :title => 'Ricons Purchase Item Sent' }

          factory :ricons_purchase_with_purchaser_feedback do
            item { FactoryGirl.create :item, :title => 'Ricons Purchase With Buyer Feedback' }
            rating_on_purchaser 1
            comment_on_purchaser "Good people- would buy from again in the future"
          end

          factory :ricons_purchase_with_seller_feedback do
            item { FactoryGirl.create :item, :title => 'Ricons Purchase With Seller Feedback' }
            rating_on_seller -1
            comment_on_seller "Pain in the ass -avoid this dude"
          end
        end
      end

      factory :ricons_purchase_item_sent_no_payment do
        item_sent_at {Time.now.utc-450}
        item { FactoryGirl.create :item, :title => 'Ricons Purchase Item Sent No Payment' }
      end
    end
    
    factory :stewies_purchase do 
      purchaser { FactoryGirl.singleton_user :user_stewie} 
      item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase Item' }

      factory :stewies_purchase_payment_sent do
        payment_sent_at {Time.now.utc-1800}
        item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase Payment Sent' }

        factory :stewies_purchase_item_sent do
          item_sent_at {Time.now.utc-450}
          item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase Item Sent' }
          
          factory :stewies_purchase_with_purchaser_feedback do
            item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase With Buyer Feedback' }
            rating_on_purchaser 1
            comment_on_purchaser "Good people- would buy from again in the future"
          end

          factory :stewies_purchase_with_seller_feedback do
            item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase With Seller Feedback' }
            rating_on_seller -1
            comment_on_seller "Pain in the ass -avoid this dude"
          end
        end
      end

      factory :stewies_purchase_item_sent_no_payment do
        item_sent_at {Time.now.utc-450}
        item { FactoryGirl.create :ricon_item, :title => 'Stewies Purchase Item Sent No Payment' }
      end

    end
  
  end
end
