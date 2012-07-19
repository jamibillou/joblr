class Profile < ActiveRecord::Base

  attr_accessible :education, :experience, :quality_1, :quality_2, :quality_3, :skill_1, :skill_1_level, :skill_2, :skill_2_level, :skill_3, :skill_3_level, :text, :user_id

  belongs_to :user

  validates :user,          presence: true
  validates :education,     length: { maximum: 100 }
  validates :experience,    length: { maximum: 100 }
  validates :skill_1,       length: { maximum: 50 }
  validates :skill_2,       length: { maximum: 50 }
  validates :skill_3,       length: { maximum: 50 }
  validates :skill_1_level, level_format: true, allow_blank: true
  validates :skill_2_level, level_format: true, allow_blank: true
  validates :skill_3_level, level_format: true, allow_blank: true
  validates :quality_1,     length: { maximum: 50 }
  validates :quality_2,     length: { maximum: 50 }
  validates :quality_3,     length: { maximum: 50 }
  validates :text,          length: { maximum: 140 }
end

## == Schema Information
#
# Table name: profiles
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  experience    :string(255)
#  education     :string(255)
#  skill_1       :string(255)
#  skill_1_level :string(255)
#  skill_2       :string(255)
#  skill_2_level :string(255)
#  skill_3       :string(255)
#  skill_3_level :string(255)
#  quality_1     :string(255)
#  quality_2     :string(255)
#  quality_3     :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  text          :string(255)
#

