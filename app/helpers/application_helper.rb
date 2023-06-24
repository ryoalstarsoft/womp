module ApplicationHelper
	def cart_text
		if current_cart.all_projects.present?
			"#{image_tag('icon-cart.svg', class: 'mw-100 w-auto v-mid', style: 'height:18px;', alt: 'cart')}<sup>#{current_cart.all_projects.count}".html_safe
		else
			"#{image_tag('icon-cart.svg', class: 'mw-100 w-auto v-mid', style: 'height:18px;', alt: 'cart')}".html_safe
		end
	end

	def mobile_cart_text
		if current_cart.all_projects.present?
			"cart<sup>#{current_cart.all_projects.count}</sup>".html_safe
		else
			"cart"
		end
	end

	def trim_num(num)
		i, f = num.to_i, num.to_f
		i == f ? i : f
	end

	def womp_strftime(timestamp)
		if timestamp.present?
			timestamp.in_time_zone('Eastern Time (US & Canada)').strftime('%B %d, %Y %I:%M%P') + " EST"
		else
			'n/a'
		end
	end
end
