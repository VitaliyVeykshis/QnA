require 'rails_helper'

RSpec.describe FindForOauth, type: :interactor do
  describe '.call' do
    context 'when user is finded' do
      let!(:user) { create(:user) }
      let(:auth) { create(:auth, :github, info: { email: user.email }) }
      let(:context) { FindForOauth.call(auth: auth) }

      it 'does not create new user' do
        expect { context }.not_to change(User, :count)
      end

      it_behaves_like 'valid identity'
      it_behaves_like 'valid context'
    end

    context 'when user is not finded' do
      let(:auth) { create(:auth, :github) }
      let(:context) { FindForOauth.call(auth: auth) }

      it 'creates new user' do
        expect { context }.to change(User, :count)
      end

      it 'creates new user with auth email' do
        expect(context.identity.user.email).to eq auth.info.email
      end

      it_behaves_like 'valid identity'
      it_behaves_like 'valid context'
    end

    context 'when auth not have email' do
      let(:auth) { create(:auth, :vkontakte) }
      let(:context) { FindForOauth.call(auth: auth) }

      it 'creates new user' do
        expect { context }.to change(User, :count)
      end

      it 'creates new user with temporary email' do
        expect(context.identity.user.email).to eq "#{auth.provider}_#{auth.uid}@change.me"
      end

      it_behaves_like 'valid identity'
      it_behaves_like 'valid context'
    end
  end
end
