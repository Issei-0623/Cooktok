require 'rails_helper'

RSpec.describe Folder, type: :model do
  describe "アソシエーション" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:video_folders).dependent(:destroy) }
    it { is_expected.to have_many(:saved_videos).through(:video_folders) }
  end

  describe "バリデーション" do
    context "nameが存在するとき" do
      it "有効であること" do
        folder = build(:folder)
        expect(folder).to be_valid
      end
    end

    context "nameが空のとき" do
      it "無効であること" do
        folder = build(:folder, name: "")
        expect(folder).not_to be_valid
      end
    end

    context "同じユーザーで同名フォルダを作るとき" do
      it "無効であること" do
        user = create(:user)
        create(:folder, user: user, name: "料理")
        duplicate = build(:folder, user: user, name: "料理")
        expect(duplicate).not_to be_valid
      end
    end

    context "別のユーザーで同名フォルダを作るとき" do
      it "有効であること" do
        create(:folder, name: "料理")
        other_user = create(:user)
        folder = build(:folder, user: other_user, name: "料理")
        expect(folder).to be_valid
      end
    end
  end
end
