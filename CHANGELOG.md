Changelog for the gruf-lightstep gem.

### Pending Release

### 1.8.0

- Add support for Ruby 3.3, 3.4
- Drop support for Ruby 3.0, 3.1 (EOL)

### 1.7.1

- Use default value of `'true'` for the `ot-tracer-sampled` value in the client interceptor instead of `'1'`

### 1.7.0

- Add support for Ruby 3.2
- Drop support for Ruby 2.7 (EOL March 2023)

### 1.6.0

- Add support for Ruby 3.1
- Drop support for Ruby 2.6

### 1.5.1

- Remove unnecessarily strict dev dependencies

### 1.5.0

- Add official support for Ruby 3

### 1.4.0

- Ensure `error` span tag is always set when an exception is raised
- Move from whitelist -> allowlist in server interceptor

### 1.3.0

- Bump Ruby requirement to 2.6+
- Bump bc-lightstep-ruby dependency to 2.0+
- Explicitly declare gruf requirement in gemspec
- Explicitly declare development deps for gem

###  1.2.1

- Ensure boundary span has `span.kind` set

### 1.2.0

- Add `frozen_string_literal: true` to all files
- Deprecate ruby 2.2 support

### 1.1.3

- Bump bc-lightstep-ruby to 1.2.0

### 1.1.2

- First OSS release
- Explicitly require bc-lightstep-ruby dependency
- Add option to allowlist request params to lightstep as span tags

### 1.1.1

- Bump bc-lightstep-ruby to 1.1.5
- Bump gruf minimum version to 2.4

### 1.1.0

- Exclude client validation errors from being "errors"

### 1.0.3

- Ensure gRPC requests are always the root span

### 1.0.2

- Add ignore_methods as an option to server interceptor
- Standardize span tags according to BC spec

### 1.0.0

- Support for gruf 2.0.0

### 0.10.3

- Update to 0.10.3, add rubocop+bundler-audit

### 0.10.2

- Updated license to MIT

### 0.10.1

- Handle case when tracer is not yet initialized before trace executes

### 0.10.0

- Initial public release
