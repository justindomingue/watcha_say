# WatchaSay

Question classifier gem that determines the type of question and the type of answer.

Classifier | Feature | Accuracy
---------- | ------- | ---------|
Naives Bayes | Unigram | 61.40% (**Very poor**)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watcha_say'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watcha_say

## Usage

### Instantiating a classifier

    # Create classifier for the naive bayes implementation
    ws = WatchaSay::BayesClassifier.new

### Training the classifier

    # Train the classifier by providing a `type` and `question`
    # ws.train(type, question)
    ws.train('DESC:manner', 'How did serfdom develop in and then leave Russia ?')

    # Train the classifier by providing a formatted file
    # each line of `file` has format 'type:subtype question'
    # for example: 'LOC:state What sprawling U.S. state boasts the most airports ?'
    ws.train('filename')

### Classify questions

    # ws.classify(question)
    ws.classify('What is titanium ?') # => DESC:def

### Persistence

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/watcha_say/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
