module Skymod
	class FomodInstallStepRadioButton < Gtk::RadioButton
		type_register

		attr_accessor :files

		def initialize(files)
			super()

			@files = files
		end
	end
end
