// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

const { SpecReporter } = require('jasmine-spec-reporter');

exports.config = {
  seleniumAddress: 'http://192.168.43.231:4444/wd/hub',
  allScriptsTimeout: 11000,
  useAllAngular2AppRoots: true,
  specs: [
    './e2e/**/*.e2e-spec.ts'
  ],
  capabilities: {
    'browserName': 'chrome',
    // 'chromeOptions': {
    //   'args': [
    //     '--headless',
    //     '--no-sandbox',
    //     '--disable-web-security',
    //     '--disable-dev-shm-usage',
    //     "--disable-gpu", "--window-size=800x600"
    //   ]
    // }
  },
  // directConnect: true,
  // baseUrl: 'http://localhost:4200/wd/hub',
  framework: 'jasmine',
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function () { }
  },
  onPrepare() {
    require('ts-node').register({
      project: 'e2e/tsconfig.e2e.json'
    });
    jasmine.getEnv().addReporter(new SpecReporter({ spec: { displayStacktrace: true } }));
  }
};
