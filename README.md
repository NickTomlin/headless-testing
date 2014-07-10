Testing (headlessly) with Capybara and friends.
---

```bash
# getting up and running
gem install bundler
bundle
npm i

# running the tests locally
npm test

# running the tests through sauce
# A. Make sure your sauce credentials are available as environment variables
# - export SAUCE_USERNAME <your sauce username>
# - export SAUCE_ACCESS_KEY <your sauce key>
# B. Set USE_SAUCE when invoking the tests
USE_SAUCE=true npm test

```

Note:

The integration tests will run headlessly on most \*nix distributions with `xfvb` installed, otherwise a local copy of Firefox will be used.

If `xvfb` is not installed, it should be available through your distro's package manager (e.g. `sudo apt-get install xvfb`).
