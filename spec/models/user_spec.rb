require 'rails_helper'

RSpec.describe User, type: :model do
  describe "アソシエーション" do
    it { is_expected.to have_many(:saved_videos).dependent(:destroy) }
    it { is_expected.to have_many(:folders).dependent(:destroy) }
  end

  describe "バリデーション" do
    context "nicknameが30文字以内のとき" do
      it "有効であること" do
        user = build(:user, nickname: "a" * 30)
        expect(user).to be_valid
      end
    end

    context "nicknameが31文字以上のとき" do
      it "無効であること" do
        user = build(:user, nickname: "a" * 31)
        expect(user).not_to be_valid
      end
    end

    context "nicknameが空のとき" do
      it "有効であること" do
        user = build(:user, nickname: "")
        expect(user).to be_valid
      end
    end
  end
end
