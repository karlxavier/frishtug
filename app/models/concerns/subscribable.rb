module Subscribable
  extend ActiveSupport::Concern

  included do
    after_create :create_subscription
    after_destroy :delete_subscription
  end

  private

  def create_subscription
    is_a_subscription? && StripePlanner.new(self).run
  end

  def delete_subscription
    is_a_subscription? && StripePlanner.new(self).delete
  end

  def is_a_subscription?
    self[:interval] == 'month'
  end
end