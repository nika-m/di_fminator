require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get resume" do
    get :resume
    assert_response :success
  end

  test "should get code" do
    get :code
    assert_response :success
  end

  test "should get sandbox" do
    get :sandbox
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
