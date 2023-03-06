trigger CTLocationTracingTrigger on Location_Tracing__c (before insert,before update) {

    switch on Trigger.operationType {
        when  BEFORE_INSERT{
            CTLocationTracingTriggerController.beforeInsert(Trigger.new);
        }
    }

}