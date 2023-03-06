public with sharing class CTPersonTriggerHandler {
    public static void beforeInsert(List<Person__c> newRecords){
        for(Person__c per : newRecords){
            per.Health_Status__c='Green';
            per.Token__c=CTPersonController.getToken(per.Mobile__c);
      }
    }

    public static void beforeUpdate(List<Person__c> newRecords,Map<Id,Person__c> oldRecordMap){
        for(Person__c per: newRecords){
            if(per.Health_Status__c != oldRecordMap.get(per.Id).Health_Status__c){
                per.Status_Update_Date__c=Date.today();
            }
        }
    }

    public static void afterUpdate(List<Person__c> newRecords,Map<Id,Person__c> oldRecordMap){

        System.debug('after Update Method is call 1');

        Set<Id> statusChange=new Set<Id>();
        Set<Id> redStatusChange =new Set<Id>();
        for(Person__c per: newRecords){
            if(per.Health_Status__c != oldRecordMap.get(per.Id).Health_Status__c){
               statusChange.add(per.Id);
            }
            if(per.Health_Status__c == 'Red' && oldRecordMap.get(per.Id).Health_Status__c !='Red'){
                redStatusChange.add(per.Id);
               
            }

        }
        Set<Id> orangeStatus=new Set<Id>();
        Set<Id> yellowStatus=new Set<Id>();

        System.debug('Red Status list size'+redStatusChange.size());

        List<Person__c> personToUpdate=new List<Person__c>();

        Set<Id> allreadyproccessed =new Set<Id>();
        allreadyproccessed.addAll(redStatusChange);

        orangeStatus.addAll(CTPersonController.getCohibitant(redStatusChange,allreadyproccessed));
        
        Set<Id> primaryCons=CTPersonController.getPrimaryContacts(redStatusChange,allreadyproccessed);
        orangeStatus.addAll(primaryCons);

        yellowStatus.addAll(CTPersonController.getNeighbour(redStatusChange,allreadyproccessed));

        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryCons,allreadyproccessed));

        System.debug('Yellow status size'+yellowStatus.size());
        System.debug('Orange status size'+orangeStatus.size());

        for(Id pid: orangeStatus){
            personToUpdate.add(new Person__c(Id =pid,Health_Status__c ='Orange'));
        }
        for(Id pid: yellowStatus){
            personToUpdate.add(new Person__c(Id =pid,Health_Status__c ='Yellow'));
        }

        System.debug('size'+personToUpdate.size());
        if(personToUpdate.size()>0){
            update personToUpdate;
        }

       List<Location_Tracing__c> locationTraces= CTLocationTracingController.getLocationByPersonId(statusChange);
          if(locationTraces.size()>0 && locationTraces!=null){
            Set<Id> locationIdSet = new Set<Id>();
              for(Location_Tracing__c lc: locationTraces){
                locationIdSet.add(lc.Location__c);
              }

              CTLocationController.updateRedScore(locationIdSet);
              
          }

          System.debug('after Update Method is call last line');

    }
}