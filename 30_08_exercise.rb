# frozen_string_literal: true

# Create class UserAPIConsumer to interact with API
class UserAPIConsumer
  require 'faraday'
  require 'zip'
  require 'htmltoword'

  @conn = Faraday.new(url: 'https://6418014ee038c43f38c45529.mockapi.io/api/v1') do |faraday|
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.adapter  Faraday.default_adapter
    faraday.response :json, content_type: /\bjson$/
  end

  def self.users_index(*params)
    users_response = @conn.get '/users', params[0]
    users_response.body
  end

  def self.new_user(*params)
    @conn.post '/users', params[0]
  end

  def self.show_user(id, *params)
    user_response = @conn.get "/users/#{id}", params[0]
    user_response.body
  end

  def self.update_user(id, *params)
    @conn.put "/users/#{id}", params[0]
  end

  def self.delete_user(id)
    @conn.delete "/users/#{id}"
  end

  @current_file_path = File.expand_path(__FILE__)
  @folder = @current_file_path.split('/')[0..-2].join('/')

  @current_time = Time.now
  @formatted_time = @current_time.strftime('%d_%m_%y_%H_%M')

  @docfile_name = "#{@folder}/users_#{@formatted_time}.doc"
  @zipfile_name = "#{@folder}/users_#{@formatted_time}.zip"

  @html_table = <<~HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Users Table</title>
    </head>
    <body>
      <table border="1">
        <thead>
          <tr>
            #{users_index.first.keys.map { |key| "<th>#{key}</th>" }.join("\n")}
          </tr>
        </thead>
        <tbody>
          #{users_index.map { |row| "<tr><td>#{row.values.join('</td><td>')}</td></tr>" }.join("\n")}
        </tbody>
      </table>
    </body>
    </html>
  HTML

  def self.zip_index
    Htmltoword::Document.create_and_save(@html_table, @docfile_name)

    Zip::File.open(@zipfile_name, create: true) do |zipfile|
      zipfile.add("users_#{@formatted_time}.doc", @docfile_name)
    end
  end
end

# List all users
users = UserAPIConsumer.users_index
p users
p users.size

# List active users
active_users = UserAPIConsumer.users_index({ active: true })
p active_users
p active_users.size

# Create a new user
new_user = {
  'created_at' => Time.now,
  'name' => 'Nguyen Khoa Hoang Phuc',
  'avatar' => 'google.com',
  'sex' => 'male',
  'active' => 'true'
}
UserAPIConsumer.new_user(new_user)

# Search users by params
user_search = UserAPIConsumer.users_index({
                                            name: 'Nguyen Khoa Hoang Phuc'
                                          })
p user_search

# Update user to have { active: false }
UserAPIConsumer.update_user(66, { active: false })

# Show user using id
user = UserAPIConsumer.show_user(66)
p user

# Delete user
UserAPIConsumer.delete_user(66)

# List users to .doc file then compress to .zip file
UserAPIConsumer.zip_index
