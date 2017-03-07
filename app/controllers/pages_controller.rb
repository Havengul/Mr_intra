class PagesController < ApplicationController
  UID = "efed4ffd11a9e8bf9d09f735c5f63fc0c8ce9a5cd50dbcdfcc95f523e728e71a"
  SECRET = "e34de41c45d7f895c8d7387108d0336c1d6f485e82ffc0ef98481ae6033761f1"
  PROJECTS = ['bootcamp-day-00', 'bootcamp-day-01', 'bootcamp-day-02', 'bootcamp-day-03', 'bootcamp-day-04', 'bootcamp-day-05', 'bootcamp-day-06', 'bootcamp-day-07', 'bootcamp-day-08', 'bootcamp-day-09', 'bootcamp-day-10', 'bootcamp-day-11', 'bootcamp-day-12', 'bootcamp-day-13', 'bootcamp-sastantua', 'bootcamp-match-n-match', 'bootcamp-evalexpr', 'bootcamp-colle-00', 'bootcamp-colle-01', 'bootcamp-colle-02', 'bootcamp-joburg-exam-00', 'bootcamp-joburg-exam-01', 'bootcamp-joburg-exam-02', 'bootcamp-joburg-final-exam', 'bootcamp-bsq']
  def token_get(username)
    client = OAuth2::Client.new(UID, SECRET, site: "https://api.intra.42.fr")
    token = client.client_credentials.get_token
    response = token.get("/v2/users/" + username)
  end

  def validator(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['projects_users'].size-1
      if data_hash['projects_users'][i]['final_mark']
	if data_hash['projects_users'][i]['final_mark'] > 0
	  hold = data_hash['projects_users'][i]['project']['name']
	  hold2 = data_hash['projects_users'][i]['final_mark']
          ret_arr.push("____(" + hold + " with " + hold2.to_s + "%)")
        end
      end
    end
    return ret_arr.to_sentence
  end

  def invalidator(data_hash)
    ret_arr = Array.new()
    for i in 0..data_hash['projects_users'].size-1
      if data_hash['projects_users'][i]['final_mark'] == false || data_hash['projects_users'][i]['final_mark'] == 0
        hold = data_hash['projects_users'][i]['project']['name']
	ret_arr.push("____(" + hold + ")")
      end
    end
    return ret_arr.to_sentence
  end

  def unregistered(data_hash)
    ret_arr = Array.new()
    @test_arr = Array.new()
    for i in 0..PROJECTS.size-1
      if not data_hash['projects_users'].any? {|h| h['project']['slug'] == PROJECTS[i]}
	hold = PROJECTS[i]
	ret_arr.push("____(" + hold + ")")
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

  def get_all_usernames
    my_file = File.open("app/fixtures/userlist/userlist.txt")
    ret_arr = my_file.read.split.sort!
    my_file.close
    return ret_arr
  end

  def users_to_JSON
    usernames = get_all_usernames
    for i in 0..usernames.size-1 
      hold = token_get(usernames[i])
      data_hash = hold.parsed
      File.open("app/fixtures/userlist/" + usernames[i] + ".json","w") do |f|
	f.write(data_hash.to_json)
      end
    end
    return usernames
  end

  def get_user_info(name)
    
  end

  def get_all_user_info_arr
    userlist = get_all_usernames
    mass_info = Array.new()
    for i in 0..userlist.size-1
      file = File.read("app/fixtures/userlist/" + userlist[i] + ".json")
      data_hash = JSON.parse(file)
      mass_info[i][0] = data_hash['login']
      for k in 0..PROJECTS.size-1
	mass_info[i][k + 1] = PROJECTS[k]
      end
    end
    return mass_info
  end

  def shower
    file = File.read("app/fixtures/userlist/" + params[:usernamesearch] + ".json")
    data_hash = JSON.parse(file)
    @first_name = data_hash['first_name']
    @last_name = data_hash['last_name']
    @login = data_hash['login']
    @campus_name = data_hash['campus'][0]['name']
    @intra_link = data_hash['url']
    @level = data_hash['cursus_users'][0]['level']
    @correction_points = data_hash['correction_point']
    @wallet = data_hash['wallet']
    @validated_arr = validator(data_hash)
    @invalidated_arr = invalidator(data_hash)
    @unregistered_arr = unregistered(data_hash)
    @hash = data_hash
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

  def allusers
    userlist = get_all_usernames
    mass_info = Array.new()
    mass_info.push(['Name', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', 'Sast', 'Match', 'Eval', 'Col00', 'Col01', 'Col02', 'Exam00', 'Exam01', 'Exam02', 'FINAL EXAM', 'BSQ'])
    for i in 0..userlist.size-1
      file = File.read("app/fixtures/userlist/" + userlist[i] + ".json")
      temp_info = Array.new()
      data_hash = JSON.parse(file)
      temp_info[0] = data_hash['login']
      for k in 0..PROJECTS.size-1
        if data_hash['projects_users'].any? {|h| h['project']['slug'] == PROJECTS[k]}
          for j in 0..data_hash['projects_users'].size-1
	    if data_hash['projects_users'][j]['project']['slug'] == PROJECTS[k]
	      temp_info << data_hash['projects_users'][j]['final_mark'].to_s
	    end
	  end
	else
	  temp_info << "--"
	end
      end
      mass_info << temp_info
    end
    @test = mass_info
    @list = get_all_usernames
  end

  def refreshusers
    @refreshedusers = users_to_JSON
  end

  def show
    render template: "pages/#{params[:page]}"
  end
end 
