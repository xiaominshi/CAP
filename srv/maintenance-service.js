const cds = require('@sap/cds')
 
module.exports = cds.service.impl(async function () {
  const { Equipments, MaintenanceRequests } = this.entities

  const cpi = await cds.connect.to('CPIService')
 
  const validEquipmentStatuses = ['Available', 'Broken', 'InMaintenance']
  const validRequestPriorities = ['Low', 'Medium', 'High']
  const validRequestStatuses = ['New', 'Approved', 'Rejected', 'Closed']
 
  function getRequestID(req) {
    const lastParam = req.params[req.params.length - 1]
    return lastParam.ID
  }
  async function notifyCPI(action, request, comment, userId) {
    console.log('>>> notifyCPI called')
    console.log('>>> CPI action:', action)
    console.log('>>> CPI payload:', {
      action,
      requestId: request.ID,
      status: request.status,
      equipmentId: request.equipment_ID,
      comment,
      userId
    })
  try {
    await cpi.send({
      method: 'POST',
      path: '/http/businesspartners_clean',
      headers: {
        'Content-Type': 'application/json'
      },
      data: {
        action,
        requestId: request.ID,
        status: request.status,
        equipmentId: request.equipment_ID,
        comment,
        userId,
        timestamp: new Date().toISOString()
      }
    })
  } catch (error) {
    console.error('Failed to call CPI:', error.message)
  }
}
 
  this.after('READ', 'MaintenanceRequests', (data) => {
    const requests = Array.isArray(data) ? data : [data]
 
    for (const request of requests) {
      if (!request) continue
      request.canApprove = request.status === 'New'
      request.canClose = request.status === 'Approved'
    }
  })
 
  this.before(['CREATE', 'UPDATE'], 'Equipments', (req) => {
    if (!req.data.status) req.data.status = 'Available'
 
    if (!validEquipmentStatuses.includes(req.data.status)) {
      return req.error(400, `Invalid equipment status: ${req.data.status}`)
    }
  })
 
  this.before(['CREATE', 'UPDATE'], 'MaintenanceRequests', (req) => {
    if (!req.data.status) req.data.status = 'New'
    if (!req.data.priority) req.data.priority = 'Medium'
 
    if (!validRequestStatuses.includes(req.data.status)) {
      return req.error(400, `Invalid request status: ${req.data.status}`)
    }
 
    if (!validRequestPriorities.includes(req.data.priority)) {
      return req.error(400, `Invalid request priority: ${req.data.priority}`)
    }
  })
 
  this.on('approve', 'MaintenanceRequests', async (req) => {
    console.log('>>> approve action triggered')
    console.log('>>> approve req.data:', req.data)
    console.log('>>> approve req.params:', req.params)
    const ID = getRequestID(req)
    const { comment } = req.data
 
    const request = await SELECT.one.from(MaintenanceRequests).where({ ID })
 
    if (!request) {
      return req.error(404, 'Maintenance request not found')
    }
 
    if (request.status !== 'New') {
      return req.error(
        400,
        `Only New requests can be approved. Current status is ${request.status}`
      )
    }
 
    await UPDATE(MaintenanceRequests)
      .set({
        status: 'Approved',
        approver: req.user?.id || 'anonymous',
        comment: comment || 'Approved',
        approvedAt: new Date().toISOString()
      })
      .where({ ID })
 
    if (request.equipment_ID) {
      await UPDATE(Equipments)
        .set({ status: 'InMaintenance' })
        .where({ ID: request.equipment_ID })
    }
    
    const updatedRequest = await SELECT.one.from(MaintenanceRequests).where({ ID })

    await notifyCPI(
      'approve',
      updatedRequest,
      comment || 'Approved',
      req.user?.id || 'anonymous'
    )

    return SELECT.one.from(MaintenanceRequests).where({ ID })
  })
 
  this.on('rejectRequest', 'MaintenanceRequests', async (req) => {
    const ID = getRequestID(req)
    const { comment } = req.data
 
    const request = await SELECT.one.from(MaintenanceRequests).where({ ID })
 
    if (!request) {
      return req.error(404, 'Maintenance request not found')
    }
 
    if (request.status !== 'New') {
      return req.error(
        400,
        `Only New requests can be rejected. Current status is ${request.status}`
      )
    }
 
    await UPDATE(MaintenanceRequests)
      .set({
        status: 'Rejected',
        approver: req.user?.id || 'anonymous',
        comment: comment || 'Rejected',
        approvedAt: new Date().toISOString()
      })
      .where({ ID })
 
    return SELECT.one.from(MaintenanceRequests).where({ ID })
  })
 
  this.on('close', 'MaintenanceRequests', async (req) => {
    const ID = getRequestID(req)
    const { comment } = req.data
 
    const request = await SELECT.one.from(MaintenanceRequests).where({ ID })
 
    if (!request) {
      return req.error(404, 'Maintenance request not found')
    }
 
    if (request.status !== 'Approved') {
      return req.error(
        400,
        `Only Approved requests can be closed. Current status is ${request.status}`
      )
    }
 
    await UPDATE(MaintenanceRequests)
      .set({
        status: 'Closed',
        comment: comment || 'Closed',
        closedAt: new Date().toISOString()
      })
      .where({ ID })
 
    if (request.equipment_ID) {
      await UPDATE(Equipments)
        .set({ status: 'Available' })
        .where({ ID: request.equipment_ID })
    }
 
    return SELECT.one.from(MaintenanceRequests).where({ ID })
  })
})
