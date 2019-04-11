@isTest
public class PotentialLookupUtilityTest {

    public static testmethod void testgetCompetitors(){
        String accountName='Comp1';
        PotentialTestDataFactory.insertCompetitorAccount(accountName);
        Response re=PotentialLookupUtility.getCompetitors('');
        if(re!=null){
            for(Account acc:(List<Account>)re.data){
                System.assertEquals(accountName, acc.Name);
            }
        }
    }
     public static testmethod void testgetSalesPersons(){
        String salesperson='Sp1'; 
        String accountName='Comp1';
        Id accId=PotentialTestDataFactory.insertCompetitorAccount(accountName);
        PotentialTestDataFactory.insertContact(salesperson,accId); 
        Response re=PotentialLookupUtility.getSalesPersons(accountName,'');
         if(re!=null){
             for(Contact cc:(List<Contact>)re.data){
                 System.assertEquals(salesperson, cc.Name);
             }
         } 
    }
}