require 'test_helper'

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @property = properties(:one)
  end

  test 'should get index' do
    get properties_url
    assert_response :success
  end

  test 'should create property' do
    assert_difference('Property.count') do
      owner = User.last
      post :create,
           { property: { active: @property.active, is_approved: @property.is_approved,
                         is_available: @property.is_available, name: @property.name, owner_id: owner.id } }
    end
    assert_redirected_to properties_path(Property.last)
    assert_equal 'Property was successfully created.', flash[:notice]
  end

  test 'should show property' do
    get properties_url(@property)
    assert_response :success
  end

  test 'should update property' do
    patch properties_url(@property),
          params: { property: { active: @property.active, is_approved: @property.is_approved,
                                is_available: @property.is_available, name: @property.name } }
    assert_redirected_to properties_url(@property)
  end

  test 'should destroy property' do
    assert_difference('Property.count', -1) do
      delete properties_url(@property)
    end

    assert_redirected_to properties_url
  end

  test 'should add owner' do
    assert_difference('Property.count') do
      owner = User.last
      post :create,
           { property: { is_active: @property.is_active, is_approved: @property.is_approved,
                         is_available: @property.is_available, name: @property.name, owner_id: owner.id } }
    end
    assert_redirected_to properties_path(Property.last)
    assert_equal 'Property was successfully created.', flash[:notice]
  end

  test 'should update approval status' do
    patch properties_url(@property),
          params: { property: { is_approved: @property.is_approved } }
    assert_redirected_to properties_url(@property)
  end

  test 'should update availability' do
    patch properties_url(@property),
          params: { property: { is_available: @property.is_available } }
    assert_redirected_to properties_url(@property)
  end

  test 'should deactivate property' do
    patch properties_url(@property),
          params: { property: { is_active: 0 } }
    assert_redirected_to properties_url(@property)
  end
end
