global class schedulerUserDeactivationAdoptionMax implements Schedulable{

   global void execute(SchedulableContext SC) {

      UserDeactivationAdoptionMax.userDeactivate();
   }

   
}