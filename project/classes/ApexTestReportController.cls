/**
 * Created by guan on 15/12/17.
 */

public class ApexTestReportController {

    //@TestVisible private static Map<Id, ApexClass> classMap;
    //@TestVisible private static Map<Id, ApexTrigger> triggerMap;
    private static Map<String, String> developerStreamMap;
    @TestVisible private static Map<String, FileDetail> fileDetailMap;

    public String encryptedSessionId {get; set;}

    private static Blob cryptoKey;

    static{
        cryptoKey = Blob.valueOf('et4dg41f8tboj2ap');

        //classMap = new Map<Id, ApexClass>([SELECT Id, Name, Body, LastModifiedBy.Name, LastModifiedDate FROM ApexClass ORDER By Name]);
        //triggerMap = new Map<Id, ApexTrigger>([SELECT Id, Name, LastModifiedBy.Name, LastModifiedDate FROM ApexTrigger ORDER By Name]);

        developerStreamMap = new Map<String, String>{
            'Aarya Tiwary' => 'Referral',
            'Abeer Qureshi' => 'Communities',
            'Abhijeet Tiwari' => 'Core',
            'Achala Gore' => 'Core',
            'Adrian Chiew' => 'Placement Legal',
            'Alex Odago' => 'Core',
            'Andrew Zhang' => 'Case',
            'Anjani Tiwari' => 'C&F',
            'Anton Rybkin' => 'Core',
            'Anuradha Nimbalkar' => 'Referral',
            'Bea Rillorta' => 'R1 Streams',
            'Bhrigu Bansal' => 'Core',
            'Bhrigu Bansal (R2DEV2)' => 'Core',
            'Brett Cawrse' => 'Core',
            'Bruno Nakamura' => 'Integration',
            'CI' => 'R1 Streams',
            'Chid Gurav' => 'MuleSoft',
            'danijel turkovic' => 'C&F',
            'Darko Jovanovic' => 'Core',
            'Dattu Sarma' => 'Placement Legal',
            'Dheeraj Singhal' => 'Case',
            'Divya Kalra' => 'Code Merge',
            'Francesco Iervolino' => 'Communities',
            'Gourav Sood' => 'Integration',
            'Guy Beres' => 'Case',
            'Harry He' => 'Core',
            'Ian Huang' => 'Core',
            'Ishu Jain' => 'C&F',
            'Ivor goreta' => 'C&F',
            'James Neave' => 'R1 Streams',
            'Jansirani Avula' => 'Communities',
            'Jarrod Hunt' => 'Conga',
            'Jason Guan' => 'Referral',
            'Jen Karen' => 'R1 Streams',
            'Jodi Acton' => 'Adoption',
            'John Moriarty' => 'R1 Streams',
            'Jyoti Arage' => 'C&F',
            'Karthiga Pulliappan' => 'Core',
            'Kashyap Kmurthy' => 'Core',
            'Kevin Bertuldo' => 'R1 Streams',
            'Kim Cabela' => 'R1 Streams',
            'kiran kulkarni' => 'Placement Legal',
            'Krishnasaireddy Patil' => 'C&F',
            'kumar roshan1' => 'Communities',
            'Malvika Sharma' => 'C&F',
            'Martin Fortmann' => 'R1 Streams',
            'Mubbashir Ali' => 'Case',
            'Narendra Singh' => 'C&F',
            'Neha Sonawane' => 'Core',
            'nidhi dewangan1' => 'Core',
            'nikhil verma2' => 'Case',
            'Paras Prajapati' => 'C&F',
            'Patrick Villarica' => 'R1 Streams',
            'Paul Lucas' => 'Core',
            'Prajakta Sanap' => 'Communities',
            'Rakesh Murugan' => 'C&F',
            'Ram Mohan Reddy. K' => 'Communities',
            'Ric Jason Dayrit' => 'Case',
            'Rohit Nair' => 'Placement Legal',
            'Roland Niflis' => 'Case',
            'Sagar Shah' => 'Adoption',
            'Sara renberg' => 'Communities',
            'Sayali Limaye' => 'Placement Legal',
            'Shahar Banay' => 'Communities',
            'Shankar Chintala' => 'Case',
            'Sharan Desai' => 'Communities',
            'Sharath Krishnaraj' => 'R1 Streams',
            'shilpa vashishtha' => 'Placement Legal',
            'sneha likhar' => 'Placement Legal',
            'sneha rawat1' => 'C&F',
            'Srikanth Srivillibhutturu' => 'Placement Legal',
            'Srisailam chintapally' => 'Referral',
            'Subhashini Katta' => 'Referral',
            'Sunila M' => 'C&F',
            'Sunny Gill' => 'Referral',
            'Swathi Ramireddy' => 'Referral',
            'Tatineni Sindhu' => 'C&F',
            'Tony Gao' => 'R1 Streams',
            'Udaya Napa' => 'Referral',
            'Usman Sargaana' => 'R1 Streams',
            'Venkat Amiya' => 'C&F',
            'Yogesh Rawal' => 'Placement Legal'
        };
    }

