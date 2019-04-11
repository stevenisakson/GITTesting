public with sharing class ExternalReportController{
    public Integer FiscalYearStartMonth {get; set;}

        public ExternalReportController(){
            FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
            Date orgFiscalYear = Date.newinstance(system.today().year(), FiscalYearStartMonth, 1);
            
            if(Date.today() < orgFiscalYear){
                FiscalYearStartMonth = Date.today().year() - 1;
            }
            else{
                FiscalYearStartMonth = Date.today().year();
            }
            
            system.debug('******Fiscal Year' + FiscalYearStartMonth);
        }
}