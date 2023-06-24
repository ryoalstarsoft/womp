class Order < ApplicationRecord
	has_many :scanning_projects, dependent: :destroy
	has_many :modeling_projects, dependent: :destroy
	has_many :printing_projects, dependent: :destroy
	belongs_to :user

	def subtotal
		scanning_projects.to_a.sum(&:final_price) +
		modeling_projects.to_a.sum(&:final_price) +
		printing_projects.to_a.sum(&:final_price)
	end

	def sales_tax
		printing_projects.to_a.sum(&:final_tax)
	end

	def total
		subtotal + sales_tax
	end
end
