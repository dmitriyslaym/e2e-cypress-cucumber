const { defineConfig } = require('cypress');
const { addCucumberPreprocessorPlugin } = require('@badeball/cypress-cucumber-preprocessor');
const createBundler = require('@bahmutov/cypress-esbuild-preprocessor');
const createEsbuildPlugin = require('@badeball/cypress-cucumber-preprocessor/esbuild');

module.exports = defineConfig({
  e2e: {
    specPattern: 'features/**/*.e2e.feature',

    async setupNodeEvents(on, config) {
      await addCucumberPreprocessorPlugin(on, config);

      on(
        'file:preprocessor',
        createBundler({
          plugins: [createEsbuildPlugin.default(config)],
        })
      );

      return config;
    },
  },
  defaultCommandTimeout: 6000000,

  watchForFileChanges: false,
  env: {
    ENVIRONMENT: process.env.ENVIRONMENT,
    tags: 'not @investigate',
  },
  video: false,
  screenshotOnRunFailure: false,
  retries: {
    runMode: 1,
    openMode: 0,
  },
});
