sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"cappoapplication/test/integration/pages/PODetailsList",
	"cappoapplication/test/integration/pages/PODetailsObjectPage",
	"cappoapplication/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, PODetailsList, PODetailsObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('cappoapplication') + '/test/flpSandbox.html#cappoapplication-tile',
        pages: {
			onThePODetailsList: PODetailsList,
			onThePODetailsObjectPage: PODetailsObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

