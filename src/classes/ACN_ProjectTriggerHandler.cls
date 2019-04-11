/*
    Author              : Erick
    Email               : erick.carle.bower@accenture.com
    Company             : Accenture
    Date Created        : 04-OCT-2016
    Description         : Handler class for Project Trigger/ Story No.64
    Modified By         : -
    Modified Date       : -
*/

public class ACN_ProjectTriggerHandler {
    public void beforeInsert(List<Project__c> projectRecs){
        OwnerUpdate(projectRecs,false);
    }
    
    public void afterInsert(List<Project__c> projectRecs){
        doAfterInsert(projectRecs);
    }
    
    
    public void doAfterInsert(List<Project__c> projectRec){
        List<Milestone__c> mileStoneList = new List<Milestone__c>();
        Map<String, Project_Template__c> projTempMap = new Map<String, Project_Template__c>();
        Map<Id, List<ProjectTemplate_MilestoneList__c>> projTempMileListMap = new Map<Id, List<ProjectTemplate_MilestoneList__c>>();
        Map<Id, String> recTypeMap = new Map<Id, String>();

        for(Project_Template__c projTemp : [SELECT Project_Record_Type__c, Project_Sub_Type__c FROM Project_Template__c]) {
            projTempMap.put(projTemp.Project_Record_Type__c+projTemp.Project_Sub_Type__c, projTemp);
        }

        for(ProjectTemplate_MilestoneList__c projMile : [SELECT Project_Template__c, Project_Template__r.Project_Record_Type__c, Project_Template__r.Project_Sub_Type__c,Milestone_List_Library__r.Name, Milestone_List_Library__r.Due_Date__c, Order_No__c FROM ProjectTemplate_MilestoneList__c ORDER BY Order_No__c ASC]) {
            if(!projTempMileListMap.containsKey(projMile.Project_Template__c)){
                projTempMileListMap.put(projMile.Project_Template__c, new List<ProjectTemplate_MilestoneList__c>{projMile});
            }else{
                projTempMileListMap.get(projMile.Project_Template__c).add(projMile);
            }
        }
        
        for(RecordType recType : [SELECT Id, Name FROM RecordType]){
            recTypeMap.put(recType.Id, recType.Name);
        }
        
        DateTime dt;
        
        for(Project__c p : projectRec){
            String name = recTypeMap.get(p.RecordTypeId);
            List<ProjectTemplate_MilestoneList__c> projMileList = projTempMileListMap.get(projTempMap.get(name+p.Project_Sub_Type__c).id);
            
            for(ProjectTemplate_MilestoneList__c pmList:projMileList){
                if(!(pmList.Project_Template__r.Project_Record_Type__c == 'Standard' && pmList.Project_Template__r.Project_Sub_Type__c == 'Fulfillment')){
                    Milestone__c mStone = new Milestone__c();
                    mStone.Name = pmList.Milestone_List_Library__r.Name;
                    mStone.Project__c = p.Id;
    
                    if(name == 'Standard'){ 
                        if(pmList.Milestone_List_Library__r.Due_Date__c != null){  
                            Date startDate = p.Project_Kickoff_Date__c;
                            Double dueDateCounter = pmList.Milestone_List_Library__r.Due_Date__c;
                            Date datePointer = startDate;
                            dt = DateTime.newInstance(datePointer, Time.newInstance(0, 0, 0, 0));
                            String dayOfWeek = dt.format('EEEE');
                            
                            while(dueDateCounter > 0){
                                dt = dt.addDays(1);
                                dayOfWeek = dt.format('EEEE');
                                if((dayOfWeek != 'Saturday') && (dayOfWeek != 'Sunday')){
                                    dueDateCounter--;
                                }
                            }
                            
                            Date myDate = date.newinstance(dt.year(), dt.month(), dt.day());
                            mStone.Due_Date__c = myDate;             
                        }
                    }else{
                        if(p.In_Hands_Date_Requested__c != null){
                            if(pmList.Milestone_List_Library__r.Due_Date__c != null){
                            Date startDate = p.In_Hands_Date_Requested__c;
                            Double dueDateCounter = pmList.Milestone_List_Library__r.Due_Date__c;
                            Date datePointer = startDate;
                            dt = DateTime.newInstance(datePointer, Time.newInstance(0, 0, 0, 0));
                            String dayOfWeek = dt.format('EEEE');
                            
                            while(dueDateCounter > 0){
                                dt = dt -1;
                                dayOfWeek = dt.format('EEEE');
                                if((dayOfWeek != 'Saturday') && (dayOfWeek != 'Sunday')){
                                    dueDateCounter--;
                                }
                            }
                            
                            Date myDate = date.newinstance(dt.year(), dt.month(), dt.day());
                            mStone.Due_Date__c = myDate; 
                                
                            }
                        }else{
                            p.In_Hands_Date_Requested__c.addError('In Hands Date Requested field is required for Custom Fulfillment and Custom Creative sub-types.');
                        }
                    }
                    milestoneList.add(mStone);
                }
            }
           
       }
        
        if(milestoneList.size() > 0) { 
            insert milestoneList;
        }
    }
    
    
   public void OwnerUpdate(List<Project__c> prjList, Boolean Updateflag){
    
        Set<Id> projSetId = new Set<Id>();
        Map<Id,Project_Group__c> projectGrpToMap = new Map<Id,Project_Group__c>();

      
        String CommercialCustomer='Commercial Customer';
        String Standard ='Standard';
        String Consumer='Consumer';
        set<id> prjgrpidset = new set<id>();
     
        for(Project__c probj : prjList){
            if(probj.Project_Group__c!=null){
               projSetId.add(probj.Project_Group__c);
            }
        }
        System.debug('projSetId --> ' + projSetId);
        for(Project_Group__c pj : [SELECT Id,Assigned_To__c,Account__r.Segment_Step_1__c,Account__r.Account_Type__C, Status__c FROM Project_Group__c WHERE Id IN:projSetId]){
            projectGrpToMap.put(pj.Id, pj);
        }
       System.debug('projectGrpToMap --> ' + projectGrpToMap);
     
     

    for(Project__c prj:prjList){
              
           //system.debug('accnt-->'+accntSegmentMap.get(prj.Project_Group__c));  
                
            if((projectGrpToMap.get(prj.Project_Group__c).Account__r.Account_Type__c == CommercialCustomer ) || (projectGrpToMap.get(prj.Project_Group__c).Account__r.Account_Type__c == Standard) || ((projectGrpToMap.get(prj.Project_Group__c).Account__r.Account_Type__c == Consumer) )){
               if((projectGrpToMap.get(prj.Project_Group__c).Account__r.Segment_Step_1__c == Label.CFR_Baxter)){

                    if ((prj.Project_Sub_Type__c== Label.CFR_Fulfillment)  || (prj.Project_Sub_Type__c == Label.CFR_Template_Creative)){
                            prj.OwnerId= projectGrpToMap.get(prj.Project_Group__c).Assigned_To__c;
                            prj.Status__c =Label.CFR_Project_Status_Complete; 
                    }
                }else if ((prj.Project_Sub_Type__c== Label.CFR_Fulfillment)  || (prj.Project_Sub_Type__c == Label.CFR_Template_Creative)){
                            prj.OwnerId= projectGrpToMap.get(prj.Project_Group__c).Assigned_To__c;
                            prj.Status__c =Label.CFR_Project_Status_Complete;
                }
            }        

            if(prj.Project_Sub_Type__c== Label.CFR_Tradeshow){  
                    prj.OwnerId=Label.CFR_Tradeshow_UserID;
                    prj.Status__c = Label.CFR_NotStarted;
            }
            
            if(prj.Project_Sub_Type__c == Label.CFR_Coupon){
                    prj.OwnerId = Label.CFR_CouponPodQueueID;
                    prj.Status__c = Label.CFR_NotStarted;
            } 
                    
            if(prj.Project_Sub_Type__c ==Label.CFR_Custom_Creative){
                    prj.Status__c = Label.CFR_NotStarted;
            }
                     
        }
    }
      
      
    public void updateProjectGroupStatus(List<Project__c> prjList){
    
        Set<Id> projIdset = new Set<Id>();
        Map<Id,Project_Group__c> projectGrpMap;

     
        for(Project__c pj : prjList){
            if(pj.Project_Group__c!=null){
               projIdset.add(pj.Project_Group__c);
            }
        }
        projectGrpMap = new Map<Id,Project_Group__c>([SELECT id, Status__c,Designate_Payment_Type__c,Budget_Name__c FROM Project_Group__c WHERE Id IN:projIdset]);
        System.debug('projectGrpMap --> ' + projectGrpMap);     
     
        map<id,boolean> prjstatusmap = new map<id,boolean>();
        for(Project__c prj:[select id,Status__c,Project_Group__c from project__c where Project_Group__r.id IN:projIdset]){
            if(!prjstatusmap.containskey(prj.Project_Group__c)){
                prjstatusmap.put(prj.Project_Group__c,true);
            }
            if(prj.status__c != Label.CFR_Project_Status_Complete){
                prjstatusmap.put(prj.Project_Group__c,false);           
            }
        }
        
        list<Project_Group__c> pglist = new list<Project_Group__c>();
        
        for(Project_Group__c pg:projectGrpMap.values()){
            if(prjstatusmap.get(pg.Id) && (pg.Designate_Payment_Type__c  ==  Label.CFR_Budget && (pg.Budget_Name__c == Label.CFR_GEM || pg.Budget_Name__c == Label.CFR_Orscheln_Marketing_Fund || pg.Budget_Name__c ==Label.CFR_Cargill_Budget_Internal_USE_ONLY_SY) )){
                pg.status__c = Label.CFR_Delivered_Invoicing;
            } else if (prjstatusmap.get(pg.Id) && (pg.Designate_Payment_Type__c  !=  Label.CFR_Budget || (pg.Designate_Payment_Type__c  ==  Label.CFR_Budget && (pg.Budget_Name__c != Label.CFR_GEM && pg.Budget_Name__c != Label.CFR_Orscheln_Marketing_Fund && pg.Budget_Name__c != Label.CFR_Cargill_Budget_Internal_USE_ONLY_SY)))){
                pg.status__c = Label.CFR_Work_Complete;
            } else if(!prjstatusmap.get(pg.Id)){
                pg.status__c = Label.CFR_In_Progress;
            }
            pglist.add(pg);
        }
        if(!pglist.isEmpty()){
        Update pglist;
        }
    }
   
}