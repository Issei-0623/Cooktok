require 'rails_helper'

RSpec.describe "Searches", type: :request do
  describe "GET /searches" do
    context "keywordがないとき" do
      it "YouTube APIを呼ばずに検索画面を表示すること" do
        expect(Net::HTTP).not_to receive(:get)

        get searches_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("YouTube Shorts を探す")
      end
    end

    context "keywordがあるとき" do
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
          "nextPageToken" => "NEXT_TOKEN"
        }
      end

      before do
        allow(Net::HTTP).to receive(:get).and_return(api_response.to_json)
      end

      it "検索結果を表示すること" do
        get searches_path, params: { keyword: "親子丼" }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("親子丼の作り方")
        expect(response.body).to include("Cook Channel")
      end

      it "JSONでは検索結果HTMLを返すこと" do
        get searches_path(format: :json), params: { keyword: "親子丼" }

        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["html"]).to include("親子丼の作り方")
        expect(json["html"]).to include("Cook Channel")
      end

      it "次ページ用トークンをセッションに保存すること" do
        get searches_path, params: { keyword: "親子丼" }

        expect(session[:youtube_next_page_token]["親子丼"]).to eq("NEXT_TOKEN")
      end
    end
  end
end
