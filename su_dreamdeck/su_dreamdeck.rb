$LOAD_PATH.unshift File.dirname(__FILE__.force_encoding('UTF-8'))

require 'sketchup'
require 'su_dreamdeck/cubic_images'
require 'rubygems'
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
				res=dlg.get_element_value('res_input')
	        	vr_image=CubicImage.new(width=res.to_i(),height=res.to_i())
				vr_image.start
				
				img_folder=File.dirname(vr_image.export_list[0])
				zip_file=img_folder+'\\cubic_images.zip'
				upload_response_file=img_folder+'\\upload.log'
				upload_response_file.gsub!('\\', '\\\\\\\\')

				zip_compress_files(vr_image.export_list,zip_file)
				zip_file.gsub!('\\', '\\\\\\\\')
				
				# upload zip file
				upload_succ=upload_zip_file(dlg.get_element_value('userId'),
											dlg.get_element_value('projectId'),
											dlg.get_element_value('projectName'),
											zip_file,
											upload_response_file)
				
				js_command1="$('#uploadResult').val('"+upload_succ.to_s+"');"
				dlg.execute_script(js_command1)
				
				js_command2="$('#img_path').val('"+zip_file+"');"
				dlg.execute_script(js_command2)

				# if upload_succ.to_s == 'true'
				# 	UI.messagebox "上传全景图成功!"
				# end

				# clear temp data
				vr_image.deletedirs img_folder
		        puts "\nRemove lefun tmp folder "+img_folder

		        show
	        end

	        show
	    end

		def upload_zip_file(user_id,proj_id,proj_name,file,upload_log)
			curl_exe=File.dirname(__FILE__.force_encoding('UTF-8'))+'/curl/curl.exe'
			curl_exe.gsub!('/', '\\\\\\\\')
			lefun_url='http://www.dreeck.com/dreamDeck/web/write/dreeck/project/zip/ruby/add'

			cmd='"'+curl_exe+'" -F userId='+user_id+' -F projectId='+proj_id+' -F projectName='+proj_name.force_encoding('UTF-8')+' -F "dreeckProjectZipFile=@'+file.force_encoding('UTF-8')+'" "'+lefun_url+'"'
			cmd=cmd+' > "'+upload_log+'"'

			puts "\n"+'Run '+cmd+' to upload zip file.'
			# stdin,stdout,stderr=Open3.popen3(cmd.encode('gbk'))
			# return true
			# result=system cmd.encode('gbk')
			# return result
			result=system cmd.encode('gbk')
			return result
		end
		
		def zip_compress_files(file_list,zip_file_name)
			zip_exe=File.dirname(__FILE__.force_encoding('UTF-8'))+'/7z/7z.exe'
			zip_exe.gsub!('/', '\\\\\\\\')
			dest_zip=zip_file_name.force_encoding('UTF-8')
			dest_zip.gsub!('\\', '\\\\\\\\')
			cmd='"'+zip_exe+'" a "'+dest_zip+'"'
			
			file_list.each do |filepath|
				source_f=filepath.force_encoding('UTF-8')
				source_f.gsub!('\\', '\\\\\\\\')

				cmd+=' "'+source_f+'"'
			end

			puts "\n"+'Run '+cmd+' to compress files to zip.'
			system cmd.encode('gbk')

			if (!File::exists?(zip_file_name))
				UI.messagebox "生成zip压缩包失败!"	
			end
		end

	end #end DreeckVR class

end #end DreamDeck module

# Get file name of this file
file = File.basename(__FILE__)

# Add menu items
unless file_loaded?(file)
	# Add main menu item
	plugin_menu=UI.menu("Plugins")
	# url_path="C:\\Users\\lefunner\\AppData\\Roaming\\SketchUp\\SketchUp 2014\\SketchUp\\Plugins\\su_dreamdeck\\ui.html"
	url_path="http://www.dreeck.com/dreeck_3/index.htm"
	plugin_menu.add_item("Dsketch") {dreeck_vr=DreamDeck::DreeckVR.new(url_path)}

	file_loaded file
end
