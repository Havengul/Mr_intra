class PagesController < ApplicationController
  UID = "efed4ffd11a9e8bf9d09f735c5f63fc0c8ce9a5cd50dbcdfcc95f523e728e71a"
  SECRET = "e34de41c45d7f895c8d7387108d0336c1d6f485e82ffc0ef98481ae6033761f1"

  def token_get
    client = OAuth2::Client.new(UID, SECRET, site: "https://api.intra.42.fr")
    token = client.client_credentials.get_token

    response = token.get("/v2/users/10719")
  end
  def show
    render template: "pages/#{params[:page]}"
  end
  def button_clicked(username)
    hold = token_get

  end
end 
