@isTest
public with sharing class WarehouseCalloutServiceTest {
    @isTest
    static void warehouseCalloutServiceTest1() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService callJob = new WarehouseCalloutService();
        Test.startTest();
        System.enqueueJob(callJob);
        Test.stopTest();
        Product2 equipment = [SELECT ID, Warehouse_SKU__c, Maintenance_Cycle__c FROM Product2 LIMIT 1];
        System.assertEquals('122221', equipment.Warehouse_SKU__c);
    }
}
