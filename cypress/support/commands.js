import { addStreamCommands } from '@lensesio/cypress-websocket-testing';
addStreamCommands();

Cypress.Commands.add('sayHello', () => {
  return cy.wrap('Hello').then((data) => Cypress.log({
    name: `Variables`,
    displayName: data,
    message: 'World',
  }))
});
