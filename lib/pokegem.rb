require 'pokegem/version'
require 'typhoeus'
require 'json'
require 'uri'

module Pokegem
  class Cache
    def initialize
      @memory = {}
    end

    def get(request)
      @memory[request]
    end

    def set(request, response)
      @memory[request] = response
    end
  end

  class << self
    BASE_URL  = 'http://pokeapi.co/api'
    RESOURCES = {
      'v1' => %w(
        pokedex
        pokemon
        move
        ability
        type
        egg
        description
        sprite
        game
      ),
      'v2' => %w(
        berry
        berry-firmness
        berry-flavor
        contest-type
        contest-effect
        super-contest-effect
        encounter-method
        encounter-condition
        encounter-condition-value
        evolution-chain
        evolution-trigger
        generation
        pokedex
        version
        version-group
        item
        item-attribute
        item-category
        item-fling-effect
        item-pocket
        machine
        move
        move-ailment
        move-battle-style
        move-category
        move-damage-class
        move-learn-method
        move-target
        location
        location-area
        pal-park-area
        region
        ability
        characteristic
        egg-group
        gender
        growth-rate
        nature
        pokeathlon-stat
        pokemon
        pokemon-color
        pokemon-form
        pokemon-habitat
        pokemon-shape
        pokemon-species
        stat
        type
        language
      )
    }
    API_VERSIONS = RESOURCES.keys
    DEFAULT_API_VERSION = API_VERSIONS.last # Set last configured API as default

    def resources_hash
      @resource_hash ||= RESOURCES.each { |k,v| RESOURCES[k] = Hash[v.map { |r| [r, {}] }] }
    end

    def get(resource, n = nil, **params)
      resource = resource.to_s
      api_version = (params[:api_version] || DEFAULT_API_VERSION).to_s

      check_api_version!(api_version)
      check_resource!(resource, api_version)

      request_parameters = URI.encode_www_form(params.reject { |k| k == :api_version } || {})

      Typhoeus::Config.cache ||= Cache.new
      Typhoeus.get("#{BASE_URL}/#{api_version}/#{resource}/#{n}?#{request_parameters}", followlocation: true).options[:response_body]
    end

    def get_obj(resource, n = nil, **params)
      resource = resource.to_s
      api_version = (params[:api_version] || DEFAULT_API_VERSION).to_s

      OpenStruct.new(JSON.parse(get(resource, n, params)))
    end

    private
      def is_api_version_valid?(api_version)
        API_VERSIONS.include?(api_version)
      end

      def is_resource_valid_for_api?(resource, api_version)
        resources_hash[api_version].keys.include?(resource)
      end

      def check_api_version!(api_version)
        raise "Invalid API version, select from #{API_VERSIONS.join(', ')} (#{DEFAULT_API_VERSION} by default)" unless is_api_version_valid?(api_version)
      end

      def check_resource!(resource, api_version)
        raise "Invalid resource, select from #{resources_hash[api_version].keys.join(', ')}" unless is_resource_valid_for_api?(resource, api_version)
      end
  end
end
