module ApplicationHelper
  def browser_title_custom(yield_title = nil)
    if @meta.browser_title.present?
      return @meta.browser_title
    end
    [
      yield_title,
      @meta.path,
      Refinery::Core.site_name
    ].reject(&:blank?).join(" | ")
  end

  def lazy_load_images(html, alt_title=nil)
    parsed = Nokogiri::HTML(html)
    parsed.xpath("//img").each_with_index do |img, i|
      img.set_attribute('data-original', "#{::Refinery::Images.config.dragonfly_url_host}#{img['src'].gsub(/http:\/\/[^\/]+/,'')}")
      img.set_attribute('class', 'lazy')
      # img.set_attribute('alt', "#{alt_title}, Image #{i}") unless alt_title.nil?
      img.set_attribute('src', '/assets/gray.gif')
    end
    parsed.to_html
  end

  def get_video_embed_url(html)
    videos = []
    videos.concat(parse_videos(html, 'youtube_short'))
    videos.concat(parse_videos(html, 'youtube'))
    unless videos.blank?
      return "https://www.youtube.com/embed/%s?version=3&enablejsapi=1" % videos[0]['id']
    end
  end

  def get_videos(html)
    videos = []
    videos.concat(parse_videos(html, 'youtube_short'))
    videos.concat(parse_videos(html, 'youtube'))
    videos.concat(parse_videos(html, 'vimeo'))
  end

  def video_embeds(html, width=1280, height=720)
    videos = get_videos(html)

    videos.each do |v|
      case v['type']
      when 'youtube', 'youtube_short'
        embed = '<iframe src="https://www.youtube.com/embed/' + v['id'] + '?controls=0" width="' + width.to_s + '" height="' + height.to_s + '" frameborder="0" allowfullscreen></iframe>'
      when 'vimeo'
        embed = '<iframe src="https://player.vimeo.com/video/' + v['id'] + '" width="' + width.to_s + '" height="' + height.to_s + '" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      end

      embed = '<div class="video-wrap">' + embed + '</div>' if embed

      html.sub!(v['url'], embed)
    end

    html
  end

  # remove video URLs alone on a paragraph for listing views
  def strip_videos(html)
    videos = get_videos(html)
    videos.each do |v|
      html.sub!("<p>#{v['url']}</p>", '')
    end
    html
  end

  def parse_videos(html, type)
    regex = nil
    videos = []

    case type
    when 'youtube_short'
      regex = /\s*(https?:\/\/youtu.be\/([a-zA-Z0-9\-_]+))/i
    when 'youtube'
      regex = /\s*(https?:\/\/www.youtube.com\/watch\?v=([a-zA-Z0-9\-_]+))/i
    when 'vimeo'
      regex = /\s*(https?:\/\/vimeo.com\/([a-zA-Z0-9\-_]+))/i
    end

    if regex
      matches = html.scan(regex)

      matches.each do |match|
        videos << { 'url' => match[0], 'id' => match[1], 'type' => type }
      end
    end

    videos
  end
end