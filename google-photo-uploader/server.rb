# frozen_string_literal: true
require 'bundler/setup'
require 'pry-byebug'
require 'sucker_punch'
require 'sinatra'
require 'httpclient'

credentials = JSON.parse(File.read(File.expand_path('../credentials.json', __FILE__)))

class UploadPhotoJob
  include SuckerPunch::Job

  def upload_photo(credentials, filename, file)
    logger.info "Start uploading to google photo: #{filename}"
    client = HTTPClient.new
    res = client.post_content('https://www.googleapis.com/oauth2/v4/token',
                              client_id: credentials['client_id'],
                              client_secret: credentials['client_secret'],
                              refresh_token: credentials['refresh_token'],
                              grant_type: 'refresh_token')
    access_token = JSON.parse(res)['access_token']

    client.post_content(
      "https://picasaweb.google.com/data/feed/api/user/#{credentials['user_id']}/albumid/default?access_token=#{access_token}",
      file,
      'Content-Type': 'image/jpeg',
      'Content-Length': file.size,
      'Slug' => filename
    )
    logger.info "Uploaded to google photo: #{filename}"
  end

  def perform(credentials, filename, file)
    upload_photo(credentials, filename, file)
  end
end

class LastModification
  @file = File.expand_path('../modifications.json', __FILE__)
  @modification = JSON.parse(File.read(@file))

  def self.get(device)
    @modification[device]
  end

  def self.set(device, modification)
    @modification[device] = modification
    open(@file, 'w') do |f|
      JSON.dump(@modification, f)
    end
  end
end

get '/last_modification' do
  LastModification.get(params[:device])
end

post '/upload' do
  raise 'No file' unless params[:file]
  filename = params[:file][:filename]
  file = params[:file][:tempfile]
  device = params[:device]
  modification = params[:modification]
  LastModification.set(device, modification)
  UploadPhotoJob.perform_async(credentials, filename, file)
  'ok'
end
