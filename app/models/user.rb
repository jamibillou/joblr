class User < ActiveRecord::Base

  include User::Linkedin

  attr_accessible :fullname, :email, :city, :country, :role, :company, :subdomain, :password, :password_confirmation,
                  :remember_me, :image, :username, :profiles_attributes, :remove_image, :commit, :remote_image_url
  attr_accessor   :commit

  has_many :authentifications,   dependent: :destroy
  has_many :profiles,            dependent: :destroy
  has_many :authored_sharings,                                  class_name: 'Sharing', foreign_key: 'author_id'
  has_many :received_sharings,                                  class_name: 'Sharing', foreign_key: 'recipient_id'
  has_many :sharings_authors,    through:   :received_sharings, class_name: 'User',    source:      'author'
  has_many :sharings_recipients, through:   :authored_sharings, class_name: 'User',    source:      'recipient'
  has_one  :beta_invite,         dependent: :destroy

  accepts_nested_attributes_for :profiles, allow_destroy: true

  validates :fullname, length:     { maximum: 100 }
  validates :city,     length:     { maximum: 50 }
  validates :country,  length:     { maximum: 50 }
  validates :role,     length:     { maximum: 100 }
  validates :company,  length:     { maximum: 50 }
  validates :username, length:     { maximum: 100 }
  validates :username, uniqueness: { case_sensitive: true },        presence: true
  validates :email,    uniqueness: { case_sensitive: true },        allow_nil: true, if: :email_changed?
  validates :email,    format:     { with:   Devise.email_regexp }, allow_nil: true, if: :email_changed?
  validates :password, length:     { within: Devise.password_length }, confirmation: true, presence: true, if: ->(u) { u.commit == 'Sign up' }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  mount_uploader :image, UserImageUploader

  def profile
    profiles.first
  end

  def initials
    fullname.parametize.split('-').map{ |name| name.chars.first }.join
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
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  city                   :string(255)
#  country                :string(255)
#  role                   :string(255)
#  company                :string(255)
#  image                  :string(255)
#  subdomain              :string(255)
#  username               :string(255)
#

