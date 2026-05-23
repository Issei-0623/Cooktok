require 'rails_helper'

RSpec.describe "Folders", type: :request do
  let(:user) { create(:user) }

  describe "GET /folders" do
    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        get folders_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしているとき" do
      it "自分のフォルダだけを表示すること" do
        create(:folder, user: user, name: "和食")
        create(:folder, name: "洋食")
        sign_in user

        get folders_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("和食")
        expect(response.body).not_to include("洋食")
      end
    end
  end

  describe "GET /folders/:id" do
    it "フォルダに紐づく動画を表示すること" do
      folder = create(:folder, user: user, name: "朝食")
      video = create(:saved_video, user: user, title: "卵焼き")
      create(:video_folder, folder: folder, saved_video: video)
      sign_in user

      get folder_path(folder)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("朝食")
      expect(response.body).to include("卵焼き")
    end
  end

  describe "GET /folders/:id/edit" do
    it "編集画面を表示すること" do
      folder = create(:folder, user: user)
      sign_in user

      get edit_folder_path(folder)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("フォルダ編集")
    end
  end

  describe "POST /folders" do
    before { sign_in user }

    context "有効な値のとき" do
      it "フォルダを作成すること" do
        expect {
          post folders_path, params: { folder: { name: "作り置き" } }
        }.to change { user.folders.count }.by(1)

        expect(response).to redirect_to(folders_path)
        expect(user.folders.last.name).to eq("作り置き")
      end
    end

    context "無効な値のとき" do
      it "フォルダを作成しないこと" do
        expect {
          post folders_path, params: { folder: { name: "" } }
        }.not_to change(Folder, :count)

        expect(response).to redirect_to(folders_path)
        expect(flash[:alert]).to eq("作成に失敗しました")
      end
    end
  end

  describe "PATCH /folders/:id" do
    it "フォルダ名を更新すること" do
      folder = create(:folder, user: user, name: "更新前")
      sign_in user

      patch folder_path(folder), params: { folder: { name: "更新後" } }

      expect(response).to redirect_to(folders_path)
      expect(folder.reload.name).to eq("更新後")
    end
  end

  describe "DELETE /folders/:id" do
    it "フォルダを削除すること" do
      folder = create(:folder, user: user)
      sign_in user

      expect {
        delete folder_path(folder)
      }.to change { user.folders.count }.by(-1)

      expect(response).to redirect_to(folders_path)
    end
  end
end
