require './app/libs/installer.rb'

module Skymod
	class FomodInstaller < Installer
		def initialize(game, mod, db, doc)
			super(game, mod, db)
			@xml = doc.root
			@name = nil
			@dependecies = Array.new
			@required_files = Array.new
			@install_steps = Array.new
			@files_list = Array.new
		end

		def prepare
			get_module_name
			get_required_files
			get_install_steps

			@install_steps.each do |is|
				dialog = FomodInstallStepDialog.new(is)
				if dialog.run == Gtk::ResponseType::OK
					dialog.files.each do |file|
						@files_list << file
					end
				end
				dialog.destroy
			end
			return self
		end

		def run
			puts @root
			@files_list.each do |file|
				if file.type == :folder
					dir = Skymod::Dir.find_dir_no_case(@root, file.source)
					add_files_to_list(@root, dir) if dir
				else
					@installed_files << File.join(@root, file.source)
				end
			end
			copy_files(@root)
		end

		private

		def get_module_name
			@name = @xml.elements['moduleName']
			if not @name
				puts "No moduleName found in ModuleConfig.xml"
			end
			return @name
		end
		
		def get_required_files
			if @xml.elements['requiredInstallFiles']
				@xml.elements['requiredInstallFiles'].each_element('file|folder') do |e|
					@required_files << Skymod::Fomod::File.new(e)
				end
			end
		end

		def get_install_steps
			@xml.elements['installSteps'].each_element('installStep') do |is|
				@install_steps << Skymod::Fomod::InstallStep.new(is)
			end
		end
	end
end
