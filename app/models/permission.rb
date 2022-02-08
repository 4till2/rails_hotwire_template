class Permission < ApplicationRecord
  belongs_to :permissionable, polymorphic: true

  def owner
    return self if permissionable_type == 'Account'

    permissionable.account
  end

  enum scope: {
    private: 0,
    public: 1
  }, _suffix: true
end
