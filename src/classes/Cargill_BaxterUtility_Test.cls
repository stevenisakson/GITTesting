/*******
 * CreatedDate : 19-07-2018
 * Author : Amrish Surve
 * Description : test class for a class Cargill_BaxterUtility
 *******/
@isTest
public class Cargill_BaxterUtility_Test {

    @isTest
    static void checkValues(){
        Cargill_BaxterUtility cb = new Cargill_BaxterUtility();
        System.assertEquals(Cargill_BaxterUtility.parentRecords, 'Parent');
        System.assertEquals(Cargill_BaxterUtility.childRecords,'Child');
        System.assertEquals(Cargill_BaxterUtility.createTypeRecord,'Month');
        System.assertEquals(Cargill_BaxterUtility.getObjectType,'Account_Attachments__c');
        System.assertEquals(Cargill_BaxterUtility.typeDisplay,'Display');
        System.assertEquals(Cargill_BaxterUtility.typeEvents,'Events');
        System.assertEquals(Cargill_BaxterUtility.typeTraining,'For Training');
        System.assertEquals(Cargill_BaxterUtility.typeProspectList,'Prospect Lists and Activities');
        System.assertEquals(Cargill_BaxterUtility.cargillSettingTypeM,'Month');
        System.assertEquals(Cargill_BaxterUtility.cargillSettingTypeY,'Year');
    }
}