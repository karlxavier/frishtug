class RefreshMaterializedWorker
  include Sidekiq::Worker
  sidekiq_options queue: "critical"

  def perform(klass)
    klass.constantize.refresh
  end
end