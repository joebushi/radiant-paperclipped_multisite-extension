namespace :radiant do
  namespace :extensions do
    namespace :paperclip_multisite do
      
      desc "Runs the migration of the Paperclip Multisite extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PaperclipMultisiteExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PaperclipMultisiteExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Paperclip Multisite to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[PaperclipMultisiteExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PaperclipMultisiteExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
