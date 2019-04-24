module Skymod
	class FomodInstallStepRadioButton < Gtk::RadioButton
		type_register

		attr_accessor :files
		attr_reader :description

		def initialize(files, description)
			super()

			@files = files
			@description = description
		end
	end
end
