require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: 'other-user@example.com') }

  describe '#show' do
    context 'when an authorize user views his profile' do
      before(:each) do
        sign_in(user)
        get(:show, params: { id: user.id })
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to_not be_nil
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:user)).to have_attributes(last_name: user.last_name, first_name: user.first_name)
      end

      it 'renders index view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
        expect(response.body).to match(I18n.t('users.show.title'))
      end
    end

    context "when an authorize user views someone else's profile" do
      it 'redirects to student index view' do
        sign_in(user)
        get(:show, params: { id: other_user.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('pundit.user_policy.show?'))
      end
    end

    context "when an unauthorized user views someone else's profile" do
      it 'redirects to new user session view' do
        get(:show, params: { id: user.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#edit' do
    context 'when an authorize user edits his profile' do
      before(:each) do
        sign_in(user)
        get(:edit, params: { id: user.id })
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to_not be_nil
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:user)).to have_attributes(last_name: user.last_name, first_name: user.first_name)
      end

      it 'renders index view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(response.body).to match(I18n.t('users.edit.title'))
      end
    end

    context "when an authorize user edits someone else's profile" do
      it 'redirects to student index view' do
        sign_in(user)
        get(:edit, params: { id: other_user.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('pundit.user_policy.edit?'))
      end
    end

    context "when an unauthorized user views someone else's profile" do
      it 'redirects to new user session view' do
        get(:edit, params: { id: user.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to be
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end

  describe '#update' do
    let(:user_params) { { last_name: 'QWERTY LAST', first_name: 'QWERTY FIRST', middle_name: 'QWERTY MIDDLE' } }

    context 'when an authorize user updates his profile' do
      before(:each) do
        sign_in(user)
        patch(:update, params: { id: user.id, user: user_params })
      end

      it 'updates record' do
        expect(user.reload.last_name).to eq('QWERTY LAST')
        expect(user.reload.first_name).to eq('QWERTY FIRST')
        expect(user.reload.middle_name).to eq('QWERTY MIDDLE')
      end

      it 'redirects to user show view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq(I18n.t('controllers.users.updated'))
      end
    end

    context "when an authorize user updates someone else's profile" do
      it 'redirects to student index view' do
        sign_in(user)
        patch(:update, params: { id: other_user.id, user: user_params })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('pundit.user_policy.update?'))
      end
    end

    context "when an unauthorized user updates someone else's profile" do
      it 'redirects to new user session view' do
        patch(:update, params: { id: user.id, user: user_params })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end
end
