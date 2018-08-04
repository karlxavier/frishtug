# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id         :bigint(8)        not null, primary key
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Document < ApplicationRecord
  mount_uploader :file, SpreadsheetUploader
end
