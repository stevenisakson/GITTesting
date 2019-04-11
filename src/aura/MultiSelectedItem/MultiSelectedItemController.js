({
	removeSelection : function(cmp, event, helper) {
      var item=cmp.get("v.item");
      item.checked=false;
      cmp.set("v.item",item);
      helper.fireChangeEvent(cmp);   
	}
})