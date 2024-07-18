Feature: BDD Test

  Background:
    Given authorised admin API session
    And following calendars
      | Name        | TimeZone | MarketOpen | MarketClose | TradingDays | Holidays |
      #      | <calendar1> | +01:00   |            |             | Monday, Tuesday, Wednesday, Thursday, Friday |          |
      | <calendar1> | +01:00   |            |             |             |          |
    And following MPs
      | Name  |
      | <mp1> |
    And following instruments
      | symbol  | Description | Calendar Id   | Activity Status | Quote Currency | Price Precision | Quantity Precision | Min Quantity | Max Quantity |
      | <inst1> | Instrument  | <calendar1Id> | Active          | USD            | 6               | 2                  | 1            | 100000       |
    And an apiKey with full permissions for "<mp1>" mp
    And a session to exchange GW with credentials for "<mp1>" mp is created successfully
    And the mp subscribes to the "executionReports" stream of exchange gateway
    And the mp subscribes to the "trades" stream of exchange gateway

  Scenario: creating a match between limit GTC and limit GTC
    When the mp requested to place the following orders
      | mpOrderId    | orderType | side | price   | quantity | instrument | timeInForce |
      | <mpOrderId1> | Limit     | Buy  | 10.1234 | 76.55    | <inst1>    | GTC         |
      | <mpOrderId2> | Limit     | Sell | 10.1234 | 77.55    | <inst1>    | GTC         |
    Then the following messages are published from "executionReports" stream
      | eventId    | messageType | orderId    | mpOrderId    | orderType | side | instrument | quantity | price   | timeInForce | orderTimestamp | filledQuantity | remainingOpenQuantity | removedQuantity | lastFilledQuantity | lastFilledPrice | matchId    | tradingMode | marketModel | eventTimestamp | eventId    | trackingNumber    | mpId    | mpName |
      | <eventId1> | Add         | <orderId1> | <mpOrderId1> | Limit     | Buy  | <inst1>    | 76.55    | 10.1234 | GTC         | <timestamp0>   | 0              | 76.55                 | 0               |                    |                 |            |             | T           | <timestamp0>   | <eventId1> | <trackingNumber1> | <mp1Id> | <mp1>  |
      | <eventId2> | Executed    | <orderId1> | <mpOrderId1> | Limit     | Buy  | <inst1>    | 76.55    | 10.1234 | GTC         | <timestamp0>   | 76.55          | 0                     | 0               | 76.55              | 10.1234         | <matchId1> | CT          | T           | <timestamp1>   | <eventId2> | <trackingNumber2> | <mp1Id> | <mp1>  |
      | <eventId3> | Executed    | <orderId2> | <mpOrderId2> | Limit     | Sell | <inst1>    | 77.55    | 10.1234 | GTC         | <timestamp1>   | 76.55          | 1                     | 0               | 76.55              | 10.1234         | <matchId1> | CT          | T           | <timestamp1>   | <eventId2> | <trackingNumber2> | <mp1Id> | <mp1>  |
      | <eventId4> | Add         | <orderId2> | <mpOrderId2> | Limit     | Sell | <inst1>    | 77.55    | 10.1234 | GTC         | <timestamp1>   | 76.55          | 1                     | 0               |                    |                 |            |             | T           | <timestamp1>   | <eventId3> | <trackingNumber3> | <mp1Id> | <mp1>  |
    And the following messages are published from "trades" stream
      | actionType   | timestamp    | trackingNumber    | eventId    | orderId    | mpOrderId    | mpId    | mpName | instrumentId | instrument | side | price   | quantity | tradeId    | tradingMode | makerTaker | tradeDate    | multiLegReportingType |
      | MatchedTrade | <timestamp1> | <trackingNumber2> | <eventId2> | <orderId1> | <mpOrderId1> | <mp1Id> | <mp1>  | <inst1Id>    | <inst1>    | Buy  | 10.1234 | 76.55    | <tradeId1> | CT          | Maker      | <tradeDate1> | SingleSecurity        |
      | MatchedTrade | <timestamp1> | <trackingNumber2> | <eventId2> | <orderId2> | <mpOrderId2> | <mp1Id> | <mp1>  | <inst1Id>    | <inst1>    | Sell | 10.1234 | 76.55    | <tradeId1> | CT          | Taker      | <tradeDate1> | SingleSecurity        |
