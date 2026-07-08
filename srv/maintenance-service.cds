using maintenance.center as db from '../db/schema';
 
service MaintenanceService @(requires: 'Viewer') {
 
  @odata.draft.enabled
  entity Equipments @(restrict: [
    { grant: 'READ', to: ['Viewer', 'Manager', 'Technician', 'Admin'] },
    { grant: ['CREATE', 'UPDATE', 'DELETE'], to: 'Admin' }
  ]) as projection on db.Equipments;
 
  @odata.draft.enabled
  entity MaintenanceRequests @(restrict: [
    { grant: 'READ', to: ['Viewer', 'Manager', 'Technician', 'Admin'] },
    { grant: ['CREATE', 'UPDATE'], to: ['Manager', 'Admin'] },
    { grant: 'DELETE', to: 'Admin' },
    { grant: ['approve', 'rejectRequest'], to: ['Manager', 'Admin'] },
    { grant: 'close', to: ['Technician', 'Admin'] }
  ]) as projection on db.MaintenanceRequests {
    *,
    virtual canApprove : Boolean,
    virtual canClose   : Boolean
  } actions {
    action approve(comment: String) returns MaintenanceRequests;
    action rejectRequest(comment: String) returns MaintenanceRequests;
    action close(comment: String) returns MaintenanceRequests;
  };
}
