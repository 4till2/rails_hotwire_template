require 'test_helper'

class ProfilePolicyTest < ActionDispatch::IntegrationTest
  setup do
    @owner = create_user_with_account
    @account = @owner.account
    @profile = @account.profile
    @guest = create_user_with_account
    @stranger = create_user_with_account
    Subscription.create! subscriber: @guest.account, subscribable: @account
    sign_in_as(@guest)
  end

  def test_scope
  end

  def test_show
    #private
    @account.permission = permissions(:two)
    @account.save

    get profile_url(@profile)
    assert_response :success

    sign_in_as(@stranger)
    get profile_url(@profile)
    assert_redirected_to root_path

    #public
    sign_out_user
    @account.permission = permissions(:one)
    @account.save

    get profile_url(@profile)
    assert_response :success

    sign_in_as(@guest)
    get profile_url(@profile)
    assert_response :success

    sign_in_as(@stranger)
    get profile_url(@profile)
    assert_response :success
  end

  def test_create
    # no user
    sign_out_user
    post profiles_url, params: { profile: { account: @account } }
    assert_response :redirect

    # user
    sign_in_as(@guest)
    assert_difference("Profile.count") do
      post profiles_url, params: { profile: { account: @guest.account } }
    end
    assert_redirected_to profile_url(Profile.last)
  end

  def test_update
    patch profile_url(@profile), params: { profile: { profile_id: @profile.id, title: 'Julies' } }
    assert_redirected_to root_path

    sign_in_as(@stranger)
    patch profile_url(@profile), params: { profile: { profile_id: @profile.id, title: 'Julies' } }
    assert_redirected_to root_path
  end

  def test_destroy
    assert_no_difference("Account.count") do
      delete profile_url(@profile)
    end

    sign_in_as(@stranger)
    assert_no_difference("Account.count") do
      delete profile_url(@profile)
    end
  end
end
