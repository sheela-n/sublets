#Test sublet
#Created with Sur-0.1
require 'rss'
require 'yaml'

configure :rssfeeds do |s|
s.interval = s.config[:interval]  || 15
s.foreground = "#a0a0a0"
end


on :mouse_down do |s, x, y, button|
    t = Thread.new {system %@chromium-browser "#{s.link}"@}
        Thread.pass (t)
        end

on :run do |s|
  sites = { "GoogleIndia" => "http://news.google.com/news?ned=in&topic=n&output=rss",
          "Google" => "http://news.google.com/?output=rss",
          "CNET" => "http://feeds.feedburner.com/cnet/NnTv?format=xml",
          "Infowars" => "http://www.infowars.com/feed",
          "TOI" => "http://dynamic.feedsportal.com/pf/555218/http://toi.timesofindia.indiatimes.com/rssfeedstopstories.cms",
          "Security" => "http://news.cnet.com/8300-1009_3-83.xml?tag=postrtcol;about",
          "Reuters" => "http://feeds.reuters.com/reuters/MostRead ",
          "Reuters World" => "http://feeds.reuters.com/Reuters/worldNews"
          }

  yml = ".#{File.basename(__FILE__,".rb")}"
  counter = if  File.exists?(yml)
            YAML::load(File.read(yml))
            else
              0
  end

  unless sites.length.to_i > counter.to_i
    counter = 0
  end

  url = sites.values[counter.to_i].to_s
    open(url) do |rss|
       RSS::Parser.parse(rss).items.each do |item|
       s.data = "#{sites.keys[counter]}:#{item.title}"
       s.link = item.link
    end
  end

  counter += 1

  File.open(yml,'w') do |file|
    file.puts counter.to_yaml
    end

  end
