@isTest(seealldata = true)
public class LabyrinthDocumentPage_ctrl_Test {
    
    static testmethod void testmethod1()
    {
       
       
        
        Document document;
        document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [select id from folder where name = 'Reference Documents English'].id;
        insert document;
        
        PageReference pageRef = Page.LabyrinthDocumentPage;
        system.Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id', String.valueOf(document.Id));
         
         ApexPages.StandardController sc = new ApexPages.StandardController(document);
         LabyrinthDocumentPage_ctrl Testdoc = new LabyrinthDocumentPage_ctrl(sc);
         
         LabyrinthDocumentPage_ctrl dc=new LabyrinthDocumentPage_ctrl();
         
         Testdoc.load();
            
        
    }

}