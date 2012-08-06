class Sharing < ActiveRecord::Base
  attr_accessible :company, :email, :fullname, :role, :user_id
end
