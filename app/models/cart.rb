class Cart < ApplicationRecord
	has_many :scanning_projects
	has_many :modeling_projects
	has_many :printing_projects
	belongs_to :user

	def all_projects
		scanning_projects + modeling_projects + printing_projects
	end

	def subtotal
		scanning_projects.to_a.sum(&:total_price) +
		modeling_projects.to_a.sum(&:total_price) +
		printing_projects.to_a.sum(&:total_price)
	end

	def sales_tax
		printing_projects.to_a.sum(&:total_price) * 0.0888
	end

	def total
		subtotal + sales_tax
	end

	def stripe_amount
		(total * 100).ceil
	end
end
