public with sharing class CTPersonController {
    public static List<Person__c> getRecentHealthChanges(){
        List<Person__c> persons=[SELECT Id, Health_Status__c, Name, Status_Update_Date__c, Mobile__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];

          return persons;
    }

    public static List<Person__c> searchPerson(String searchKey){
        String searchTerm= searchKey + '%';
        return [SELECT Id, Health_Status__c, Name, Status_Update_Date__c, Mobile__c, Token__c FROM Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm  ORDER BY Status_Update_Date__c DESC NULLS LAST ];
    }

    public static Person__c getPersonById(String personId){
        List<Person__c> people= [SELECT Id, Health_Status__c,
         Name, Status_Update_Date__c, Mobile__c, Token__c FROM Person__c WHERE Id =:personId];

         if(people.size()>0 && people != null){
            return people.get(0);
         }
         return null;
    }

    public  static String getToken(String mobileNo){
        Blob value= Blob.valueOf(mobileNo);
        Blob hash= Crypto.generateDigest('MD5' ,value);

        return EncodingUtil.base64Encode(hash);
   }

   public static Map<String,Integer>  getHealthStatusCount(){
    Map<String,Integer> healthCountMap = new  Map<String,Integer>();
      for(AggregateResult res : [Select Health_Status__c ,COUNT(Id) total from Person__c GROUP BY Health_Status__c] ){
            healthCountMap.put(String.valueOf(res.get('Health_Status__c')),Integer.valueOf(res.get('total')));
      }
      return healthCountMap;
   }

   public static Set<Id> getCohibitant(Set<Id> personIds, Set<Id> allreadyproccessed){
      
       List<String> healthStatus=new List<String>{'Green','Yellow'};

      List<People_Tracing__c> cohabitantList= [Select Id, Person_1__c,Person_2__c from People_Tracing__c WHERE (Person_1__c IN :personIds 
       OR Person_2__c IN :personIds) AND Contact_Type__c= 'Cohabitant'
       AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];

       Set<Id> conhabitantset=new Set<Id>();

          for(People_Tracing__c pt: cohabitantList){
              if(!allreadyproccessed.contains(pt.Person_1__c)){
                  conhabitantset.add(pt.Person_1__c);
                  allreadyproccessed.add(pt.Person_1__c);
              }
              if(!allreadyproccessed.contains(pt.Person_2__c)){
                conhabitantset.add(pt.Person_2__c);
                allreadyproccessed.add(pt.Person_2__c);
            }
          }

          return conhabitantset;
   }

   public static Set<Id> getNeighbour(Set<Id> personIds , Set<Id> allreadyproccessed){
      
 

   List<People_Tracing__c> neighbourList= [Select Id, Person_1__c,Person_2__c from People_Tracing__c WHERE (Person_1__c IN :personIds 
    OR Person_2__c IN :personIds) AND Contact_Type__c= 'Neighbour'
    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c  = 'Green')];

    Set<Id> neighbour=new Set<Id>();

       for(People_Tracing__c pt: neighbourList){
           if(!allreadyproccessed.contains(pt.Person_1__c)){
            neighbour.add(pt.Person_1__c);
            allreadyproccessed.add(pt.Person_1__c);
           }
           if(!allreadyproccessed.contains(pt.Person_2__c)){
            neighbour.add(pt.Person_2__c);
            allreadyproccessed.add(pt.Person_2__c);
         }
       }

       return neighbour;
}

public static Set<Id> getPrimaryContacts(Set<Id> personIds , Set<Id> allreadyproccessed){
      
    List<String> healthStatus=new List<String>{'Green','Yellow'};

   List<People_Tracing__c> primaryContactList= [Select Id, Person_1__c,Person_2__c from People_Tracing__c WHERE (Person_1__c IN :personIds 
    OR Person_2__c IN :personIds) AND Contact_Type__c= 'Other' AND Contact_Date__c = LAST_N_DAYS:10
    AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];

    Set<Id> primaryset=new Set<Id>();

       for(People_Tracing__c pt: primaryContactList){
           if(!allreadyproccessed.contains(pt.Person_1__c)){
            primaryset.add(pt.Person_1__c);
            allreadyproccessed.add(pt.Person_1__c);
           }
           if(!allreadyproccessed.contains(pt.Person_2__c)){
            primaryset.add(pt.Person_2__c);
            allreadyproccessed.add(pt.Person_2__c);
         }
       }

       return primaryset;
}
public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> allreadyproccessed){
      
    // List<String> healthStatus=new List<String>{'Green','Yellow'};

   List<People_Tracing__c> secondaryContactList= [Select Id, Person_1__c,Person_2__c from People_Tracing__c WHERE (Person_1__c IN :primaryContactIds 
    OR Person_2__c IN :primaryContactIds) AND Contact_Type__c= 'Other' AND Contact_Date__c = LAST_N_DAYS:10
    AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c  = 'Green')];

    Set<Id> secondaryset=new Set<Id>();

       for(People_Tracing__c pt: secondaryContactList){
           if(!allreadyproccessed.contains(pt.Person_1__c)){
            secondaryset.add(pt.Person_1__c);
            allreadyproccessed.add(pt.Person_1__c);

           }
           if(!allreadyproccessed.contains(pt.Person_2__c)){
            secondaryset.add(pt.Person_2__c);
            allreadyproccessed.add(pt.Person_2__c);
         }
       }

       return secondaryset;
}

public static Map<String,Integer> getPersonHealthStatusCount(){
    AggregateResult[] heathCountPerson=[SELECT Health_Status__c ,COUNT(Id) total from Person__c GROUP BY Health_Status__c];

    Map<String,Integer> results=new Map<String,Integer>();
      
    if(heathCountPerson !=null && heathCountPerson.size()>0){
        for(AggregateResult ar: heathCountPerson){
            results.put(String.valueOf(ar.get('Health_Status__c')),Integer.valueOf(ar.get('total')));
        }

        return results;
    }
    return null;
   
        
}
}