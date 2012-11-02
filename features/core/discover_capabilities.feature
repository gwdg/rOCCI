# language: en

Feature: Discover capabilities
  In order to discover the capabilities of an OCCI Server
  As an OCCI Client
  I want to see all available capabilities of the OCCI Server
  Scenario: Discovery of all categories
    When I ask for all capabilities of an OCCI Server
    Then I should retrieve
  Scenario: Discovery of all kinds
  Scenario: Discovery of all mixins
  Scenario: Discovery of all actions