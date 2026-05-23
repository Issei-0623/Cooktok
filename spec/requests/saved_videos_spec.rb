require 'rails_helper'

RSpec.describe "SavedVideos", type: :request do
  let(:user) { create(:user) }

  describe "GET /saved_videos" do
    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        get saved_videos_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしているとき" do
      it "未分類の保存動画だけを表示すること" do
        create(:saved_video, user: user, title: "未分類動画", needs_sorting: true)
        create(:saved_video, user: user, title: "分類済み動画", needs_sorting: false)
        create(:saved_video, title: "他ユーザーの動画", needs_sorting: true)
        sign_in user

        get saved_videos_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("未分類動画")
        expect(response.body).not_to include("分類済み動画")
        expect(response.body).not_to include("他ユーザーの動画")
      end
    end
  end

  describe "POST /saved_videos" do
    before { sign_in user }

    let(:video_params) do
      {
        title: "保存する動画",
        url: "https://www.youtube.com/embed/abc123def45",
        nickname: "Cook Channel",
        username: "cook_channel"
      }
    end

    context "まだ保存していない動画のとき" do
      it "保存動画を作成すること" do
        expect {
          post saved_videos_path, params: { saved_video: video_params }
        }.to change { user.saved_videos.count }.by(1)

        saved_video = user.saved_videos.last
        expect(response).to redirect_to(searches_path)
        expect(saved_video.title).to eq("保存する動画")
        expect(saved_video.needs_sorting).to eq(true)
      end
    end

    context "同じURLの動画を保存済みのとき" do
      it "重複して作成しないこと" do
        create(:saved_video, user: user, url: video_params[:url])

        expect {
          post saved_videos_path, params: { saved_video: video_params }
        }.not_to change(SavedVideo, :count)

        expect(response).to redirect_to(searches_path)
      end
    end
  end

  describe "PATCH /saved_videos/:id" do
    it "動画を選択したフォルダへ移動すること" do
      video = create(:saved_video, user: user, needs_sorting: true)
      old_folder = create(:folder, user: user)
      new_folder = create(:folder, user: user)
      create(:video_folder, saved_video: video, folder: old_folder)
      sign_in user

      patch saved_video_path(video), params: { folder_ids: [new_folder.id] }

      expect(response).to redirect_to(saved_videos_path)
      expect(video.reload.needs_sorting).to eq(false)
      expect(video.folders).to contain_exactly(new_folder)
    end

    it "フォルダ未選択でも未分類状態を解除すること" do
      video = create(:saved_video, user: user, needs_sorting: true)
      folder = create(:folder, user: user)
      create(:video_folder, saved_video: video, folder: folder)
      sign_in user

      patch saved_video_path(video), params: {}

      expect(response).to redirect_to(saved_videos_path)
      expect(video.reload.needs_sorting).to eq(false)
      expect(video.folders).to be_empty
    end
  end

  describe "DELETE /saved_videos/:id" do
    it "保存動画を削除すること" do
      video = create(:saved_video, user: user)
      sign_in user

      expect {
        delete saved_video_path(video)
      }.to change { user.saved_videos.count }.by(-1)

      expect(response).to redirect_to(searches_path)
    end
  end

  describe "POST /saved_videos/:id/remove_from_folder" do
    it "動画をフォルダから外して未分類に戻すこと" do
      video = create(:saved_video, user: user, needs_sorting: false)
      folder = create(:folder, user: user)
      create(:video_folder, saved_video: video, folder: folder)
      sign_in user

      expect {
        post remove_from_folder_saved_video_path(video, folder_id: folder.id)
      }.to change(VideoFolder, :count).by(-1)

      expect(response).to redirect_to(folders_path)
      expect(video.reload.needs_sorting).to eq(true)
      expect(video.folders).to be_empty
    end
  end
end
