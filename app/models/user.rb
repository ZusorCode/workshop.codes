class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :remember_tokens, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :forgot_password_tokens, dependent: :destroy

  encrypts :email
  blind_index :email

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }
  validates :password, presence: true, length: { minimum: 8 }
  validates :email, uniqueness: true, allow_blank: true
end
