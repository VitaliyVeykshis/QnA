require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  before { subscribe }

  it 'subscribes to a stream' do
    expect(subscription).to be_confirmed
  end

  it "subscribes to 'questions' stream" do
    expect(subscription).to have_stream_from('questions')
  end
end
