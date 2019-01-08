# ActiveModel::Unvalidate

Intended for working with models outside of your control, `ActiveModel::Unvalidate` provides methods for cleanly removing existing `ActiveModel::Validations` validators from existing models. This allows your project to loosen or change the validations to suite the needs of your application without the need to dig into the implmentation details of validations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activemodel-unvalidate', require: 'active_model/unvalidate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activemodel-unvalidate

## Usage

Assume a model exists that you cannot modify its original definition.

```ruby
class Example
  include ActiveModel::Validations

  attr_accessor :name, :email

  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true

  validate :real_email

  private

  def real_email
    unless email =~ /[a-z]+@[a-z]+\.[a-z]{1,5}/
      errors.add(:email, 'is not formatted correctly.')
    end
  end
end
```

With `activemodel-unvalidate` included in your bundle, the `Unvalidate` methods are automatically available to any class that includes `ActiveModel::Validations`. Here you can remove individual validations on specific fields or attributes, such as the length validator on `name`. You can also remove a method-base validation, such as the `real_email` validator.

```ruby
class Example
  unvalidates :name, :length
  unvalidate :real_email
end
```

You can also remove all validations associated to a specific field/attribute.

```ruby
class Example
  unvalidates_all :name
  unvalidates_all :email

  unvalidate :real_email
end
```

This would remove all the validations provided in the example, allowing your application to either redefine new validation rules or leave the model without validations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/weblinc/activemodel-unvalidate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
