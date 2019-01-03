require "test_helper"

class ActiveModel::UnvalidateTest < Minitest::Test
  class BaseExample
    include ActiveModel::Validations
    include ActiveModel::Unvalidate

    attr_accessor :name, :email

    validates :name, presence: true, length: { minimum: 2 }
    validates :email, presence: true

    validate :real_email

    def initialize(attrs = {})
      (attrs || {}).each do |key, value|
        send "#{key}=", value
      end
    end

    def real_email
      unless email =~ /[a-z]+@[a-z]+\.[a-z]{1,5}/
        errors.add(:email, 'is not formatted correctly.')
      end
    end
  end

  class LooseExample < BaseExample
    unvalidates :name, :length
    unvalidate :real_email
  end

  class UnvalidatedExample < BaseExample
    unvalidates_all :name
    unvalidates_all :email
    unvalidate :real_email
  end

  def test_unvalidates
    attributes = { name: 'f', email: 'foobar@weblinc.com' }

    assert(BaseExample.new(attributes).invalid?)
    assert(LooseExample.new(attributes).valid?)

    assert(LooseExample.new(email: 'foobar@weblinc.com').invalid?)
  end

  def test_unvalidate
    attributes = { name: 'foobar', email: 'foobar' }

    assert(BaseExample.new(attributes).invalid?)
    assert(LooseExample.new(attributes).valid?)

    assert(LooseExample.new(name: 'foobar').invalid?)
  end

  def test_unvalidates_all
    assert(BaseExample.new.invalid?)
    assert(UnvalidatedExample.new.invalid?)
  end
end
