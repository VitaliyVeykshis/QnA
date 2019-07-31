shared_examples_for 'valid identity' do
  it 'creates identity for user' do
    expect(context.identity).to eq User.first.identities.first
  end

  it 'creates identity with provider' do
    expect(context.identity.provider).to eq auth.provider
  end

  it 'creates identity with uid' do
    expect(context.identity.uid).to eq auth.uid
  end
end

shared_examples_for 'valid context' do
  it 'returns identity' do
    expect(context.identity).to eq User.first.identities.first
  end
end