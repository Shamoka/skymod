require 'sqlite3'

module Skymod
	class Application < Gtk::Application
		attr_accessor :db
		attr_accessor :current_game

		def initialize
			super 'org.shamoka.skymod', Gio::ApplicationFlags::FLAGS_NONE

			@db = Skymod::DB.new
			@current_game = nil

			signal_connect :activate do |application|
				window = Skymod::ApplicationWindow.new(application)
				window.present
			end
		end
	end
end
