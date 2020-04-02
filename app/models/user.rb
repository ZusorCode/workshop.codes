class SerializedArrayLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options.key?(:maximum)
    return unless value
    maximum = options[:maximum]
    return unless value.count > maximum

    record.errors.add(attribute, :too_long_array, count: maximum)
  end
end

class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :remember_tokens, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :forgot_password_tokens, dependent: :destroy

  has_one_attached :profile_image, dependent: :destroy
  has_one_attached :banner_image, dependent: :destroy

  serialize :featured_posts

  encrypts :email
  blind_index :email

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z\d][a-z\d-]*[a-z\d#]*[a-z\d]\z/i }
  validates :password, presence: true, length: { minimum: 8 }, if: :password
  validates :email, uniqueness: true, allow_blank: true
  validates :link, allow_blank: true, format: URI::regexp(%w[http https])
  validates :description, length: { maximum: 255 }
  validates :featured_posts, allow_blank: true, serialized_array_length: { maximum: 3 }
  validates :profile_image, content_type: ["image/jpeg", "image/jpg", "image/png"],
                            size: { less_than: 2.megabytes }

  def self.find_or_create_from_auth_hash(auth_hash)
    uid = auth_hash["uid"]
    provider = auth_hash["provider"]

    user = find_or_create_by(uid: uid, provider: provider)

    user.username = auth_hash["info"]["name"] || auth_hash["info"]["battletag"]
    user.username.gsub!(" ", "-")
    user.provider_profile_image = auth_hash["info"]["image"]
    user.password = "no_password"

    user if user.save
  end
end
