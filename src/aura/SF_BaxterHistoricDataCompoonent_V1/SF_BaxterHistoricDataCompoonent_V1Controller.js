({
    doInit : function(component, event, helper) {
        var isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
        if (isMobile) 
            component.set("v.deviceType",'true');
        else 
          	component.set("v.deviceType",'false');
    }
})