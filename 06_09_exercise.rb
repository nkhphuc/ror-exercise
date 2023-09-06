# frozen_string_literal: true

# Create class DataFaker to fake data
class DataFaker
  require 'faker'
  require 'csv'

  @users = [
    { name: 'created_at', faker: -> { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) } },
    { name: 'name', faker: -> { Faker::Name.name } },
    { name: 'avatar', faker: -> { Faker::Avatar.image } },
    { name: 'sex', faker: -> { Faker::Gender.binary_type } },
    { name: 'active', faker: -> { Faker::Boolean.boolean(true_ratio: 0.5) } }
  ]

  def self.create_users_csv
    CSV.open('users.csv', 'a', col_sep: ';') do |csv|
      csv << @users.map { |field| field[:name] }
      (1..10).each do |_i|
        csv << @users.map { |field| field[:faker].call }
      end
    end
  end
end

# Create a module to split the class into many modules
module Connection
  require 'faraday'
  require 'json'

  @@conn = Faraday.new(url: 'https://6418014ee038c43f38c45529.mockapi.io/api/v1') do |faraday|
    faraday.adapter  Faraday.default_adapter
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.response :raise_error
    faraday.response :json, content_type: /\bjson$/
  end

  def users_index(*params)
    res = @@conn.get '/users', params[0]
    res.body
  rescue StandardError => e
    puts e.message
    puts e.response[:status]
    puts e.response[:body]
  end

  def new_user(*params)
    res = @@conn.post '/users', params[0].to_json, { 'Content-Type' => 'application/json' }
    puts 'User created successfully!'
    puts res.status
    puts res.body
  rescue StandardError => e
    puts e.message
    puts e.response[:status]
    puts e.response[:body]
  end

  def show_user(id, *params)
    res = @@conn.get "/users/#{id}", params[0]
    res.body
  rescue StandardError => e
    puts e.message
    puts e.response[:status]
    puts e.response[:body]
  end

  def update_user(id, *params)
    res = @@conn.put "/users/#{id}", params[0].to_json, { 'Content-Type' => 'application/json' }
    puts 'User updated successfully!'
    puts res.status
    puts res.body
  rescue StandardError => e
    puts e.message
    puts e.response[:status]
    puts e.response[:body]
  end

  def delete_user(id)
    res = @@conn.delete "/users/#{id}"
    puts 'User deleted successfully'
    puts res.status
    puts res.body
  rescue StandardError => e
    puts e.message
    puts e.response[:status]
    puts e.response[:body]
  end
end

# Create class UserAPIConsumer to interact with API
class UserAPIConsumer
  extend Connection
  require 'zip'
  require 'caracal'
  require 'google_drive'
  require 'csv'

  @current_file_path = File.expand_path(__FILE__)
  @folder = @current_file_path.split('/')[0..-2].join('/')

  @current_time = Time.now
  @formatted_time = @current_time.strftime('%d_%m_%y_%H_%M')

  @file_name = "users_#{@formatted_time}"

  @docx_file_name = "#{@file_name}.docx"
  @zip_file_name = "#{@file_name}.zip"

  @docx_file_path = "#{@folder}/#{@docx_file_name}"
  @zip_file_path = "#{@folder}/#{@zip_file_name}"
  @csv_file_path = "#{@folder}/users.csv"

  @session = GoogleDrive::Session.from_config('config.json')

  def self.create_docx
    docx = Caracal::Document.new(@docx_file_name)
    docx.table [users_index.first.keys, *users_index.map(&:values)] do
      border_color   '666666'
      border_line    :double
      border_size    10
      border_spacing 10
    end
    docx.save
  end

  def self.zip_then_upload
    create_docx

    Zip::File.open(@zip_file_path, create: true) do |zip_file|
      zip_file.add(@docx_file_name, @docx_file_path)
    end

    @session.upload_from_file(@zip_file_path, @zip_file_name, convert: false)
  end

  def self.check_drive
    @session.files.each do |file|
      p file.title
    end
  end

  def self.update_file(file_name, file_path)
    updating_file = @session.file_by_title(file_name)
    updating_file.update_from_file(file_path)
  end

  def self.import_csv
    csv = CSV.read(@csv_file_path, col_sep: ';', headers: true)
    csv.map(&:to_hash).each do |user|
      user_search = users_index({ name: user['name'] })
      user['active'] = user['active'].downcase == 'true'
      if user_search.empty?
        new_user(user)
      else
        update_user(user_search[0]['id'], user)
      end
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
  'active' => true
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
UserAPIConsumer.delete_user(157)

# List users to .doc file, then compress to .zip file,
#   then upload to Google Drive
UserAPIConsumer.zip_then_upload

# Check files on Google Drive
UserAPIConsumer.check_drive

# Create users csv file
DataFaker.create_users_csv

# Import or update users from CSV file
UserAPIConsumer.import_csv
