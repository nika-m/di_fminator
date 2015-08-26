require 'test_helper'

class TraxtersControllerTest < ActionController::TestCase
  setup do
    @traxter = traxters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:traxters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create traxter" do
    assert_difference('Traxter.count') do
      post :create, traxter: { artist: @traxter.artist, song: @traxter.song, track: @traxter.track }
    end

    assert_redirected_to traxter_path(assigns(:traxter))
  end

  test "should show traxter" do
    get :show, id: @traxter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @traxter
    assert_response :success
  end

  test "should update traxter" do
    patch :update, id: @traxter, traxter: { artist: @traxter.artist, song: @traxter.song, track: @traxter.track }
    assert_redirected_to traxter_path(assigns(:traxter))
  end

  test "should destroy traxter" do
    assert_difference('Traxter.count', -1) do
      delete :destroy, id: @traxter
    end

    assert_redirected_to traxters_path
  end
end
