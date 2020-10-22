# gruf-lightstep - LightStep tracing for gruf

[![CircleCI](https://circleci.com/gh/bigcommerce/gruf-lightstep/tree/main.svg?style=svg)](https://circleci.com/gh/bigcommerce/gruf-lightstep/tree/main) [![Gem Version](https://badge.fury.io/rb/gruf-lightstep.svg)](https://badge.fury.io/rb/gruf-lightstep) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-lightstep.svg?branch=main)](http://inch-ci.org/github/bigcommerce/gruf-lightstep)

Adds LightStep tracing support for [gruf](https://github.com/bigcommerce/gruf) 2.0.0+.

## Installation

```ruby
gem 'gruf-lightstep'
```

Then in an initializer or before use, after loading gruf:

```ruby
require 'gruf/lightstep'
```

### Configuration

You can use the following ENV vars to configure lightstep:

| Name | Description |
| ---- | ---- |
|LIGHTSTEP_ACCESS_TOKEN|LightStep access token, if used in your satellites|
|LIGHTSTEP_COMPONENT_NAME|The name of your service| 
|LIGHTSTEP_HOST|The host of your lightstep satellites|
|LIGHTSTEP_PORT|The port of your lightstep satellites|

See more configuration here: https://github.com/bigcommerce/bc-lightstep-ruby#environment-config

### Server Interceptors

In your gruf initializer:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::Lightstep::ServerInterceptor)
end
```

It comes with a few more options as well:

| Option | Description | Default |
| ------ | ----------- | ------- |
| allowlist | An array of parameter key names to log to lightstep. E.g. `[uuid kind]` | `[]` |
| ignore_methods | An array of method names to ignore from logging. E.g. `['namespace.health.check']` | `[]` |

It's important to maintain a safe allowlist should you decide to log parameters; gruf does no
parameter sanitization on its own. We also recommend do not allowlist parameters that may contain
very large values (such as binary or json data).

### Client Interceptors

To automatically propagate the trace context outbound, in your Gruf clients, pass the client interceptor
to your `Gruf::Client` initializer:

```ruby
Gruf::Client.new(
  service: MyService,
  client_options: {
    interceptors: [Gruf::Lightstep::ClientInterceptor.new]
  }
)
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
