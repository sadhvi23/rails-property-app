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
      post :create,
           { property: { active: @property.active, approval_status: @property.approval_status,
                         availability_status: @property.availability_status, name: @property.name } }
    end
    assert_redirected_to properties_path(Property.last)
    assert_equal 'Property was successfully created.', flash[:notice]
  end

  test 'should show property' do
    get property_url(@property)
    assert_response :success
  end

  test 'should update property' do
    patch property_url(@property),
          params: { property: { active: @property.active, approval_status: @property.approval_status,
                                availability_status: @property.availability_status, name: @property.name } }
    assert_redirected_to property_url(@property)
  end

  test 'should destroy property' do
    assert_difference('Property.count', -1) do
      delete property_url(@property)
    end

    assert_redirected_to properties_url
  end
end
