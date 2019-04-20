require 'sqlite3'

module Skymod
	class Application < Gtk::Application
		attr_accessor :db

		def initialize(app_root)
			super 'org.shamoka.skymod', Gio::ApplicationFlags::FLAGS_NONE

			@db = Skymod::DB.new(app_root)

			signal_connect :activate do |application|
				window = Skymod::ApplicationWindow.new(application)
				window.present
			end
		end
	end
end
