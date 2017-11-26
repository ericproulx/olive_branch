# frozen_string_literal: true

RSpec.describe OliveBranch::Middleware do
  before :each do
    OliveBranch.reset_configuration
  end

  describe 'modifying request' do
    let(:params) do
      {
        'action_dispatch.request.request_parameters' => {
          'post' => {
            'authorName' => 'Adam Smith'
          }
        }
      }
    end

    before :each do
      @request_params = nil
      @query_params = nil
      @app = ->(env) {
        @request_params = env['action_dispatch.request.request_parameters']
        @query_params = env['action_dispatch.request.query_parameters']
        [200, {}, ['{}']]
      }
    end

    context 'when content-type JSON and inflection header present' do
      it 'snake cases incoming params' do
        env = params.merge(
          'CONTENT_TYPE' => 'application/json',
          'HTTP_X_KEY_INFLECTION' => 'camel',
          'QUERY_STRING' => 'categoryFilter[categoryName]=economics'
        )
        described_class.new(@app).call(env)
        expect(@request_params['post']['author_name']).not_to be_nil
        expect(@query_params['category_filter']['category_name']).to eq 'economics'
      end
    end

    context 'when content-type not JSON' do
      it 'does not modify incoming params' do
        env = params.merge(
          'CONTENT_TYPE' => 'text/html',
          'HTTP_X_KEY_INFLECTION' => 'camel'
        )

        described_class.new(@app).call(env)
        expect(@request_params['post']['authorName']).not_to be_nil
      end
    end

    context 'when inflection header missing' do
      it 'does not modify incoming params' do
        env = params.merge('CONTENT_TYPE' => 'application/json')
        described_class.new(@app).call(env)
        expect(@request_params['post']['authorName']).not_to be_nil
      end
    end

    context 'with a custom content type check' do
      before :each do
        OliveBranch.configure do |config|
          config.content_type_check = ->(content_type) { content_type == 'foo/type' }
        end
      end

      it 'snake cases incoming params if content-type matches the custom check' do
        env = params.merge(
          'CONTENT_TYPE' => 'foo/type',
          'HTTP_X_KEY_INFLECTION' => 'camel'
        )
        described_class.new(@app).call(env)
        expect(@request_params['post']['author_name']).not_to be_nil
      end

      it 'does not modify incoming params if content-type not matching custom check' do
        env = params.merge(
          'CONTENT_TYPE' => 'application/json',
          'HTTP_X_KEY_INFLECTION' => 'camel'
        )
        described_class.new(@app).call(env)
        expect(@request_params['post']['authorName']).not_to be_nil
      end
    end
  end

  describe 'modifying response' do
    let(:http_status) { 200 }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:app) { ->(_env) { [http_status, headers, body] } }
    let(:request) { Rack::MockRequest.new(described_class.new(app)) }
    let(:body) { ['{"author_name":"Adam Smith"}']  }

    context 'when JSON and inflection header present' do
      context 'when hash' do
        it 'camel-cases response' do
          response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'camel')
          expect(JSON.parse(response.body)['authorName']).not_to be_nil
          expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
        end

        it 'dash-cases response' do
          response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'dash')
          expect(JSON.parse(response.body)['author-name']).not_to be_nil
          expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
        end
      end

      context 'when array' do
        let(:body) { ['[{"author_name":"Adam Smith"}]']  }

        it 'camel-cases array response' do
          response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'camel')
          expect(JSON.parse(response.body)[0]['authorName']).not_to be_nil
          expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
        end

        it 'dash-cases array response' do
          response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'dash')
          expect(JSON.parse(response.body)[0]['author-name']).not_to be_nil
          expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
        end
      end
    end

    context 'when not JSON' do
      let(:headers) { { 'Content-Type' => 'text/html' } }
      it 'does not modify response' do
        response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'camel')
        expect(JSON.parse(response.body)['author_name']).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end

    context 'when inflection header is missing' do
      it 'does not modify response if inflection header missing' do
        response = request.get('/')
        expect(JSON.parse(response.body)['author_name']).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end

    context 'when invalid json' do
      let(:body) { ['{"post":{"author_name":"Adam Smith"}']}
      it 'does not modify response if invalid JSON' do
        response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'camel')
        expect(response.body =~ /author_name/).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end

    context 'with custom camelize method' do
      before :each do
        OliveBranch.configure do |config|
          config.camelize = ->(string) { "camel#{string}" }
        end
      end

      it 'uses the custom camelize method' do
        response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'camel')
        expect(JSON.parse(response.body)['camelauthor_name']).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end

    context 'with custom dasherize method' do
      before :each do
        OliveBranch.configure do |config|
          config.dasherize = ->(string) { "dash#{string}" }
        end
      end

      it 'uses the custom dasherize method' do
        response = request.get('/', 'HTTP_X_KEY_INFLECTION' => 'dash')
        expect(JSON.parse(response.body)['dashauthor_name']).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end

    context 'with custom default inflection' do
      before :each do
        OliveBranch.configure do |config|
          config.default_inflection = 'camel'
        end
      end

      it 'uses the default inflection' do
        response = request.get('/')
        expect(JSON.parse(response.body)['authorName']).not_to be_nil
        expect(response.headers['Content-Length']).to eq(response.body.bytesize.to_s)
      end
    end
  end
end
