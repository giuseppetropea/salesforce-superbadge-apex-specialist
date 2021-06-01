public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    
    // System.enqueueJob(new WarehouseCalloutService());
    // SELECT Status,NumberOfErrors FROM AsyncApexJob

    public void execute(QueueableContext context) {
        Http httpObj = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        HttpResponse response = httpObj.send(request);
        
        if(response.getStatusCode() == 200) {
            List<Object> responseBody = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> newEquipmentList = new List<Product2>();

            for(Object obj : responseBody) {
                Map<String, Object> responseMap = (Map<String, Object>) obj;
                Product2 newEquipment = new Product2();
                newEquipment.Warehouse_SKU__c = (String)responseMap.get('sku');
                newEquipment.Current_Inventory__c = (Decimal)responseMap.get('quantity');
                newEquipment.Name = (String) responseMap.get('name');
                newEquipment.Maintenance_Cycle__c = (Decimal)responseMap.get('maintenanceperiod');
                newEquipment.Lifespan_Months__c = (Decimal)responseMap.get('lifespan');
                newEquipment.Cost__c = (Decimal)responseMap.get('cost');
                newEquipment.Replacement_Part__c = true;
                newEquipmentList.add(newEquipment);
            }

            if (newEquipmentList.size()>0) {
                upsert newEquipmentList;
            }
        }

    }
}