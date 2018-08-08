/**
 * Created by guan on 15/12/17.
 */
({
    doInit : function(component, event, helper){

        // loadTestOutcomes
        // loadApexCoverages

        Core.AuraUtils.execute(component, 'loadReportData', null, function (returnValue){
            let result = JSON.parse(returnValue);
            //component.set('v.coverages', result.coverages);
            //component.set('v.outcomes', result.outcomes);

            var coverages = result.coverages;
            var outcomes = result.outcomes;
            var developerResult = result.developerResult;
            var streamResult = result.streamResult;
            var totalLines = result.totalLines;
            var totalLinesCovered = result.totalLinesCovered;
            var coverPercentage = totalLinesCovered / totalLines;
            var totalFailures = result.totalFailures;
            component.set('v.totalLines', totalLines);
            component.set('v.totalLinesCovered', totalLinesCovered);
            component.set('v.coverPercentage', coverPercentage);
            component.set('v.totalFailures', totalFailures);

            // Table 1
            var tableRef = document.getElementById('coverageTbl').getElementsByTagName('tbody')[0];
              for(var i=0;i<coverages.length;i++){
                var record = coverages[i];
                var tr = document.createElement('tr');
                tr.innerHTML = '<tr>'
                                + '<td>' + record.classOrTriggerName + '</td>'
                                + (record.coverage < 80 ? '<td style="color:red;">' : '<td style="color:lime;">') + record.coverage + '</td>'
                                + '<td>' + record.linesCovered + '</td>'
                                + '<td>' + record.linesUncovered + '</td>'
                                + '<td>' + record.linesTotal + '</td>'
                                + '<td>' + record.lastModifiedBy + '</td>'
                                + '<td>' + record.stream + '</td>'
                                + '</tr>';
                tableRef.appendChild(tr);
              }
              $('#coverageTbl').DataTable({
                "lengthMenu": [[-1, 10, 50, 100], ["All", 10, 50, 100]]
            });

            // Table 2
            var tableRef2 = document.getElementById('outcomeTable').getElementsByTagName('tbody')[0];
             for(var i=0;i<outcomes.length;i++){
               var record = outcomes[i];
               var tr = document.createElement('tr');
               tr.innerHTML = '<tr>'
                               + (record.outcome != 'Pass' ? '<td style="color:red;">' : '<td style="color:lime;">') + record.testClassName + '</td>'
                               + '<td>' + record.methodName + '</td>'
                               + (record.outcome != 'Pass' ? '<td style="color:red;">' : '<td style="color:lime;">') + record.outcome + '</td>'
                               + '<td>' + record.message + '</td>'
                               + '<td>' + record.stackTrace + '</td>'
                               + '<td>' + record.lastModifiedBy + '</td>'
                                + '<td>' + record.stream + '</td>'
                               + '</tr>';
               tableRef2.appendChild(tr);
             }
             $('#outcomeTable').DataTable({
               "lengthMenu": [[-1, 10, 50, 100], ["All", 10, 50, 100]]
            });

            // Table 3
            var tableRef3 = document.getElementById('statsTable').getElementsByTagName('tbody')[0];
             for(var i=0;i<developerResult.length;i++){
               var record = developerResult[i];
               var tr = document.createElement('tr');
               tr.innerHTML = '<tr>'
                               + '<td>' + record.developerName + '</td>'
                               + '<td>' + record.stream + '</td>'
                               + '<td>' + record.linesCovered + '</td>'
                               + '<td>' + record.linesUncovered + '</td>'
                               + '<td>' + record.linesTotal + '</td>'
                               + (record.coverage < 80 ? '<td style="color:red;">' : '<td style="color:lime;">') + record.coverage + '</td>'
                               + (record.failures > 0 ? '<td style="color:red;">' : '<td style="color:lime;">') + record.failures + '</td>'
                               + '</tr>';
               tableRef3.appendChild(tr);
             }
             $('#statsTable').DataTable({
               "lengthMenu": [[-1, 10, 50, 100], ["All", 10, 50, 100]]
            });

            // Table 4
            var tableRef4 = document.getElementById('streamTable').getElementsByTagName('tbody')[0];
             for(var i=0;i<streamResult.length;i++){
               var record = streamResult[i];
               var tr = document.createElement('tr');
               tr.innerHTML = '<tr>'
                               + '<td>' + record.stream + '</td>'
                               + '<td>' + record.linesCovered + '</td>'
                               + '<td>' + record.linesUncovered + '</td>'
                               + '<td>' + record.linesTotal + '</td>'
                               + (record.coverage < 80 ? '<td style="color:red;">' : '<td style="color:lime;">') + record.coverage + '</td>'
                               + (record.failures > 0 ? '<td style="color:red;">' : '<td style="color:lime;">') + record.failures + '</td>'
                               + '</tr>';
               tableRef4.appendChild(tr);
             }
             $('#streamTable').DataTable({
               "lengthMenu": [[-1, 10, 50, 100], ["All", 10, 50, 100]]
            });

            $A.util.toggleClass(component.find("mySpinner"), "slds-hide");
        });
    },

    showTab : function(component, event, helper){
        var element = event.target;
        var scope = element.getAttribute('aria-controls');
        component.set('v.currentTab', scope);
    },

    exportExcel : function(component, event, helper){
        var today = new Date();
        var todayString = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        var fileName = 'ApexTestReport-'+todayString+'.xls';
        Core.FileUtils.tablesToExcel(['streamTable', 'statsTable', 'coverageTbl'], ['StreamStats', 'DeveloperStats', 'ApexCoverage'], fileName, 'Excel');
        /*
        var uri = 'data:application/vnd.ms-excel;base64,'
                , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><style> table, td {border:1px solid gray} table {border-collapse:collapse}</style><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
                , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
                , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) };
        var table = document.getElementById('streamTable');
        var ctx = { worksheet: 'Streams' || 'Worksheet', table: table.innerHTML };

        var element = document.createElement('a');
        element.setAttribute('href', uri + base64(format(template, ctx)));
        element.setAttribute('download', );
        element.style.display = 'none';
        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
        */
    },
})