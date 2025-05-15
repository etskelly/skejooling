<template>
  <div class="scheduling-page">
    <div class="page-header">
      <h1>Scheduling</h1>
      <div class="header-actions">
        <button @click="showResourceModal = true" class="btn btn-outline">Manage Resources</button>
        <button @click="showServiceModal = true" class="btn btn-outline">Manage Services</button>
        <button @click="showClientModal = true" class="btn btn-outline">Manage Clients</button>
      </div>
    </div>
    
    <div class="scheduling-container">
      <SchedulingCalendar />
    </div>
    
    <!-- Resource Management Modal (placeholder) -->
    <div v-if="showResourceModal" class="modal-overlay">
      <div class="modal-container">
        <div class="modal-header">
          <h2>Manage Resources</h2>
          <button @click="showResourceModal = false" class="close-btn">&times;</button>
        </div>
        <div class="modal-body">
          <div class="resource-list">
            <div v-if="resources.length === 0" class="empty-state">
              No resources found. Add your first resource.
            </div>
            <div v-else class="list-container">
              <div v-for="resource in resources" :key="resource.id" class="list-item">
                <div class="list-item-content">
                  <div class="list-item-title">{{ resource.name }}</div>
                  <div class="list-item-subtitle">{{ resource.type }}</div>
                </div>
                <div class="list-item-actions">
                  <button @click="editResource(resource)" class="btn btn-small">Edit</button>
                  <button @click="deleteResource(resource.id)" class="btn btn-small btn-danger">Delete</button>
                </div>
              </div>
            </div>
          </div>
          
          <div class="form-container">
            <h3>{{ editingResource ? 'Edit Resource' : 'Add Resource' }}</h3>
            <div class="form-group">
              <label for="resource-name">Name</label>
              <input id="resource-name" v-model="resourceForm.name" type="text" class="form-control" />
            </div>
            <div class="form-group">
              <label for="resource-type">Type</label>
              <select id="resource-type" v-model="resourceForm.type" class="form-control">
                <option value="room">Room</option>
                <option value="equipment">Equipment</option>
                <option value="staff">Staff Member</option>
                <option value="other">Other</option>
              </select>
            </div>
            <div class="form-group">
              <label for="resource-description">Description</label>
              <textarea id="resource-description" v-model="resourceForm.description" class="form-control"></textarea>
            </div>
            <div class="form-group">
              <label for="resource-location">Location</label>
              <select id="resource-location" v-model="resourceForm.locationId" class="form-control">
                <option value="">None</option>
                <option v-for="location in locations" :key="location.id" :value="location.id">
                  {{ location.name }}
                </option>
              </select>
            </div>
            <div class="form-group">
              <label for="resource-capacity">Capacity</label>
              <input id="resource-capacity" v-model.number="resourceForm.capacity" type="number" min="0" class="form-control" />
            </div>
            <div class="form-group">
              <label for="resource-color">Color</label>
              <input id="resource-color" v-model="resourceForm.color" type="color" class="form-control color-input" />
            </div>
            <div class="form-actions">
              <button @click="resetResourceForm" class="btn btn-outline">Cancel</button>
              <button @click="saveResource" class="btn btn-primary">Save</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Service Management Modal (placeholder) -->
    <div v-if="showServiceModal" class="modal-overlay">
      <div class="modal-container">
        <div class="modal-header">
          <h2>Manage Services</h2>
          <button @click="showServiceModal = false" class="close-btn">&times;</button>
        </div>
        <div class="modal-body">
          <div class="service-list">
            <div v-if="services.length === 0" class="empty-state">
              No services found. Add your first service.
            </div>
            <div v-else class="list-container">
              <div v-for="service in services" :key="service.id" class="list-item">
                <div class="list-item-content">
                  <div class="list-item-title">{{ service.name }}</div>
                  <div class="list-item-subtitle">{{ service.duration }} minutes</div>
                </div>
                <div class="list-item-actions">
                  <button @click="editService(service)" class="btn btn-small">Edit</button>
                  <button @click="deleteService(service.id)" class="btn btn-small btn-danger">Delete</button>
                </div>
              </div>
            </div>
          </div>
          
          <div class="form-container">
            <h3>{{ editingService ? 'Edit Service' : 'Add Service' }}</h3>
            <div class="form-group">
              <label for="service-name">Name</label>
              <input id="service-name" v-model="serviceForm.name" type="text" class="form-control" />
            </div>
            <div class="form-group">
              <label for="service-description">Description</label>
              <textarea id="service-description" v-model="serviceForm.description" class="form-control"></textarea>
            </div>
            <div class="form-group">
              <label for="service-duration">Duration (minutes)</label>
              <input id="service-duration" v-model.number="serviceForm.duration" type="number" min="5" step="5" class="form-control" />
            </div>
            <div class="form-group">
              <label for="service-price">Price</label>
              <input id="service-price" v-model.number="serviceForm.price" type="number" min="0" step="0.01" class="form-control" />
            </div>
            <div class="form-group">
              <label for="service-color">Color</label>
              <input id="service-color" v-model="serviceForm.color" type="color" class="form-control color-input" />
            </div>
            <div class="form-actions">
              <button @click="resetServiceForm" class="btn btn-outline">Cancel</button>
              <button @click="saveService" class="btn btn-primary">Save</button>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Client Management Modal (placeholder) -->
    <div v-if="showClientModal" class="modal-overlay">
      <div class="modal-container">
        <div class="modal-header">
          <h2>Manage Clients</h2>
          <button @click="showClientModal = false" class="close-btn">&times;</button>
        </div>
        <div class="modal-body">
          <div class="client-list">
            <div v-if="clients.length === 0" class="empty-state">
              No clients found. Add your first client.
            </div>
            <div v-else class="list-container">
              <div v-for="client in clients" :key="client.id" class="list-item">
                <div class="list-item-content">
                  <div class="list-item-title">{{ client.name }}</div>
                  <div class="list-item-subtitle">{{ client.email || client.phone || 'No contact info' }}</div>
                </div>
                <div class="list-item-actions">
                  <button @click="editClient(client)" class="btn btn-small">Edit</button>
                  <button @click="deleteClient(client.id)" class="btn btn-small btn-danger">Delete</button>
                </div>
              </div>
            </div>
          </div>
          
          <div class="form-container">
            <h3>{{ editingClient ? 'Edit Client' : 'Add Client' }}</h3>
            <div class="form-group">
              <label for="client-name">Name</label>
              <input id="client-name" v-model="clientForm.name" type="text" class="form-control" />
            </div>
            <div class="form-group">
              <label for="client-email">Email</label>
              <input id="client-email" v-model="clientForm.email" type="email" class="form-control" />
            </div>
            <div class="form-group">
              <label for="client-phone">Phone</label>
              <input id="client-phone" v-model="clientForm.phone" type="tel" class="form-control" />
            </div>
            <div class="form-group">
              <label for="client-notes">Notes</label>
              <textarea id="client-notes" v-model="clientForm.notes" class="form-control"></textarea>
            </div>
            <div class="form-actions">
              <button @click="resetClientForm" class="btn btn-outline">Cancel</button>
              <button @click="saveClient" class="btn btn-primary">Save</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'
