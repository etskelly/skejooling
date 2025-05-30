<template>
  <div class="scheduler">
    <!-- Header with days -->
    <div class="scheduler-grid">
      <div class="corner-cell"></div>
      <div v-for="day in days" :key="day" class="header-cell">
        {{ day }}
      </div>

      <!-- Resources and time slots -->
      <template v-for="resource in resources" :key="resource">
        <div class="resource-cell">{{ resource }}</div>
        <div 
          v-for="day in days" 
          :key="`${resource}-${day}`"
          class="booking-cell"
          :class="{ 'has-booking': getBooking(resource, day) }"
          @click="handleCellClick(resource, day)"
        >
          <div v-if="getBooking(resource, day)" class="booking">
            {{ getBooking(resource, day).title }}
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>

import { ref } from 'vue'
const days = ref(['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])
const resources = ref(['Room A', 'Room B', 'Room C', 'Room D'])

// Sample bookings data - replace with your actual data source
const bookings = ref([
  { resource: 'Room A', day: 'Mon', title: 'Team Meeting' },
  { resource: 'Room B', day: 'Wed', title: 'Interview' },
])

const getBooking = (resource, day) => {
  return bookings.value.find(
    booking => booking.resource === resource && booking.day === day
  )
}

const handleCellClick = (resource, day) => {
  // Handle booking creation/editing
  console.log(`Clicked: ${resource} on ${day}`)
}
</script>

<style scoped>
.scheduler {
  padding: 20px;
}

.scheduler-grid {
  display: grid;
  grid-template-columns: 120px repeat(5, 1fr);
  gap: 1px;
  background-color: #e0e0e0;
  border: 1px solid #e0e0e0;
  width: 100%;
}

.corner-cell, .header-cell, .resource-cell, .booking-cell {
  background-color: white;
  padding: 10px;
}

.header-cell {
  font-weight: bold;
  text-align: center;
  padding: 15px;
  background-color: #f5f5f5;
  border-bottom: 2px solid #e0e0e0;
}

.resource-cell {
  font-weight: bold;
}

.booking-cell {
  min-height: 80px;
  cursor: pointer;
}

.booking-cell:hover {
  background-color: #f5f5f5;
}

.has-booking {
  background-color: #e3f2fd;
}

.booking {
  background-color: #2196f3;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.9em;
}
</style> 