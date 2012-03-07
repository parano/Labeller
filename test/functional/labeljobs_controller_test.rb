require 'test_helper'

class LabeljobsControllerTest < ActionController::TestCase
  setup do
    @labeljob = labeljobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:labeljobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create labeljob" do
    assert_difference('Labeljob.count') do
      post :create, labeljob: @labeljob.attributes
    end

    assert_redirected_to labeljob_path(assigns(:labeljob))
  end

  test "should show labeljob" do
    get :show, id: @labeljob
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @labeljob
    assert_response :success
  end

  test "should update labeljob" do
    put :update, id: @labeljob, labeljob: @labeljob.attributes
    assert_redirected_to labeljob_path(assigns(:labeljob))
  end

  test "should destroy labeljob" do
    assert_difference('Labeljob.count', -1) do
      delete :destroy, id: @labeljob
    end

    assert_redirected_to labeljobs_path
  end
end
