require "spec_helper"

feature "Authentication" do
  scenario "Unauthenticated users are prompted to log in" do
    get '/default'

    expect(last_response.status).to eq 401
  end

  scenario "Authenticated users are cool" do
    authorize 'test_user', 'test_pass'

    get '/default'

    expect(last_response.status).to eq 200
  end
end
