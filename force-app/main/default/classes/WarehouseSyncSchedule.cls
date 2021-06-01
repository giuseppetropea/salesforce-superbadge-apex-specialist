public with sharing class WarehouseSyncSchedule implements Schedulable {
    // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_scheduler.htm
    // System.schedule('WarehouseSyncScheduleJob', '0 0 1 * * ?', new WarehouseSyncSchedule());
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}