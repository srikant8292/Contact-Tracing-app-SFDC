({
    createRecord : function(component, event, helper) {

        const createRecordEvent = $A.get("e.force:createRecord");

        const scope= component.get("v.headerTitleId");
        createRecordEvent.setParams({
            "entityApiName": scope === "person" ? "Person__c" :"Location__c"
        });
        createRecordEvent.fire();

    },

    doInit:function(component, event, helper) {
        helper.fetchhealthstatuscount(component);
    },
    fetchCount :function(component, event, helper) {
        helper.fetchhealthstatuscount(component);
    }
})
