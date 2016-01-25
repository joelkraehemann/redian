# coding: utf-8

# Redian-Build-Server - Interactive build server written in Ruby
# Copyright (C) 2016 Joël Krähemann
#
# This file is part of redian-client.
#
# Redian-Client is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Redian-Client is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Redian-Client.  If not, see <http://www.gnu.org/licenses/>.

$LOAD_PATH << '..'
$LOAD_PATH << '.'

require_relative '../redian'
require_relative 'redian_build_package'
require_relative 'redian_build_command'

require 'tty-prompt'
require 'securerandom'

class Redian::BuildServer < Object

  include Redian
  include Redian::BuildCommand

  DEFAULT_WARRANTY = "#{Dir.pwd}/gpl-preamble.txt"
  DEFAULT_COPYLEFT = "#{Dir.pwd}/gpl.txt"

  DEFAULT_SHELL = "/bin/bash"
  
  attr_accessor :build_cycle, :show_menu,
                :build_package


  # default constructor
  def initialize(show_menu = true)

    @show_menu = show_menu
    
    @build_cycle = :SHOW_BUILD_COMMAND

    @build_package = nil
    Redian::BuildPackage.load_directory
    
  end

  # show menu
  def do_show_menu
    
    case @build_cycle
    when :SHOW_BUILD_COMMAND

      prompt = TTY::Prompt.new
      
      # shows build commands as menu
      @build_cycle = prompt.select("how do you like to proceed?") do |menu|
        
        menu.choice 'show build command', :SHOW_BUILD_COMMAND
        menu.choice 'Quit', :QUIT
        menu.choice 'show warranty', :WARRANTY
        menu.choice 'show copyleft', :COPYLEFT
        menu.choice 'open existing package', :OPEN_PACKAGE
        menu.choice 'start new package', :NEW_PACKAGE
        menu.choice 'do PTY session', :PTY_SESSION
        menu.choice 'build package', :BUILD_PACKAGE
        menu.choice 'show packages', :BROWS_BUILDS
        menu.choice 'edit build', :EDIT_BUILD
        
      end

      # confirm quit if necessary
      if @build_cycle == :QUIT

        prompt = TTY::Prompt.new
        
        # leave session
        confirm_quit = prompt.no?("do you really want to quit? (y/N) ")
        
        if confirm_quit == true
          
          @build_cycle = :SHOW_BUILD_COMMAND
          
        end
        
      end
      
    when :WARRANTY

      STDOUT << File.new(DEFAULT_WARRANTY).read

      prompt = TTY::Prompt.new
      
      # confirm UP
      confirm_up = prompt.yes?("leave warranty? (Y/n) ")

      if confirm_up == true
        
        @build_cycle = :SHOW_BUILD_COMMAND
        
      end
      
    when :COPYLEFT

      STDOUT << File.new(DEFAULT_COPYLEFT).read

      prompt = TTY::Prompt.new

      # confirm UP
      confirm_up = prompt.yes?("leave copyleft? (Y/n) ")
      
      if confirm_up == true
        
        @build_cycle = :SHOW_BUILD_COMMAND
        
      end

    when :OPEN_PACKAGE

      attribute = nil
      str = nil

      package_arr = nil
      package = nil
      
      success = false

      # ask attribute
      prompt = TTY::Prompt.new

      attribute = prompt.select("What attribute do you like to lookup?") do |menu|
        
        menu.choice 'uuid', :uuid
        menu.choice 'package name', :package_name
        menu.choice 'package version', :package_version
        menu.choice 'program title', :package_title
        menu.choice 'program description', :program_description
        
      end

      # ask attribute
      prompt = TTY::Prompt.new

      str = prompt.ask("Enter the search term? ")
      str.chomp!
      
      # retrieve suiting packages as array
      package_arr = Redian::BuildPackage.find(attribute, str)

      if package_arr != nil
        # ask value
        prompt = TTY::Prompt.new

        package = prompt.select("Select of matching packages?") do |menu|
          
          package_arr.each do |current|

            tmp = sprintf("%s-%d\t%s\t\t\t\t\t%s", current.package_version, current.package_revision, current.package_name, current.uuid)
            menu.choice tmp, current.uuid
            
          end
          
        end
        
      end

      # set build package
      if package != nil

        @build_package = package
        success = true
        
      end
      
      if success == true

        @build_cycle = :EDIT_BUILD

      else
        
        @build_cycle = :SHOW_BUILD_COMMAND

      end
      
    when :NEW_PACKAGE

      package_name = nil
      package_version = nil
      
      # ask package name
      prompt = TTY::Prompt.new

      package_name = prompt.ask("New package name? ")
      package_name.chomp!
      
      # ask package version
      prompt = TTY::Prompt.new

      package_version = prompt.ask("New package version? ")
      package_version.chomp!
      
      if (package_name != nil &&
          package_version != nil)

        @build_package = Redian::BuildPackage.new(SecureRandom.uuid(), package_name, package_version)

        @build_cycle = :EDIT_BUILD
        
      else

        @build_cycle = :SHOW_BUILD_COMMAND
        
      end

    when :EDIT_BUILD

      do_edit_build = true

      while do_edit_build == true

        # show build package fields
        prompt = TTY::Prompt.new

        package_field = prompt.select("Edit package field with uuid='#{@build_package.uuid}'") do |menu|

          # package name
          tmp = sprintf("name:\t\t\t%s", @build_package.package_name)
          menu.choice tmp, Redian::BuildPackage::package_name

          # package version
          tmp = sprintf("version:\t\t\t%s", @build_package.package_version)
          menu.choice tmp, Redian::BuildPackage::package_version

          # package revision
          tmp = sprintf("revision:\t\t\t%d", @build_package.package_revision)
          menu.choice tmp, Redian::BuildPackage::

          # program title
          tmp = sprintf("title:\t\t\t%s", @build_package.program_title)
          menu.choice tmp, Redian::BuildPackage::program_title

          # program description
          tmp = sprintf("description:\n%s", @build_package.program_description)
          menu.choice tmp, Redian::BuildPackage::program_description

          # runtime dependency
          tmp = "runtime dependency:\n"
          tmp += "#{@build_package.program_description}"
          
          menu.choice tmp, Redian::BuildPackage::runtime_dependency

          # build dependency
          tmp = "build dependency:\n"

          @build_package.build_dependency.each do |current|

            tmp += "#{current}\n"
            
          end
          
          menu.choice tmp, Redian::BuildPackage::build_dependency

          # licence
          tmp = "licences:\n"

          @build_package.licence.each do |current|
            
            tmp += "#{current[0].to_s} Version #{current[1]}\n"
            
          end
          
          menu.choice tmp, Redian::BuildPackage::licence

          # build dependency
          tmp = "documentation:\n"

          @build_package.installed_documentation.each do |current|

            tmp += "#{current}\n"
            
          end
          
          menu.choice tmp, Redian::BuildPackage::installed_documentation

          # build dependency
          tmp = "files:\n"

          @build_package.installed_file.each do |current|

            tmp += "#{current}\n"
            
          end
          
          menu.choice tmp, Redian::BuildPackage::installed_file

          menu.choice "Cancel", nil

        end


        case package_field
        when Redian::BuildPackage::package_name

          prompt = TTY::Prompt.new
          value = prompt.ask("new name? ")

          @build_package.package_name = value
          
        when Redian::BuildPackage::package_version

          prompt = TTY::Prompt.new
          value = prompt.ask("new version? ")

          @build_package.package_version = value
          
        when Redian::BuildPackage::package_revision

          prompt = TTY::Prompt.new
          value = prompt.ask("new revision? ")

          @build_package.package_revision = value.to_i
          
        when Redian::BuildPackage::program_title

          prompt = TTY::Prompt.new
          value = prompt.ask("new revision? ")

          @build_package.program_title = value
          
        when Redian::BuildPackage::program_description

          prompt = TTY::Prompt.new
          value = prompt.multiline("new description?\n")

          @build_package.program_description = value.split(/\n/)
          
        when Redian::BuildPackage::runtime_dependency

          prompt = TTY::Prompt.new
          value = prompt.multiline("new runtime dependency?\n")

          @build_package.runtime_dependency = value.split(/\n/)
          
        when Redian::BuildPackage::build_dependency

          prompt = TTY::Prompt.new
          value = prompt.multiline("new build dependency?\n")

          @build_package.build_dependency = value.split(/\n/)
          
        when Redian::BuildPackage::installed_documentation

          prompt = TTY::Prompt.new
          value = prompt.multiline("new installed documentation?\n")

          @build_package.installed_documentation = value.split(/\n/)
          
        when Redian::BuildPackage::installed_file

          prompt = TTY::Prompt.new
          value = prompt.multiline("new installed file?\n")

          @build_package.installed_file = value.split(/\n/)
          
        else
          
          do_edit_build = false
          
        end
        
      end
      
      @build_cycle = :SHOW_BUILD_COMMAND
      
    when :PTY_SESSION

      # TODO:JK: implement me
      @build_cycle = :SHOW_BUILD_COMMAND
      
    when :BUILD_PACKAGE

      # TODO:JK: implement me
      @build_cycle = :SHOW_BUILD_COMMAND
      
    else

      prompt = TTY::Prompt.new
      
      prompt.yes?("didn't understand input. Continue. ")

      @build_cycle = :SHOW_BUILD_COMMAND
      
    end

    true
    
  end

  def do_interactive

    
    
  end
  
  def show_build_command

    STDOUT << "Redian-Build-Server  Copyright (C) 2016  Joël Krähemann"
    STDOUT << "This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'."
    STDOUT << "This is free software, and you are welcome to redistribute it"
    STDOUT << "under certain conditions; type `show c' for details."

  end

  def run    
    
    while(@build_cycle == nil ||
          @build_cycle != :QUIT)

      if show_menu

        do_show_menu
        
      else
        
        do_interactive
        
      end
      
    end

  end
  
end