    /*
    * This method is to be executed on a regular basis in order to update the ApexDevMap static resource
    * */
    public static String retrieveApexDeveloperMapData(){
        Map<String, FileDetail> returnFileDetailMap = new Map<String, FileDetail>();
        for(List<ApexClass> classObjs : [SELECT Name, LastModifiedBy.Name, LastModifiedDate FROM ApexClass ORDER By Name]){
            for(ApexClass classObj : classObjs){
                FileDetail fileDetailObj = new FileDetail();
                fileDetailObj.className = classObj.Name;
                fileDetailObj.lastModifiedBy = classObj.LastModifiedBy.Name;
                fileDetailObj.lastModifiedDate = classObj.LastModifiedDate;
                returnFileDetailMap.put(fileDetailObj.className, fileDetailObj);
            }
        }

        for(List<ApexTrigger> triggerObjs : [SELECT Name, LastModifiedBy.Name, LastModifiedDate FROM ApexTrigger ORDER By Name]){
            for(ApexTrigger triggerObj : triggerObjs){
                FileDetail fileDetailObj = new FileDetail();
                fileDetailObj.className = triggerObj.Name;
                fileDetailObj.lastModifiedBy = triggerObj.LastModifiedBy.Name;
                fileDetailObj.lastModifiedDate = triggerObj.LastModifiedDate;
                returnFileDetailMap.put(fileDetailObj.className, fileDetailObj);
            }
        }

        String genString = JSON.serialize(returnFileDetailMap);
        genString = genString.replace('\\"', '"');
        genString = genString.replace('"{', '{');
        genString = genString.replace('}"', '}');

        return genString;
    }

    public ApexTestReportController(){
        Blob data = Blob.valueOf(UserInfo.getSessionId());
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
        encryptedSessionId = EncodingUtil.base64Encode(encryptedData);
    }

    @AuraEnabled
    public static String loadReportData(){
        fileDetailMap = getFileDetailsFromStaticResource();
        List<CoverageLineItem> coverageLineItems = getCoverageLineItems();
        TestReportData reportData = populateTestReportData(coverageLineItems);
        getDeveloperResult(reportData);
        getTestResults(reportData);
        return JSON.serialize(reportData);
    }

    public static String getSessionIdFromVFPage(){
        PageReference visualforcePage = Page.ApexTestReport;
        Blob blobContent;
        if (Test.IsRunningTest())
        {
            Blob data = Blob.valueOf(UserInfo.getSessionId());
            Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey , data );
            blobContent = Blob.valueOf('Start_Of_Session_Id' + EncodingUtil.base64Encode(encryptedData) + 'End_Of_Session_Id');
        }
        else
        {
            blobContent = visualforcePage.getContent();
        }

        String content = blobContent.toString();
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');

