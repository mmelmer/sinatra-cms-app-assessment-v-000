class User <ActiveRecord::Base
  has_many :apartments
  has_many :sales
  has_many :wanteds
  has_secure_password
end