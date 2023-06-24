class OrdersController < ApplicationController
	def create
		@amount = current_cart.stripe_amount

		if @amount <= 0
			@order = Order.create!(user_id: current_user.id)

			current_cart.scanning_projects.each do |scanning_project|
				scanning_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: scanning_project.total_price)
				scanning_project.send_emails
			end
			current_cart.modeling_projects.each do |modeling_project|
				modeling_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: modeling_project.total_price)
				modeling_project.send_emails
			end
			current_cart.printing_projects.each do |printing_project|
				printing_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: printing_project.total_price)
				printing_project.send_emails
			end

			redirect_to orders_path
		else
			@stripe_customer_identifier = current_user.stripe_customer_identifier

			if @stripe_customer_identifier.present?
				@stripe_customer = Stripe::Customer.retrieve(@stripe_customer_identifier)
				@stripe_customer.source = params[:stripeToken]
				@stripe_customer.save
			else
				@stripe_customer = Stripe::Customer.create(
					email: current_user.email,
					source: params[:stripeToken]
				)
			end

			current_user.update_attributes(stripe_customer_identifier: @stripe_customer.id)

			begin
				@charge = Stripe::Charge.create(
					customer: @stripe_customer.id,
					amount: @amount.to_i,
					description: "Womp Order #{Order.last.present? ? (Order.last.id + 1) : 1}",
					currency: 'usd',
					metadata: {
						"email": current_user.email,
						"user_id": current_user.id
					}
				)
				@order = Order.create!(user_id: current_user.id) # this is created after just in case the charge fails

				current_cart.scanning_projects.each do |scanning_project|
					scanning_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: scanning_project.total_price)
					scanning_project.send_emails
				end
				current_cart.modeling_projects.each do |modeling_project|
					modeling_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: modeling_project.total_price)
					modeling_project.send_emails
				end
				current_cart.printing_projects.each do |printing_project|
					printing_project.update_attributes(cart_id: nil, order_id: @order.id, paid: true, paid_at: DateTime.now, final_price: printing_project.total_price)
					printing_project.send_emails
				end

				redirect_to orders_path
			rescue Stripe::CardError => err
				if err == "card_declined"
					redirect_to cart_path, alert: "your card was declined"
				else
					redirect_to cart_path, alert: "there was an error processing your payment"
				end
			end
		end
	end

	def index
		@orders = current_user.orders
	end
end
