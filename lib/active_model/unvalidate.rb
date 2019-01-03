require "active_model/unvalidate/version"

module ActiveModel
  module Unvalidate
    extend ActiveSupport::Concern

    module ClassMethods
      # Removes specified validations from existing models for a given field
      #
      # @param [Symbol] field the field to remove validations from
      # @param [Array<Symbol> | Symbol] validations validations to remove from field
      #
      # @return nil
      #
      def unvalidates(field, validations)
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
            callback.raw_filter.attributes.include?(field) &&
              validations.include?(extract_validator_name(callback.raw_filter))
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
          is_callback_class?(callback) && callback.raw_filter.attributes.include?(field)
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
          callback.raw_filter == method
        end.each do |callback|
          _validate_callbacks.delete(callback)
        end
      end

      private

      def extract_validator_name(validator)
        validator.class.to_s.demodulize
      end

      def is_callback_class?(callback)
        callback.raw_filter.respond_to?(:attributes)
      end
    end
  end
end
