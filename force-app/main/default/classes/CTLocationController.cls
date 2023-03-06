public with sharing class CTLocationController {
    public static List<Location__c> getStatusChangeLocation(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c  ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Location__c>  searchLocation(String searchKey){
        String searchTerm= searchKey + '%';

        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, 
        Status_Update_Date__c, Status__c FROM Location__c WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm  
        ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Location__c getLocationId(String locationId){
    List<Location__c> locations= [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
        FROM Location__c WHERE Id =:locationId];

        if(locations.size()>0 && locations != null){
            return locations.get(0);
         }
         return null;
    }

    public static Map<String,Integer> getLocationStatus(){
        Map<String,Integer> healthCountMap = new  Map<String,Integer>();
      for(AggregateResult res : [Select Status__c ,COUNT(Id) total from Location__c GROUP BY Status__c] ){
            healthCountMap.put(String.valueOf(res.get('Status__c')),Integer.valueOf(res.get('total')));
      }
      return healthCountMap;
    }

    public static void updateRedScore(Set<Id> locationId){
       List<Location__c> locationToUpdate=new List<Location__c>();

      AggregateResult[] resPeoplePerLocation=[Select Location__c, COUNT(Id) total from 
              Location_Tracing__c WHERE Person__r.Health_Status__c ='Red'
           AND Visit_Date__c=LAST_N_DAYS:10 AND Location__c IN :locationId GROUP BY Location__c];

           for(AggregateResult ar: resPeoplePerLocation){
               String locId=String.valueOf(ar.get('Location__c'));
               Integer redScore =Integer.valueOf(ar.get('total'));
                String score = getRedScore(redScore);

                locationToUpdate.add(new Location__c(Id =locId ,Red_Score__c=redScore,Status__c=score));
           }

           if(locationToUpdate !=null && locationToUpdate.size()>0){
              update locationToUpdate;
           }
    }

    public static String getRedScore(Integer redScore){
        if(redScore == 0) return 'Green';
        else if(redScore <=5) return 'Yellow';
        else if(redScore <=10) return 'Orange';
        else return 'Red';
    }

    public static Map<String,Integer> getLocationHealthStatusCount(){
        AggregateResult[] heathCountLocation=[SELECT Status__c ,COUNT(Id) total from Location__c GROUP BY Status__c];
    
        Map<String,Integer> results=new Map<String,Integer>();
          
        if(heathCountLocation !=null && heathCountLocation.size()>0){
            for(AggregateResult ar: heathCountLocation){
                results.put(String.valueOf(ar.get('Status__c')),Integer.valueOf(ar.get('total')));
            }
    
            return results;
        }
        return null;
       
            
    }

}