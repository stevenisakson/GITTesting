({
	toggleDropDown : function(cmp, event, helper) {
        if(cmp.get("v.isDropDownOpen")){
            cmp.set("v.isDropDownOpen",false);
        }else{
            cmp.set("v.isDropDownOpen",true); 
        }
      
	},
   closeDropDown : function(cmp, event, helper) {
       /*On blur should delay until the user selects out*/
       cmp.set("v.isDropDownOpen",false); 
       window.setTimeout(
           $A.getCallback(function() {
              
           }), 500
       );
        
       
      
	},
    openDropDown : function(cmp, event, helper) {
       
        
            cmp.set("v.isDropDownOpen",true); 
        
      
	},
    initOptions:function(cmp,event){
        var params=cmp.get("arguments");
        var options=cmp.options;
        var newoptions=[];
        var temp;
        for(var i=0;i<options.length;i++){
            temp=options[i];
            temp['checked']=false;
            newoptions.push(temp);
        }
        cmp.set("v.options",newoptions);
    },
    getSelectedOptions:function(cmp,event){
        var selected=cmp.get("v.selectedList")
        if(selected.length!=0)
            return cmp.get("v.selectedList");
        else
            return null;
            
       
    },
    selectionChanged:function(cmp,event){
        var options=cmp.get("v.options");
        var selected=[];
        var count=0;
        for(var i=0;i<options.length;i++){
            if(options[i].checked==true){
               selected.push(options[i].value);
               count++;
            }
        }
     
        cmp.set("v.selectedList",selected);
        cmp.set("v.numberOfChecked",count);
        cmp.set("v.options",options);
        
     
    }
})