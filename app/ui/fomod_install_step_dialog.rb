module Skymod
	class FomodInstallStepDialog < Gtk::Dialog
		type_register

		attr_reader :files

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

			@files = Array.new

			set_title(installStep.name)

			return if installStep.print(fomodInstallStepListBox) == false

			okButton.signal_connect :clicked do |button|
				fomodInstallStepListBox.children.each do |row|
					row.children.each do |elem|
						if (elem.is_a?(Gtk::RadioButton) or elem.is_a?(Gtk::CheckButton)) and elem.active? and elem.visible?
							elem.files.each do |file|
								@files << file
							end
						end
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
