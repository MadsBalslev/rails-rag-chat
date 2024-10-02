module ApplicationHelper
  def is_active?(action)
    params[:controller] == action ? "active" : nil
  end

  def current_user
    Current.user
  end
end
