# frozen_string_literal: true

require 'faraday'

conn = Faraday.new(url: 'https://6418014ee038c43f38c45529.mockapi.io/api/v1') do |faraday|
  faraday.request  :url_encoded
  faraday.response :logger
  faraday.adapter  Faraday.default_adapter
  faraday.response :json, content_type: /\bjson$/
end

# new_user = {
#   'created_at' => Time.now,
#   'name' => 'Nguyen Khoa Hoang Phuc',
#   'avatar' => 'google.com',
#   'sex' => 'male',
#   'active' => 'true'
# }
# create_new_user = conn.post '/users', new_user

# active_users = conn.get '/users', { active: true }
# p active_users.body
# p active_users.body.size

user = conn.get '/users', { name: 'Nguyen Khoa Hoang Phuc' }
p user.body

# update_user = conn.put '/users/30', { active: false }
# p update_user.body

# delete_user = conn.delete 'users/30'
# p delete_user.body
