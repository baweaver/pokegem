require "pokegem/version"
require 'typhoeus'
require 'json'

module Pokegem
  class << self
    BASE_URL  = 'http://pokeapi.co/api/v1'
    RESOURCES = %w(pokedex pokemon move ability type egg description sprite game)

    def init_hash; RESOURCES.reduce({}) { |h, r| h.merge! r => {} } end

    def get(resource, n)
      raise "Invalid resource, select from #{RESOURCES.join(', ')}" unless RESOURCES.include?(resource)
      (@cache ||= init_hash)[resource][n] ||=
        Typhoeus.get("#{BASE_URL}/#{resource}/#{n}", followlocation: true).options[:response_body]
    end

    def get_obj(resource, n)
      (@obj_cache ||= init_hash)[resource][n] ||= OpenStruct.new(JSON.parse(get(resource, n)))
    end
  end
end
