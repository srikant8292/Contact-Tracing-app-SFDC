public with sharing class CTPersonTabController {
    @AuraEnabled
    public static UserInformation getPersonDetails(String personId){

        UserInformation info=new UserInformation();

     Person__c person=CTPersonController.getPersonById(personId);

       if(person !=null){
        info.name=person.Name;
        info.token=person.Token__c;
        info.statusupdatedate=person.Status_Update_Date__c;
        info.mobile=person.Mobile__c;
        info.heathstatus=person.Health_Status__c;
       }

        List<People_Tracing__c> traces= CTPeopleTracingController.getTraces(personId);

        if(traces!=null && traces.size()>0){
            List<CloseContact> closecontactlist=new List<CloseContact>();

            Set<Id> uniqueIds=new Set<Id>();
            uniqueIds.add(personId);

            for(People_Tracing__c trace : traces){
                CloseContact cc=new CloseContact();
               if(!uniqueIds.contains(trace.Person_1__c)){
                   cc.id=trace.Person_1__c;
                   cc.token=trace.Person_1__r.Token__c;
                   cc.contactdate=trace.Contact_Date__c;
                   cc.status=trace.Person_1__r.Health_Status__c;
               }

               if(!uniqueIds.contains(trace.Person_2__c)){
                cc.id=trace.Person_2__c;
                cc.contactdate=trace.Contact_Date__c;
                cc.token=trace.Person_2__r.Token__c;
                cc.status=trace.Person_2__r.Health_Status__c;
            }
              closecontactlist.add(cc);
            }
            info.contacts=closecontactlist;
            info.contactCounts=closecontactlist.size();
        }

        return info;

       
    }

    public class UserInformation{
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date statusupdatedate;
        @AuraEnabled public String mobile;
        @AuraEnabled public String heathstatus;
        @AuraEnabled public Integer contactCounts=0;
        @AuraEnabled public List<CloseContact> contacts;

    }

    public class CloseContact{
        @AuraEnabled public String id;
        @AuraEnabled public Date contactdate;
        @AuraEnabled public String token;
        @AuraEnabled public String status;
    }
        
}