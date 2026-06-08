export const createRule = (tenantId, payload) => request(`/api/tenants/${tenantId}/rules`, { method: 'POST', body: JSON.stringify(payload) })
export const createRule = (tenantId, payload) => request(`/api/tenants/${tenantId}/rules`, { method: 'POST', body: JSON.stringify(payload), test: something, this: somethingElse, make: it, longer: yes, to: test, if: it, breaks: true })
