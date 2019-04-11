({
	toggleSelection : function(cmp, event, helper) {
        var item=cmp.get("v.item");
        if(item.checked){
           item.checked=false;
           cmp.set("v.item",item);
           helper.fireChangeEvent(cmp);
        }else{
           item.checked=true;
           cmp.set("v.item",item);
           helper.fireChangeEvent(cmp);
        }
	}
})