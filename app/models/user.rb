class User < ApplicationRecord
  has_one_attached :avatar
  has_many :saved_videos, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
