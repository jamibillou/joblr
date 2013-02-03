# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  fullname               :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  username               :string(255)
#  image                  :string(255)
#  city                   :string(255)
#  country                :string(255)
#  subdomain              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  social                 :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :fullname, :email, :city, :country, :subdomain, :password, :password_confirmation, :remember_me, :image, :username, :admin,
                  :social, :remove_image, :remote_image_url, :profiles_attributes

  # Virtual attribute to authenticate users by username or email
  attr_accessor   :login

  has_many :authentications,         dependent: :destroy
  has_many :profiles,                dependent: :destroy
  has_many :authored_emails,         dependent: :destroy, class_name: 'FromUserEmail', foreign_key: 'author_id'
  has_many :received_emails,         dependent: :destroy, class_name: 'ToUserEmail',   foreign_key: 'recipient_id'
  has_many :authored_profile_emails, dependent: :destroy, class_name: 'ProfileEmail',  foreign_key: 'author_id'

  accepts_nested_attributes_for :profiles, allow_destroy: true

  validates :fullname,  length:     { maximum: 100 },                                       presence: true
  validates :username,  uniqueness: { case_sensitive: true },                               presence: true
  validates :password,  length:     { within: Devise.password_length }, confirmation: true, presence: true, unless: :password_required?
  validates :subdomain,                                                                     presence: true, on: :update
  validates :city,      length:     { maximum: 50 }
  validates :country,   length:     { maximum: 50 }
  validates :username,  length:     { maximum: 63 }, subdomain_format: true
  validates :subdomain, length:     { maximum: 63 }, subdomain_format: true, allow_nil: true
  validates :subdomain, uniqueness: { case_sensitive: true }
  validates :admin,     inclusion:  { in: [true, false] }
  validates :email,     uniqueness: { case_sensitive: true },      allow_nil: true, if: :email_changed?
  validates :email,     format:     { with: Devise.email_regexp }, allow_nil: true, if: :email_changed?

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable, :authentication_keys => [:login]

  after_create :update_subdomain

  mount_uploader :image, UserImageUploader

  class << self

    # REFACTOR AND TEST ME!
    #
    def make_username(desired_username, fullname)
      unless username = username_available?(desired_username)
        unless fullname.blank?
          unless username = username_available?(fullname.parameterize)
            username = username_available?(fullname.parameterize.split('-').map{ |name| name.chars.first }.join)
          end
        end
      end
      username ||= "user-#{User.last.id + 1}"
    end
    #
    def username_available?(username)
      username if find_by_username(username).nil?
    end

    def find_first_by_auth_conditions(conditions)
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.downcase}]).first
      else
        where(conditions).first
      end
    end
  end

  def profile
    profiles.first
  end

  def authored_profile_emails_by_date
    profile_emails = authored_profile_emails.order('created_at DESC')

    profile_emails.map{|pe| {month: pe.created_at.month, year: pe.created_at.year}}.uniq.map do |date|
      { date: date,
        profile_emails: profile_emails.select{|pe| pe.created_at.month == date[:month] && pe.created_at.year == date[:year]} }
    end
  end

  def activated?
    !authored_profile_emails.select{|pe| pe.profile.user == pe.author}.empty?
  end

  def has_authored_profile_emails?
    !authored_profile_emails.blank?
  end

  def auth(provider)
    authentications.find_by_provider(provider)
  end

  def has_auth?(provider)
    !auth(provider).nil?
  end

  def password_required?
    if self.persisted?
      social? || password.blank?
    else
      social
    end
  end

  def initials
    fullname.parameterize.split('-').map{|name| name.chars.first}.join
  end

  def public_url
    "http://#{subdomain}.joblr.co"
  end

  private

    def update_subdomain
      self.update_attributes subdomain: username
    end

    def update_with_password(params, *options)
      if encrypted_password.blank?
        update_attributes(params, *options)
      else
        super
      end
    end
end
