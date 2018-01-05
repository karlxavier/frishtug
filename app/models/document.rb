class Document < ApplicationRecord
  mount_uploader :file, SpreadsheetUploader
end
