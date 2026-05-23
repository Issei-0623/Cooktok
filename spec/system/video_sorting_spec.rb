require 'rails_helper'

RSpec.describe "Video sorting", type: :system do
  it "未分類動画をフォルダに移動し、フォルダから外して削除できること" do
    user = create(:user)
    folder = create(:folder, user: user, name: "夕食")
    video = create(
      :saved_video,
      user: user,
      title: "カレーの作り方",
      needs_sorting: true
    )

    log_in_as(user)

    visit saved_videos_path

    expect(page).to have_content("未分類動画")
    expect(page).to have_content("カレーの作り方")

    within ".saved-video-folder-form" do
      find(".folder-checkbox", text: "夕食").click
      expect(find("input[type='checkbox']")).to be_checked
      click_button "移動"
    end

    wait_until { video.reload.needs_sorting == false }
    expect(video.reload.needs_sorting).to eq(false)
    expect(video.folders).to contain_exactly(folder)
    visit saved_videos_path
    expect(page).to have_content("保存した動画はありません")

    visit folder_path(folder)

    expect(page).to have_content("夕食 フォルダの動画")
    expect(page).to have_content("カレーの作り方")

    click_button "このフォルダから外す"

    expect(page).not_to have_content("カレーの作り方")
    expect(video.reload.needs_sorting).to eq(true)
    expect(video.folders).to be_empty

    visit saved_videos_path

    expect(page).to have_content("未分類動画")
    expect(page).to have_content("カレーの作り方")

    expect {
      accept_confirm "この動画を削除しますか？" do
        click_link "削除"
      end
      expect(page).not_to have_content("カレーの作り方")
    }.to change { user.saved_videos.count }.by(-1)

    visit saved_videos_path
    expect(page).to have_content("保存した動画はありません")
  end
end
