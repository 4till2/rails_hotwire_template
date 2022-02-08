require "test_helper"

class RecordTest < ActiveSupport::TestCase
  test 'create record' do
    assert Record.create!(account: accounts(:one), creator: users(:one), title: 'Record Title', subtitle: 'Record SubTitle', description: 'Record Description', recordable: links(:one))
  end

  test 'invalid record - missing recordable ' do
    assert_raises(ActiveRecord::RecordInvalid, 'account missing') do
      Record.create!(account: accounts(:one), creator: users(:one), title: 'Record Title', subtitle: 'Record SubTitle', description: 'Record Description')
    end
  end
end
