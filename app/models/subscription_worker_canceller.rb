class SubscriptionWorkerCanceller
  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def self.call(user_id:)
    self.new(user_id).cancel
  end

  def cancel
    sidekiq_scheduled_jobs = Sidekiq::ScheduledSet.new
    job = sidekiq_scheduled_jobs.find { |i| i.klass == 'SubscriptionWorker' && i.args.include?(user_id) }

    return if job.nil?
    job.delete
  end
end