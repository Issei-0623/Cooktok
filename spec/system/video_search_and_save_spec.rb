require 'rails_helper'

RSpec.describe "Video search and save", type: :system do
  let(:api_response) do
    {
      "items" => [
        {
          "id" => { "videoId" => "abc123def45" },
          "snippet" => {
            "title" => "親子丼の作り方",
            "channelTitle" => "Cook Channel"
          }
        }
      ],
      "nextPageToken" => nil
    }
  end

  before do
    allow(Net::HTTP).to receive(:get).and_return(api_response.to_json, { "items" => [] }.to_json)
  end

  it "動画を検索して保存できること" do
    user = create(:user)
    log_in_as(user)

    click_link "動画を探す"
    fill_in "keyword", with: "親子丼"
    click_button "検索"

    expect(page).to have_content("親子丼の作り方")
    expect(page).to have_content("Cook Channel")

    expect {
      first(".video-item").click_button "保存"
      within first(".video-item") do
        expect(page).to have_button("保存解除")
      end
    }.to change { user.saved_videos.count }.by(1)

    saved_video = user.saved_videos.last
    expect(saved_video.title).to eq("親子丼の作り方")
    expect(saved_video.url).to eq("https://www.youtube.com/embed/abc123def45")
    expect(saved_video.needs_sorting).to eq(true)

    visit saved_videos_path

    expect(page).to have_content("未分類動画")
    expect(page).to have_content("親子丼の作り方")
  end
end
