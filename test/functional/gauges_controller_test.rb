require 'test_helper'

class GaugesControllerTest < ActionController::TestCase
  setup do
    @gauge = gauges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gauges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gauge" do
    assert_difference('Gauge.count') do
      post :create, gauge: { name: @gauge.name, vzt: @gauge.vzt }
    end

    assert_redirected_to gauge_path(assigns(:gauge))
  end

  test "should show gauge" do
    get :show, id: @gauge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gauge
    assert_response :success
  end

  test "should update gauge" do
    put :update, id: @gauge, gauge: { name: @gauge.name, vzt: @gauge.vzt }
    assert_redirected_to gauge_path(assigns(:gauge))
  end

  test "should destroy gauge" do
    assert_difference('Gauge.count', -1) do
      delete :destroy, id: @gauge
    end

    assert_redirected_to gauges_path
  end
end