        String encryptedString = content.substring(s, e);
        Blob data = EncodingUtil.base64Decode(encryptedString);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey , data);
        return decryptedData.toString();
    }

    @TestVisible
    private static Map<String, FileDetail> getFileDetailsFromStaticResource(){
        StaticResource classDevMap = [SELECT Id, Body FROM StaticResource WHERE Name = 'ApexDevMap' LIMIT 1];
        String classDevMapString = classDevMap.Body.toString();

        // Parse JSON array into
        return (Map<String, FileDetail>) JSON.deserialize(classDevMapString, Map<String, FileDetail>.class);
    }

    @TestVisible
    private static TestReportData populateTestReportData(List<CoverageLineItem> coverageLineItems){
        TestReportData reportData = new TestReportData();
        List<CoverageWrapper> coverageWrappers = new List<CoverageWrapper>();
        Integer totalLines = 0;
        Integer totalLinesCovered = 0;

        for(CoverageLineItem cli : coverageLineItems){
            FileDetail targetFile = fileDetailMap.get(cli.ApexClassOrTrigger.Name);
            // && targetFile.classBody.indexOfIgnoreCase('@isTest') == -1
            if(targetFile == null) continue;

            String developerName = targetFile.lastModifiedBy;
            // Process coverages
            Integer total = cli.NumLinesCovered + cli.NumLinesUncovered;
            Integer percentage = total == 0 ? 0 : Integer.valueOf(Math.floor(cli.NumLinesCovered * 100 / total));
            CoverageWrapper cWrapper = new CoverageWrapper();
            cWrapper.classOrTriggerName = targetFile.className;
            cWrapper.coverage = percentage;
            cWrapper.linesCovered = cli.NumLinesCovered;
            cWrapper.linesUncovered = cli.NumLinesUncovered;
            cWrapper.linesTotal = total;
            cWrapper.lastModifiedBy = developerName;
            cWrapper.lastModifiedDate = targetFile.lastModifiedDate.format('dd/mm/yyyy HH:mm');
            cWrapper.stream = developerStreamMap.get(developerName) != null ? developerStreamMap.get(developerName) : 'Unknown';
            coverageWrappers.add(cWrapper);

            // Aggregate numbers
            totalLines += total;
            totalLinesCovered += cWrapper.linesCovered;
        }

        // Set aggregated information
        reportData.coverages = coverageWrappers;
        reportData.totalLines = totalLines;
        reportData.totalLinesCovered = totalLinesCovered;

        return reportData;
    }

    @TestVisible
    private static List<CoverageLineItem> getCoverageLineItems(){
        List<CoverageLineItem> coverageLineItems = new List<CoverageLineItem>();

        String query = 'SELECT NumLinesCovered,NumLinesUncovered,ApexClassOrTrigger.Name FROM ApexCodeCoverageAggregate';

        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm()
                + '/services/data/v39.0/tooling/query';

        String toolingurl = baseUrl + '?q=' + EncodingUtil.urlEncode(query, 'UTF-8');
        System.debug('@@@@ ApexTestReportController.getCoverageLineItems toolingurl:' + toolingurl);

        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(toolingurl);
        req.setMethod('GET');
        // OAuth header
        req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage());
        req.setHeader('Content-Type', 'application/json');

        Http h = new Http();
        HttpResponse res = h.send(req);

        String coverageResult = res.getBody();

        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(coverageResult);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        CoverageLineItem cli = (CoverageLineItem)parser.readValueAs(CoverageLineItem.class);
                        coverageLineItems.add(cli);
                    }
                }
            }
        }

        return coverageLineItems;
    }

    @TestVisible
    private static void getTestResults(TestReportData reportData) {

        reportData.totalFailures = 0;
        List<TestResultWrapper> testResultWrappers = new List<TestResultWrapper>();
        Set<String> testResultKeys = new Set<String>();
        Map<String, Integer> dev_FailuresMap = new Map<String, Integer>();
        Map<String, StreamResultWrapper> stream_WrapperMap = new Map<String, StreamResultWrapper>();

        for(List<ApexTestResult> testResults : [SELECT ApexClassId, ApexClass.Name, MethodName, StackTrace, Message, Outcome, TestTimestamp FROM ApexTestResult ORDER BY TestTimestamp DESC LIMIT 30000]){
            for(ApexTestResult testResult : testResults) {
                String key = testResult.apexClassId + '_' + testResult.methodName;
                if(testResultKeys.contains(key)) continue;
                testResultKeys.add(key);

                FileDetail targetFile = fileDetailMap.get(testResult.ApexClass.Name);
                //if(targetFile == null || targetFile.classBody.indexOf(testResult.methodName) == -1) continue;
                if(targetFile == null) continue;

                String developerName = targetFile.lastModifiedBy;
                TestResultWrapper tWrapper = new TestResultWrapper();
                tWrapper.testClassName = targetFile.className;
                tWrapper.methodName = testResult.MethodName;
                tWrapper.outcome = testResult.Outcome;
                tWrapper.message = testResult.Message;
                tWrapper.stackTrace = testResult.StackTrace;
                tWrapper.lastModifiedBy = developerName;
                tWrapper.lastModifiedDate = targetFile.lastModifiedDate.format('dd/mm/yyyy HH:mm');
                tWrapper.stream = developerStreamMap.get(developerName) != null ? developerStreamMap.get(developerName) : 'Unknown';
                testResultWrappers.add(tWrapper);

                if(testResult.Outcome != 'Fail') continue;

                reportData.totalFailures += 1;
                if(dev_FailuresMap.containsKey(developerName)){
                    dev_FailuresMap.put(developerName, dev_FailuresMap.get(developerName) + 1);
                }
                else{
                    dev_FailuresMap.put(developerName, 1);
                }
            }
        }

        reportData.outcomes = testResultWrappers;

        for(DeveloperResultWrapper devWrapper : reportData.developerResult){
            Integer failureAmount = dev_FailuresMap.containsKey(devWrapper.developerName) ? dev_FailuresMap.get(devWrapper.developerName) : 0;
            devWrapper.failures = failureAmount;
            String stream = devWrapper.stream;
            StreamResultWrapper streamWrapper;
            if(stream_WrapperMap.containsKey(stream)){
                streamWrapper = stream_WrapperMap.get(stream);
            }
            else{
                streamWrapper = new StreamResultWrapper();
                streamWrapper.stream = stream;
                streamWrapper.linesCovered = 0;
                streamWrapper.linesUncovered = 0;
                streamWrapper.linesTotal = 0;
                streamWrapper.coverage = 0;
                streamWrapper.failures = 0;
            }
            streamWrapper.linesCovered += devWrapper.linesCovered;
            streamWrapper.linesUncovered += devWrapper.linesUncovered;
            streamWrapper.linesTotal += devWrapper.linesTotal;
            streamWrapper.failures += devWrapper.failures;
            stream_WrapperMap.put(stream, streamWrapper);
        }

        for(StreamResultWrapper streamWrapper : stream_WrapperMap.values()){
            streamWrapper.coverage = streamWrapper.linesTotal == 0 ? 0 : Integer.valueOf(Math.floor(streamWrapper.linesCovered * 100 / streamWrapper.linesTotal));
        }
        reportData.streamResult = stream_WrapperMap.values();
    }

    @TestVisible
    private static void getDeveloperResult(TestReportData reportData){
        Map<String, DeveloperResultWrapper> dev_WrapperMap = new Map<String, DeveloperResultWrapper>();
        for(CoverageWrapper cWrapper : reportData.coverages){
            DeveloperResultWrapper devWrapper;
            String developerName = cWrapper.lastModifiedBy;
            if(dev_WrapperMap.containsKey(developerName)){
                devWrapper = dev_WrapperMap.get(developerName);
                devWrapper.linesCovered = devWrapper.linesCovered + cWrapper.linesCovered;
                devWrapper.linesUncovered = devWrapper.linesUncovered+ cWrapper.linesUncovered;
                devWrapper.linesTotal = devWrapper.linesTotal + cWrapper.linesTotal;
            }
            else{
                devWrapper = new DeveloperResultWrapper();
                devWrapper.developerName = developerName;
                devWrapper.stream = developerStreamMap.get(developerName) != null ? developerStreamMap.get(developerName) : 'Unknown';
                devWrapper.linesCovered = cWrapper.linesCovered;
                devWrapper.linesUncovered = cWrapper.linesUncovered;
                devWrapper.linesTotal = cWrapper.linesTotal;
                devWrapper.failures = 0;
            }
            dev_WrapperMap.put(developerName, devWrapper);
        }

        for(DeveloperResultWrapper devWrapper : dev_WrapperMap.values()){
            devWrapper.coverage = devWrapper.linesTotal == 0 ? 0 : Integer.valueOf(Math.floor(devWrapper.linesCovered * 100 / devWrapper.linesTotal));
        }

        reportData.developerResult = dev_WrapperMap.values();
    }

    public class TestReportData{
        @AuraEnabled public List<CoverageWrapper> coverages;
        @AuraEnabled public List<TestResultWrapper> outcomes;
        @AuraEnabled public List<DeveloperResultWrapper> developerResult;
        @AuraEnabled public List<StreamResultWrapper> streamResult;
        @AuraEnabled public Integer totalLines;
        @AuraEnabled public Integer totalLinesCovered;
        @AuraEnabled public Integer totalFailures;
    }

    public class CoverageWrapper{
        @AuraEnabled public String classOrTriggerName {get; set;}
        @AuraEnabled public Integer coverage {get; set;}
        @AuraEnabled public Integer linesCovered {get; set;}
        @AuraEnabled public Integer linesUncovered {get; set;}
        @AuraEnabled public Integer linesTotal {get; set;}
        @AuraEnabled public String lastModifiedBy {get; set;}
        @AuraEnabled public String lastModifiedDate {get; set;}
        @AuraEnabled public String stream {get; set;}
    }

    public class TestResultWrapper{
        @AuraEnabled public String testClassName {get; set;}
        @AuraEnabled public String methodName {get; set;}
        @AuraEnabled public String outcome {get; set;}
        @AuraEnabled public String message {get; set;}
        @AuraEnabled public String stackTrace {get; set;}
        @AuraEnabled public String lastModifiedBy {get; set;}
        @AuraEnabled public String lastModifiedDate {get; set;}
        @AuraEnabled public String stream {get; set;}
    }

    public class DeveloperResultWrapper{
        @AuraEnabled public String developerName {get; set;}
        @AuraEnabled public String stream {get; set;}
        @AuraEnabled public Integer linesCovered {get; set;}
        @AuraEnabled public Integer linesUncovered {get; set;}
        @AuraEnabled public Integer linesTotal {get; set;}
        @AuraEnabled public Integer coverage {get; set;}
        @AuraEnabled public Integer failures {get; set;}
    }

    public class StreamResultWrapper{
        @AuraEnabled public String stream {get; set;}
        @AuraEnabled public Integer linesCovered {get; set;}
        @AuraEnabled public Integer linesUncovered {get; set;}
        @AuraEnabled public Integer linesTotal {get; set;}
        @AuraEnabled public Integer coverage {get; set;}
        @AuraEnabled public Integer failures {get; set;}
    }

    /*
    * Mapping of JSON object return from Tooiling API
    * */
    public class CoverageLineItem{
        public Integer NumLinesCovered;
        public Integer NumLinesUncovered;
        public ApexClassOrTriggerObject ApexClassOrTrigger;
    }

    /*
    * Mapping of JSON object return from Tooiling API
    * */
    public class ApexClassOrTriggerObject{
        public String Name;
    }

    public class FileDetail{
        public String className;
        public String lastModifiedBy;
        public DateTime lastModifiedDate;
    }
}