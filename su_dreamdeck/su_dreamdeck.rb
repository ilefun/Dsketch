
require 'sketchup'
require 'su_dreamdeck/cubic_images'
require 'rubygems'
require 'zip'
## Wrap into main module

module DreamDeck


  	# Creates new class
	class DreeckVR < UI::WebDialog


	      # Initialize class and callbacks
	      def initialize(html_ui_path)                              
	        ## Set some variables

	        # Get platform info
	        @dreeck_su_os = (Object::RUBY_PLATFORM =~ /mswin/i) ? 'windows' :
	          ((Object::RUBY_PLATFORM =~ /darwin/i) ? 'mac' : 'other')

	        ## Set up the WebDialog
	      	@default_width,@default_height=400,800
	        super "Dsketch", false, "DreamdeckVR", @default_width, @default_height, 100, 100, false
	        print "Load "+html_ui_path

	        if html_ui_path.start_with?("http")
	        	set_url(html_ui_path)
	        else
		        set_file(html_ui_path)
		    end
	        set_size @default_width,@default_height

	        add_action_callback('gen_image') do |dlg, params|
	        	begin
		        	#get resolution from ui
		        	res=dlg.get_element_value('res_input')
		        	vr_image=Dreeck_CubicImage::CubicImage.new(width=res.to_i(),height=res.to_i())
					vr_image.start

		        rescue
		        	vr_image=Dreeck_CubicImage::CubicImage.new()
					vr_image.start

		        end

				
				img_folder=File.dirname(vr_image.export_list[0])
				zip_file=img_folder+'\\cubic_images.zip'
				zip_compress_files(vr_image.export_list,zip_file)
				zip_file.gsub!('\\', '\\\\\\\\')

				js_command="$('#img_path').val('"+zip_file+"');"
				dlg.execute_script(js_command)
    			# UI.messagebox "You have exported the following files:\n"+img_folder+ "\nImage Export Successful!"

	        end

	        show
	    end

		def zip_compress_files(file_list,zip_file_name)
		    Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
		      file_list.each do |filepath|
		        # Two arguments:
		        # - The name of the file as it will appear in the archive
		        # - The original file, including the path to find it
		        filename=File.basename(filepath)
		        zipfile.add(filename, filepath)
		      end
		    end
		end

	end #end DreeckVR class

end #end DreamDeck module

# Get file name of this file
current_ruby_file = File.basename(__FILE__)

# Add menu items
unless file_loaded?(current_ruby_file)
	# Add main menu item
	plugin_menu=UI.menu("Plugins")
	# url_path="D:\\dreeck_vr\\server_ui\\ui.html"
	url_path="http://www.dreeck.com/dreeck/index.htm"
	plugin_menu.add_item("Dsketch") {dreeck_vr=DreamDeck::DreeckVR.new(url_path)}

	file_loaded current_ruby_file
end