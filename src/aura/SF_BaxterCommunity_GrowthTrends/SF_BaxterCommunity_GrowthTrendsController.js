({
    doInit : function(component, event, helper) {
        
        component.set('v.isSending',true);
        /*component.set('v.columns', [
            {label: 'Brand', fieldName: 'Brand__c', type: 'text', sortable : true},
            {label: 'Sub Brand', fieldName: 'Sub_Brand__c', type: 'text', sortable : true, initialWidth: "50x"},
            {label: 'Quantity Shipped', fieldName: 'Tons__c', type: 'number', sortable : true, initialWidth: "50x"},
        ]);
            component.set('v.Parentcolumns', [
            {label: 'Tons', fieldName: 'Tons__c', type: 'text', sortable : true},
            {label: '% Growth', fieldName: 'Growth__c', type: 'number', sortable : true},
        ]);   
        */
        //helper.doFetchGrowthData(component); // get child growth data   
        helper.getParentData(component); // get parent growth data
        helper.getChildData(component); // get child growth data   
        helper.getMaxDate(component); // get last date when child records were loaded    
    },
    
    
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
})