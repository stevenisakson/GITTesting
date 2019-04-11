public class LabyrinthDocumentPage_ctrl {

    public LabyrinthDocumentPage_ctrl(ApexPages.StandardController controller) {
        
         id=ApexPages.currentPage().getParameters().get('id');
         load();
        
    }


 public List<Document> documents {set;get;}
 public List<Document> documents1 {set;get;}
 public string id{set;get;}

 public LabyrinthDocumentPage_ctrl()
 {
    
 }
 
  public void load(){
        
          documents = [SELECT Id, FolderId, Name, Type, Description FROM Document where id =: id limit 1];
          //String id=documents[0].folderid;
          documents1 = [SELECT Id, FolderId, Name, Type, Description FROM Document where  FolderId =: documents[0].FolderId]; 
        
            
    }
    


}