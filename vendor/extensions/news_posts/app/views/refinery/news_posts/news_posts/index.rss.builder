xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    # Required to pass W3C validation.
    xml.atom :link, nil, {
      :href => refinery.news_posts_news_posts_url(format: 'rss'),
      :rel => 'self', :type => 'application/rss+xml'
    }

    # Feed basics.
    xml.title             @page_title
    xml.description       'Firebelly Design News'
    xml.link              refinery.news_posts_news_posts_url(:format => 'rss')

    # News items.
    @news_posts.each do |news_post|
      xml.item do
        xml.title         news_post.title
        xml.link          refinery.news_posts_news_post_url(news_post)
        xml.description   truncate(strip_tags(news_post.content), :length => 250)
        xml.pubDate       news_post.date.to_s(:rfc822)
        xml.guid          refinery.news_posts_news_post_url(news_post)
      end
    end
  end
end
