# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'spec_helper'

describe Gruf::Lightstep::ServerInterceptor do
  let(:service) { ThingService.new }
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:active_call) { grpc_active_call }
  let(:grpc_method_name) { 'ThingService.get_thing' }
  let(:request) do
    double(
      :request,
      method_key: signature,
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      request_class: ThingRequest,
      service_key: 'thing_service.thing_request',
      message: grpc_request,
      method_name: grpc_method_name
    )
  end
  let(:errors) { Gruf::Error.new }
  let(:interceptor) { described_class.new(request, errors, options) }

  describe '.call' do
    let(:tracer) { ::Bigcommerce::Lightstep::Tracer.instance }
    subject { interceptor.call { true } }

    it 'should trace the request' do
      expect(tracer).to receive(:start_span).once
      subject
    end

    context 'with an ignored method' do
      let(:options) { { ignore_methods: [grpc_method_name] } }

      it 'should not trace the request' do
        expect(tracer).to_not receive(:start_span)
        subject
      end
    end

    context 'when it errors' do
      let(:exception) { GRPC::Internal.new }
      let(:span) { double(:span, set_tag: true) }
      subject { interceptor.call { raise exception } }

      it 'should trace the request with a tag' do
        expect {
          expect(tracer).to receive(:start_span).once.and_yield(span)
          expect(span).to receive(:set_tag).with('error', true).ordered
          expect(span).to receive(:set_tag).with('grpc.error', true).ordered
          expect(span).to receive(:set_tag).with('grpc.error_code', exception.code).ordered
          expect(span).to receive(:set_tag).with('grpc.error_class', exception.class).ordered

          subject
        }.to raise_error(exception)
      end

      context 'but the error class is not in the error_classes option' do
        let(:exception) { GRPC::NotFound.new }
        it 'should trace the request as a grpc error but not a span error' do
          expect {
            expect(tracer).to receive(:start_span).once.and_yield(span)
            expect(span).to_not receive(:set_tag).with('error', true)
            expect(span).to receive(:set_tag).with('grpc.error', true).ordered
            expect(span).to receive(:set_tag).with('grpc.error_code', exception.code).ordered
            expect(span).to receive(:set_tag).with('grpc.error_class', exception.class).ordered

            subject
          }.to raise_error(exception)
        end
      end
    end
  end
end
