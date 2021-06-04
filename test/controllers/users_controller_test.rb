require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test "should create user" do
    role = Role.where(name: "admin")
    user = User.create(email: 'test@user.com', name: 'Test User', role: role.id)
    get users_path
    assert_redirected_to users_path(assigns(user))
  end

  test 'should signup user' do
    assert_difference('User.count') do
      post :create, { is_active: @user.is_active, email: @user.email, name: @user.name, encrypted_password: @user.encrypted_password,
                      role_id: @user.role_id }
    end
    assert_redirected_to users_signup_path(User.last)
  end

  test 'should update user' do
    patch user_url(@user),
          params: { user: { is_active: @user.is_active, email: @user.email, name: @user.name } }
    assert_redirected_to user_path(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
    assert_redirected_to users_path
  end

  test 'should login user' do
    assert_difference('User.count') do
      post '/users/login', params: { email: @user.email, password: @user.encrypted_password }

    end
    assert_redirected_to users_login_url(User.last)
  end

  test 'should logout user' do
    patch user_url(@user), {}
    assert_redirected_to users_login_url
  end

  test 'should deactivate user' do
    patch user_url(@user),
          params: { user: { is_active: 0 } }
    assert_redirected_to user_url(@user)
  end
end
