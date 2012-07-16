module ApplicationHelper

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse(FAYE_SERVER)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def suscribe(channel)
    content = File.read("#{Rails.root}/app/views/shared/javascipts/suscribe.js.erb")
    eruby = Erubis::Eruby.new(content)
    eruby.result(binding()).html_safe
  end

end
