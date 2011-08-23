# Javert
A LDAP mapper-ish library to build ruby classes that connect to LDAP objects.

## Why?
Javert was created with a very narrow scope in mind. The initial focus was to be able to pull user and group data out of Active Directory without some of the pain that comes along with querying Active Directory/LDAP. 

## Required knowledge
One should hope to have a basic understanding of LDAP - mainly OU's, objectClasses, attributes.

## Requirements
* ActiveModel 3.0
* ActiveSupport 3.0
* Net-Ldap 0.2-ish

## Installation
TODO

## Usage

An example user class mapping into Active Directory

    class User
      include Javert::Entity
  
      attribute :cn, :as => :full_name
      attribute :givenName, :as => first_name
      attribute :sn, :as => :last_name
      attribute :mail
      
      set_object_class "user" # The actual objectClass in AD/LDAP
      @@conf = { 
        :host => "localhost", 
        :port => "389", 
        :auth => {
          :method => :simple,
          :username => "ldap_user",
          :password => "password"
        }
        :base => "ou=Users"
      }
    end
    
IRB Output

    irb(main):031:0> User.attributes
    => ["location", "hiredate", "title", "id", "last_name", "full_name", "department", "email", "first_name"]
  
    irb(main):032:0> User.ldap_attributes
    => ["l", "hiredate", "title", "employeeid", "sn", "cn", "department", "mail", "givenName"]
  
    irb(main):036:0> User.attribute_map
    => {"location"=>"l", "hiredate"=>"hiredate", "title"=>"title", "id"=>"employeeid", "last_name"=>"sn", "full_name"=>"cn", "department"=>"department", "email"=>"mail", "first_name"=>"givenName"}
  
  

## Problems or Questions?
TODO

## TODO List
* Pull connection information into a common configuration file
* Handle multi-value attributes (memberof, etc.)
* Various other things I can't think of right now
* Should this accept query parameter arrays?
* Better handling of symbols vs strings for keys
