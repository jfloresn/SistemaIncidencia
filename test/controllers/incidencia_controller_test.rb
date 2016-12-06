require 'test_helper'

class IncidenciaControllerTest < ActionController::TestCase
  test "should get bandeja" do
    get :bandeja
    assert_response :success
  end

end
