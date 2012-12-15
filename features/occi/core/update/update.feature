Feature:
  ...

  Scenario Outline: ...
    Given endpoint : <endpoint>
    And transfer_protocol : <protocol>
    And accept type : <accept_type>
    And have an initialize Client
    When the Client makes an update request
    Then the Client should have the response code <response_code>

  Scenarios:
    | protocol  | endpoint                  | accept_type       | response_code |
    |  http     | http://141.5.99.69/       | text/plain        | 201           |
