import { Given } from '@badeball/cypress-cucumber-preprocessor';

Given(/^say hello$/, function () {
  return cy.sayHello();
});
