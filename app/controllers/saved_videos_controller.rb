class SavedVideosController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_videos = current_user.saved_videos.where(needs_sorting: true)
    @folders = current_user.folders
  end

  def update
    video = current_user.saved_videos.find(params[:id])
    video.video_folders.destroy_all
    if params[:folder_ids].present?
      params[:folder_ids].each do |folder_id|
        video.video_folders.create(folder_id: folder_id)
      end
    end
    video.update(needs_sorting: false)
    redirect_to saved_videos_path, notice: "動画を移動しました"
  end

  def create
    @saved_video = current_user.saved_videos.find_or_initialize_by(
      url: saved_video_params[:url]
    )
    if @saved_video.new_record?
      @saved_video.assign_attributes(saved_video_params)
      @saved_video.needs_sorting = true
      @saved_video.save!
    end
    redirect_back fallback_location: searches_path,
                  notice: "動画を保存しました"
  end

  def destroy
    @saved_video = current_user.saved_videos.find(params[:id])
    @saved_video.destroy
    redirect_back fallback_location: searches_path, notice: "保存を解除しました"
  end

  def remove_from_folder
    @video = current_user.saved_videos.find(params[:id])
    @video.video_folders
          .where(folder_id: params[:folder_id])
          .destroy_all
    @video.update!(needs_sorting: true)
  end

  private
  def saved_video_params
    params.require(:saved_video).permit(:title, :url, :nickname, :username)
  end
end
