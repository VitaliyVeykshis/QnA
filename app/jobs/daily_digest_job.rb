class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigest.call
  end
end
