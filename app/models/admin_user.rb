class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

	has_many :comments, dependent: :destroy
end
