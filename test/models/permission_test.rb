require "test_helper"

class PermissionTest < ActiveSupport::TestCase
  test 'valid permission' do
    assert Permission.create! permissionable: accounts(:one), scope: 'public'
    assert Permission.create! permissionable: records(:one), scope: 'private'
  end

  test 'invalid permission scope' do
    assert_raises(ArgumentError, 'not a valid scope') do
      Permission.create! permissionable: records(:one), scope: 'hacked'
    end
  end

end
