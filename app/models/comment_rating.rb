# == Schema Information
#
# Table name: comment_ratings
#
#  id         :integer          not null, primary key
#  comment_id :integer
#  user_id    :integer
#  score      :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class CommentRating < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user
end
