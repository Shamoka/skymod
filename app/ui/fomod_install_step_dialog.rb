require './app/ui/fomod_install_step_dialog_row.rb'

module Skymod
	class FomodInstallStepDialog < Gtk::Dialog
		type_register

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/FomodInstallStepDialog.ui'

				bind_template_child 'fomodInstallStepListBox'
			end
		end

		def initialize(installStep)
			super()

			installStep.optional_file_groups.each do |opt|
				row = FomodInstallStepDialogRow.new(opt)
				fomodInstallStepListBox.add(row)
			end
		end
	end
end
