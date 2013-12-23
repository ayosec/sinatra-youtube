
require "json"
require "httparty"
require "cgi"

module YouTube

  extend self

  def make_id
    @last_id ||= 0
    @last_id = @last_id + 1
  end

 def search(query)
    response = HTTParty.get("http://gdata.youtube.com/feeds/videos?vq=#{CGI.escape(query)}&max-results=50&alt=json")
    JSON.parse(response.body)["feed"]["entry"].map do |entry|
      {
        id: make_id(),
        link: (l = entry["link"].find {|link| link["type"] == "text/html"} and l["href"]),
        title: entry["title"]["$t"],
        thumbnail: entry["media$group"]["media$thumbnail"][0]["url"],
        content: %[<iframe src="#{entry["media$group"]["media$content"][0]["url"]}"></iframe>]
      }
    end
  end

end
