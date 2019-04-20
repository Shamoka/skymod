module Skymod
	class FileChooser < Gtk::FileChooserDialog
		type_register

		class << self
			def init
				set_template resource: "/org/shamoka/skymod/ui/FileChooser.ui"

				bind_template_child 'fileChooserOKButton'
				bind_template_child 'fileChooserCancelButton'
			end
		end

		def initialize(application)
			super application: application

			set_title 'Skymod: choose file...'

			fileChooserOKButton.signal_connect 'clicked' do |widget|
				puts
			end
		end
	end
end
