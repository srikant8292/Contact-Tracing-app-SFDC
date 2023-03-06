trigger CTLocationTrigger on Location__c (before insert,after insert,before update,after update) {

    switch on Trigger.operationType {
        when  BEFORE_INSERT{
            CTLOcationTriggerHandler.beforeInsert(Trigger.New);
        }
        when BEFORE_UPDATE {
            CTLOcationTriggerHandler.beforeUpdate(Trigger.New,Trigger.oldMap);
        }

        when AFTER_UPDATE {
            CTLOcationTriggerHandler.afterUpdate(Trigger.New,Trigger.oldMap);
        }

    }


}