import SchedulingCalendar from '~/components/scheduling/SchedulingCalendar.vue'

const supabase = useSupabaseClient()

// State for resources
const resources = ref([])
const showResourceModal = ref(false)
const editingResource = ref(null)
const resourceForm = ref({
  name: '',
  type: 'room',
  description: '',
  capacity: null,
  color: '#2196f3',
  locationId: null,
  isActive: true
})

// State for services
const services = ref([])
const showServiceModal = ref(false)
const editingService = ref(null)
const serviceForm = ref({
  name: '',
  description: '',
  duration: 60,
  price: null,
  color: '#4caf50',
  isActive: true
})

// State for clients
const clients = ref([])
const showClientModal = ref(false)
const editingClient = ref(null)
const clientForm = ref({
  name: '',
  email: '',
  phone: '',
  notes: ''
})

// State for locations
const locations = ref([])

// Resource methods
const fetchResources = async () => {
  try {
    const { data, error } = await supabase
      .from('Resources')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    resources.value = data || []
  } catch (error) {
    console.error('Error fetching resources:', error)
  }
}

const resetResourceForm = () => {
  resourceForm.value = {
    name: '',
    type: 'room',
    description: '',
    capacity: null,
    color: '#2196f3',
    locationId: null,
    isActive: true
  }
  editingResource.value = null
}

