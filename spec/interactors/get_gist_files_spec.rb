require 'rails_helper'

RSpec.describe GetGistFiles, type: :interactor do
  describe '.call' do
    context 'when given valid gist url' do
      let(:context) { GetGistFiles.call(gist_url: 'https://gist.github.com/VitaliyVeykshis/bba333f611c70a24cd9a2364e43ce738') }

      it 'returns gist files' do
        expect(context.gist_files.first).to include(content: 'gist text')
      end
    end

    context 'when given invalid gist url' do
      let(:context) { GetGistFiles.call(gist_url: 'https://gist.github.com/bba333f611c70a24cd9a2364e8') }

      it 'returns nil' do
        expect(context.gist_files).to be_nil
      end
    end
  end
end