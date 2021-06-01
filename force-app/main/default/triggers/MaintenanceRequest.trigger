trigger MaintenanceRequest on Case (after update) {
    System.debug('*** inside case trigger ***');
    MaintenanceRequestHelper.handleAfterUpdate(trigger.new);
}