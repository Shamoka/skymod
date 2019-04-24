module Skymod
	class FomodInstallStepCheckButton < Gtk::CheckButton
		type_register

		attr_accessor :files
		attr_reader :description

		def initialize(files, description)
			super()

			@files = Array.new
			@description = description
		end
	end
end
