require 'rubygems'
require 'net/ldap'
require 'set'
require 'active_model'
require 'active_support/all'

module Javert
	extend ActiveSupport::Concern
  
  autoload :Connection, 'javert/connection'
  autoload :Entity, 'javert/entity'

  extend Connection
end
