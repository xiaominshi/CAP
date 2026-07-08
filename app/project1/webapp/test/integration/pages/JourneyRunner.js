sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/MaintenanceRequestsList.gen",
	"project1/test/integration/pages/MaintenanceRequestsObjectPage.gen"
], function (JourneyRunner, MaintenanceRequestsListGenerated, MaintenanceRequestsObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onTheMaintenanceRequestsListGenerated: MaintenanceRequestsListGenerated,
			onTheMaintenanceRequestsObjectPageGenerated: MaintenanceRequestsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

