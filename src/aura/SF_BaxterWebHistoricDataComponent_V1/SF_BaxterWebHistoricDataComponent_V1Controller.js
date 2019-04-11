({
    
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
    
})