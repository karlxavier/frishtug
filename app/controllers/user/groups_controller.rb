class User::GroupsController < User::BaseController
  def create
    @referrer = current_user.build_referrer(group_code: SecureRandom.urlsafe_base64(10)
    )
    if @referrer.save
      flash[:notice] = "Your group code is: #{@referrer.group_code}"
      redirect_to user_subscriptions_path
    else
      flash[:error] = @referrer.errors.full_messages.join(', ')
      redirect_to user_subscriptions_path
    end
  end

  def join
    @referrer = Referrer.find_by_group_code(group_code)
    if @referrer
      current_user.create_candidate!(referrer_id: @referrer.id)
      flash[:notice] = "You joined #{@referrer.user.full_name}'s group'"
      redirect_to user_subscriptions_path
    else
      flash[:error] = "Group code does not exists for #{group_code}"
      redirect_to user_subscriptions_path
    end
  end

  private

  def group_code
    params[:group_code]
  end
end