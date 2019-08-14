require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:context) { double(:context, success?: true) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  before do
    allow(NewAnswer).to receive(:call).with(answer: answer)
                                      .and_return(context)
  end

  it 'calls NewAnswer#call' do
    expect(NewAnswer).to receive(:call).with(answer: answer)

    NewAnswerJob.perform_now(answer)
  end
end
