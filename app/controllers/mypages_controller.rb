class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def avatar_update
    if current_user.update(avatar_params)
      redirect_to mypage_path, notice: "更新しました"
    else
      redirect_to mypage_path, alert: "更新に失敗しました"
    end
  end

  def avatar_destroy
    if current_user.avatar.attached?
      current_user.avatar.purge
      redirect_to mypage_path, notice: "画像を削除しました"
    else
      redirect_to mypage_path, alert: "削除に失敗しました"
    end
  end


  private
  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
