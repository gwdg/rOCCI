Feature:
  In order to read an OCCI Resource on the OCCI Server
  As an OCCI Client
  I want to get an success report of the read operation and receive Resource data from the OCCI Server

  @vcr_record
  Scenario Outline: Read an OCCI Resource
    Given endpoint : <endpoint>
    And transfer_protocol : <protocol>
    And accept type : <accept_type>
    And have an initialize Client
    When the Client makes a read request
    Then the Client should have the response code <response_code>

  @vcr_record
  Scenarios:
    | protocol  | endpoint                  | accept_type       | response_code |
    |  http     | http://141.5.99.69/       | text/plain        | 201           |
