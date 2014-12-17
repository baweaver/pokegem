# Pokegem

http://pokeapi.co/

Simple to use wrapper for the pokeapi v1, with basic caching

Resources:
```
pokedex, pokemon, move, ability, type, egg, description, sprite, game
```

## Usage
```
Pokegem.get resource, number     # => JSON Response
Pokegem.get_obj resource, number # => OpenStruct from Response
```

## Examples
```
Pokegem.get "pokemon", 25  # => JSON Response containing Pikachu's data
Pokegem.get_obj "type", 10  # => Object containing Fire type's data
```

## Pokéapi v2
According to Pokéapi's creator, Paul Hallet, v1 will be deprecated in January 2015 (http://phalt.co/if-you-have-data-they-will-consume-it/).
After release of v2, this gem will be updated to match the new API.

## Contributing

1. Fork it ( http://github.com/baweaver/pokegem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
