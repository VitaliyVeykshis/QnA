shared_examples_for 'API failure response' do |response_status|
  it "renders json with status #{response_status}" do
    do_request(method, api_path, options)
    expect(response).to have_http_status response_status
  end
end
