Refinery::PageImages.configure do |config|
  config.enable_for = [
  	{:model=>"Refinery::Page", :tab=>"Refinery::Pages::Tab"}, 
  	{:model=>"Refinery::Products::Product", :tab=>"Refinery::Products::Tab"}
  ]
  # config.captions = false
  # config.wysiwyg = true
end