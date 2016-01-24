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
require_relative 'redian_build_licence'

require 'libxml'
require 'logger'

class Redian::BuildPackage < LibXML::XML::Document

  include Redian::BuildLicence

  LOGGER_FILENAME = "/dev/stdout"

  DEFAULT_BUILD_PACKAGE_DIRECTORY = "#{Dir.pwd}/package"

  @@logger = Logger.new(LOGGER_FILENAME)

  @@manager
  
  attr_accessor :uuid,
                :package_name, :package_version,
                :package_revision, :program_title,
                :program_description, 
                :runtime_dependency, :build_dependency,
                :filename, :licence,
                :installed_documentation, :installed_file,
                :xml_doc, :binary_tarball

  class << self

    @@manager = Array.new
    
  end
  
  def initialize(uuid, package_name = nil, package_version = nil, package_revision = 1, program_title = nil, program_description = nil, runtime_dependency = nil, build_dependency = nil, licence = nil)

    @package_name = package_name
    @package_version = package_version
    @package_revision = package_revision

    @program_title = program_title
    @program_description = program_description
    
    @uuid = uuid

    @runtime_dependency = runtime_dependency
    @build_dependency = build_dependency

    @filename = "#{@package_name}-#{package_version}-#{package_revision}.xml"
    @licence = licence
    
    @installed_documentation = Array.new
    @installed_files = Array.new

    @xml_doc = nil
    @binary_tarball = nil

    @@manager.push(self)
    
  end

  def self.with_defaults

    new(SecureRandom.uuid)
    
  end

  # find a package by matching attribute value
  def self.find(attribute, str)

    retval = nil
    
    @@manager.each do |current|

      if current.send(attribute) == str

        if retval == nil

          retval = Array.new
          
        end

        retval.push(current)
        
      end
      
    end

    retval
    
  end

  # parse XML file containing package information
  def self.parse_file(filename)

    doc = XML::Document.file(filename)
    retval = nil
    
    if doc.root.name == "package"

      case doc.root.attributes.getAttribute("version")
      when "1.0"
        
        retval = Redian::BuildPackage.new(:uuid => doc.root.attributes.getAttribute("uuid"))
        retval.xml_doc = doc
        
        # parse document
        doc.root.each_element do |current_node|

          if current_node.type == ELEMENT_NODE
            
            case current_node.name
            when "package-name"

              # package name
              retval.package_name = current_node.content.strip
              
            when "package-version"

              # package version
              retval.package_version = current_node.content.strip
              
            when "package-revision"

              # package revision
              retval.package_revision = current_node.content.strip
              
            when "program-title"

              # program title
              retval.program_title = current_node.content.strip
              
            when "program-description"

              # program description
              retval.program_description = current_node.content.strip
              
            when "runtime-dependency"

              # runtime dependency
              current_node.each_element do |filename_node|

                # push uri-ref if available
                if(filename_node.type == ELEMENT_NODE &&
                   filename_node.name == "filename")

                  retval.runtime_dependency.push(filename_node.attributes.getAttribute("uri-ref"))

                end
                
              end
              
            when "build-dependency"
              
              # build dependency
              current_node.each_element do |filename_node|

                # push uri-ref if available
                if(filename_node.type == ELEMENT_NODE &&
                   filename_node.name == "filename")
                  
                  retval.build_dependency.push(filename_node.attributes.getAttribute("uri-ref"))

                end
                
              end

            when "filename"
              
              retval.filename = current_node.content.strip
              
            when "licence"
              
              # licenses
              current_node.each_element do |licence_node|
                
                licence_node.each_element do |copyleft_node|

                  # check for know licence
                  if copyleft_node.type == ELEMENT_NODE

                    case copyleft_node.name
                    when "mit"

                      # MIT licence
                      retval.licence.push([:REDIAN_BUILD_MIT_LICENCE, copyleft_node.attributes.getAttribute("version")])
                      
                    when "lgpl"

                      # LGPL licence
                      retval.licence.push([:REDIAN_BUILD_LGPL_LICENCE, copyleft_node.attributes.getAttribute("version")])
                      
                    when "gfdl"

                      # GFDL licence
                      retval.licence.push([:REDIAN_BUILD_GFDL_LICENCE, copyleft_node.attributes.getAttribute("version")])
                      
                    when "gpl"
                      
                      # GPL licence
                      retval.licence.push([:REDIAN_BUILD_GPL_LICENCE, copyleft_node.attributes.getAttribute("version")])
                      
                    when "agpl"

                      # AGPL licence
                      retval.licence.push([:REDIAN_BUILD_AGPL_LICENCE, copyleft_node.attributes.getAttribute("version")])
                      
                    else
                      
                      @@logger.warn("unknown copyleft licence #{copyleft_node.name}")
                      
                    end
                    
                  end
                  
                end
              end
             when "installed-documentation"

               # installed documentation
               current_node.each_element do |filename_node|

                 # push uri-ref if available
                 if(filename_node.type == ELEMENT_NODE &&
                    filename_node.name == "filename")
                   
                   retval.installed_documentation.push(filename_node.attributes.getAttribute("uri-ref"))
                   
                 end
                 
               end

             when "installed-file"

               # installed files
               current_node.each_element do |filename_node|

                 # push uri-ref if available
                 if(filename_node.type == ELEMENT_NODE &&
                    filename_node.name == "filename")
                   
                   retval.installed_file.push(filename_node.attributes.getAttribute("uri-ref"))

                 end
                 
               end

             when "binary-tarball"
               
               retval.binary_tarball = current_node.content.strip
               
             else

               # unknown node
               @@logger.warn("unknown XML node #{current_node.name}")
               
             end
            
          end
          
        end

      else

        # unknown version
        @@logger.warn("unknown package version #{doc.root.attributes.getAttribute('version')}")
        
      end
      
    else

      # unsupported root node
      @@logger.warn("unsupported root node #{doc.root.name}")
      
    end

    retval
    
  end

  # load directory and parse all package related XML files
  def self.load_directory(dirname = DEFAULT_BUILD_PACKAGE_DIRECTORY)

    d = Dir.new(dirname)

    # iterate filenames
    d.each do |filename|

      # check if .xml suffix
      if filename.end_with?(".xml") == true

        # push to manager array
        @@manager.push(Redian::BuildPackage.parse_file(filename))
        
      end
      
    end
    
  end
  
end