const editResource = (resource) => {
  editingResource.value = resource
  resourceForm.value = { ...resource }
}

const saveResource = async () => {
  try {
    const form = resourceForm.value
    
    // Validate form
    if (!form.name) {
      alert('Resource name is required')
      return
    }
    
    // Get current user's organization ID (this should be dynamic in a real app)
    const organizationId = 1 // Placeholder
    
    const resourceData = {
      name: form.name,
      type: form.type,
      description: form.description,
      capacity: form.capacity,
      color: form.color,
      locationId: form.locationId || null,
      isActive: form.isActive,
      organizationId
    }
    
    if (editingResource.value) {
      // Update existing resource
      const { data, error } = await supabase
        .from('Resources')
        .update(resourceData)
        .eq('id', editingResource.value.id)
        .select()
      
      if (error) throw error
      
      // Update the resource in the local state
      const index = resources.value.findIndex(r => r.id === editingResource.value.id)
      if (index !== -1 && data && data.length > 0) {
        resources.value[index] = data[0]
      }
    } else {
      // Create new resource
      const { data, error } = await supabase
        .from('Resources')
        .insert(resourceData)
        .select()
      
      if (error) throw error
      
      // Add the new resource to the local state
      if (data && data.length > 0) {
        resources.value.push(data[0])
      }
    }
    
    // Reset the form
    resetResourceForm()
    
  } catch (error) {
    console.error('Error saving resource:', error)
    alert('Error saving resource: ' + error.message)
  }
}

const deleteResource = async (id) => {
  if (!confirm('Are you sure you want to delete this resource?')) return
  
  try {
    const { error } = await supabase
      .from('Resources')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    
    // Remove the resource from the local state
    resources.value = resources.value.filter(r => r.id !== id)
    
  } catch (error) {
    console.error('Error deleting resource:', error)
    alert('Error deleting resource: ' + error.message)
  }
}

// Service methods
const fetchServices = async () => {
  try {
    const { data, error } = await supabase
      .from('Services')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    services.value = data || []
  } catch (error) {
    console.error('Error fetching services:', error)
  }
}

const resetServiceForm = () => {
  serviceForm.value = {
    name: '',
    description: '',
    duration: 60,
    price: null,
    color: '#4caf50',
    isActive: true
  }
  editingService.value = null
}

const editService = (service) => {
  editingService.value = service
  serviceForm.value = { ...service }
}

const saveService = async () => {
  try {
    const form = serviceForm.value
    
    // Validate form
    if (!form.name) {
      alert('Service name is required')
      return
    }
    
    if (!form.duration || form.duration < 5) {
      alert('Service duration must be at least 5 minutes')
      return
    }
    
    // Get current user's organization ID (this should be dynamic in a real app)
    const organizationId = 1 // Placeholder
    
    const serviceData = {
      name: form.name,
      description: form.description,
      duration: form.duration,
      price: form.price,
      color: form.color,
      isActive: form.isActive,
      organizationId
    }
    
    if (editingService.value) {
      // Update existing service
      const { data, error } = await supabase
        .from('Services')
        .update(serviceData)
        .eq('id', editingService.value.id)
        .select()
      
      if (error) throw error
      
      // Update the service in the local state
      const index = services.value.findIndex(s => s.id === editingService.value.id)
      if (index !== -1 && data && data.length > 0) {
        services.value[index] = data[0]
      }
    } else {
      // Create new service
      const { data, error } = await supabase
        .from('Services')
        .insert(serviceData)
        .select()
      
      if (error) throw error
      
      // Add the new service to the local state
      if (data && data.length > 0) {
        services.value.push(data[0])
      }
    }
    
    // Reset the form
    resetServiceForm()
    
  } catch (error) {
    console.error('Error saving service:', error)
    alert('Error saving service: ' + error.message)
  }
}

const deleteService = async (id) => {
  if (!confirm('Are you sure you want to delete this service?')) return
  
  try {
    const { error } = await supabase
      .from('Services')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    
    // Remove the service from the local state
    services.value = services.value.filter(s => s.id !== id)
    
  } catch (error) {
    console.error('Error deleting service:', error)
    alert('Error deleting service: ' + error.message)
  }
}

