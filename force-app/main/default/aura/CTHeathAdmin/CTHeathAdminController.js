({
    tabSelectHandler : function(component, event, helper) {

        const tabtitleId=event.getParam("id");

        if(tabtitleId ==='person'){
         component.set("v.headerTitle","Person View");
         }
         else{
            component.set("v.headerTitle","Location View");
         }
         component.set("v.headerTitleId",tabtitleId);

      const heathheadercomp =  component.find("heathheadercomp");
      heathheadercomp.fetchCount();
        
    }
})
