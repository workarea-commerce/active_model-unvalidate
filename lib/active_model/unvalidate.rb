require "active_model/unvalidate/version"

module ActiveModel
  module Unvalidate
    extend ActiveSupport::Concern

    module ClassMethods
      # Copies callbacks to subclasses to ensure ancestor validations
      # are not affected by unvalidating.
      #
      def inherited(base)
        base._validate_callbacks = _validate_callbacks.dup
        super
      end

      # Removes specified validations from existing models for a given field
      #
      # @param [Symbol] field the field to remove validations from
      # @param [Array<Symbol> | Symbol] validations validations to remove from field
      #
      # @return nil
      #
      def unvalidates(field, validations = nil)
        return unvalidates_all(field) if validations.nil?

        validations = Array(validations).map do |validation|
          [validation, 'validator'].join('_').classify
        end
        _validators.reject! do |key, validators|
          if field == key
            validators.any? do |validator|
              validations.include?(extract_validator_name(validator))
            end
          end
        end
        _validate_callbacks.select do |callback|
          is_callback_class?(callback) &&
            callback_filter(callback).attributes.include?(field) &&
              validations.include?(extract_validator_name(callback_filter(callback)))
        end.each do |callback|
          _validate_callbacks.delete(callback)
        end
      end

      # Removes all validations from a given field
      #
      # @param [Symbol] field field to remove validations from
      #
      # @return nil
      #
      def unvalidates_all(field)
        _validators.reject! do |key, _|
          key == field
        end
        _validate_callbacks.select do |callback|
          is_callback_class?(callback) && callback_filter(callback).attributes.include?(field)
        end.each do |callback|
          _validate_callbacks.delete(callback)
        end
      end

      # Removes method-based validation
      #
      # @param [Symbol] method name of validation method to remove
      #
      # @return nil
      #
      def unvalidate(method)
        _validate_callbacks.select do |callback|
          callback_filter(callback) == method
        end.each do |callback|
          _validate_callbacks.delete(callback)
        end
      end

      private

      def callback_filter(callback)
        # Rails < 7.1 used raw_filter; Rails 7.1+ uses filter
        callback.respond_to?(:raw_filter) ? callback.raw_filter : callback.filter
      end

      def extract_validator_name(validator)
        validator.class.to_s.demodulize
      end

      def is_callback_class?(callback)
        callback_filter(callback).respond_to?(:attributes)
      end
    end
  end

  Validations.include Unvalidate
end
