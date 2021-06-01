@IsTest
global with sharing class WarehouseCalloutServiceMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest req) {
        String json = '[{\"_id\":\"55d66226726b611100aaf741\",\"replacement\":false,\"quantity\":2,\"name\":\"TestClass 1000 kW\",\"maintenanceperiod\":225,\"lifespan\":100,\"cost\":5000,\"sku\":\"122221\"}]';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody(json);
        return res;
    }
}
