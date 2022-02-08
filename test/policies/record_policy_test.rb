require 'test_helper'

class ProfilePolicyTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_user_with_account
    @account = @owner.account
    @record = Record.create!(account: @account, creator: @owner, title: 'Record Title', subtitle: 'Record SubTitle', description: 'Record Description', recordable: links(:one))
    @guest = create_user_with_account
    @stranger = create_user_with_account
    Subscription.create! subscriber: @guest.account, subscribable: @record
    sign_in_as(@guest)
  end

  def test_scope
  end

  def test_show
    #private
    @record.permission = permissions(:two)
    @record.save

    get record_url(@record)
    assert_response :success

    sign_in_as(@stranger)
    get record_url(@record)
    assert_redirected_to root_path

    #public
    @record.permission = permissions(:one)
    @record.save

    get record_url(@record)
    assert_response :success
  end

  def test_create
    # no user
    sign_out_user
    post records_url, params: { record: { record: @record } }
    assert_response :redirect

    # user
    sign_in_as(@guest)
    assert_difference("Record.count") do
      post records_url, params: { record: { recordable_id: links(:one).id, recordable_type: 'Link', title: 'Record Title' } }
    end
    assert_redirected_to record_url(Record.last)
  end

  def test_update
    patch record_url(@record), params: { record: { record_id: @record.id, title: 'NEW Record Title' } }
    assert_redirected_to root_path

    sign_in_as(@stranger)
    patch record_url(@record), params: { record: { record_id: @record.id, title: 'NEW Record Title' } }
    assert_redirected_to root_path
  end

  def test_destroy
    assert_no_difference("Record.count") do
      delete record_url(@record)
    end

    sign_in_as(@stranger)
    assert_no_difference("Record.count") do
      delete record_url(@record)
    end
  end
end
