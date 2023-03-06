public with sharing class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitor(String locationId){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, CreatedDate, Person__r.Token__c,Person__r.Health_Status__c FROM 
        Location_Tracing__c WHERE Id =:locationId ORDER BY Visit_Date__c DESC];
     }
  
     public static List<Location_Tracing__c> getLocationByPersonId(Set<Id> personIds){
  
        return [SELECT  Person__c, Location__c, Visit_Date__c FROM 
        Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c =LAST_N_DAYS:10];
     }
  
     public static List<Location_Tracing__c> getLocationByLocationId(Set<Id> locationIds){
  
      return [SELECT  Person__c, Location__c, Visit_Date__c FROM 
      Location_Tracing__c WHERE Location__c IN :locationIds AND Person__r.Health_Status__c='Green'  AND Visit_Date__c =LAST_N_DAYS:10];
   }

   public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationtracinglist){
           Set<Id> locId=new Set<Id>();
           Set<Id> personId= new Set<Id>();

           for(Location_Tracing__c lt: locationtracinglist){
                locId.add(lt.Location__c);
                personId.add(lt.Person__c);
           }

           Map<Id,Set<Id>> mapOfExistingId= new Map<Id,Set<Id>>();

           List<Location_Tracing__c> duplicatesList=new List<Location_Tracing__c>();

     List<Location_Tracing__c> existingRecords=[SELECT  Person__c, Location__c, Visit_Date__c FROM 
           Location_Tracing__c WHERE Location__c IN :locId AND Person__c IN :personId];

           if(existingRecords !=null && existingRecords.size()>0){
                 for(Location_Tracing__c trace: existingRecords){
                      if(!mapOfExistingId.containsKey(trace.Location__c)){
                        mapOfExistingId.put(trace.Location__c,new Set<Id>());
                      }
                      mapOfExistingId.get(trace.Location__c).add(trace.Person__c);
                 }
           }

           for(Location_Tracing__c trace : locationtracinglist){

            if(mapOfExistingId.containsKey(trace.Location__c) && mapOfExistingId.get(trace.Location__c).contains(trace.Person__c)){
                duplicatesList.add(trace);
            }
           }

           return duplicatesList;


   }
}