// Client methods
const fetchClients = async () => {
  try {
    const { data, error } = await supabase
      .from('Clients')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    clients.value = data || []
  } catch (error) {
    console.error('Error fetching clients:', error)
  }
}

const resetClientForm = () => {
  clientForm.value = {
    name: '',
    email: '',
    phone: '',
    notes: ''
  }
  editingClient.value = null
}

const editClient = (client) => {
  editingClient.value = client
  clientForm.value = { ...client }
}

const saveClient = async () => {
  try {
    const form = clientForm.value
    
    // Validate form
    if (!form.name) {
      alert('Client name is required')
      return
    }
    
    // Get current user's organization ID (this should be dynamic in a real app)
    const organizationId = 1 // Placeholder
    
    const clientData = {
      name: form.name,
      email: form.email,
      phone: form.phone,
      notes: form.notes,
      organizationId
    }
    
    if (editingClient.value) {
      // Update existing client
      const { data, error } = await supabase
        .from('Clients')
        .update(clientData)
        .eq('id', editingClient.value.id)
        .select()
      
      if (error) throw error
      
      // Update the client in the local state
      const index = clients.value.findIndex(c => c.id === editingClient.value.id)
      if (index !== -1 && data && data.length > 0) {
        clients.value[index] = data[0]
      }
    } else {
      // Create new client
      const { data, error } = await supabase
        .from('Clients')
        .insert(clientData)
        .select()
      
      if (error) throw error
      
      // Add the new client to the local state
      if (data && data.length > 0) {
        clients.value.push(data[0])
      }
    }
    
    // Reset the form
    resetClientForm()
    
  } catch (error) {
    console.error('Error saving client:', error)
    alert('Error saving client: ' + error.message)
  }
}

const deleteClient = async (id) => {
  if (!confirm('Are you sure you want to delete this client?')) return
  
  try {
    const { error } = await supabase
      .from('Clients')
      .delete()
      .eq('id', id)
    
    if (error) throw error
    
    // Remove the client from the local state
    clients.value = clients.value.filter(c => c.id !== id)
    
  } catch (error) {
    console.error('Error deleting client:', error)
    alert('Error deleting client: ' + error.message)
  }
}

// Location methods
const fetchLocations = async () => {
  try {
    const { data, error } = await supabase
      .from('Location')
      .select('*')
      .order('name')
    
    if (error) throw error
    
    locations.value = data || []
  } catch (error) {
    console.error('Error fetching locations:', error)
  }
}

// Lifecycle hooks
onMounted(() => {
  fetchResources()
  fetchServices()
  fetchClients()
  fetchLocations()
})
</script>

<style scoped>
.scheduling-page {
  padding: 20px;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.scheduling-container {
  flex: 1;
  min-height: 0;
}

.btn {
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background-color: #2196f3;
  color: white;
  border: none;
}

.btn-outline {
  background-color: transparent;
  border: 1px solid #e0e0e0;
}

.btn-danger {
  background-color: #f44336;
  color: white;
  border: none;
}

.btn-small {
  padding: 4px 8px;
  font-size: 12px;
}

/* Modal styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-container {
  background-color: white;
  border-radius: 8px;
  width: 800px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid #e0e0e0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #757575;
}

.modal-body {
  padding: 16px;
  display: flex;
  gap: 20px;
}

.list-container {
  flex: 1;
  max-height: 500px;
  overflow-y: auto;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}

.form-container {
  flex: 1;
  padding: 16px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}

.empty-state {
  padding: 20px;
  text-align: center;
  color: #757575;
}

.list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  border-bottom: 1px solid #f5f5f5;
}

.list-item:last-child {
  border-bottom: none;
}

.list-item-title {
  font-weight: 500;
}

.list-item-subtitle {
  font-size: 12px;
  color: #757575;
}

.list-item-actions {
  display: flex;
  gap: 8px;
}

.form-group {
  margin-bottom: 16px;
}

label {
  display: block;
  margin-bottom: 4px;
  font-weight: 500;
}

.form-control {
  width: 100%;
  padding: 8px;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}

.color-input {
  height: 40px;
  padding: 4px;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 20px;
}
</style>
