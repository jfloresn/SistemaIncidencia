require 'test_helper'

class UsuarioControllerTest < ActionController::TestCase
  test "should get bandeja" do
    get :bandeja
    assert_response :success
  end

end
