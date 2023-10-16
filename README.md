# MealOfFortune
This app allows users to find a random restaurant near their current location or a chosen area

## Running
Open the project in xCode. You will be able to run the project in a simulator with no additional steps.


# Deployment
You may run the project locally in the simulator or use your Apple Developer account in xCode to sign the package and run it on an iOS device connected by USB.

# Testing
To run the tests open the project in XCode and click on 'Product' on the top tabs and select 'Tests' or just hit Command U to run the Tests.

## Unit Tests: MealOfFortune/MealOfFortune/MealOfFortuneTests
### NOT USED CloudKitTests: This test can only be used by the CloudKit account holder
- testCKRecordSave(): Tests if a record can be saved to cloudkit and retrieved again

### MealOfFortuneTests:
- testPerformanceExample: Tests time for loading HomeView & getting user coordinates
- testLongLat: Tests for obtaining user location function

### testHomeView:
- testHomeViewLocation: Tests that the user's location can be retrieved from the main page

### testList:
- testListCreation: Tests that the API call correctly generates a list

## UI Tests: MealOfFortune/MealOfFortune/MealOfFortuneUITests
### ConstraintsViewTests:
- testDistance: Tests that the distance buttons are selected one at a time and work
- testPrice: Tests that the price can be multi-selected and deselected
- testIcons: Tests that the icons can select, the terms change the icons, and that the icons deselect upon the term changing

### MealOfFortuneUITests:
- testLaunch: Tests that the app can launch without error
- testLaunchPerformance: Test the performance of launching the app multiple times
- testRandomButton: Tests 'Random Restaurant' button is there and is functional
- testSpecificButton: Tests 'Something Specific' button is there and is functional
- testListButton: Tests 'List of Restaurants' button is there and is functional
- testSavedButton: Tests 'Saved Restaurants' button is there and is functional
