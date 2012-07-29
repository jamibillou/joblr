class Authentification < ActiveRecord::Base

  attr_accessible :provider, :uemail, :uid, :uname, :user_id, :url, :upic, :remote_upic_url

  belongs_to :user

  validates :user, :provider, :uid,  presence: true
  validates :url,  url_format: true, allow_blank: true

  mount_uploader :upic, AuthentificationImageUploader
end

# == Schema Information
#
# Table name: authentifications
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  uname      :string(255)
#  uemail     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  url        :string(255)
#  upic       :string(255)
#

