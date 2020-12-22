class StudentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def create?
    index?
  end

  def new?
    create?
  end

  def update?
    user.present? && record.user == user
  end

  def show?
    update?
  end

  def destroy?
    update?
  end
end
