module ApplicationHelper

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse("http://localhost:5000/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def suscribe(channel)
    %Q(
    $(document).ready(function(){
      faye = new Faye.Client('http://localhost:5000/faye')
      faye.subscribe("#{channel}", function(message){
        eval(message)
        scroll_to_bottom("#messages")
      });
    })
    ).html_safe
  end

end
