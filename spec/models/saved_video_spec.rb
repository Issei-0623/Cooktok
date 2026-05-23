require 'rails_helper'

RSpec.describe SavedVideo, type: :model do
  describe "アソシエーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:video_folders).dependent(:destroy) }
    it { is_expected.to have_many(:folders).through(:video_folders) }
  end

  describe "依存関係" do
    context "ユーザーを削除したとき" do
      it "紐づく保存動画も削除されること" do
        user = create(:user)
        create(:saved_video, user: user)
        expect { user.destroy }.to change(SavedVideo, :count).by(-1)
      end
    end
  end
end
