class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
		universal_endpoint
	end

	def google_oauth2
		universal_endpoint
	end

	def failure
	end

	private
	def universal_endpoint
		omniauth = request.env["omniauth.auth"]
		authentication = Authentication.find_by(provider: omniauth['provider'], uid: omniauth['uid'])

		if authentication.present? && current_user.present?
			authentication.update_attributes(user_id: current_user.id)
			redirect_to edit_user_registration_path, notice: "you have linked your #{authentication.provider} account"
		elsif authentication.present?
			sign_in_and_redirect(:user, authentication.user)
		elsif current_user.present?
			authentication = current_user.authentications.create!(provider: omniauth['provider'], uid: omniauth['uid'])
			redirect_to edit_user_registration_path, notice: "you have linked your #{authentication.provider} account"
		elsif User.find_by(email: omniauth['info']['email']).present?
			user = User.find_by(email: omniauth['info']['email'])
			authentication = user.authentications.create!(provider: omniauth['provider'], uid: omniauth['uid'])
			sign_in_and_redirect(:user, authentication.user)
		else
			user = User.new
			user.apply_omniauth(omniauth)

			if user.save
				sign_in_and_redirect(:user, user)
			else
				session[:omniauth] = omniauth.except('extra')
				redirect_to new_user_registration_url, notice: user.errors.full_messages.to_sentence.downcase
			end
		end
	end
end
