require "sinatra"
require "./youtube"

get "/" do
  %[
    <script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
    <script src="/app.js"></script>
    <form>
      Search on YouTube
      <input name="q" id="query-field">
      <input type="submit">
    </form>

    <style>
      iframe, img { width: 300px; height: 200px; }
    </style>

    <div id="videos"></div>
  ]
end

get "/app.js" do
  headers["Content-Type"] = "application/javascript"
  File.read "app.js"
end

Contents = {}

post "/search" do
  headers["Content-Type"] = "application/json"
  results = YouTube.search(params[:q])
  results.map do |item|
    Contents[item[:id]] = item.delete(:content)
    item.merge(source_html: "/video/#{item[:id]}/content")
  end.to_json
end

get "/video/:id/content" do
  Contents[params[:id].to_i]
end
