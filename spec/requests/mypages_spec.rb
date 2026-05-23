require 'rails_helper'

RSpec.describe "Mypages", type: :request do
  let(:user) { create(:user, nickname: "テストユーザー") }

  describe "GET /mypage" do
    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        get mypage_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしているとき" do
      it "マイページを表示すること" do
        sign_in user

        get mypage_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("テストユーザー")
        expect(response.body).to include("CookTubeへログイン中です。")
      end
    end
  end

  describe "PATCH /mypage/avatar_update" do
    it "アバター画像を更新すること" do
      sign_in user
      image = Rack::Test::UploadedFile.new(
        Rails.root.join("app/assets/images/default_avatar.png"),
        "image/png"
      )

      patch avatar_update_mypage_path, params: { user: { avatar: image } }

      expect(response).to redirect_to(mypage_path)
      expect(user.reload.avatar).to be_attached
    end
  end

  describe "DELETE /mypage/avatar_destroy" do
    context "アバター画像が登録されているとき" do
      it "アバター画像を削除すること" do
        image_path = Rails.root.join("app/assets/images/default_avatar.png")
        File.open(image_path) do |file|
          user.avatar.attach(
            io: file,
            filename: "default_avatar.png",
            content_type: "image/png"
          )
        end
        sign_in user

        expect {
          delete avatar_destroy_mypage_path
        }.to change { user.reload.avatar.attached? }.from(true).to(false)

        expect(response).to redirect_to(mypage_path)
        expect(flash[:notice]).to eq("画像を削除しました")
      end
    end

    context "アバター画像が登録されていないとき" do
      it "削除に失敗したことを通知すること" do
        sign_in user

        expect {
          delete avatar_destroy_mypage_path
        }.not_to change { user.reload.avatar.attached? }

        expect(response).to redirect_to(mypage_path)
        expect(flash[:alert]).to eq("削除に失敗しました")
      end
    end
  end
end
