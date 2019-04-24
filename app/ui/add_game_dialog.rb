module Skymod
	class AddGameDialog < Gtk::Dialog
		type_register

		attr_accessor	:name
		attr_accessor	:path

		class << self
			def init
				set_template resource: '/org/shamoka/skymod/ui/AddGameDialog.ui'

				bind_template_child 'buttonAdd'
				bind_template_child 'buttonCancel'
				bind_template_child 'gameName'
				bind_template_child 'gamePath'
			end
		end

		def initialize
			super()

			@path = nil
			@name = nil

			set_title('Add Game')

			buttonAdd.signal_connect :clicked do |widget|
				@name = gameName.buffer.text
				self.response(Gtk::ResponseType::OK) if @path
			end

			buttonCancel.signal_connect :clicked do |widget|
				self.response(Gtk::ResponseType::CANCEL)
			end

			gamePath.signal_connect 'file-set' do |widget|
				@path = widget.filename
			end
		end
	end
end
