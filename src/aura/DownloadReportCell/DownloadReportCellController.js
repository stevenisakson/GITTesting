({
	doinit : function(cmp,event) {
        
        if(cmp.get("v.record")!='undefined' && cmp.get("v.record")!=null){
            var record=cmp.get("v.record");
            var potRecord=cmp.get("v.record").Pot;
            var pothisRecord=cmp.get("v.record").PotHis;
            var columnName=cmp.get("v.columnName");
            console.log('Potential');
            console.log(cmp.get("v.record"));
            
            if(columnName != "Field" || columnName != "NewValue" || columnName != "OldValue" || columnName != "CreatedBy" || columnName != "CreatedDate")
            {	
                var columnValue1=potRecord[columnName];
                cmp.set("v.columnValue",columnValue1);
            }
            if(columnName == "Field")
            {
                var columnValue2=pothisRecord.Field;
                cmp.set("v.columnValue",columnValue2);
            }
            
            if(columnName == "NewValue")
            {
                var columnValue3=pothisRecord.NewValue;
                cmp.set("v.columnValue",columnValue3);
            }
            if(columnName == "OldValue")
            {
                var columnValue4=pothisRecord.OldValue;
                cmp.set("v.columnValue",columnValue4);
            }
            if(columnName == "CreatedBy")
            {
                var columnValue5=pothisRecord.CreatedBy.Name;
                cmp.set("v.columnValue",columnValue5);
            }
            if(columnName == "CreatedDate")
            {
                var columnValue6=record.CreatedDatePDF;
                cmp.set("v.columnValue",columnValue6);
            }
        }
     
}
})