class StudentsController < ApplicationController
  before_action :set_student, only: %i[show edit update destroy]

  def index
    @search = Student.where(user: current_user).ransack(params[:q])
    @students = @search.result
    authorize(@students)
  end

  def show; end

  def new
    @student = current_user.students.build
    authorize(@student)
  end

  def edit; end

  def create
    @student = current_user.students.build(student_params)

    if @student.save
      redirect_to(@student, notice: t('controllers.students.created'))
    else
      render(:new)
    end
  end

  def update
    if @student.update(student_params)
      redirect_to(@student, notice: t('controllers.students.updated'))
    else
      render(:edit)
    end
  end

  def destroy
    @student.destroy
    redirect_to(students_url, notice: t('controllers.students.destroyed'))
  end

  private

  def set_student
    @student = Student.find(params[:id])
    authorize(@student)
  end

  def student_params
    params.require(:student).permit(:last_name, :first_name, :middle_name, :gender, :suid)
  end
end
