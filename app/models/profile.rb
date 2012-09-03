class Profile < ActiveRecord::Base

  attr_accessible :headline, :experience, :last_job, :past_companies, :education, :skill_1, :skill_1_level, :skill_2, :skill_2_level, :skill_3, :skill_3_level,
                  :quality_1, :quality_2, :quality_3, :file, :url, :text, :user_id, :remove_file

  belongs_to :user
  has_many   :email_sharings, dependent: :destroy

  validates :user,                                                            presence: true
  validates :headline,       length: { maximum: 100 }, headline_format: true, presence: true
  validates :experience,     length: { maximum: 100 },                        presence: true
  validates :education,      length: { maximum: 100 },                        presence: true
  validates :text,           length: { maximum: 140 },                        presence: true
  validates :last_job,       length: { maximum: 100 }
  validates :past_companies, length: { maximum: 100 }
  validates :skill_1,        length: { maximum: 50 }
  validates :skill_2,        length: { maximum: 50 }
  validates :skill_3,        length: { maximum: 50 }
  validates :quality_1,      length: { maximum: 50 }
  validates :quality_2,      length: { maximum: 50 }
  validates :quality_3,      length: { maximum: 50 }
  validates :skill_1_level,  level_format: true, allow_blank: true
  validates :skill_2_level,  level_format: true, allow_blank: true
  validates :skill_3_level,  level_format: true, allow_blank: true
  validates :url,            url_format:   true, allow_blank: true

  mount_uploader :file, ProfileFileUploader
end

# == Schema Information
#
# Table name: profiles
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  headline       :string(255)
#  experience     :string(255)
#  last_job       :string(255)
#  past_companies :string(255)
#  education      :string(255)
#  skill_1        :string(255)
#  skill_1_level  :string(255)
#  skill_2        :string(255)
#  skill_2_level  :string(255)
#  skill_3        :string(255)
#  skill_3_level  :string(255)
#  quality_1      :string(255)
#  quality_2      :string(255)
#  quality_3      :string(255)
#  file           :string(255)
#  url            :string(255)
#  text           :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

