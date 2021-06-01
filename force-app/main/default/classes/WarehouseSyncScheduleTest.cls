@IsTest
public with sharing class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @IsTest
    static void testMethod1(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobID = System.schedule('WarehouseSyncScheduleTest', CRON_EXP, new WarehouseSyncSchedule());
        Test.stopTest();
        List<Product2> equipList = [SELECT  ID, Warehouse_SKU__c FROM Product2];
        System.assertEquals(0, equipList.size());
    }

    @isTest
    static void testMethod2() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncScheduleTest', '0 0 1 * * ?', new WarehouseSyncSchedule());
        Test.stopTest();
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertNotEquals(null, ct);
    }
}