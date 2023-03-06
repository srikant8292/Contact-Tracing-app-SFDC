({
    doInit : function(component, event, helper) {
        const scope=component.get("v.scope");
        if(scope ==="person"){
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Health Status', fieldName: 'Health_Status__c', type: 'text'},
                {label: 'Mobile Number', fieldName: 'Mobile__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Person Token', fieldName: 'Token__c', type: 'text'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }
        else{
            component.set('v.columns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Location Health Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Address', fieldName: 'Address__c', type: 'text'},
                {label: 'Location Pincode', fieldName: 'Pincode__c', type: 'text'},
                {label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date'},
                {label: 'Location Red Score', fieldName: 'Red_Score__c', type: 'number'},
                {label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'View/Update', name: 'view_details', title: 'Click to View Details'}}
            ]);
        }
       

        helper.fetchRecentHealthChanges(component);

    },
    onKeyUpHandler : function(component, event, helper){
        var isEnterKey = evt.keyCode === 13;
        var queryTerm = component.find('searchid').get('v.value');

        if(!queryTerm){
            component.set("v.data",component.get("v.intialdata"));
        }
        if (isEnterKey) {
            component.set('v.searching', true);

            helper.searchRecord(component,queryTerm);
            
        }
    
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var scope = component.get("v.scope");
        switch (action.name) {
            case 'view_details':
                  const aapEvent= scope=== "person" ? $A.get("e.c:CTPersonTraceEvent") : $A.get("e.c:CTLocationTraceEvent");
                  aapEvent.setParams({
                    recordId :row.Id,
                    status :scope=== "person" ? row.Health_Status__c : row.Status__c
                  });
                  aapEvent.fire();
                break;
        }
    }
})
