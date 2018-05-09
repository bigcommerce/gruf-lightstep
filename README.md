# gruf-lightstep - LightStep tracing for gruf

[![Build Status](https://travis-ci.com/bigcommerce/gruf-lightstep.svg?branch=master)](https://travis-ci.com/bigcommerce/gruf-lightstep) [![Gem Version](https://badge.fury.io/rb/gruf-lightstep.svg)](https://badge.fury.io/rb/gruf-lightstep) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-lightstep.svg?branch=master)](http://inch-ci.org/github/bigcommerce/gruf-lightstep)

Adds LightStep tracing support for [gruf](https://github.com/bigcommerce/gruf) 2.0.0+.

## Installation

```ruby
gem 'gruf-lightstep'
```

Then in an initializer or before use, after loading gruf:

```ruby
require 'gruf/lightstep'

Gruf::Lightstep.configure(
  component_name: 'myapp',
  access_token: 'abcdefg',
  host: 'my.lightstep.service.io',
  port: 8080,
  verbosity: 1
)

Gruf.configure do |c|
  c.interceptors.use(Gruf::Lightstep::Interceptor)
end
```

## License

Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
