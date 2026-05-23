require 'rails_helper'

RSpec.describe VideoFolder, type: :model do
  describe "アソシエーション" do
    it { is_expected.to belong_to(:saved_video) }
    it { is_expected.to belong_to(:folder) }
  end

  describe "依存関係" do
    context "保存動画を削除したとき" do
      it "紐づくVideoFolderも削除されること" do
        video_folder = create(:video_folder)
        expect { video_folder.saved_video.destroy }.to change(VideoFolder, :count).by(-1)
      end
    end

    context "フォルダを削除したとき" do
      it "紐づくVideoFolderも削除されること" do
        video_folder = create(:video_folder)
        expect { video_folder.folder.destroy }.to change(VideoFolder, :count).by(-1)
      end
    end
  end
end
