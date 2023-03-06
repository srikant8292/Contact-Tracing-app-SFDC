trigger CTPeopleTracingTrigger on People_Tracing__c (before insert) {
   
    switch on Trigger.operationType {
        when  BEFORE_INSERT{
            CTPeopleTracingHandler.beforeInsert(Trigger.New);
        }
        when else {
            
        }
    }
}