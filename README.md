# Superbadge: Apex Specialist

- [Superbadge Requirements](https://trailhead.salesforce.com/en/content/learn/superbadges/superbadge_apex)
- [Challenge Help](https://trailhead.salesforce.com/help?article=Apex-Specialist-Superbadge-Challenge-Help)

## Set Up Development Org

- Create a new Trailhead Playground for this superbadge. Using this org for any other reason might create problems when validating the challenge. If you choose to use a development org, make sure you deploy My Domain to all the users. The package you will install has some custom lightning components that only show when My Domain is deployed.
- Install this [unlocked package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6g000008av9iAAA) (package ID: 04t6g000008av9iAAA). This package contains metadata you'll use to complete this challenge. If you have trouble installing this package, follow the steps in the [Install a Package or App to Complete a Trailhead Challenge](https://trailhead.salesforce.com/help?article=Installing-a-package-or-app-to-complete-a-Trailhead-challenge) help article.
- Add picklist values Repair and Routine Maintenance to the Type field on the Case object.
- Update the Case page layout assignment to use the Case (HowWeRoll) Layout for your profile.
- Rename the tab/label for the Case tab to Maintenance Request.
- Update the Product page layout assignment to use the Product (HowWeRoll) Layout for your profile.
- Rename the tab/label for the Product object to Equipment.
- Use App Launcher to navigate to the Create Default Data tab of the How We Roll Maintenance app. Click Create Data to generate sample data for the application.
- Review the newly created records to get acquainted with the data model.

## Challenge 1: Automate record creation

Install the unlocked package and configure the development org.
Use the included package content to automatically create a Routine Maintenance request every time a maintenance request of type Repair or Routine Maintenance is updated to Closed. Follow the specifications and naming conventions outlined in the business requirements.

## Challenge 2

Implement an Apex class (called WarehouseCalloutService) that implements the queueable interface and makes a callout to the external service used for warehouse inventory management. This service receives updated values in the external system and updates the related records in Salesforce. Before checking this section, enqueue the job at least once to confirm that it's working as expected.

## Challenge 3

Build scheduling logic that executes your callout and runs your code daily. The name of the schedulable class should be WarehouseSyncSchedule, and the scheduled job should be named WarehouseSyncScheduleJob.

## Challenge 4

Build tests for all cases (positive, negative, and bulk) specified in the business requirements by using a class named MaintenanceRequestHelperTest. You must have 100% test coverage to pass this section and assert values to prove that your logic is working as expected. Choose Run All Tests in the Developer Console at least once before attempting to submit this section. Be patient as it may take 10-20 seconds to process the challenge check.

## Challenge 5

Build tests for your callout using the included class for the callout mock (WarehouseCalloutServiceMock) and callout test class (WarehouseCalloutServiceTest) in the package. You must have 100% test coverage to pass this challenge and assert values to prove that your logic is working as expected.

## Challenge 6

Build unit tests for the class WarehouseSyncSchedule in a class named WarehouseSyncScheduleTest. You must have 100% test coverage to pass this challenge and assert values to prove that your logic is working as expected.
