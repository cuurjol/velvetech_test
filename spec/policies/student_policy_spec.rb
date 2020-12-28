require 'rails_helper'

RSpec.describe StudentPolicy do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: 'other-user@example.com') }

  subject { described_class }

  context 'when user in an owner' do
    let(:student) { FactoryBot.create(:student, user: user) }

    permissions :index?, :new?, :create?, :show?, :edit?, :update?, :destroy? do
      it { is_expected.to permit(user, student) }
    end
  end

  context 'when user in not an owner' do
    let(:student) { FactoryBot.create(:student, user: other_user) }

    permissions :show?, :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(user, student) }
    end
  end

  context 'when user is an anonymous' do
    let(:student) { FactoryBot.create(:student, user: user) }

    permissions :index?, :new?, :create?, :show?, :edit?, :update?, :destroy? do
      it { is_expected.not_to permit(nil, student) }
    end
  end
end
