class Collection < ApplicationRecord
  belongs_to :user

  has_many :posts, -> { select(:id, :title, :code, :ptr, :image_order, :maps, :user_id, :categories, :updated_at ) }

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
end
