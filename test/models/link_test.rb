require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test 'create link' do
    assert Link.create! url: 'https://validurl.com'
  end

  test 'invalid link - bad url' do
    assert_raises(ActiveRecord::RecordInvalid, 'url invalid') do
      Link.create! url: 'badlink.com'
    end
  end
end

