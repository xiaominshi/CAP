namespace maintenance.center;
 
using {
  cuid,
  managed
} from '@sap/cds/common';
 
entity Equipments : cuid, managed {
  equipmentId : String(30);
  name        : String(100);
  location    : String(100);
  status      : String(20);   // Available, Broken, InMaintenance
 
  requests    : Association to many MaintenanceRequests
                  on requests.equipment = $self;
}
 
entity MaintenanceRequests : cuid, managed {
  equipment_ID : UUID;

  equipment    : Association to Equipments on equipment.ID = equipment_ID;

  title        : String(100);
  description  : String(500);
  priority     : String(20);  // Low, Medium, High
  status       : String(20);  // New, Approved, Rejected, Closed
  requester    : String(100);
  approver     : String(100);
  comment      : String(500);
  approvedAt   : Timestamp;
  closedAt     : Timestamp;
}

