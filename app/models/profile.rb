class Profile < ActiveRecord::Base

  attr_accessible :education, :experience, :quality_1, :quality_2, :quality_3, :skill_1, :skill_1_level, :skill_2, :skill_2_level, :skill_3, :skill_3_level, :user_id

  belongs_to :user

  validates :user, presence: true
end