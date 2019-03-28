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

describe Gruf::Lightstep do
  describe '.configure' do
    let(:configuration) { described_class  }
    subject(:configure) { configuration.configure(&block) }

    before { described_class.reset }
    after { described_class.reset }

    context 'when no values are overridden' do
      let(:block) { Proc.new { |config|  } }

      it 'has default values' do
        configure

        expect(configuration.default_error_code).to be(GRPC::Core::StatusCodes::INTERNAL)
        expect(configuration.options).to eq(default_error_code: GRPC::Core::StatusCodes::INTERNAL)
      end
    end

    context 'when values are overridden' do
      let(:block) do
        Proc.new { |config|
          config.default_error_code = GRPC::Core::StatusCodes::UNKNOWN
        }
      end

      it 'has overridden values' do
        configure

        expect(configuration.default_error_code).to be(GRPC::Core::StatusCodes::UNKNOWN)
        expect(configuration.options).to eq(default_error_code: GRPC::Core::StatusCodes::UNKNOWN)
      end
    end
  end
end
