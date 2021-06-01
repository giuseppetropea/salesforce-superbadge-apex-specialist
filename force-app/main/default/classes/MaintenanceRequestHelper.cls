public with sharing class MaintenanceRequestHelper {

    public static void handleAfterUpdate(List<Case> newCases) {
        List<Case> closedCases = new List<Case>();
        for(Case caseObj : newCases) {
            if(caseObj.Status == 'Closed' && (caseObj.Type == 'Repair' || caseObj.Type == 'Routine Maintenance')) {
                closedCases.add(caseObj);
            }
            
        }

        if(closedCases.size() > 0) {
            MaintenanceRequestHelper.updateWorkOrder(closedCases);
        }
    }

    public static void updateWorkOrder(List<Case> caseList) {
        List<Case> caseListToInsert = new List<Case>();
        List<Equipment_Maintenance_Item__c> itemListToInsert = new List<Equipment_Maintenance_Item__c>();
        Map<Id, Integer> dueDateMap = MaintenanceRequestHelper.getDueDates(caseList);
        Map<Id, List<Equipment_Maintenance_Item__c>> maintenanceItemMap = MaintenanceRequestHelper.getMaintenanceItems(caseList);

        for(Case caseObj : caseList) {
            Case newCase = new Case();
            newCase.Vehicle__c = caseObj.Vehicle__c;
            newCase.Subject = 'Routine Maintenance';
            newCase.Type = 'Routine Maintenance';
            newCase.Date_Reported__c = Date.today();
            newCase.ParentId = caseObj.Id;
            
            newCase.Date_Due__c = Date.today();
            if(dueDateMap.get(caseObj.Id) != null) {
                newCase.Date_Due__c = newCase.Date_Due__c.addDays(dueDateMap.get(caseObj.Id));
            }

            caseListToInsert.add(newCase);
        }

        if(caseListToInsert.size() > 0) {
            insert caseListToInsert;

            for(Case insertedCase : caseListToInsert) {
                List<Equipment_Maintenance_Item__c> itemList = maintenanceItemMap.get(insertedCase.ParentId);
                if(itemList != null && itemList.size() > 0) {
                    for(Equipment_Maintenance_Item__c itemObj : itemList) {
                        Equipment_Maintenance_Item__c newItem = new Equipment_Maintenance_Item__c();
                        newItem.Maintenance_Request__c = insertedCase.Id;
                        newItem.Equipment__c = itemObj.Equipment__c;
                        newItem.Quantity__c = itemObj.Quantity__c;

                        itemListToInsert.add(newItem);
                    }
                }
            }

            if(itemListToInsert.size() > 0) {
                insert itemListToInsert;
            }
        }
    }

    private static Map<Id, Integer> getDueDates(List<Case> caseList) {
        Map<Id, Integer> results = new Map<Id, Integer>();
        Map<Id, Case> caseMap = new Map<Id, Case>(CaseList);
        
        List<AggregateResult> aggResults = [
            SELECT 
                Maintenance_Request__c cId, // Case Id
                MIN(Equipment__r.Maintenance_Cycle__c) cycle
            FROM Equipment_Maintenance_Item__c
            WHERE
                Maintenance_Request__c IN :caseMap.keySet() 
                AND Equipment__r.Maintenance_Cycle__c != null
            GROUP BY Maintenance_Request__c
        ];

        for(AggregateResult res : aggResults) {
            results.put(String.valueOf(res.get('cId')), Integer.valueOf(res.get('cycle')));
        }

        return results;
    }

    private static Map<Id, List<Equipment_Maintenance_Item__c>> getMaintenanceItems(List<Case> caseList) {
        Map<Id, List<Equipment_Maintenance_Item__c>> results = new Map<Id, List<Equipment_Maintenance_Item__c>>();
        Map<Id, Case> caseMap = new Map<Id, Case>(caseList);
        
        List<Equipment_Maintenance_Item__c> itemList = [
            SELECT 
                Id,
                Maintenance_Request__c,
                Equipment__c,
                Quantity__c
            FROM Equipment_Maintenance_Item__c
            WHERE Maintenance_Request__c IN :caseMap.keySet()
        ];

        for(Equipment_Maintenance_Item__c item : itemList) {

            List<Equipment_Maintenance_Item__c> requestItemList = results.get(item.Maintenance_Request__c);
            if(requestItemList == null) {
                requestItemList = new List<Equipment_Maintenance_Item__c>();
                results.put(item.Maintenance_Request__c, requestItemList);
            }
            requestItemList.add(item);
        }

        return results;
    }

}