class User < ActiveRecord::Base

  attr_accessible :fullname, :email, :city, :country, :subdomain, :password, :password_confirmation, :remember_me, :image, :username, :admin,
                  :social, :remove_image, :remote_image_url, :profiles_attributes

  has_many :authentifications,       dependent:  :destroy
  has_many :profiles,                dependent:  :destroy
  has_many :authored_email_sharings, class_name: 'EmailSharing', foreign_key: 'author_id'
  has_one  :beta_invite,             dependent:  :destroy

  accepts_nested_attributes_for :profiles, allow_destroy: true

  validates :fullname,  length:     { maximum: 100 },                   presence: true
  validates :username,  uniqueness: { case_sensitive: true },           presence: true
  validates :username,  length:     { maximum: 100 }
  validates :city,      length:     { maximum: 50 }
  validates :country,   length:     { maximum: 50 }
  validates :subdomain, length:     { maximum: 100 }
  validates :subdomain, uniqueness: { case_sensitive: true }
  validates :email,     uniqueness: { case_sensitive: true },           allow_nil:    true, if: :email_changed?
  validates :email,     format:     { with:   Devise.email_regexp },    allow_nil:    true, if: :email_changed?
  validates :password,  length:     { within: Devise.password_length }, confirmation: true, presence: true, unless: :password_required?
  validates :admin,     inclusion:  { :in => [true, false] }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  mount_uploader :image, UserImageUploader

  def profile
    profiles.first
  end

  def initials
    fullname.parameterize.split('-').map{|name| name.chars.first}.join
  end

  def auth(provider)
    authentifications.find_by_provider(provider)
  end

  def has_auth?(provider)
    unless provider == :all
      !auth(provider).nil?
    else
      has_auth?('linkedin') && has_auth?('twitter') && has_auth?('facebook') && has_auth?('google')
    end
  end

  def password_required?
    if self.persisted?
      social? || password.blank?
    else
      social
    end
  end

  private

    def update_with_password(params, *options)
      if encrypted_password.blank?
        update_attributes(params, *options)
      else
        super
      end
    end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  fullname               :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  username               :string(255)
#  image                  :string(255)
#  city                   :string(255)
#  country                :string(255)
#  subdomain              :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  admin                  :boolean         default(FALSE)
#  social                 :boolean
#

