module UsersHelper
  def title_params
    {:user => @user.name } if @user
  end

  def block_params_left
    [ [:cell, :categories, :show, :category => @category] ]
  end

  def resource_assets
    resources = []

    # This is for the ask a question modal
    resources << tinymce_assets if current_user && action_name == 'show'
  end

  def user_rating(val)
    raw ( val == 1 ) ?
      '<span class="positive_rating">Positive</span>' :
      '<span class="negative_rating">Negative</span>'
  end
end
