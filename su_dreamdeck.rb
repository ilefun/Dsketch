

require 'sketchup.rb'
require 'extensions.rb'

su_dreeckvr = SketchupExtension.new "DreamDeck VR", "su_dreamdeck/su_dreamdeck.rb"
su_dreeckvr.copyright= 'Copyright 2010-2016 LeFun'
su_dreeckvr.creator= 'www.lefun.com'
su_dreeckvr.version = '0.1'
su_dreeckvr.description = "This tool is used for designers to quickly enjoy the vr of your sketch scene."
Sketchup.register_extension su_dreeckvr, true
