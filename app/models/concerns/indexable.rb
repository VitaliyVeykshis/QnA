module Indexable
  extend ActiveSupport::Concern

  included do
    after_save :real_time_callback
  end

  private

  def real_time_callback
    ThinkingSphinx::RealTime.callback_for(symbolised_model_name).after_save self
  end

  def symbolised_model_name
    self.class.name.underscore.downcase.to_sym
  end
end
