require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  test 'valid subscription' do
    assert Subscription.create! subscriber: accounts(:two), subscribable: accounts(:one)
    assert Subscription.create! subscriber: accounts(:two), subscribable: records(:one)
  end

  test 'invalid subscription to self' do
    assert_raises(ActiveRecord::RecordInvalid, 'Subscriber must be other than self') do
      Subscription.create! subscriber: accounts(:one), subscribable: accounts(:one)
    end

    assert_raises(ActiveRecord::RecordInvalid, 'Subscriber must be other than self') do
      Subscription.create! subscriber: accounts(:one), subscribable: records(:one)
    end
  end

end
