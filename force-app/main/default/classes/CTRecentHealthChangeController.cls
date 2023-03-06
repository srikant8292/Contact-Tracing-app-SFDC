public with sharing class CTRecentHealthChangeController {
    
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        return CTPersonController.getRecentHealthChanges();
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        return CTLocationController.getStatusChangeLocation();
    }

    @AuraEnabled
    public static List<Person__c> searchPerson(String searchTerm){
        return CTPersonController.searchPerson(searchTerm);
    }

    @AuraEnabled
    public static List<Location__c> searchLocation(String searchTerm){
        return CTLocationController.searchLocation(searchTerm);
    }
}