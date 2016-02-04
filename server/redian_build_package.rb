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

class Redian::BuildPackage < Object

  include LibXML
  include Redian::BuildLicence

  LOGGER_FILENAME = "/dev/stdout"

  DEFAULT_BUILD_PACKAGE_DIRECTORY = "#{Dir.pwd}/package"

  @@logger = Logger.new(LOGGER_FILENAME)

  @@manager
  
  attr_accessor :filename, :uuid,
                :package_name, :package_version,
                :package_revision, :program_title,
                :program_description, 
                :runtime_dependency, :build_dependency,
                :licence,
                :installed_documentation, :installed_file,
                :binary_tarball, :xml_doc

  class << self

    @@manager = Array.new
    
  end
  
  def initialize(uuid, package_name = nil, package_version = nil, package_revision = 1, program_title = nil, program_description = nil, runtime_dependency = nil, build_dependency = nil, licence = nil, xml_doc = nil)

    super()

    self.filename = "#{DEFAULT_BUILD_PACKAGE_DIRECTORY}/#{package_name}-#{package_version}-#{package_revision}.xml"
    
    # save XML
    if xml_doc == nil
       
       self.xml_doc = LibXML::XML::Document.new
       @xml_doc.root = XML::Node.new('package')
       @xml_doc.root['version'] = "1.0"

       @xml_doc.save(@filename, :indent => true, :encoding => LibXML::XML::Encoding::UTF_8)

    else

      @xml_doc = xml_doc
      
    end

    self.package_name = package_name
    self.package_version = package_version
    self.package_revision = package_revision

    self.program_title = program_title
    self.program_description = program_description
    
    self.uuid = uuid

    self.runtime_dependency = runtime_dependency
    self.build_dependency = build_dependency

    self.licence = licence
    
    self.installed_documentation = Array.new
    self.installed_file = Array.new

    self.binary_tarball = nil

    # add to manager
    @@manager.push(self)
    
  end

  def self.with_defaults

    new(SecureRandom.uuid)
    
  end

  def package_name

    @package_name
    
  end
  
  def package_name=(value)

    @package_name = value
    
    node = XML::Node.new('package-name')
    node.content = value
    @xml_doc.root << node
    
  end

  def package_version

    @package_version

  end
  
  def package_version=(value)

    @package_version = value
    
    if value != nil

      node = XML::Node.new('package-version')
      node.content = value
      @xml_doc.root << node

    end
        
  end

  def package_revision=(value)
    
    @package_revision = value
    
    if value != nil

      node = XML::Node.new('package-revision')
      node.content = value.to_s
      @xml_doc.root << node

    end
    
  end

  def program_title=(value)

    @program_title = value

    if value != nil
      
      node = XML::Node.new('program-title')
      node.content = value
      @xml_doc.root << node

    end
    
  end

  def program_description=(value)
    
    @program_description = value
    
    if value != nil
      
      node = XML::Node.new('program-description')
      node.content = value
      @xml_doc.root << node

    end
        
  end
  
  def uuid=(value)
    
    @uuid = value
    
    if value != nil
      
      node = XML::Node.new('uuid')
      node.content = value
      @xml_doc.root << node
      
    end
    
  end

  def runtime_dependency=(value)

    @runtime_dependency = value
    
    if value != nil
      
      # create parent
      parent = @xml_doc.find('//runtime-dependency', nil)

      if parent == nil
        
        parent = XML::Node.new('runtime-dependency')
        @xml_doc.root << parent

      end

      # write array
      value.each do |current|

        node = XML::Node.new('filename')
        node['uri-ref'] = current
        parent << node

      end
      
    end
    
  end

  def build_dependency=(value)
    
    @build_dependency = value
    
    if value != nil
      
      # create parent
      parent = @xml_doc.find('//build-dependency', nil)

      if parent == nil
        
        parent = XML::Node.new('build-dependency')
        @xml_doc.root << parent

      end

      # write array
      value.each do |current|

        node = XML::Node.new('filename')
        node['uri-ref'] = current
        parent << node

      end

    end
    
  end

  def filename=(value)

    @filename = value
    
  end
    
  def licence=(value)
    
    @licence = value
    
    if value != nil
      
      # create parent
      parent = @xml_doc.find('//licence', nil)
      
      if parent == nil
        
        parent = XML::Node.new('licence')
        @xml_doc.root << parent

      end

      # write 2d array
      value.each do |current|

        case current[0]
        when :REDIAN_BUILD_MIT_LICENCE

          node = XML::Node.new('mit')

        when :REDIAN_BUILD_LGPL_LICENCE

          node = XML::Node.new('lgpl')

        when :REDIAN_BUILD_GFDL_LICENCE

          node = XML::Node.new('gfdl')

        when :REDIAN_BUILD_GPL_LICENCE

          node = XML::Node.new('gpl')

        when :REDIAN_BUILD_AGPL_LICENCE

          node = XML::Node.new('agpl')

        else

          @@logger.warn("unknown copyleft licence #{current[0].to_s}")
          
        end

        
        node['version'] = current[1]
        parent << node

      end

    end
    
  end

  def installed_documentation=(value)

    @installed_documentation = value
    
    if value != nil
      
      # create parent
      parent = @xml_doc.find('//installed-documentation', nil)

      if parent == nil
        
        parent = XML::Node.new('installed-documentation')
        @xml_doc.root << parent

      end

      # write array
      value.each do |current|

        node = XML::Node.new('filename')
        node['uri-ref'] = current
        parent << node

      end

    end
    
  end
  
  def installed_file=(value)

    @installed_file
    
    if value != nil
      
      # create parent
      parent = @xml_doc.find('//installed-file', nil)

      if parent == nil
        
        parent = XML::Node.new('installed-file')
        @xml_doc.root << parent

      end

      # write array
      value.each do |current|

        node = XML::Node.new('filename')
        node['uri-ref'] = current
        
        parent << node
        
      end

    end
    
  end
  
  def binary_tarball=(value)

    @binary_tarball = value
    
    if value != nil
      
      node = XML::Node.new('binary-tarball')
      node.content = value
      @xml_doc.root << node

    end
    
  end
  
  # find a package by matching attribute value
  def self.find(attribute, str)

    retval = nil

    if(attribute != nil &&
       str != nil)
      
      @@manager.each do |current|

        if current.instance_variable_get("@#{attribute}") == str

          if retval == nil

            retval = Array.new
            
          end

          retval.push(current)
          
        end
        
      end

    end
    
    retval
    
  end

  # parse XML file containing package information
  def self.parse_file(filename)

    xml_doc = LibXML::XML::Document::file(filename)
    
    # initialize return value
    retval = nil
    
    if xml_doc.root.name == "package"

      case xml_doc.root.attributes.get_attribute("version")
      when "1.0"
        
        retval = Redian::BuildPackage.new(:uuid => xml_doc.root.attributes.get_attribute("uuid"), :xml_doc => xml_doc)
        
        # parse document
        xml_doc.root.each_element do |current_node|

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

                  retval.runtime_dependency.push(filename_node.attributes.get_attribute("uri-ref"))

                end
                
              end
              
            when "build-dependency"
              
              # build dependency
              current_node.each_element do |filename_node|

                # push uri-ref if available
                if(filename_node.type == ELEMENT_NODE &&
                   filename_node.name == "filename")
                  
                  retval.build_dependency.push(filename_node.attributes.get_attribute("uri-ref"))

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
                      retval.licence.push([:REDIAN_BUILD_MIT_LICENCE, copyleft_node.attributes.get_attribute("version")])
                      
                    when "lgpl"

                      # LGPL licence
                      retval.licence.push([:REDIAN_BUILD_LGPL_LICENCE, copyleft_node.attributes.get_attribute("version")])
                      
                    when "gfdl"

                      # GFDL licence
                      retval.licence.push([:REDIAN_BUILD_GFDL_LICENCE, copyleft_node.attributes.get_attribute("version")])
                      
                    when "gpl"
                      
                      # GPL licence
                      retval.licence.push([:REDIAN_BUILD_GPL_LICENCE, copyleft_node.attributes.get_attribute("version")])
                      
                    when "agpl"

                      # AGPL licence
                      retval.licence.push([:REDIAN_BUILD_AGPL_LICENCE, copyleft_node.attributes.get_attribute("version")])
                      
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
                   
                   retval.installed_documentation.push(filename_node.attributes.get_attribute("uri-ref"))
                   
                 end
                 
               end

             when "installed-file"

               # installed files
               current_node.each_element do |filename_node|

                 # push uri-ref if available
                 if(filename_node.type == ELEMENT_NODE &&
                    filename_node.name == "filename")
                   
                   retval.installed_file.push(filename_node.attributes.get_attribute("uri-ref"))

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
        @@logger.warn("unknown package version #{xml_doc.root.attributes.get_attribute('version')}")
        
      end
      
    else

      # unsupported root node
      @@logger.warn("unsupported root node #{xml_doc.root.name}")
      
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
        @@manager.push(Redian::BuildPackage.parse_file("#{dirname}/#{filename}"))
        
      end
      
    end
    
  end
  
end
