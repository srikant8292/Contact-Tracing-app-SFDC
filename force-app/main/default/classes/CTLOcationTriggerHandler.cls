public with sharing class CTLOcationTriggerHandler {
    
     public static void beforeInsert(List<Location__c> newRecords){
         for(Location__c loc: newRecords){
            loc.Status__c='Green';
         }
     }

     public static void beforeUpdate(List<Location__c> newRecords,Map<Id,Location__c> oldRecordMap){
           for(Location__c loc: newRecords){
               if(loc.Status__c != oldRecordMap.get(loc.Id).Status__c){
                  loc.Status_Update_Date__c= Date.today();
               }
           }
     }

     public static void afterUpdate(List<Location__c> newRecords,Map<Id,Location__c> oldRecordMap){
           Set<Id> statusChange =new Set<Id>();

            for(Location__c loc: newRecords){
                if(loc.Status__c == 'Red' && oldRecordMap.get(loc.Id).Status__c != 'Red'){
                    statusChange.add(loc.Id);
                }
            }

            List<Location_Tracing__c> locationTraces= CTLocationTracingController.getLocationByLocationId(statusChange);
             
            Set<Id> personId=new Set<Id>();

            for(Location_Tracing__c lc: locationTraces){
                personId.add(lc.Person__c);
            }

            List<Person__c> peopleToUpdate=new List<Person__c>();

            for(Id per: personId){
                peopleToUpdate.add(new Person__c(Id=per,Health_Status__c='Yellow'));
            }

            if(peopleToUpdate.size()>0){
                update peopleToUpdate;
            }
     }
}