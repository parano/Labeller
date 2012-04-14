require 'test_helper'

class KnowlegeBaseControllerTest < ActionController::TestCase
  test "should get import" do
    get :import
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

end
