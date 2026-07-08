sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"equip/test/integration/pages/EquipmentsList.gen",
	"equip/test/integration/pages/EquipmentsObjectPage.gen",
	"equip/test/integration/pages/MaintenanceRequestsObjectPage.gen"
], function (JourneyRunner, EquipmentsListGenerated, EquipmentsObjectPageGenerated, MaintenanceRequestsObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('equip') + '/test/flp.html#app-preview',
        pages: {
			onTheEquipmentsListGenerated: EquipmentsListGenerated,
			onTheEquipmentsObjectPageGenerated: EquipmentsObjectPageGenerated,
			onTheMaintenanceRequestsObjectPageGenerated: MaintenanceRequestsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

