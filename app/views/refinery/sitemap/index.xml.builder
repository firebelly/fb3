xml.instruct!

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:image" => "http://www.google.com/schemas/sitemap-image/1.1" do

  # default Pages sitemap entries
  @locales.each do |locale|
    ::I18n.locale = locale
    ::Refinery::Page.live.in_menu.includes(:parts).each do |page|
     # exclude sites that are external to our own domain.
     page_url = if page.url.is_a?(Hash)
       # This is how most pages work without being overriden by link_url
       page.url.merge({:only_path => false})
     elsif page.url.to_s !~ /^http/
       # handle relative link_url addresses.
       [request.protocol, request.host_with_port, page.url].join
     end

     # Add XML entry only if there is a valid page_url found above.
     xml.url do
       xml.loc refinery.url_for(page_url)
       xml.lastmod page.updated_at.to_date
     end if page_url.present? and page.show_in_menu?
    end
  end

  # add Projects to sitemap
  ::Refinery::Projects::Project.published.each do |project|
    # pull all project images for sitemap
    project_images = []
    parsed = Nokogiri::HTML(project.content)
    parsed.xpath("//img").each_with_index do |img, i|
      project_images.push({ :src => "#{::Refinery::Images.config.dragonfly_url_host}#{img['src'].gsub(/http:\/\/[^\/]+/,'')}", :alt => img['alt'] })
    end

    xml.url do
      xml.loc [request.protocol, request.host_with_port, refinery.projects_project_path(project)].join
      xml.lastmod project.updated_at.to_date
      project_images.each do |image|
        xml.tag!("image:image") do
          xml.tag!("image:loc", image[:src])
          xml.tag!("image:title", image[:alt])
        end
      end
    end
  end

  # add Products to sitemap
  ::Refinery::Products::Product.all.each do |product|
    # pull all product images for sitemap
    product_images = []
    unless product.images.blank?
      product.images.each_with_index do |image, index|
        product_images.push({ :src => image.thumbnail(geometry: :portfolio).convert('-quality 75').url, :alt => [product.title, index].join(" ") })
      end
    end

    xml.url do
      xml.loc [request.protocol, request.host_with_port, refinery.products_product_path(product)].join
      xml.lastmod product.updated_at.to_date
      product_images.each do |image|
        xml.tag!("image:image") do
          xml.tag!("image:loc", image[:src])
          xml.tag!("image:title", image[:alt])
        end
      end
    end
  end

  # add Thoughts to sitemap
  ::Refinery::NewsPosts::NewsPost.published.each do |news_post|
    # pull all post images for sitemap
    news_post_images = []
    unless news_post.image.nil?
      alt = news_post.image_caption.nil? ? '' : news_post.image_caption
      news_post_images.push({ :src => news_post.image.thumbnail(geometry: :portfolio).convert('-quality 75').url, :alt => alt })
    end

    xml.url do
      xml.loc [request.protocol, request.host_with_port, refinery.news_posts_news_post_path(news_post)].join
      xml.lastmod news_post.updated_at.to_date
      news_post_images.each do |image|
        xml.tag!("image:image") do
          xml.tag!("image:loc", image[:src])
          xml.tag!("image:title", image[:alt])
        end
      end
    end
  end

end
