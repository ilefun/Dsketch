
##example
# require 'su_dreamdeck/cubic_images'
# vr_image=Dreeck_CubicImage::CubicImage.new()
# vr_image.start
# print vr_image.export_list.to_s


#
require 'sketchup.rb'
require 'fileutils'

module Dreeck_CubicImage

class CubicImage

### Set Initials values
#========================

attr_reader :export_list

  def initialize(width=800,height=800,image_folder=ENV['TMP'],image_prefix='dreeckvr')
    @out_iamges_path=image_folder+'\\'+image_prefix+'_'+Time.now.to_i.to_s
    FileUtils::mkdir_p @out_iamges_path
    print 'Output images to folder '+@out_iamges_path+" , resolution is "+width.to_s()+"\n"
    
    @width,@height=width,height
    @export_list=[]
    @offset_top=true
    @top_offset=0.0001
    @create_pages=false
  end
#========================

### Get info about current camera
#========================
  def get_alpha 
      model=Sketchup.active_model
      view=model.active_view
      camera=view.camera
      @eye0=camera.eye
      @tgt0=camera.target
      @up0=camera.up
      @fov0=camera.fov
      @ar0=camera.aspect_ratio
      @iw0=camera.image_width
  end # CubicImage.get_alpha
#========================

### Reset camera to alpha values
#========================
  def set_alpha 
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    camera=camera.set @eye0, @tgt0, @up0
    camera.fov=@fov0
    camera.aspect_ratio=@ar0
    camera.image_width=@iw0
  end # CubicImage.set_alpha
#========================

#========================
  def start
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    ptest=camera.perspective?


    if (ptest)
        puts "Perspective Camera.... check."

        shadowinfo = model.shadow_info
        old_sun_shading=shadowinfo['UseSunForAllShading']
        shadowinfo['UseSunForAllShading']=true
        print 'Set [UseSunForAllShading] to true for cubic images'+"\n"

        gen_images
    
        shadowinfo['UseSunForAllShading']=old_sun_shading
        print 'Set [UseSunForAllShading] to old value'+"\n"

    else
          @errorcode=1
          CubicImage::errormsg
    end

  end #### CubicImage.start
#========================


#========================
  def CubicImage::errormsg
    if @errorcode==nil
      UI.messagebox "There has been an unexplained error. Please try again."
    else @errorcode==1
      UI.messagebox "Failure. Camera must be Perspective"
      @errorcode=nil
    end
  exit
  end ### CubicImage.errormsg
#========================

#========================
  def gen_images
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera

    get_alpha  
    
    #Write Image 01
    fname= ( @out_iamges_path + "\\mobile_f.jpg")
    tgt1=[@tgt0.x, @tgt0.y, @eye0.z]
    up1=[0,0,1]
    camera=camera.set @eye0, tgt1, up1
    fov=camera.fov=90
    perspective=true
    ar=camera.aspect_ratio=1.0
    iw=camera.image_width=24.0
    Sketchup.set_status_text "Writing Image 1 of 6"
        view.write_image fname, @width, @height, true, 100
        @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end

    #Write Image 02
    fname= ( @out_iamges_path + "\\mobile_r.jpg")
    rot_deg=-90
    tilt_deg=0
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, zaxis,rot_rad)
    target.transform!(t)
    camera=camera.set eye, target, up
    Sketchup.set_status_text "Writing Image 2 of 6"
      view.write_image fname, @width, @height, true, 100
        @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end
    #Write Image 03
    fname= ( @out_iamges_path + "\\mobile_b.jpg")
    rot_deg=-90.0
    tilt_deg=0.0
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, zaxis,rot_rad)
    target.transform!(t)
    camera=camera.set eye, target, up
    Sketchup.set_status_text "Writing Image 3 of 6"
      view.write_image fname, @width, @height, true, 100
        @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end
    #Write Image 04
    fname= ( @out_iamges_path + "\\mobile_l.jpg")
    rot_deg=-90
    tilt_deg=0
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, zaxis,rot_rad)
    target.transform!(t)
    camera=camera.set eye, target, up
    Sketchup.set_status_text "Writing Image 4 of 6"
      view.write_image fname, @width, @height, true, 100
          @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end
    #Write Image 05
    fname= ( @out_iamges_path + "\\mobile_u.jpg")
    rot_deg=-90
    tilt_deg=0
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, zaxis,rot_rad)
    target.transform!(t)
    camera=camera.set eye, target, up
    rot_deg=0
    tilt_deg=-90 + @top_offset
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, yaxis,tilt_rad)
    target.transform!(t)
    t=Geom::Transformation.rotation( eye, yaxis,tilt_rad)
    up.transform!(t)
    camera=camera.set eye, target, up
    Sketchup.set_status_text "Writing Image 5 of 6"
      view.write_image fname, @width, @height, true, 100
          @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end
    #Write Image 06
    fname= ( @out_iamges_path + "\\mobile_d.jpg")
    rot_deg=0
    tilt_deg=180 - @top_offset
    rot_rad=(Math::PI/180)*rot_deg
    tilt_rad=(Math::PI/180)*tilt_deg
    model=Sketchup.active_model
    view=model.active_view
    camera=view.camera
    eye = camera.eye
    up=camera.up
        xaxis = camera.target - eye
        xaxis.normalize!
        zaxis = camera.up
        yaxis = zaxis * xaxis
    target=camera.target
    t=Geom::Transformation.rotation( eye, yaxis,tilt_rad)
    target.transform!(t)
    t=Geom::Transformation.rotation( eye, yaxis,tilt_rad)
    up.transform!(t)
    camera=camera.set eye, target, up
    status = view.invalidate
    Sketchup.set_status_text "Writing Image 6 of 6"
        view.write_image fname, @width, @height, true, 100
            @export_list.push fname
        if @create_pages == true
          Sketchup.active_model.pages.add File.basename(fname,".*"), use_camera=1
        end
      
    set_alpha
  end ### End go
#========================

end### End class CubicImage

end #end Dreeck_CubicImage
#=============================================================================