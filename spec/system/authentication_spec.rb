require 'rails_helper'

RSpec.describe "Authentication", type: :system do
  it "ユーザー登録後にマイページを表示すること" do
    visit new_user_registration_path

    fill_in "user_email", with: "new-user@example.com"
    fill_in "user_password", with: "password123"
    fill_in "user_password_confirmation", with: "password123"
    fill_in "user_nickname", with: "新米ユーザー"
    click_button "ユーザー登録"

    expect(page).to have_content("アカウントを登録しました。")
    expect(page).to have_content("新米ユーザー さん")
    expect(page).to have_content("CookTubeへログイン中です。")
  end

  it "登録済みユーザーがログインしてログアウトできること" do
    user = create(:user, email: "login-user@example.com", nickname: "ログインユーザー")

    visit new_user_session_path

    fill_in "user_email", with: user.email
    fill_in "user_password", with: "password123"
    click_button "ログイン"

    expect(page).to have_content("ログインしました。")
    expect(page).to have_content("ログインユーザー さん")
    expect(page).to have_content("CookTubeへログイン中です。")

    click_link "ログアウト"

    visit mypage_path
    expect(page).to have_content("ログイン")
    expect(page).to have_button("ログイン")
    expect(page).to have_link("新規ユーザー登録")
  end
end
