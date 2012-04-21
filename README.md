# BloombergQuote

BloombergQuote is Ruby module which getting quotes from Bloomberg site

## Installation

Add this line to your application's Gemfile:

    gem 'bloomberg_quote'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bloomberg_quote

## Usage

```ruby
require 'bloomberg_quote'
# Fetching TOPIX Index quote
quote = BloombergQuote::Quote.new('TPX:IND')
quote.valid?
# => true
quote.data['Price']
# => 813.33
quote.data['Previous Close']
# => 819.27
quote.data['Open']
# => 814.37
# Fetching DUMMY currency
quote = BloombergQuote::Quote.new('DUMMY:CUR')
quote.valid?
# => false
```

## Supported fields

- Price
- Previous Close
- Open

## FAQ

### Where can I find ticker symbols?

You can search them at [Bloomberg](http://www.bloomberg.com/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgement

Code and APIs are inspired by [yahoo_quote](https://github.com/bcarreno/yahoo_quote).
