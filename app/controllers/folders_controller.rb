class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    @folders = current_user.folders
    @folder = Folder.new
  end

  def create
    @folder = current_user.folders.build(folder_params)
    if @folder.save
      redirect_to folders_path, notice: "作成しました"
    else
      redirect_to folders_path, alert: "作成に失敗しました"
    end
  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])
    if params[:folder][:remove_image] == "1"
      @folder.image.purge
    end
    
    if @folder.update(folder_params)
      redirect_to folders_path, notice: "更新しました"
    else
      render :edit
    end
  end


  def destroy
    @folder = current_user.folders.find(params[:id])
    @folder.destroy
    redirect_to folders_path, notice: "削除しました"
  end

  def show
    @folder = current_user.folders.find(params[:id])
    @saved_videos = @folder.saved_videos
  end


  private
    def folder_params
      params.require(:folder).permit(:name, :image)
    end
end
