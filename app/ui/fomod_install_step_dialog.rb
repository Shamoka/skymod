module Skymod
	class FomodInstallStepDialog < Gtk::Dialog
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/FomodInstallStepDialog.ui'

				bind_template_child 'fomodInstallStepListBox'
				bind_template_child 'okButton'
				bind_template_child 'cancelButton'
			end
		end

		def initialize(installStep)
			super()

			@files_array = Array.new

			set_title(installStep.name)

			installStep.print(fomodInstallStepListBox)

			okButton.signal_connect :clicked do |button|
				fomodInstallStepListBox.children.each do |row|
					row.children.each do |elem|
						if elem.is_a?(Gtk::Button) and elem.active? and elem.visible?
							@files_array << elem.files
						end
					end
				end
				@files_array.each do |files|
					files.each do |file|
						puts ("Source: " + file.source)
						puts ("Destination: = Data/" + file.destination)
						puts ("Type: " + file.type.to_s)
					end
				end
				self.response(Gtk::ResponseType::OK)
			end

			cancelButton.signal_connect :clicked do |button|
				self.response(Gtk::ResponseType::CANCEL)
			end
		end
	end
end
