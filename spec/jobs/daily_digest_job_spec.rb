require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:context) { double(:context, success?: true) }

  before do
    allow(DailyDigest).to receive(:call).and_return(context)
  end

  it 'calls DailyDigest#call' do
    expect(DailyDigest).to receive(:call)

    DailyDigestJob.perform_now
  end
end
