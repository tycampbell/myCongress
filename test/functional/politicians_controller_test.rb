require 'test_helper'

class PoliticiansControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:politicians)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create politician" do
    assert_difference('Politician.count') do
      post :create, :politician => { }
    end

    assert_redirected_to politician_path(assigns(:politician))
  end

  test "should show politician" do
    get :show, :id => politicians(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => politicians(:one).to_param
    assert_response :success
  end

  test "should update politician" do
    put :update, :id => politicians(:one).to_param, :politician => { }
    assert_redirected_to politician_path(assigns(:politician))
  end

  test "should destroy politician" do
    assert_difference('Politician.count', -1) do
      delete :destroy, :id => politicians(:one).to_param
    end

    assert_redirected_to politicians_path
  end
end
