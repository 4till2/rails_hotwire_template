require "test_helper"

class RecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create! email: "#{SecureRandom.alphanumeric(10)}@mail.com", password: @@pswd, password_confirmation: @@pswd, account_attributes: { nickname: SecureRandom.alphanumeric(10) }
    @record = Record.create!(account: @owner.account, creator: @owner, title: 'Record Title', subtitle: 'Record SubTitle', description: 'Record Description', recordable: links(:one))
    sign_in_as(@owner)
  end

  test "should not get index" do
    get records_url
    assert_response :redirect
  end

  test "get new" do
    get new_record_url
    assert_response :success

    sign_out_user
    get new_record_url
    assert_response :redirect
  end

  test "should create record" do
    assert_difference("Record.count") do
      post records_url, params: { record: { recordable_id: links(:one).id, recordable_type: 'Link', title: 'Record Title' } }
    end

    assert_redirected_to record_url(Record.last)
  end

  test "should show record" do
    get record_url(@record)
    assert_response :success
  end

  test "should get edit" do
    get edit_record_url(@record)
    assert_response :success
  end

  test "should update record" do
    patch record_url(@record), params: { record: { description: @record.description, subtitle: @record.subtitle, title: @record.title } }
    assert_redirected_to record_url(@record)
  end

  test "should destroy record" do
    assert_difference("Record.count", -1) do
      delete record_url(@record)
    end

    assert_redirected_to records_url
  end
end
