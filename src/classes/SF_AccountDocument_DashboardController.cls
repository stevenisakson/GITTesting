/*******
* CreatedDate : 11-09-2018
* Author : Amrish Surve
* Description : Contains method which are used for checking monthly account document data
*******/

public with sharing class SF_AccountDocument_DashboardController{

    public static String currentID{get;set;}
    public static Boolean monthFlag{get; set;}
    public static Boolean trainFlag{get; set;}
    public static Boolean eventFlag{get; set;}
    public static Boolean prospectFlag{get; set;}
    public static Boolean growthFlag{get; set;}
    public static Boolean productOfferinggrowthFlag{get;set;}
    
    public SF_AccountDocument_DashboardController(ApexPages.StandardController controller){
        currentID = controller.getRecord().id;
        monthFlag = Cargill_Lt_AttachmentUpload.checkMonthlyList(currentID);
        trainFlag = Cargill_Lt_AttachmentUpload.checkTrainingList(currentID);
        eventFlag = Cargill_Lt_AttachmentUpload.checkQuarterlyList(currentID);
        prospectFlag = Cargill_Lt_AttachmentUpload.checkProspectList(currentID);
        growthFlag = Cargill_Lt_AttachmentUpload.checkGrowthMetrix(currentID);
        productOfferinggrowthFlag = Cargill_Lt_AttachmentUpload.checkGrowthMetrixV1(currentID);
    }
    
    
    
}