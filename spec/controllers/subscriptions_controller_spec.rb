require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe 'POST #create' do
    let(:options) { { question_id: question } }
    let(:request_params) { { method: :post, action: :create, options: options } }

    context 'when user does not have subscription  on question' do
      let(:question) { create(:question) }

      it 'saves the new subscription in the database' do
        expect do
          do_request(request_params)
        end.to change(question.subscribers, :count).by(1)
      end

      it 'associates subscription with the user' do
        expect do
          do_request(request_params)
        end.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'when user have subscription on question' do
      let(:question) { create(:question, user: user) }

      it 'does not save the new subscription in the database' do
        expect do
          do_request(request_params)
        end.not_to change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:options) { { id: question.subscriptions.first } }
    let(:request_params) { { method: :delete, action: :destroy, options: options } }

    context 'when user is subscription owner' do
      let!(:question) { create(:question, user: user) }

      it 'deletes subscription' do
        expect do
          do_request(request_params)
        end.to change(Subscription, :count).by(-1)
      end
    end

    context 'when user is not subscription owner' do
      let!(:question) { create(:question) }

      it 'does not deletes subscription' do
        expect do
          do_request(request_params)
        end.not_to change(Subscription, :count)
      end
    end
  end
end
