require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { FactoryBot.create(:user) }

  subject { described_class }

  context 'when user owns his profile' do
    permissions :show?, :edit?, :update? do
      it { is_expected.to permit(user, user) }
    end
  end

  context 'when user is an anonymous' do
    permissions :show?, :edit?, :update? do
      it { is_expected.not_to permit(nil, user) }
    end
  end
end
