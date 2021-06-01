@isTest
public with sharing class MaintenanceRequestHelperTest {

    @TestSetup 
    static void makeData() {
        List<Product2> equipList = new List<Product2>();
        List<Case> testCaseList = new List<Case>();
        List<Equipment_Maintenance_Item__c> itemsList = new List<Equipment_Maintenance_Item__c>();
        Vehicle__c veh = new Vehicle__c();
        veh.Name = 'Debin RV';
        veh.Awning__c = 'Manual';
        veh.Bathrooms__c = 2.0;
        veh.Bedrooms__c = 2.0;
        insert veh;

        Product2 equipment1 = new Product2();
        Product2 equipment2 = new Product2();
        equipment1.Name = 'Rotor W1000';
        equipment1.ProductCode = 'RW1001';
        equipment1.Warehouse_SKU__c = 'SK1001';
        equipment1.Maintenance_Cycle__c = 10.0;
        equipment1.Replacement_Part__c = true;
        equipment2.Name = 'Motor W1000';
        equipment2.ProductCode = 'MW1001';
        equipment2.Warehouse_SKU__c = 'SK1002';
        equipment2.Maintenance_Cycle__c = 10.0;
        equipment2.Replacement_Part__c = true;
        equipList.add(equipment1);
        equipList.add(equipment2);
        insert equipList;

        for (Integer i = 0; i < 300; i++) {
            Case testCase = new Case();
            testCase.Subject = 'Test Case '+i;
            testCase.Vehicle__c = veh.Id;
            testCase.Status = 'New';
            testCase.Priority = 'Medium';
            testCase.Origin = 'Phone';
            testCase.Type = 'Repair';
            testCaseList.add(testCase);
        }
        insert testCaseList;

        for (Case caseRec : testCaseList) {
            Equipment_Maintenance_Item__c item1 = new Equipment_Maintenance_Item__c();
            Equipment_Maintenance_Item__c item2 = new Equipment_Maintenance_Item__c();
            item1.Maintenance_Request__c = caseRec.Id;
            item1.Equipment__c = equipList[0].Id;
            item1.Quantity__c = 2;
            item2.Maintenance_Request__c = caseRec.Id;
            item2.Equipment__c = equipList[1].Id;
            item2.Quantity__c = 2;
            itemsList.add(item1);
            itemsList.add(item2);
        }
        insert itemsList;
    }

    @IsTest
    static void positiveTest1(){
        Case testCase = [Select ID, Status from Case limit 1];
        testCase.Status = 'Closed';
        Test.startTest();
        update testCase;
        Test.stopTest();
        
        Case newFollowUpCase = [SELECT ID, ParentId, Status, Type FROM Case WHERE ParentId =: testCase.Id];
        System.assertEquals('Routine Maintenance', newFollowUpCase.Type);
    }

    @IsTest
    static void positiveTest2(){
        Vehicle__c veh = new Vehicle__c();
        veh.Name = 'Debin RV Negative';
        veh.Awning__c = 'Manual';
        veh.Bathrooms__c = 2.0;
        veh.Bedrooms__c = 2.0;
        insert veh;

        Product2 equipment = new Product2();
        equipment.Name = 'Rotor W1001';
        equipment.ProductCode = 'RW1002';
        equipment.Warehouse_SKU__c = 'SK1002';
        equipment.Replacement_Part__c = true;
        insert equipment;

        Case testCase = new Case();
        testCase.Subject = 'Test Case';
        testCase.Vehicle__c = veh.Id;
        testCase.Status = 'New';
        testCase.Priority = 'Medium';
        testCase.Origin = 'Phone';
        testCase.Type = 'Repair';
        insert testCase;

        Equipment_Maintenance_Item__c item = new Equipment_Maintenance_Item__c();
        item.Maintenance_Request__c = testCase.Id;
        item.Equipment__c = equipment.Id;
        item.Quantity__c = 2;
        insert item;

        testCase.Status = 'Closed';
        Test.startTest();
        update testCase;
        Test.stopTest();
        
    }
    
    @IsTest
    static void negativeTest(){
        Case testCase = [Select ID, Status from Case limit 1];
        testCase.Status = 'Pending';
        Test.startTest();
        update testCase;
        Test.stopTest();
        
    }

    @IsTest
    static void bulkTest(){
        List<Case> bulkUpdateList = new List<Case>();
        List<Case> bulkCaseList = [Select ID, Status from Case];
        for (Case caseRec : bulkCaseList) {
            caseRec.Status = 'Closed';
            bulkUpdateList.add(caseRec);
        }
        Test.startTest();
        update bulkUpdateList;
        Test.stopTest();
        
    }
}
