public with sharing class CTPeopleTracingHandler {
        public static void beforeInsert(List<People_Tracing__c> newRecords){
            List<People_Tracing__c>  duplicates=CTPeopleTracingController.checkDuplicates(newRecords);

            for(People_Tracing__c pt: duplicates){
                pt.addError('Duplicate Record Found. Person 1'+pt.Person_1__c +'Person 2'+pt.Person_2__c);
            }
        }
}