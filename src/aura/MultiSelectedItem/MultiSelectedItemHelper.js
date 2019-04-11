({
    fireChangeEvent : function(cmp) {
        var eve=cmp.getEvent("selectionChanged");
        eve.fire();
    }
})