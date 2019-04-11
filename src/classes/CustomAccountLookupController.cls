public with sharing class CustomAccountLookupController {
  //  public Product_Line__c pl {get;set;} // new pl to create
  //  public List<Product_Line__c> results{get;set;} // search results
    public string searchString{get;set;} // search keyword

    public CustomAccountLookupController() {
     //   pl = new Product_Line__c();
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        runSearch();  
    }

    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }

    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
     //   results = performSearch(searchString);               
    } 

    // run the search and return the records found. 
     /*  // Commented By Shalu Req 4.9 
    @TestVisible private List<Product_Line__c> performSearch(string searchString) {
        String soql = 'select id, name from Product_Line__c';
        if(searchString != '' && searchString != null){
            soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
            soql = soql + ' limit 25';
        }   
        return database.query(soql); 
    }*/

    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }

    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}