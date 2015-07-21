Refinery::PagesController.class_eval do

  def show
    @page = Refinery::Page.friendly.find_by_path_or_id(params[:path], params[:id])
    @body_id = @page.slug
    
    if @page.parent
      if @page.parent.slug =~ /people/
        redirect_to "/people##{@page.slug}"
        return
      end
    end
    
    # define subnav elements
    @child_pages = @page.children.where(:show_in_menu => true) unless @page.root?
        
    # add the class and id to give the body tag, based on page ancestor presence
    @body_class = "single"
    @current_section = (@page.parent) ? @page.root.title.parameterize : @page.title.parameterize
    @body_class = (@body_class) ? @body_class << " #{@current_section}" : @current_section
    
    @current_section = 'people' if @body_id =~ /people/
    
    if @body_id =~ /contact/
      @body_id = "contact"
      @current_section = 'contact'
      return render 'contact'
    elsif @body_id =~ /(endeavors|grant-for-good|firebelly-foundation|firebelly-u|reason-to-give)/
      @child_pages = @page.children
      @child_pages = @child_pages.sort { |a,b| b.title <=> a.title }
      @foundation_pages = (Refinery::Page.friendly.find('firebelly-foundation').children).sort { |a,b| a.position <=> b.position }
    end
    
    if @body_id =~ /about/
      @body_id = "about"
      @current_section = 'about'
      doc = Nokogiri::HTML(@page.content_for :side_body)
      @highlights = []
      doc.css('li').each{ |li|
        if li.children.count == 1
          # if there's only one child (all text), simply split on the pipe
          highlight = li.text.split('|')
          @highlights << highlight
        else
          # if we have children, we've got some icky parsing to do
          begin
            # hold all elements (text & html) for later concatenation
            remaining_elements = []
            date = nil

            li.children.each_with_index do |c, index|
              # on first pass, we know we have the date
              if index == 0
                date_parts = c.text.split('|')

                # date is first chunk before the pipe
                date = date_parts[0].strip

                # if text exists after the pipe, add it to array of remaining elements
                if date_parts[1].strip! != ''
                  remaining_elements << date_parts[1].strip
                end
              else
                remaining_elements << c
              end
            end

            remaining_markup = ''

            remaining_elements.each do |re|
              remaining_markup = remaining_markup + ' ' + (re.respond_to?(:to_html) ? re.to_html : re)
            end
          rescue
            date = nil
            remaining_markup = nil
          end

          if (date && remaining_markup)
            highlight = [date, remaining_markup]

            @highlights << highlight
          end
        end

        #@highlights << li.text.split('|')
      }
    end
    
    # if the admin wants this to be a "placeholder" page which goes to its first child, go to that instead.
    if @page.try(:live?) || (refinery_user? && current_user.authorized_plugins.include?("refinery_pages"))
      if @page.skip_to_first_child && (first_live_child = @page.children.order('lft ASC').live.first).present?
        redirect_to first_live_child.url and return
      elsif @page.link_url.present?
        redirect_to @page.link_url and return
      end
    else
      error_404
    end
    
    # present(@page)
    render_with_templates?

  end
  
end
