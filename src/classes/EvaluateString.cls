public class EvaluateString
{
    public static decimal evaluate(String expression)
    {
    system.debug('expression::'+expression);
        String [] tokens = expression.split(' ');
        list<decimal> values = new list<decimal>();
        list<String> ops = new list<String>();
        
        
        for (integer i = 0; i < tokens.size(); i++)
        {
            
         
           if (EvaluateString.isNumeric(tokens[i]))
            {
                 system.debug('Inside EvaluateString_New if loop'); 
                 

                // There may be more than one digits in number
                if(EvaluateString.isNumeric(tokens[i]))
                 {   
                    values.add(Decimal.valueOf(tokens[i]));
                    system.debug('Inside numberic values loop' + values); 
                 }
            }
           
             
             else if (tokens[i] == '('){
                ops.add(tokens[i]);
            }
            else if (tokens[i] == ')')
            {
                if((ops[ops.size()-1] ) != '(')
                values.add(applyOp(ops.remove(ops.size()-1), values.remove(values.size()-1), values.remove(values.size()-1)));
                ops.remove(ops.size()-1);
            }
 
        else if (tokens[i] == '+' || tokens[i] == '-' ||tokens[i] == '*' || tokens[i] == '/')
            {
                // While top of 'ops' has same or greater precedence to current
                // token, which is an operator. Apply operator on top of 'ops'
                // to top two elements in values stack
                if (!ops.isEmpty() && hasPrecedence(tokens[i], ops[ops.size()-1])){
                  values.add(applyOp(ops.remove(ops.size()-1), values.remove(values.size()-1), values.remove(values.size()-1)));
                   
               }
                // Push current token to 'ops'.
                ops.add(tokens[i]);
               
            }
             system.debug('*****ops******'+ops);
              system.debug('*****values******'+values);
  
             }       

            system.debug('*****ops - outside For******'+ops);
              system.debug('*****values - outside For******'+values);
            if (!ops.isEmpty() )
                {
                
                values.add(applyOp(ops.remove(ops.size()-1), values.remove(values.size()-1), values.remove(values.size()-1)));
                system.debug('*****Value2******'+values);
             }
             
   
    return values.remove(values.size()-1).setScale(4);
}

public static boolean hasPrecedence(String op1, String op2)
    {
        if (op2 == '(' || op2 == ')')
           return false;
        if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-'))
            return false;
        else
            return true;
    }
    
     public static decimal applyOp(string op, decimal b, decimal a)
    {
            
        if(op.contains('+')){
            return a + b;
        }
        else if(op.contains('-')){
             return a - b;
        }
        else if(op.contains('*')){
             return a * b;
        }
        else if (op.contains('/')){
            if (b == 0)
            {
            system.debug('Cannot divide by zero');  
            }
         return a / b;
            
        }   
        return 0;
   
    }
    
    public static Boolean isNumeric(String s){
        Boolean ReturnValue;
        try{
            Decimal.valueOf(s);
            ReturnValue = TRUE; 
        } catch (Exception e) {
            ReturnValue = FALSE;
        }
        return ReturnValue;
    }
}