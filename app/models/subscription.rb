class Subscription < ApplicationRecord
  belongs_to :subscribable, polymorphic: true
  belongs_to :subscriber, class_name: 'Account'

  validates_comparison_of :subscriber, other_than: :owner, message: 'mustn\'t subscribe to thy own self'

  def owner
    return subscribable if subscribable_type == 'Account'

    subscribable.account
  end
end
