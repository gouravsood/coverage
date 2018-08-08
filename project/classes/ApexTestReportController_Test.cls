/**
 * Created by guan on 29/1/18.
 * Test class for ApexTestReportController, the apex test report lightning app
 */

@isTest
public class ApexTestReportController_Test {

    private static List<ApexTestReportController.CoverageLineItem> createMockCoverageLineItems(){
        // Set mock coverage data
        List<ApexTestReportController.CoverageLineItem> coverageLineItems = new List<ApexTestReportController.CoverageLineItem>();
        for(ApexTestReportController.FileDetail apexFileDetail : ApexTestReportController.fileDetailMap.values()){
            if(coverageLineItems.size() > 10) break;
            ApexTestReportController.ApexClassOrTriggerObject apexObject = new ApexTestReportController.ApexClassOrTriggerObject();
            apexObject.Name = apexFileDetail.className;
            ApexTestReportController.CoverageLineItem cli = new ApexTestReportController.CoverageLineItem();
            cli.NumLinesCovered = 90;
            cli.NumLinesUncovered = 10;
            cli.ApexClassOrTrigger = apexObject;
            coverageLineItems.add(cli);
        }
        return coverageLineItems;
    }

    @isTest
    static void testLoadReportData(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockApexTestReportResponseGenerator());

        Test.startTest();
            String reportDataJSON  = ApexTestReportController.loadReportData();
        Test.stopTest();
        System.assertNotEquals(null, reportDataJSON);
    }

    @isTest
    static void testControllerMethods(){

        PageReference pageRef = Page.ApexTestReport;
        Test.setCurrentPage(pageRef);
        ApexTestReportController controller = new ApexTestReportController();
        System.assertNotEquals(null, controller.encryptedSessionId);

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockApexTestReportResponseGenerator());

        Test.startTest();
            String apexDevMap = ApexTestReportController.retrieveApexDeveloperMapData();
            System.assertNotEquals(null, apexDevMap);

            ApexTestReportController.fileDetailMap = ApexTestReportController.getFileDetailsFromStaticResource();
            List<ApexTestReportController.CoverageLineItem> coverageLineItems = ApexTestReportController.getCoverageLineItems();
            System.debug('@@@@ coverageLineItems:' + coverageLineItems);
            // Set mock coverage data
            coverageLineItems = createMockCoverageLineItems();
            ApexTestReportController.TestReportData reportData = ApexTestReportController.populateTestReportData(coverageLineItems);
            ApexTestReportController.getDeveloperResult(reportData);
            ApexTestReportController.getTestResults(reportData);
        Test.stopTest();
        System.assertNotEquals(null, reportData);
    }
}