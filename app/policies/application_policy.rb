# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :pundit_user, :record

  def initialize(pundit_user, record)
    @user = pundit_user.user
    @account = pundit_user.account
    @record = record
  end

  # Handled by authorization
  def index?
    false
  end

  def show?
    owner? || public? || subscriber?
  end

  # Handled by authorization
  def create?
    false
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(pundit_user, scope)
      @user = pundit_user.user
      @account = pundit_user.account
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :pundit_user, :scope

  end

  private

  # def is
  # Currently allows for record and account level subscriptions. Inherits up the chain. TODO: do we like this?
  def subscriber?
    return unless @account

    # subscriber of record directly
    # optimization: checks from subscribers vantage for optimization, only checks if the record is a subscribable
    # subscriber = @account.subscriptions.find { |s| s.subscribable == @record }.present? if @record.methods.include?(:subscribers)
    if @record.methods.include?(:subscribers)
      subscriber = Account.joins(:subscriptions).where(subscriptions: { subscribable_id: @record.id,
                                                                        subscribable_type: @record.class.name,
                                                                        subscriber_id: @account.id }).exists?
    end
    # subscriber of records' parent account
    if subscriber.nil? && @record.has_attribute?(:account_id)
      subscriber = Account.joins(:subscriptions).where(subscriptions: { subscribable_id: @record.account_id,
                                                                        subscribable_type: @record.class.name,
                                                                        subscriber_id: @account.id }).exists?
    end
    subscriber
  end

  def public?
    public = @record.permission.scope == 'public' if @record.methods.include?(:permission)
    public = @record.account.permission.scope == 'public' if public.nil? && @record.has_attribute?(:account_id)

    public
  end

  def owner?
    return @record == @account if @record.instance_of?(Account)
    return @record.account == @account if @record&.account

    false
  end
end
