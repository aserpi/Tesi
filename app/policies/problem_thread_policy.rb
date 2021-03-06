class ProblemThreadPolicy < ApplicationPolicy
  attr_reader :user, :problem_thread

  def initialize(user, problem_thread)
    @user = user
    @problem_thread = problem_thread
  end

  def index?
    show?
  end

  def show?
    !@user.is_a?(Employee) ||
      @user.enterprise == @problem_thread.product.enterprise
  end

  def create?
    @user.is_a?(Consumer) && @problem_thread.product.active
  end

  def update?
    (@user.is_a?(Admin) || @user == @problem_thread.author) &&
      @problem_thread.product.active
  end

  def follow?
    @user.is_a?(Consumer)
  end

  def down?
    (@user.is_a?(Consumer) || (@user.is_a?(Employee) && @user.same_enterprise?(@problem_thread))) &&
      @user != @problem_thread.author &&
      @problem_thread.down_votes.where(downer: @user).empty?
  end

  def down_votes?
    show?
  end

  def search?
    show?
  end

  def up?
    (@user.is_a?(Consumer) || (@user.is_a?(Employee) && @user.same_enterprise?(@problem_thread))) &&
      @user != @problem_thread.author &&
      @problem_thread.up_votes.where(upper: @user).empty?
  end

  def permitted_attributes
    %i[content title]
  end

  class Scope < Scope
    def resolve
      if @user.is_a? Employee
        scope.joins(:product).where('products.enterprise_id' => @user.enterprise.id)
      else
        scope.all
      end
    end
  end
end
