module Bo
  class <%= options[:namespace].camelize %>Policy < ActionPolicy::Base
    def show?
      true
    end

    def new?
      true
    end

    def edit?
      true
    end

    def create?
      true
    end

    def update?
      true
    end

    def destroy?
      true
    end

    relation_scope(&:all)
  end
end
