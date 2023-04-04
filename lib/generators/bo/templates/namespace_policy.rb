# frozen_string_literal: true

module Bo
  class <%= options[:namespace].camelize %>Policy < ActionPolicy::Base
    def show?
      raise "Add custom policy scope in #{__FILE__}"
    end

    def new?
      raise "Add custom policy scope in #{__FILE__}"
    end

    def edit?
      raise "Add custom policy scope in #{__FILE__}"
    end

    def create?
      raise "Add custom policy scope in #{__FILE__}"
    end

    def update?
      raise "Add custom policy scope in #{__FILE__}"
    end

    def destroy?
      raise "Add custom policy scope in #{__FILE__}"
    end

    relation_scope(&:all)
  end
end
