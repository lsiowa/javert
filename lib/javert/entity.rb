module Javert
  module Entity
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do 
      attribute_method_suffix('', '=', '?')
    end

    module ClassMethods
      def attributes
        @attribute_map.keys ||= Array.new 
      end

      def attribute(name, options={})
        if options.has_key?(:as)
          attribute_map[options[:as].to_s] = name.to_s   # Add to attribute mapping table 
        else
          attribute_map[name.to_s] = name.to_s
        end

        if options.has_key?(:multivalue)
          multivalue_attributes << name.to_s
        end
      end

      def attribute_map
        @attribute_map ||= Hash.new
      end

      def ldap_attributes
        @attribute_map.values
      end

      def multivalue_attributes
        @multivalue_attributes ||= Array.new
      end

      def base
        @base ||= ""
      end

      def set_base(path)
        @base = path
      end

      def object_class
        @objectClass ||= ""
      end     

      def set_object_class(objectClass)
        @objectClass = objectClass
        @classFilter = Net::LDAP::Filter.construct("(objectClass=#{@objectClass})")
      end

      def set_default_filter(defaultFilter)
        @defaultFilter = Net::LDAP::Filter.construct("#{defaultFilter}")
      end

      # Searching
      def find(params={})
        return [] if params.empty?
        
		    filter = @classFilter unless @classFilter.nil?
		    filter = filter & @defaultFilter unless @defaultFilter.nil?

    		if params.has_key?("dn") # This trumps all other filters
    			results = Javert.connection.search(:base => params["dn"], :attributes => ldap_attributes, :filter => filter)
    		else
    			paramsFilter = Net::LDAP::Filter.construct(to_ldap_query(params))
    			filter = filter & paramsFilter unless params.empty?

    			results = Javert.connection.search(:base => @base, :attributes => ldap_attributes, :filter => filter)
    		end
		
    		results.map do |ldap_entity|
              e = self.new # this doesn't feel "right"
              self.attribute_map.each_pair do |p, l|
                if multivalue_attributes.include?(p)
                  # Multivalue
                  e.instance_variable_set("@#{p.to_s}", ldap_entity[l])
                else
                  # Single value
                  e.instance_variable_set("@#{p.to_s}", ldap_entity[l].first.to_s)
                end
              end
              e
            end
      end

      def all
        find
      end

      def find_one
        find.first
      end

      private
      def to_ldap_query(params={})
        ldap_params = {}
        params.each_pair {|k,v| ldap_params[attribute_map[k.to_s].to_s] = v }

        attributes = ldap_params.to_a.map {|e| "(#{e.join('=')})"}.join
        "(&#{attributes})"
      end

    end

    module InstanceMethods
      def initialize(attrs={})
        self.attributes = attrs
      end

      def initialize_from_ldap(attrs={})
        load_from_ldap(attrs)
        self
      end

      def attribute(key)
        instance_variable_get("@#{key}")
      end

      def attribute=(key, value)
        instance_variable_set("@#{key}", value)
      end

      def attribute?(key)
        instance_variable_get("@#{key}").present?
      end

      def attributes
        self.class.attributes
      end

      def attributes=(attrs)
        attrs.each_pair do |k, v|
          if respond_to?("#{k}")
            self.send("#{k}=", v)
          else
            self[k] = v
          end
        end
      end

      private
      def load_from_ldap(attrs)
        return if attrs.blank?
        attrs.each_pair do |k, v|
          if respond_to?("#{k}")
            self.send("#{k}=", v)
          else
            self[k] = v
          end
        end

      end
    end
  end
end
