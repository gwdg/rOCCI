# language: en

Feature: Discovery Interface
  In order to discover the capabilities of an OCCI Server
  As an OCCI Client
  I want to receive all OCCI Categories supported by the OCCI Server

  Scenario Outline: Retrieving all OCCI Categories supported by the OCCI Server
    Given endpoint : <endpoint>
    And transfer_protocol : <protocol>
    And accept type : <accept_type>
    And category filter : <category_filter>
    And have an initialize Client
    When OCCI Client request all OCCI Categories supported by the OCCI Server
    Then the Client should have the response code <response_code>
    And OCCI Client should display the OCCI Categories received from the OCCI Server

  Scenarios:
  | protocol | endpoint                  | accept_type       | response_code | category_filter |
  | http     | http://141.5.99.69/       | application/json  |      200      |                 |
 # | http     | http://141.5.99.69/       | text/occi         |      200      |                 |
 # | http     | http://141.5.99.69/       | text/plain        |      200      |                 |
 # | http     | http://46.231.128.85:8086/| text/occi         |      200      |                 |
 # | http     | http://141.5.99.69/       | text/plain        |      200      | action          |

