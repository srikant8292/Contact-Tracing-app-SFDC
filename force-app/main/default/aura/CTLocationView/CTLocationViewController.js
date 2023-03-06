({
    locationSelectHandler : function(component, event, helper) {
      const recordId=   event.getParam("recordId");
      const scope=   event.getParam("scope");

      const status= event.getParam("status");

      component.set("v.status",status);

      component.set("v.recordId",recordId);
      component.set("v.scope",scope);
    }
})
