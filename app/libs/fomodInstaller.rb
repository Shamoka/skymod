require './app/libs/installer.rb'

module Skymod
	class FomodInstaller < Installer
		def initialize(game_dir, doc, root, db, modId)
			super game_dir, root, db, modId
			@xml = doc.root
			@name = nil
			@dependecies = Array.new
			@required_files = Array.new
			@install_steps = Array.new
		end

		def prepare
			get_module_name
			get_required_files
			get_install_steps
			@install_steps.each do |is|
				dialog = FomodInstallStepDialog.new(is)
				dialog.run
				dialog.destroy
			end
			return self
		end

		def run
			if (data_dir = Skymod::Dir.no_case_find(@root, "data")).nil?
				dir = @root
			else
				dir = data_dir
			end
			copy_files(dir)
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
