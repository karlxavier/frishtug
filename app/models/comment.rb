# == Schema Information
#
# Table name: comments
#
#  id               :bigint(8)        not null, primary key
#  user_id          :bigint(8)
#  body             :text
#  commentable_type :string
#  commentable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
