class StyleGuideController < ApplicationController
  layout 'style_guide'

  skip_before_action :authenticate_user!

  def style_guide
	end
end
