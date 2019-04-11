/*******
 * CreatedDate : 19-06-2018
 * Author : Amrish Surve
 * Description : Contains schedular class for main class SF_UpdateAccountBatch
 *******/

global class scheduledUpdateAccountBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      SF_UpdateAccountBatchs b = new SF_UpdateAccountBatchs(); 
      database.executebatch(b, 1);
   }
}