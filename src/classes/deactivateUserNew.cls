public class deactivateUserNew{


@future
public static void deactivateUserID(String userId){
      User userObj = [Select id, isActive, name from User where id = :userId];
      System.debug('USer Data -> ' + userObj);
      userObj.isActive = false;
      update userObj;

}


}