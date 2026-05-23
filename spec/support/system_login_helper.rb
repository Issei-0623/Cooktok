module SystemLoginHelper
  def log_in_as(user, password: "password123")
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: password
    click_button "ログイン"

    expect(page).to have_content("CookTubeへログイン中です。")
  end

  def wait_until
    deadline = Capybara.default_max_wait_time.seconds.from_now

    until yield
      raise RSpec::Expectations::ExpectationNotMetError, "condition was not met" if Time.current > deadline

      sleep 0.1
    end
  end
end
