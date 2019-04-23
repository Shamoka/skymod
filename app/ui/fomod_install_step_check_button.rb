module Skymod
	class FomodInstallStepCheckButton < Gtk::CheckButton
		type_register

		attr_accessor :files

		def initialize(files)
			super()

			@files = Array.new
		end
	end
end
