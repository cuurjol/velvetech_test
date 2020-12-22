class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    update?
  end

  def edit?
    update?
  end

  def update?
    user.present? && user == record
  end
end
