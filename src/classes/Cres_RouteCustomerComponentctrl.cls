/**
* This class is for Route Customers creation used in @Cres_RouteCustcomponent
* @author : Ashok
* @version 1.0
 
*/

public class Cres_RouteCustomerComponentctrl{

    /**
   * This method is used get Route related route customers. 
     @param : Routeid record id get form landing page
   */
   @auraenabled
    public static list<Route__c> getCustomerList(String routeid){
        List<Route__c> routeCust=new List<Route__c>();
        if(routeid!=null){
            routeCust=[select id,Account__c,Active__c from Route__c where Related_Route__c =:routeid];
            return routeCust;
            
        }else{
            return null;
        }
    }
 /**
   * This method is used delete route customers. 
     @param : recId is route customer recordid
   */ 
     @AuraEnabled
    public static Response deleteRecord(Id recId){
        System.debug('Delete$$$'+recId);
            Database.DeleteResult rs=Database.delete(recId);
        if(rs.isSuccess()){
            return new Response(true,'SUCCESS',true);
        }else{
            return new Response(false,'SUCCESS',false);
        }
        
    }
    /**
   * This method is used get route details. 
     @param : routeid is route recordid
   */ 
    @auraenabled
    public static Route__c getroutedetails(String routeid){
        Route__c route=new Route__c();
        if(routeid!=null){
            route=[select id,Account__c,Active__c,Status__c from Route__c where id =:routeid];
            return route;
            
        }else{
            return null;
        }
    }


}