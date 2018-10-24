Changelog for the gruf-zipkin gem.

h3. Pending Release

h3. 1.1.3

- Bump bc-lightstep-ruby to 1.2.0

h3. 1.1.2

- First OSS release
- Explicitly require bc-lightstep-ruby dependency
- Add option to whitelist request params to lightstep as span tags

h3. 1.1.1

- Bump bc-lightstep-ruby to 1.1.5
- Bump gruf minimum version to 2.4

h3. 1.1.0

- Exclude client validation errors from being "errors"

h3. 1.0.3

- Ensure gRPC requests are always the root span

h3. 1.0.2

- Add ignore_methods as an option to server interceptor
- Standardize span tags according to BC spec

h3. 1.0.0

- Support for gruf 2.0.0

h3. 0.10.3

- Update to 0.10.3, add rubocop+bundler-audit

h3. 0.10.2

- Updated license to MIT

h3. 0.10.1

- Handle case when tracer is not yet initialized before trace executes

h3. 0.10.0

- Initial public release
