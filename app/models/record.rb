RECORDABLE_TYPES = %w[Link].freeze

class Record < ApplicationRecord
  include Permissionable
  belongs_to :account
  belongs_to :creator, class_name: 'User'
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions
  after_create_commit :create_associated

  scope :owner, -> { account }

  delegated_type :recordable, types: RECORDABLE_TYPES, dependent: :destroy

  validates :recordable_type, inclusion: {
    in: RECORDABLE_TYPES, allow_blank: false, message: 'Record Type Incorrect'
  }

  after_create_commit { broadcast_prepend_to :records }

  def create_associated
    Permission.create! permissionable: self
  end
end
