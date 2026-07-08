using MaintenanceService as service from './maintenance-service';

annotate service.Equipments with @(
  UI.HeaderInfo: {
    TypeName: 'Equipment',
    TypeNamePlural: 'Equipments',
    Title: {
      Value: equipmentId
    },
    Description: {
      Value: name
    }
  },

  UI.LineItem: [
    {
      Value: equipmentId,
      Label: 'Equipment ID'
    },
    {
      Value: name,
      Label: 'Name'
    },
    {
      Value: location,
      Label: 'Location'
    },
    {
      Value: status,
      Label: 'Status'
    }
  ],

  UI.Identification: [
    {
      Value: equipmentId,
      Label: 'Equipment ID'
    },
    {
      Value: name,
      Label: 'Name'
    },
    {
      Value: location,
      Label: 'Location'
    },
    {
      Value: status,
      Label: 'Status'
    }
  ],

  UI.FieldGroup #General: {
    Data: [
      {
        Value: equipmentId,
        Label: 'Equipment ID'
      },
      {
        Value: name,
        Label: 'Name'
      },
      {
        Value: location,
        Label: 'Location'
      },
      {
        Value: status,
        Label: 'Status'
      }
    ]
  },

  UI.Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'GeneralInformation',
      Label: 'General Information',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'MaintenanceRequests',
      Label: 'Maintenance Requests',
      Target: 'requests/@UI.LineItem'
    }
  ]
);

annotate service.Equipments with {
  requests @(
    Capabilities.InsertRestrictions.Insertable: false,
    Capabilities.UpdateRestrictions.Updatable: false,
    Capabilities.DeleteRestrictions.Deletable: false
  );
};

annotate service.Equipments with @Capabilities.NavigationRestrictions: {
  RestrictedProperties: [
    {
      NavigationProperty: requests,
      InsertRestrictions: {
        Insertable: false
      },
      UpdateRestrictions: {
        Updatable: false
      },
      DeleteRestrictions: {
        Deletable: false
      }
    }
  ]
};

annotate service.MaintenanceRequests with @(
  UI.HeaderInfo: {
    TypeName: 'Maintenance Request',
    TypeNamePlural: 'Maintenance Requests',
    Title: {
      Value: title
    },
    Description: {
      Value: status
    }
  },

  UI.SelectionFields: [
    equipment_ID,
    title,
    priority,
    status,
    requester
  ],

  UI.LineItem: [
    {
      Value: equipment_ID,
      Label: 'Equipment'
    },
    {
      Value: title,
      Label: 'Title'
    },
    {
      Value: priority,
      Label: 'Priority'
    },
    {
      Value: status,
      Label: 'Status'
    },
    {
      Value: requester,
      Label: 'Requester'
    },
    {
      Value: approver,
      Label: 'Approver'
    },
    {
      Value: approvedAt,
      Label: 'Approved At'
    },
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Approve',
      Action: 'MaintenanceService.approve'
    },
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Reject',
      Action: 'MaintenanceService.rejectRequest'
    },
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Close',
      Action: 'MaintenanceService.close'
    }
  ],

  UI.FieldGroup #General: {
    Data: [
      {
        Value: equipment_ID,
        Label: 'Equipment'
      },
      {
        Value: title,
        Label: 'Title'
      },
      {
        Value: description,
        Label: 'Description'
      },
      {
        Value: priority,
        Label: 'Priority'
      },
      {
        Value: status,
        Label: 'Status'
      },
      {
        Value: requester,
        Label: 'Requester'
      },
      {
        Value: approver,
        Label: 'Approver'
      },
      {
        Value: comment,
        Label: 'Comment'
      },
      {
        Value: approvedAt,
        Label: 'Approved At'
      },
      {
        Value: closedAt,
        Label: 'Closed At'
      }
    ]
  },

  UI.Identification: [
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Approve',
      Action: 'MaintenanceService.approve'
    },
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Reject',
      Action: 'MaintenanceService.rejectRequest'
    },
    {
      $Type: 'UI.DataFieldForAction',
      Label: 'Close',
      Action: 'MaintenanceService.close'
    }
  ],

  UI.Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      ID: 'GeneralInformation',
      Label: 'General Information',
      Target: '@UI.FieldGroup#General'
    }
  ]
);

annotate service.MaintenanceRequests with {
  equipment_ID @(
    Common.ValueList: {
      CollectionPath: 'Equipments',
      Parameters: [
        {
          $Type: 'Common.ValueListParameterInOut',
          LocalDataProperty: equipment_ID,
          ValueListProperty: 'ID'
        },
        {
          $Type: 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'equipmentId'
        },
        {
          $Type: 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'name'
        },
        {
          $Type: 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'location'
        },
        {
          $Type: 'Common.ValueListParameterDisplayOnly',
          ValueListProperty: 'status'
        }
      ]
    },
    Common.Text: equipment.name,
    Common.TextArrangement: #TextOnly
  );
};

annotate service.MaintenanceRequests actions {
  approve @(
    Core.OperationAvailable: canApprove
  );

  rejectRequest @(
    Core.OperationAvailable: canApprove
  );

  close @(
    Core.OperationAvailable: canClose
  );
};
