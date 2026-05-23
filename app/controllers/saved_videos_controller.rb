class SavedVideosController < ApplicationController
  before_action :authenticate_user!

  def index
    @saved_videos = current_user.saved_videos.where(needs_sorting: true)
    @folders = current_user.folders
  end

  def update
    video = current_user.saved_videos.find(params[:id])
    folder_ids = Array(params[:folder_ids]).reject(&:blank?)
    now = Time.current

    video.transaction do
      video.video_folders.destroy_all

      if folder_ids.present?
        VideoFolder.insert_all(
          folder_ids.map do |folder_id|
            {
              saved_video_id: video.id,
              folder_id: folder_id,
              created_at: now,
              updated_at: now
            }
          end
        )
      end

      video.update!(needs_sorting: false)
    end
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
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "save-area-#{params[:youtube_video_id]}",
          partial: "shared/save_button",
          locals: {
            video_id: params[:youtube_video_id],
            saved: @saved_video,
            title: @saved_video.title,
            nickname: @saved_video.nickname,
            username: @saved_video.username
          }
        )
      end
      format.html { redirect_back fallback_location: searches_path, notice: "動画を保存しました" }
    end
  end

  def destroy
    @saved_video = current_user.saved_videos.find(params[:id])
    youtube_video_id = params[:youtube_video_id]
    card_dom_id      = "saved_video_#{@saved_video.id}"
    title            = @saved_video.title
    nickname         = @saved_video.nickname
    username         = @saved_video.username
    @saved_video.destroy
    respond_to do |format|
      format.turbo_stream do
        if youtube_video_id.present?
          render turbo_stream: turbo_stream.replace(
            "save-area-#{youtube_video_id}",
            partial: "shared/save_button",
            locals: {
              video_id: youtube_video_id,
              saved: nil,
              title: title,
              nickname: nickname,
              username: username
            }
          )
        else
          render turbo_stream: turbo_stream.remove(card_dom_id)
        end
      end
      format.html { redirect_back fallback_location: searches_path, notice: "保存を解除しました" }
    end
  end

  def remove_from_folder
    @video = current_user.saved_videos.find(params[:id])
    @video.video_folders
          .where(folder_id: params[:folder_id])
          .destroy_all
    @video.update!(needs_sorting: true)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("saved_video_#{@video.id}") }
      format.html { redirect_back fallback_location: folders_path, notice: "フォルダから外しました" }
    end
  end

  private
  def saved_video_params
    params.require(:saved_video).permit(:title, :url, :nickname, :username)
  end
end
