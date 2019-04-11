({
	downloadpdf : function(component, event, helper) {

        var doc = new jsPDF('l','pt',"a2");
		
        var elem = document.getElementById("basic-table");
  		var res = doc.autoTableHtmlToJson(elem);
    doc.autoTable(res.columns, res.data, {
    startY: 15,
        showHeader: 'everyPage',
        tableWidth: 'auto',
        margin: { horizontal: 0,left: 10,right: 10 },
    bodyStyles: { valign: 'top' },
    styles: { overflow: 'linebreak', columnWidth:'auto',overflowColumns:false },
    columnStyles: { text: { columnWidth:'auto' } }
  });
       
  doc.save("PotentialHistoryTimeStamp.pdf");

	},
    

})