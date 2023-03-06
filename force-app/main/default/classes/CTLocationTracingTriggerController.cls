public with sharing class CTLocationTracingTriggerController {
    
    public static void beforeInsert(List<Location_Tracing__c> newRecords){
        List<Location_Tracing__c>  duplicates=CTLocationTracingController.checkDuplicates(newRecords);

            for(Location_Tracing__c lt: duplicates){
                lt.addError('Duplicate Record Found. Location'+lt.Location__c +'Person'+lt.Person__c);
            }
    }
}