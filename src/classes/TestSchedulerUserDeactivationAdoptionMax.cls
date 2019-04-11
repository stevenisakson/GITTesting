@isTest
public class TestSchedulerUserDeactivationAdoptionMax
{
      public static testMethod void testschedule() 
      {

         Test.StartTest();
         SchedulerUserDeactivationAdoptionMax sh1 = new SchedulerUserDeactivationAdoptionMax();
         String sch = '0 0 23 * * ?'; system.schedule('Test SchedulerUserDeactivationAdoptionMax', sch, sh1); 
         
        
         Test.stopTest(); 
      }

}