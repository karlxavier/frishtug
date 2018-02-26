require 'clockwork'
require 'clockwork/database_events'
require_relative '../config/boot'
require_relative '../config/environment'
module Clockwork
  every 1.hour, "items_with_stock.refresh",
        at: ["**:00", "**:05", "**:10", "**:15",
             "**:20", "**:25", "**:30", "**:35",
             "**:40", "**:45", "**:50", "**:55"],
        tz: "UTC" do
      RefreshMaterializedWorker.perform_async(ItemsWithStock)
   end
end