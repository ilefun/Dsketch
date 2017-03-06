

require 'sketchup.rb'
require 'extensions.rb'

su_dreeckvr = SketchupExtension.new "Dsketch", "su_dreamdeck/su_dreamdeck.rb"
su_dreeckvr.copyright= 'Copyright 2010-2016 Dream Deck'
su_dreeckvr.creator= 'Dsketch'
su_dreeckvr.version = '1.3'
su_dreeckvr.description = "让设计更VR"
Sketchup.register_extension su_dreeckvr, true
