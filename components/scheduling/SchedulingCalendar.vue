<template>
  <div class="scheduling-calendar">
    <div class="calendar-header">
      <div class="calendar-title">
        <h2>{{ calendarTitle }}</h2>
      </div>
      <div class="calendar-controls">
        <button @click="previousPeriod" class="btn btn-outline">
          <span class="icon">←</span>
        </button>
        <button @click="today" class="btn btn-primary">Today</button>
        <button @click="nextPeriod" class="btn btn-outline">
          <span class="icon">→</span>
        </button>
        <select v-model="viewType" class="select">
          <option value="day">Day</option>
          <option value="week">Week</option>
          <option value="month">Month</option>
        </select>
      </div>
    </div>

    <!-- Day View -->
    <div v-if="viewType === 'day'" class="day-view">
      <div class="time-column">
        <div class="time-header"></div>
        <div v-for="hour in hours" :key="hour" class="time-slot">
          {{ formatHour(hour) }}
        </div>
      </div>
      <div class="day-column">
        <div class="day-header">{{ formatDate(currentDate) }}</div>
        <div 
          v-for="hour in hours" 
          :key="hour" 
          class="day-cell"
          @click="handleCellClick(currentDate, hour)"
        >
          <div 
            v-for="appointment in getAppointmentsForHour(currentDate, hour)" 
            :key="appointment.id"
            class="appointment"
            :style="getAppointmentStyle(appointment)"
            @click.stop="handleAppointmentClick(appointment)"
          >
            <div class="appointment-title">{{ appointment.title }}</div>
            <div class="appointment-time">{{ formatAppointmentTime(appointment) }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Week View -->
    <div v-if="viewType === 'week'" class="week-view">
      <div class="time-column">
        <div class="time-header"></div>
        <div v-for="hour in hours" :key="hour" class="time-slot">
          {{ formatHour(hour) }}
        </div>
      </div>
      <div 
        v-for="day in weekDays" 
        :key="day.date" 
        class="day-column"
      >
        <div class="day-header">
          <div class="day-name">{{ day.dayName }}</div>
          <div class="day-date">{{ day.dayNumber }}</div>
        </div>
        <div 
          v-for="hour in hours" 
          :key="hour" 
          class="day-cell"
          @click="handleCellClick(day.date, hour)"
        >
          <div 
            v-for="appointment in getAppointmentsForHour(day.date, hour)" 
            :key="appointment.id"
            class="appointment"
            :style="getAppointmentStyle(appointment)"
            @click.stop="handleAppointmentClick(appointment)"
          >
            <div class="appointment-title">{{ appointment.title }}</div>
            <div class="appointment-time">{{ formatAppointmentTime(appointment) }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Month View -->
    <div v-if="viewType === 'month'" class="month-view">
      <div class="month-header">
        <div v-for="day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']" :key="day" class="month-day-header">
          {{ day }}
        </div>
      </div>
      <div class="month-grid">
        <div 
          v-for="day in monthDays" 
          :key="day.date" 
          class="month-cell"
          :class="{ 'current-month': day.currentMonth, 'today': isToday(day.date) }"
          @click="handleDayClick(day.date)"
        >
          <div class="month-cell-header">{{ day.dayNumber }}</div>
          <div class="month-cell-content">
            <div 
              v-for="appointment in getAppointmentsForDay(day.date)" 
              :key="appointment.id"
              class="month-appointment"
              :style="{ backgroundColor: appointment.color || '#2196f3' }"
              @click.stop="handleAppointmentClick(appointment)"
            >
              {{ appointment.title }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Appointment Form Modal (placeholder) -->
    <div v-if="showAppointmentForm" class="appointment-modal">
      <div class="appointment-form">
        <div class="form-header">
          <h3>{{ editingAppointment ? 'Edit Appointment' : 'New Appointment' }}</h3>
          <button @click="closeAppointmentForm" class="close-btn">&times;</button>
        </div>
        <div class="form-body">
          <div class="form-group">
            <label for="title">Title</label>
            <input id="title" v-model="appointmentForm.title" type="text" class="form-control" />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="start-date">Start Date</label>
              <input id="start-date" v-model="appointmentForm.startDate" type="date" class="form-control" />
            </div>
            <div class="form-group">
              <label for="start-time">Start Time</label>
              <input id="start-time" v-model="appointmentForm.startTime" type="time" class="form-control" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="end-date">End Date</label>
              <input id="end-date" v-model="appointmentForm.endDate" type="date" class="form-control" />
            </div>
            <div class="form-group">
              <label for="end-time">End Time</label>
              <input id="end-time" v-model="appointmentForm.endTime" type="time" class="form-control" />
            </div>
          </div>
          <div class="form-group">
            <label for="resource">Resource</label>
            <select id="resource" v-model="appointmentForm.resourceId" class="form-control">
              <option v-for="resource in resources" :key="resource.id" :value="resource.id">
                {{ resource.name }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label for="client">Client</label>
            <select id="client" v-model="appointmentForm.clientId" class="form-control">
              <option v-for="client in clients" :key="client.id" :value="client.id">
                {{ client.name }}
              </option>
            </select>
          </div>
          <div class="form-group">
            <label for="service">Service</label>
            <select id="service" v-model="appointmentForm.serviceId" class="form-control">
              <option v-for="service in services" :key="service.id" :value="service.id">
                {{ service.name }} ({{ service.duration }} min)
              </option>
            </select>
          </div>
          <div class="form-group">
            <label for="notes">Notes</label>
            <textarea id="notes" v-model="appointmentForm.notes" class="form-control"></textarea>
          </div>
        </div>
        <div class="form-footer">
          <button @click="closeAppointmentForm" class="btn btn-outline">Cancel</button>
          <button @click="saveAppointment" class="btn btn-primary">Save</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useSupabaseClient } from '#imports'

// State
const supabase = useSupabaseClient()
const viewType = ref('week')
const currentDate = ref(new Date())
const appointments = ref([])
const resources = ref([])
const clients = ref([])
const services = ref([])
const showAppointmentForm = ref(false)
const editingAppointment = ref(null)
const appointmentForm = ref({
  title: '',
  startDate: '',
  startTime: '',
  endDate: '',
  endTime: '',
  resourceId: null,
  clientId: null,
  serviceId: null,
  notes: ''
})

// Hours for day and week views
const hours = Array.from({ length: 24 }, (_, i) => i)

// Computed properties
const calendarTitle = computed(() => {
  const options = { month: 'long', year: 'numeric' }
  if (viewType.value === 'day') {
    return currentDate.value.toLocaleDateString(undefined, { ...options, day: 'numeric' })
  } else if (viewType.value === 'week') {
    const weekStart = getWeekStart(currentDate.value)
    const weekEnd = new Date(weekStart)
    weekEnd.setDate(weekEnd.getDate() + 6)
    
    if (weekStart.getMonth() === weekEnd.getMonth()) {
      return `${weekStart.toLocaleDateString(undefined, { month: 'long', year: 'numeric' })}`
    } else if (weekStart.getFullYear() === weekEnd.getFullYear()) {
      return `${weekStart.toLocaleDateString(undefined, { month: 'short' })} - ${weekEnd.toLocaleDateString(undefined, { month: 'long', year: 'numeric' })}`
    } else {
      return `${weekStart.toLocaleDateString(undefined, { month: 'short', year: 'numeric' })} - ${weekEnd.toLocaleDateString(undefined, { month: 'long', year: 'numeric' })}`
    }
  } else {
    return currentDate.value.toLocaleDateString(undefined, options)
  }
})

const weekDays = computed(() => {
  const days = []
  const weekStart = getWeekStart(currentDate.value)
  
  for (let i = 0; i < 7; i++) {
    const date = new Date(weekStart)
    date.setDate(date.getDate() + i)
    days.push({
      date: new Date(date),
      dayName: date.toLocaleDateString(undefined, { weekday: 'short' }),
      dayNumber: date.getDate()
    })
  }
  
  return days
})

const monthDays = computed(() => {
  const days = []
  const year = currentDate.value.getFullYear()
  const month = currentDate.value.getMonth()
  
  // First day of the month
  const firstDay = new Date(year, month, 1)
  // Last day of the month
  const lastDay = new Date(year, month + 1, 0)
  
  // Start from the first day of the week that contains the first day of the month
  const start = new Date(firstDay)
  start.setDate(start.getDate() - start.getDay())
  
  // End on the last day of the week that contains the last day of the month
  const end = new Date(lastDay)
  const daysToAdd = 6 - end.getDay()
  end.setDate(end.getDate() + daysToAdd)
  
  // Generate all days in the calendar
  const currentDay = new Date(start)
  while (currentDay <= end) {
    days.push({
      date: new Date(currentDay),
      dayNumber: currentDay.getDate(),
      currentMonth: currentDay.getMonth() === month
    })
    currentDay.setDate(currentDay.getDate() + 1)
  }
  
  return days
})

// Methods
const formatDate = (date) => {
  return date.toLocaleDateString(undefined, { weekday: 'short', month: 'short', day: 'numeric' })
}

const formatHour = (hour) => {
  return `${hour.toString().padStart(2, '0')}:00`
}

const formatAppointmentTime = (appointment) => {
  const start = new Date(appointment.startTime)
  const end = new Date(appointment.endTime)
  return `${start.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' })} - ${end.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit' })}`
}

const getWeekStart = (date) => {
  const result = new Date(date)
  const day = result.getDay()
  result.setDate(result.getDate() - day)
  return result
}

const isToday = (date) => {
  const today = new Date()
  return date.getDate() === today.getDate() &&
         date.getMonth() === today.getMonth() &&
         date.getFullYear() === today.getFullYear()
}

const getAppointmentsForHour = (date, hour) => {
  return appointments.value.filter(appointment => {
    const appointmentDate = new Date(appointment.startTime)
    return appointmentDate.getDate() === date.getDate() &&
           appointmentDate.getMonth() === date.getMonth() &&
           appointmentDate.getFullYear() === date.getFullYear() &&
           appointmentDate.getHours() === hour
  })
}

const getAppointmentsForDay = (date) => {
  return appointments.value.filter(appointment => {
    const appointmentDate = new Date(appointment.startTime)
    return appointmentDate.getDate() === date.getDate() &&
           appointmentDate.getMonth() === date.getMonth() &&
           appointmentDate.getFullYear() === date.getFullYear()
  })
}

const getAppointmentStyle = (appointment) => {
  return {
    backgroundColor: appointment.color || '#2196f3'
  }
}

const previousPeriod = () => {
  const newDate = new Date(currentDate.value)
  if (viewType.value === 'day') {
    newDate.setDate(newDate.getDate() - 1)
  } else if (viewType.value === 'week') {
    newDate.setDate(newDate.getDate() - 7)
  } else {
    newDate.setMonth(newDate.getMonth() - 1)
  }
  currentDate.value = newDate
  fetchAppointments()
}

const nextPeriod = () => {
  const newDate = new Date(currentDate.value)
  if (viewType.value === 'day') {
    newDate.setDate(newDate.getDate() + 1)
  } else if (viewType.value === 'week') {
    newDate.setDate(newDate.getDate() + 7)
  } else {
    newDate.setMonth(newDate.getMonth() + 1)
  }
  currentDate.value = newDate
  fetchAppointments()
}

const today = () => {
  currentDate.value = new Date()
  fetchAppointments()
}

const handleCellClick = (date, hour) => {
  // Create a new appointment at the clicked time
  const startDate = new Date(date)
  startDate.setHours(hour, 0, 0, 0)
  
  const endDate = new Date(startDate)
  endDate.setHours(hour + 1, 0, 0, 0)
  
  appointmentForm.value = {
    title: '',
    startDate: startDate.toISOString().split('T')[0],
    startTime: `${hour.toString().padStart(2, '0')}:00`,
    endDate: endDate.toISOString().split('T')[0],
    endTime: `${(hour + 1).toString().padStart(2, '0')}:00`,
    resourceId: resources.value.length > 0 ? resources.value[0].id : null,
    clientId: null,
    serviceId: null,
    notes: ''
  }
  
  editingAppointment.value = null
  showAppointmentForm.value = true
}

const handleDayClick = (date) => {
  // Set the view to day view and navigate to the clicked date
  viewType.value = 'day'
  currentDate.value = new Date(date)
  fetchAppointments()
}

const handleAppointmentClick = (appointment) => {
  // Edit the clicked appointment
  const startDate = new Date(appointment.startTime)
  const endDate = new Date(appointment.endTime)
  
  appointmentForm.value = {
    title: appointment.title,
    startDate: startDate.toISOString().split('T')[0],
    startTime: startDate.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit', hour12: false }),
    endDate: endDate.toISOString().split('T')[0],
    endTime: endDate.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit', hour12: false }),
    resourceId: appointment.resourceId,
    clientId: appointment.clientId,
    serviceId: appointment.serviceId,
    notes: appointment.notes || ''
  }
  
  editingAppointment.value = appointment
  showAppointmentForm.value = true
}

const closeAppointmentForm = () => {
  showAppointmentForm.value = false
}

const saveAppointment = async () => {
  try {
    const form = appointmentForm.value
    
    // Combine date and time
    const startDateTime = new Date(`${form.startDate}T${form.startTime}`)
    const endDateTime = new Date(`${form.endDate}T${form.endTime}`)
    
    const appointmentData = {
      title: form.title,
      startTime: startDateTime.toISOString(),
      endTime: endDateTime.toISOString(),
      notes: form.notes,
      organizationId: 1, // This should be the current user's organization
      createdById: 1, // This should be the current user's ID
    }
    
    if (form.resourceId) appointmentData.resourceId = form.resourceId
    if (form.clientId) appointmentData.clientId = form.clientId
    if (form.serviceId) appointmentData.serviceId = form.serviceId
    
    if (editingAppointment.value) {
      // Update existing appointment
      const { data, error } = await supabase
        .from('Appointments')
        .update(appointmentData)
        .eq('id', editingAppointment.value.id)
        .select()
      
      if (error) throw error
      
      // Update the appointment in the local state
      const index = appointments.value.findIndex(a => a.id === editingAppointment.value.id)
      if (index !== -1) {
        appointments.value[index] = { ...appointments.value[index], ...appointmentData }
      }
    } else {
      // Create new appointment
      const { data, error } = await supabase
        .from('Appointments')
        .insert(appointmentData)
        .select()
      
      if (error) throw error
      
      // Add the new appointment to the local state
      if (data && data.length > 0) {
        appointments.value.push(data[0])
      }
    }
    
    // Close the form
    showAppointmentForm.value = false
    
  } catch (error) {
    console.error('Error saving appointment:', error)
    // Handle error (show notification, etc.)
  }
}

const fetchAppointments = async () => {
  try {
    // Determine date range based on view type
    let startDate, endDate
    
    if (viewType.value === 'day') {
      startDate = new Date(currentDate.value)
      startDate.setHours(0, 0, 0, 0)
      
      endDate = new Date(currentDate.value)
      endDate.setHours(23, 59, 59, 999)
    } else if (viewType.value === 'week') {
      startDate = getWeekStart(currentDate.value)
      startDate.setHours(0, 0, 0, 0)
      
      endDate = new Date(startDate)
      endDate.setDate(endDate.getDate() + 6)
      endDate.setHours(23, 59, 59, 999)
    } else {
      // Month view
      startDate = new Date(currentDate.value.getFullYear(), currentDate.value.getMonth(), 1)
      endDate = new Date(currentDate.value.getFullYear(), currentDate.value.getMonth() + 1, 0, 23, 59, 59, 999)
    }
    
    // Fetch appointments for the date range
    const { data, error } = await supabase
      .from('Appointments')
      .select('*, resource:AppointmentResources(resourceId)')
      .gte('startTime', startDate.toISOString())
      .lte('endTime', endDate.toISOString())
    
    if (error) throw error
    
    appointments.value = data || []
    
  } catch (error) {
    console.error('Error fetching appointments:', error)
    // Handle error (show notification, etc.)
  }
}

const fetchResources = async () => {
  try {
    const { data, error } = await supabase
      .from('Resources')
      .select('*')
      .eq('isActive', true)
    
    if (error) throw error
    
    resources.value = data || []
    
  } catch (error) {
    console.error('Error fetching resources:', error)
  }
}

const fetchClients = async () => {
  try {
    const { data, error } = await supabase
      .from('Clients')
      .select('*')
    
    if (error) throw error
    
    clients.value = data || []
    
  } catch (error) {
    console.error('Error fetching clients:', error)
  }
}

const fetchServices = async () => {
  try {
    const { data, error } = await supabase
      .from('Services')
      .select('*')
      .eq('isActive', true)
    
    if (error) throw error
    
    services.value = data || []
    
  } catch (error) {
    console.error('Error fetching services:', error)
  }
}

// Lifecycle hooks
onMounted(() => {
  fetchAppointments()
  fetchResources()
  fetchClients()
  fetchServices()
})
</script>

<style scoped>
.scheduling-calendar {
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.calendar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid #e0e0e0;
}

.calendar-controls {
  display: flex;
  gap: 8px;
  align-items: center;
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

.select {
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #e0e0e0;
}

/* Day View */
.day-view {
  display: flex;
  flex: 1;
  overflow: auto;
}

.time-column {
  width: 60px;
  flex-shrink: 0;
  border-right: 1px solid #e0e0e0;
}

.time-header {
  height: 60px;
  border-bottom: 1px solid #e0e0e0;
}

.time-slot {
  height: 60px;
  padding: 4px;
  text-align: right;
  color: #757575;
  font-size: 12px;
  border-bottom: 1px solid #f5f5f5;
}

.day-column {
  flex: 1;
  min-width: 200px;
}

.day-header {
  height: 60px;
  padding: 8px;
  text-align: center;
  font-weight: 500;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.day-name {
  font-size: 14px;
}

.day-date {
  font-size: 24px;
  font-weight: 500;
}

.day-cell {
  height: 60px;
  border-bottom: 1px solid #f5f5f5;
  position: relative;
}

/* Week View */
.week-view {
  display: flex;
  flex: 1;
  overflow: auto;
}

/* Month View */
.month-view {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: auto;
}

.month-header {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  border-bottom: 1px solid #e0e0e0;
}

.month-day-header {
  padding: 12px;
  text-align: center;
  font-weight: 500;
}

.month-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  flex: 1;
}

.month-cell {
  min-height: 100px;
  border-right: 1px solid #f5f5f5;
  border-bottom: 1px solid #f5f5f5;
  padding: 4px;
}

.month-cell-header {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 4px;
  color: #757575;
}

.month-cell.current-month .month-cell-header {
  color: #212121;
}

.month-cell.today {
  background-color: #e3f2fd;
}

.month-cell.today .month-cell-header {
  color: #2196f3;
  font-weight: 700;
}

.month-cell-content {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.month-appointment {
  padding: 2px 4px;
  border-radius: 2px;
  font-size: 12px;
  color: white;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  cursor: pointer;
}

/* Appointments */
.appointment {
  position: absolute;
  left: 2px;
  right: 2px;
  padding: 4px;
  border-radius: 4px;
  color: white;
  font-size: 12px;
  cursor: pointer;
  z-index: 1;
  overflow: hidden;
}

.appointment-title {
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.appointment-time {
  font-size: 10px;
  opacity: 0.8;
}

/* Appointment Form Modal */
.appointment-modal {
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

.appointment-form {
  background-color: white;
  border-radius: 8px;
  width: 500px;
  max-width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.form-header {
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

.form-body {
  padding: 16px;
}

.form-group {
  margin-bottom: 16px;
}

.form-row {
  display: flex;
  gap: 16px;
}

.form-row .form-group {
  flex: 1;
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

.form-footer {
  padding: 16px;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>
