# Structure
Per Feature:
    For each core dependency
        Build models, with unit tests
        Build Controllers with unittests
        Build Views with unit tests
    Connect to previous Features
        Integration Tests

## Tests
Each step assumes the step before passes all tests.
1. Model
   1. Test pure model logic
2. Controller
   1. Test routing.
   2. Test authentication access (signed in or out only). default sign_in_as :owner
   3. Test client access to Models.
3. Policies
   1. Test resource access by non owners through authorization. (owners capabilities already tested in controller)
      default sign_in_as :guest
   2. Separate from regular controller to simplify future authorization migrations.

## Decisions
- Controller and Policy tests build users rather than use fixtures due to issues loging in with user