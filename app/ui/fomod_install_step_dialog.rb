require './app/ui/fomod_install_step_dialog_row.rb'

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

			set_title(installStep.name)

			installStep.optional_file_groups.each do |opt|
				row = FomodInstallStepDialogRow.new(opt)
				fomodInstallStepListBox.add(row)
			end

			okButton.signal_connect :clicked do |button|
				box = fomodInstallStepListBox.children.first.children.first
				box.children.each do |child|
					puts child.label if child.is_a?(Gtk::Button) and child.active?
				end
				self.response(Gtk::ResponseType::OK)
			end

			cancelButton.signal_connect :clicked do |button|
				self.response(Gtk::ResponseType::CANCEL)
			end
		end
	end
end
