/*******
* CreatedDate : 19-09-2018
* Author : Amrish Surve
* Description : Contains test class for main class scheduledUpdateAccountBatch
*******/
@istest
public class scheduledUpdateAccountBatch_Test {
    
    @istest
    public static void testschedule() {
        
        Test.StartTest();
        scheduledUpdateAccountBatch sh1 = new scheduledUpdateAccountBatch();      
        String sch = '0 0 23 * * ?';
        system.schedule('Account Update Flags', sch, sh1);
        Test.stopTest();
        
    }
}