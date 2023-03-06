public with sharing class CTPeopleTracingController {
   
  public static List<People_Tracing__c> getTraces(String personId){
     return [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c,Person_1__r.Health_Status__c,Person_1__r.Token__c, 
     Person_2__c, Person_2__r.Health_Status__c,Person_2__r.Token__c, CreatedDate FROM People_Tracing__c WHERE 
     (Person_1__c =:personId OR Person_2__c =:personId) AND Contact_Date__c =LAST_N_DAYS:30 ORDER BY Contact_Date__c];
  }

  public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTracesRecords){
   Set<Id> personIds= new Set<Id>();

       for(People_Tracing__c pt: peopleTracesRecords){
          personIds.add(pt.Person_1__c);
          personIds.add(pt.Person_2__c);
       }

       List<People_Tracing__c> duplicates=new List<People_Tracing__c>();
       Map<Id,Set<Id>> recordMap=new Map<Id,Set<Id>>();

       List<People_Tracing__c> existingRecordPersons=[Select Id, Person_1__c,Person_2__c
                                 FROM People_Tracing__c WHERE Person_1__c IN :personIds OR 
                                 Person_2__c IN :personIds];
          
         if(existingRecordPersons !=null && existingRecordPersons.size()>0){
            for(People_Tracing__c er : existingRecordPersons){
                  if(!recordMap.containsKey(er.Person_1__c)){
                      recordMap.put(er.Person_1__c, new Set<Id>());
                  }

                  recordMap.get(er.Person_1__c).add(er.Person_2__c);

                  if(!recordMap.containsKey(er.Person_2__c)){
                     recordMap.put(er.Person_2__c, new Set<Id>());
                 }

                 recordMap.get(er.Person_2__c).add(er.Person_1__c);
            }
         
         }
         
         for(People_Tracing__c trace :peopleTracesRecords){
            if(recordMap.containsKey(trace.Person_1__c) && recordMap.get(trace.Person_1__c).contains(trace.Person_2__c)
                 ||
                 recordMap.containsKey(trace.Person_2__c) && recordMap.get(trace.Person_2__c).contains(trace.Person_1__c)  
            
            ){
                duplicates.add(trace);
            }
         }

         return duplicates;
  }
       
}