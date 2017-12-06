class BaseDecorator < SimpleDelegator

  def h
    ActionController::Base.helpers
  end
end