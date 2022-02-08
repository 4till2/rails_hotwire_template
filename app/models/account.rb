class Account < ApplicationRecord
  include Permissionable
  belongs_to :user
  has_one :profile, dependent: :destroy
  has_many :records, dependent: :destroy
  # subscriptions are a join between account and subscribable, 'subs' is needed to keep consistent with other subscribable's
  has_many :subs, as: :subscribable, class_name: 'Subscription'
  has_many :subscriptions, foreign_key: 'subscriber_id', dependent: :destroy, class_name: 'Subscription'
  has_many :subscribers, through: :subs
  after_create_commit :build_associated

  validates_uniqueness_of :user_id
  validates_uniqueness_of :nickname
  validates :nickname, length: { minimum: 3, maximum: 15 }

  # must start and end with an alphanumeric character.
  # special characters underscore (_) and dash(-) are allowed
  validates :nickname, format: { with: /\A[a-zA-Z0-9]+([_-]?[a-zA-Z0-9])*\z/,
                                 message: 'is an invalid format. Only alphanumeric characters are allowed.' }

  private

  def build_associated
    build_profile.save! unless profile
    build_permission.save! unless permission
  end

end
