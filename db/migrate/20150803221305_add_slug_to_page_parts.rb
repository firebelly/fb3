class AddSlugToPageParts < ActiveRecord::Migration
  def change
    rename_column :refinery_page_parts, :title, :slug
    add_column :refinery_page_parts, :title, :string

    begin
      ::Refinery::PagePart.all.each do |pp|
        pp.title ||= pp.slug
        pp.slug = pp.slug.downcase.gsub(" ", "_")
        pp.save!
      end
    rescue NameError
      warn "Refinery::PagePart was not defined!"
    end
  end
end