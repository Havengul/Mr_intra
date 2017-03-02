class PagesController < ApplicationController
  UID = "efed4ffd11a9e8bf9d09f735c5f63fc0c8ce9a5cd50dbcdfcc95f523e728e71a"
  SECRET = "e34de41c45d7f895c8d7387108d0336c1d6f485e82ffc0ef98481ae6033761f1"

  def token_get
    client = OAuth2::Client.new(UID, SECRET, site: "https://api.intra.42.fr")
    token = client.client_credentials.get_token
    usernamesearchvar = params[:usernamesearch]
    response = token.get("/v2/users/" + usernamesearchvar)
  end

  def validator(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['projects_users'].size-1
      if data_hash['projects_users'][i]['validated?'] == true
        ret_arr.push(data_hash['projects_users'][i]['project']['name'])
        ret_arr.last.insert(0, "____(")
        ret_arr.last << " with " + data_hash['projects_users'][i]['final_mark'].to_s + "%)"
      end
    end
    return ret_arr.to_sentence
  end

  def invalidator(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['projects_users'].size-1
      if data_hash['projects_users'][i]['validated?'] == false
        ret_arr.push(data_hash['projects_users'][i]['project']['name'])
        ret_arr.last.insert(0, "____(")
        ret_arr.last << ")"
      end
    end
    return ret_arr.to_sentence
  end

  def achiever(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['achievements'].size-1
      ret_arr.push(data_hash['achievements'][i]['name'])
      ret_arr[i].insert(0, "____(")
      ret_arr[i] << ")"
    end
    return ret_arr.to_sentence
  end

  def titler(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['titles'].size-1
      ret_arr.push(data_hash['titles'][i]['name'])
      ret_arr[i].insert(0, "____(")
      ret_arr[i] << ")"
    end
    return ret_arr.to_sentence
  end

  def partnerer(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['partnerships'].size-1
      ret_arr.push(data_hash['partnerships'][i]['name'])
      ret_arr[i].insert(0, "____(")
      ret_arr[i] << ")"
    end
    return ret_arr.to_sentence
  end

  def shower
    #file = File.read('lchimes.json')
    #data_hash = JSON.parse(file)
    hold = token_get
    if hold.status == 200
      data_hash = hold.parsed
      @first_name = data_hash['first_name']
      @last_name = data_hash['last_name']
      @login = data_hash['login']
      @campus_name = data_hash['campus'][0]['name']
      @intra_link = data_hash['url']
      @level = data_hash['level']
      @correction_points = data_hash['correction_point']
      @wallet = data_hash['wallet']
      @validated_arr = validator(data_hash)
      @invalidated_arr = invalidator(data_hash)
      if data_hash['achievements'].any?
        @achievements = achiever(data_hash)
      else
        @achivements = "none"
      end
      if data_hash['titles'].any?
        @titles = titler(data_hash)
      else
        @titles = "none"
      end
      if data_hash['partnerships'].any?
        @partnerships = partnerer(data_hash)
      else
        @partnerships = "none"
      end
    end
  end

  def allusers
    @test = "hey thats pretty good"
  end

  def show
    render template: "pages/#{params[:page]}"
  end
end 
