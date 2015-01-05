require 'json'
require 'faraday'
require 'slim'
require 'sinatra'


class MyApp < Sinatra::Base
  def request_yesno(answer = :maybe, forced = true)
    unless %w(yes no maybe).map(&:to_sym).include?(answer)
      fail ArgumentError, 'it should contains a "yes", "no" or "maybe"'
    end

    # forced = false if answer.eql(:maybe)

    base_url = 'http://yesno.wtf'
    faraday = Faraday::Connection.new(url: base_url)

    response = faraday.get('/api', answer: answer.to_s, forced: forced)
    JSON.parse(response.body)
  end

  helpers do
    def img_tag_for(src_url = '')
      img_tag = ''
      img_tag << '<img src="'
      img_tag << src_url
      img_tag << '" />'
      img_tag
    end
  end

  get '/?' do
    response = request_yesno
    @answer = response['answer'].upcase
    @yesno_img = response['image']
    slim :index
  end
end
