module Permissionable
  extend ActiveSupport::Concern

  included do
    has_one :permission, as: :permissionable, dependent: :destroy, autosave: true
  end
end
