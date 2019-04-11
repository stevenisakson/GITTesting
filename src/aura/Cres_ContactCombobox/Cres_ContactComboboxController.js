({
	hide : function(cmp, event, helper) {
       cmp.set("v.isOpen",false);
	},
    search : function(cmp, event, helper) {
        
        var objName=cmp.get("v.objectName");
        console.log(objName);
        if(objName==='Contact'){
            var selectedItem=cmp.get("v.parentRecord.Id");
            console.log(selectedItem);
            if(selectedItem!=undefined){
                var searchKeyWord=cmp.get("v.searchKeyWord");
                console.log('Contact');
                cmp.set("v.selectedItemName",searchKeyWord);
                helper.getContactList(cmp,searchKeyWord,selectedItem);
                /*if(selectedItem!=="Unknown" && searchKeyWord!=='Unknown' && !$A.util.isEmpty(selectedItem)){
              
               cmp.set("v.selectedItemName",searchKeyWord);
               console.log(searchKeyWord+'--'+selectedItem);
               helper.getSalesPersonList(cmp,searchKeyWord,selectedItem);
            }else{
                var temp=[{Name:'Unknown'}];
                cmp.set("v.resultList",temp);
                cmp.set("v.isOpen",true);
            }*/
            }
        }
    },
    setSelectedItem:function(cmp,event,helper){
        var data=event.getParam("data");
        cmp.set("v.searchKeyWord",data.Name);
        cmp.set("v.selectedItemName",data.Name);
        cmp.set("v.isOpen",false);
        
    },
    doInit:function(cmp,event,helper){
        /*to display the default value*/
        var val=cmp.get("v.selectedItemName");
        if(val!=undefined && val!=null){
            console.log('init of Combo');
            console.log(val);
            cmp.set("v.searchKeyWord",val);
        }
       
    },
    clear:function(cmp,event,helper){
        cmp.set("v.searchKeyWord","");
      
        cmp.set("v.selectedItemName",{});
    }
})