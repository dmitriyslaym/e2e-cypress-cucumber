# Guidelines

## Admin part
In order to create the resources for trading you should use admin functionality of the system within REST API.

Origin:
https://admin-api-master.rnd.exberry-rnd.io

### Authorization

Credentials:
```
{
  "email": "automation.test@exberry.io",
  "password": "Test1234"
}
```
Use Get Token route (https://documenter.getpostman.com/view/6229811/TzCV3jcq#9e78837d-11af-4f2e-8e11-35275b86acc1) and then include the received JWT token in the "Authorization" header of each request to a protected route (make sure that the value of this header always starts with "Bearer " and then the token).

### Create Calendar
Use Create Calendar protected route (https://documenter.getpostman.com/view/6229811/TzCV3jcq#6f1b40e0-f805-4898-af1a-ecb06dd83f0c).

### Create Instrument
Use Create Instrument protected route (https://documenter.getpostman.com/view/6229811/TzCV3jcq#30c1cfb0-4620-40a8-96c6-ba459a8f5887).
In **calendarId** value use the id of a calendar that you created in the previous step.

### Create MP
Use Create MP protected route (https://documenter.getpostman.com/view/6229811/TzCV3jcq#9dcaa8cd-c893-4469-b908-f752c56176f0).

### Create APIKey for MP
Use Create APiKey protected route (https://documenter.getpostman.com/view/6229811/TzCV3jcq#12e42f32-7258-4e6d-bf78-447e8cf8471d).
In **mpId** value in URL (instead of _2087505413_ from the docs) use the **id** of an MP that you created in the previous step.

## Exchange GW (Trading) part
WS GW is available with the following DNS:

**wss://sandbox-shared.staging.exberry-uat.io**

You can use Sandbox application with the list of methods that you will need in this scenario - there you can send requests and see all the responses.
https://sandbox.exberry.io/?url=https://raw.githubusercontent.com/dmitriyslaym/cypress-cucumber-template/main/exchange-gw-sandbox-data.json

### Create session
Take apiKey and secret values from the APIKey, that you generated for MP before.

#### Sandbox application (to see the example of request)
- In "Message Builder" section put the APIKey and Secret values of the APIKey that you have just generated.
- In "Message Builder" section in Timestamp input click on "Refresh" icon.
- In "Message Builder" section click on "Build" button.
- Notice, that the content of JSON block in the middle was updated. Click on "Send" button there. If everything is successfull, from now on you can use any endpoints from the list while having the current WS connection opened.

#### In automational test
Establish a WS connection with Exchange GW.
You can use any kind of external package, that simplifies working with WS. We recommend to use this one:
https://github.com/lensesio/cypress-websocket-testing
(command "stream").
Make sure that through the whole test you use only one WS connection and don't accidentally open multiple ones.

Generate required data for the request:

```
import sha256 from "crypto-js/hmac-sha256";

const apiKey = 'your-api-key';
const secret = 'your secret-from-api-key';
const signature = sha256(`"apiKey":"${apiKey}","timestamp":"${String(Date.now())}"`, secret).toString()
```

Within currently opened WS connection send the request to "createSession" endpoint.

### Place order
#### Sandbox application (to see the example of request)
Select "placeOrder" method within TRADING API section on the left corner. In JSON block use the required values of the props in the "d", click "Send".

#### In automational test
Within currently opened WS connection send the request to "placeOrder" endpoint.

### Execution reports and Trades
#### Sandbox application (to see the example of request)
Select those methods within PRIVATE DATA API section on the left corner. No need to change anything in JSON block, just click "Send".

#### In automational test
Within currently opened WS connection send the request to "executionReports" and "trades" endpoints.