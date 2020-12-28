require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  render_views

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: 'other-user@example.com') }
  let(:student) { FactoryBot.create(:student, user: user) }
  let(:other_student) { FactoryBot.create(:student, user: other_user) }

  describe '#index' do
    context 'when an authorize user views a list of students' do
      before(:each) do
        FactoryBot.create_list(:student, 3, user: user)
        sign_in(user)
        get(:index)
      end

      it 'returns list of students' do
        expect(assigns(:students)).to_not be_nil
        expect(assigns(:students).count).to eq(3)
      end

      it 'renders index view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
        expect(response.body).to match(I18n.t('students.index.title'))
      end
    end

    context 'when an unauthorized user views a list of students' do
      it 'redirects to new user session view' do
        get(:index)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#new' do
    context "when an authorize user creates a new student's view" do
      before(:each) do
        sign_in(user)
        get(:new)
      end

      it 'assigns new student to @student' do
        expect(assigns(:student)).to_not be_nil
        expect(assigns(:student)).to be_a_new(Student).with(last_name: nil, first_name: nil, middle_name: nil,
                                                            gender: nil, suid: nil)
      end

      it 'renders new view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(response.body).to match(I18n.t('students.new.title'))
      end
    end

    context "when an unauthorized user creates a new student's view" do
      it 'redirects to new user session view' do
        get(:new)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#create' do
    let(:new_student) { FactoryBot.build(:student, user: user) }

    context 'when an authorize user creates a new student' do
      before(:each) { sign_in(user) }

      it 'successfully creates a new record' do
        expect do
          post(:create, params: { student: new_student.attributes.except('user_id', 'created_at', 'updated_at') })
        end.to change { Student.count }.from(0).to(1)
      end

      it 'redirects to show view' do
        post(:create, params: { student: new_student.attributes.except('user_id', 'created_at', 'updated_at') })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(student_path(Student.last))
        expect(flash[:notice]).to eq(I18n.t('controllers.students.created'))
      end
    end

    context 'when an unauthorized user creates a new student' do
      it 'redirects to new user session view' do
        post(:create, params: { student: new_student.attributes.except('user_id', 'created_at', 'updated_at') })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#show' do
    context "when an authorize user views his student's profile" do
      before(:each) do
        sign_in(user)
        get(:show, params: { id: student.id })
      end

      it 'assigns student to @student' do
        expect(assigns(:student)).to_not be_nil
        expect(assigns(:student)).to be_an_instance_of(Student)
        expect(assigns(:student)).to have_attributes(last_name: student.last_name, first_name: student.first_name,
                                                     middle_name: student.middle_name, gender: student.gender,
                                                     suid: student.suid)
      end

      it 'renders show view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
        expect(response.body).to match(I18n.t('students.show.title'))
      end
    end

    context "when an authorize user views someone else's student profile" do
      it 'redirects to student index view' do
        sign_in(user)
        get(:show, params: { id: other_student.id })

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('pundit.student_policy.show?'))
      end
    end

    context "when an unauthorized user views someone else's student profile" do
      it 'redirects to new user session view' do
        get(:show, params: { id: student.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#edit' do
    context "when an authorize user edits his student's profile" do
      before(:each) do
        sign_in(user)
        get(:edit, params: { id: student.id })
      end

      it 'assigns student to @student' do
        expect(assigns(:student)).to_not be_nil
        expect(assigns(:student)).to be_an_instance_of(Student)
        expect(assigns(:student)).to have_attributes(last_name: student.last_name, first_name: student.first_name,
                                                     middle_name: student.middle_name, gender: student.gender,
                                                     suid: student.suid)
      end

      it 'renders edit view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(response.body).to match(I18n.t('students.edit.title'))
      end
    end

    context "when an authorize user edits someone else's student profile" do
      it 'redirects to student index view' do
        sign_in(user)
        get(:edit, params: { id: other_student.id })

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('pundit.student_policy.edit?'))
      end
    end

    context "when an unauthorized user edits someone else's student profile" do
      it 'redirects to new user session view' do
        get(:edit, params: { id: student.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#update' do
    let(:student_params) { { last_name: 'Mike', first_name: 'Harton', middle_name: 'Maxwell' } }

    context "when an authorize user updates his student's profile" do
      before(:each) do
        sign_in(user)
        patch(:update, params: { id: student.id, student: student_params })
      end

      it 'updates record' do
        expect(student.reload.last_name).to eq('Mike')
        expect(student.reload.first_name).to eq('Harton')
        expect(student.reload.middle_name).to eq('Maxwell')
      end

      it 'redirects to user show view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(Student.last)
        expect(flash[:notice]).to eq(I18n.t('controllers.students.updated'))
      end
    end

    context "when an authorize user updates someone else's student profile" do
      it 'redirects to student index view' do
        sign_in(user)
        patch(:update, params: { id: other_student.id, student: student_params })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('pundit.student_policy.update?'))
      end
    end

    context "when an unauthorized user updates someone else's student profile" do
      it 'redirects to new user session view' do
        patch(:update, params: { id: student.id, student: student_params })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#destroy' do
    context "when an authorize user destroys his student's profile" do
      before(:each) do
        sign_in(user)
        student
      end

      it 'successfully destroys student' do
        expect { delete(:destroy, params: { id: student.id }) }.to change { Student.count }.from(1).to(0)
      end

      it 'redirects to index view' do
        delete(:destroy, params: { id: student.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(students_path)
        expect(flash[:notice]).to eq(I18n.t('controllers.students.destroyed'))
      end
    end

    context "when an authorize user destroys someone else's student profile" do
      it 'redirects to student index view' do
        sign_in(user)
        delete(:destroy, params: { id: other_student.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('pundit.student_policy.destroy?'))
      end
    end

    context "when an unauthorized user destroys someone else's student profile" do
      it 'redirects to new user session view' do
        delete(:destroy, params: { id: student.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end
end
