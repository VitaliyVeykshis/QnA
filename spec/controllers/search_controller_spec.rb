require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    let(:question) { create(:question) }

    context 'when valid params' do
      let(:options) { { category: 'Questions', query: question.body } }
      let(:request_params) { { method: :get, action: :search, options: options } }

      it 'call interactor GetSearchResults' do
        expect(GetSearchResults)
          .to receive(:call).with(query: question.body, category: Question).and_call_original
        do_request(request_params)
      end

      it 'renders template index' do
        do_request(request_params)
        expect(response).to render_template :index
      end
    end
  end
end
