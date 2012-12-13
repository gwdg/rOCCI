Feature:
  In order to create an OCCI Resource on the OCCI Server
  As an OCCI Client
  I want to get an success report of the create operation and receive the URI of the new Resource by the OCCI Server

  Scenario Outline: Create an OCCI Resource
    Given endpoint : <endpoint>
    And transfer_protocol : <protocol>
    And accept type : <accept_type>
    And have an initialize Client
    And OCCI Kind <occi_kind_identifier> is selected
    When OCCI Client requests OCCI Server to create OCCI Resource with the given kind
    Then the Client should have the response code <response_code>
    And get the URI of the created OCCI Resource
    And the created Resource exist in the OCCI Server

  Scenarios:
    | protocol  | endpoint                  | accept_type       | response_code | occi_kind_identifier                                |
    |  http     | http://141.5.99.82/       | text/plain        | 201           | http://schemas.ogf.org/occi/infrastructure#compute  |
  #  |  http     | http://141.5.99.69/       | text/plain        | 201           | http://schemas.ogf.org/occi/infrastructure#storage  |


