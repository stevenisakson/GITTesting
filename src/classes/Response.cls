public class Response {

    @auraenabled
    public Object data;
    @auraenabled
    public String msg;
    @auraenabled
    public Boolean isSuccess;
    public Response(Boolean isSuccess,String msg,Object data){
        this.isSuccess=isSuccess;
        this.msg=msg;
        this.data=data;
    }
    
}