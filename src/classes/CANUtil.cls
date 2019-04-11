/*
* @author : Jesfer Baculod (Cloud Sherpas)
* @date : Original - 07/23/2015, Last Modified - 07/29/2015
* @description : contains utility methods that can be used across CAN functionalities
*/
public class CANUtil {
	//The static variable to store field describe
    public static Map<String, Map<String, Schema.SObjectField>> fieldDescribeCache = new Map<String, Map<String, Schema.SObjectField>>();
                
    //get the field describe map
    public static Map<String, Schema.SObjectField> getFieldDescribe(Schema.DescribeSObjectResult sdo) {
        if (!fieldDescribeCache.containsKey(sdo.getName())) {
            fieldDescribeCache.put(sdo.getName(), sdo.fields.getMap());
        }
        return fieldDescribeCache.get(sdo.getName());
    }

	//Build Query Fields 
    public static String buildQueryFields(Schema.DescribeSObjectResult sdo) {
        Map<String, Schema.SObjectField> objectFields_map = getFieldDescribe(sdo);
        String queryFields = '';
        Boolean firstFlag = true;
        for (string c : objectFields_map.keySet()) {
            if (!firstFlag) {
                queryFields = queryFields + ', ';
            }
            queryFields = queryFields + c;
            firstFlag = false;
        }
        return queryFields;
    }

	//Build Query String of a specific object
    public static String buildQuery(Schema.DescribeSObjectResult sdo) {
        String queryFields = buildQueryFields(sdo);
        queryFields = 'SELECT ' + queryFields + ' FROM ' + sdo.getName() + ' ';
        return queryFields;
    }
    
    //Build Query String with extra fields of a specific object
    public static String buildQuery(Schema.DescribeSObjectResult sdo, String extraFields) {
        String queryFields = buildQueryFields(sdo);
        if (extrafields != '') queryFields = 'SELECT ' + queryFields + ',' + extraFields + ' FROM ' + sdo.getName() + ' ';
        else queryFields = 'SELECT ' + queryFields + ' FROM ' + sdo.getName() + ' ';
        system.debug('@@queryFields:'+queryFields);
        return queryFields;
    }

    //Read Dynamic Field Set
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName){
	    system.debug('@@fieldsetName:'+fieldSetName);
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
	    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
	    return fieldSetObj.getFields(); 
	}  
	
    //Get Record Type Id by Object
    public static string getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName) {
        //Generate a map of tokens for all the Record Types for the desired object
        Map <string, schema.recordtypeinfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();
        //system.debug('RECORD TYPES:' + recordTypeInfo);
 
        if(!recordTypeInfo.containsKey(recordTypeName)){
            //throw new RecordTypeException('Record type "'+ recordTypeName +'" does not exist.');
        }
        //Retrieve the record type id by name
        return recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
       
    //extends the exception class for Record type errors
    public class RecordTypeException extends Exception{
        //
    }
}