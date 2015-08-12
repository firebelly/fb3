require 'acts_as_indexed'
Refinery::Image.class_eval do
	acts_as_indexed :fields => [:image_name, :image_title, :image_alt]
end
