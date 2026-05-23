require 'rails_helper'

RSpec.describe "Folder management", type: :system do
  it "フォルダを作成・編集・削除できること" do
    user = create(:user)
    log_in_as(user)

    visit folders_path

    click_button "＋ 新しいフォルダ"
    expect(page).to have_css("#folder-form", visible: :visible)

    within "#folder-form" do
      fill_in "folder_name", with: "朝食"
    end

    expect {
      click_button "保存"
      wait_until { user.folders.exists?(name: "朝食") }
    }.to change { user.folders.count }.by(1)

    visit folders_path
    expect(page).to have_content("朝食")

    click_link "編集"
    fill_in "folder_name", with: "朝ごはん"
    click_button "更新"

    wait_until { user.folders.exists?(name: "朝ごはん") }
    visit folders_path
    expect(page).to have_content("朝ごはん")
    expect(page).not_to have_content("朝食")

    expect {
      accept_confirm "削除しますか？" do
        click_button "削除"
      end
      wait_until { user.folders.count.zero? }
    }.to change { user.folders.count }.by(-1)

    visit folders_path
    expect(page).not_to have_content("朝ごはん")
  end
end
