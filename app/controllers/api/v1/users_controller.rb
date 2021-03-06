class Api::V1::UsersController < ApiController
  def create
    begin
      @user = User.create(user_params)
    rescue ActiveRecord::RecordNotUnique
      @user = User.find_by(uid: params[:uid])
    end
    response_bad_request(@user.errors.message) unless @user
    token = JwtAuth.tokenize(params[:uid])
    response.set_header('Access-Token', token)
  end

  def update
    return unless params[:uid] == current_user.uid

    @user = current_user
    @user.update!(name: params[:name])
  end

  private

  def user_params
    params.permit(:uid, :name)
  end
end