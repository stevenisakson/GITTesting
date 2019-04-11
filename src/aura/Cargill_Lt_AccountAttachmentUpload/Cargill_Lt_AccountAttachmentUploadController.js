({
    doInit : function(component, event, helper) {
        helper.getAccontRecord(component); // Calling Helper method
    },
    monthlyTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make monthlyTab active and show tab data
        component.find("monthlyId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("monthlyTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    eventLogTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make eventLogTab tab active and show tab data
        component.find("quarterlyId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("quarterlyTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    prospectTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make prospectTab tab active and show tab data
        component.find("prospectId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("prospectIdTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    trainingTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make trainingTab tab active and show tab data
        component.find("trainingId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("trainingTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
    },
    growthTab: function(component, event, helper) {
        helper.clearAll(component, event);
        //make growthTab tab active and show tab data
        component.find("growthId").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("growthTabDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';
        /*component.set('v.isSending',true);
        component.set('v.columns', [
            {label: 'Brand', fieldName: 'Brand__c', type: 'text', sortable : true},
            {label: 'Sub Brand', fieldName: 'Sub_Brand__c', type: 'text', sortable : true},
            {label: 'Code', fieldName: 'Code__c', type: 'text', sortable : true},
            {label: 'SubCode', fieldName: 'SubCode__c', type: 'text', sortable : true},
            {label: '% Growth', fieldName: 'Growth__c', type: 'number', sortable : true},
            
        ]);
            component.set('v.Parentcolumns', [
            {label: 'Tons', fieldName: 'Tons__c', type: 'text', sortable : true},
            {label: '% Growth', fieldName: 'Growth__c', type: 'number', sortable : true},
        ]); */
        //helper.doFetchGrowthData(component); // get child growth data   
        //helper.getParentData(component); // get parent growth data
        //helper.getMaxDate(component); // get last date when child records were loaded  
    },
    
})