<template>
  <div class="bg-white rounded-lg shadow p-6 max-w-2xl mx-auto">
    <h2 class="text-2xl font-bold mb-6 text-gray-800">Add New Event</h2>
    
    <form @submit.prevent="handleSubmit" class="space-y-4">
      <!-- Event Title -->
      <div>
        <label for="title" class="block text-sm font-medium text-gray-700">Event Title *</label>
        <input
          id="title"
          v-model="formData.title"
          type="text"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        />
      </div>

      <!-- Resource Selection -->
      <div>
        <label for="resource" class="block text-sm font-medium text-gray-700">Resource *</label>
        <select
          id="resource"
          v-model="formData.resourceId"
          required
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        >
          <option v-for="resource in resources" :key="resource.id" :value="resource.id">
            {{ resource.name }}
          </option>
        </select>
      </div>

      <!-- Date Range -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label for="startDate" class="block text-sm font-medium text-gray-700">Start Date *</label>
          <VueDatePicker
            id="startDate"
            v-model="formData.startDate"
            :min-date="new Date()"
            :enable-time-picker="false"
            required
            class="mt-1 w-full"
          />
        </div>
        <div>
          <label for="endDate" class="block text-sm font-medium text-gray-700">End Date *</label>
          <VueDatePicker
            id="endDate"
            v-model="formData.endDate"
            :min-date="formData.startDate || new Date()"
            :enable-time-picker="false"
            required
            class="mt-1 w-full"
          />
        </div>
      </div>

      <!-- Time Range -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label for="startTime" class="block text-sm font-medium text-gray-700">Start Time *</label>
          <VueDatePicker
            id="startTime"
            v-model="formData.startTime"
            time-picker
            required
            class="mt-1 w-full"
          />
        </div>
        <div>
          <label for="endTime" class="block text-sm font-medium text-gray-700">End Time *</label>
          <VueDatePicker
            id="endTime"
            v-model="formData.endTime"
            :min-time="formData.startTime"
            time-picker
            required
            class="mt-1 w-full"
          />
        </div>
      </div>

      <!-- Description -->
      <div>
        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
        <textarea
          id="description"
          v-model="formData.description"
          rows="3"
          class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
        ></textarea>
      </div>

      <!-- Attendees -->
      <div>
        <label class="block text-sm font-medium text-gray-700">Attendees</label>
        <div class="mt-2 space-y-2">
          <div v-for="person in people" :key="person.id" class="flex items-center">
            <input
              :id="`person-${person.id}`"
              v-model="formData.attendees"
              type="checkbox"
              :value="person.id"
              class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
            />
            <label :for="`person-${person.id}`" class="ml-2 text-sm text-gray-700">
              {{ person.name }}
            </label>
          </div>
        </div>
      </div>

      <!-- Form Actions -->
      <div class="flex justify-end space-x-3 pt-4">
        <button
          type="button"
          @click="$emit('cancel')"
          class="rounded-md border border-gray-300 bg-white py-2 px-4 text-sm font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          Cancel
        </button>
        <button
          type="submit"
          class="inline-flex justify-center rounded-md border border-transparent bg-blue-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          Save Event
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';

const props = defineProps({
  resources: {
    type: Array,
    required: true,
    default: () => []
  },
  people: {
    type: Array,
    default: () => []
  },
  initialData: {
    type: Object,
    default: () => ({
      title: '',
      resourceId: null,
      startDate: new Date(),
      endDate: new Date(),
      startTime: new Date().setHours(9, 0, 0, 0),
      endTime: new Date().setHours(10, 0, 0, 0),
      description: '',
      attendees: []
    })
  }
});

const emit = defineEmits(['submit', 'cancel']);

const formData = ref({...props.initialData});

// Update form data when initialData prop changes
watch(() => props.initialData, (newVal) => {
  formData.value = { ...newVal };
}, { deep: true });

// Set default times if not set
if (!formData.value.startTime) {
  const now = new Date();
  now.setHours(9, 0, 0, 0);
  formData.value.startTime = now;
}

if (!formData.value.endTime) {
  const end = new Date(formData.value.startTime);
  end.setHours(end.getHours() + 1);
  formData.value.endTime = end;
}

const handleSubmit = () => {
  // Combine date and time for start and end
  const startDateTime = new Date(formData.value.startDate);
  const startTime = new Date(formData.value.startTime);
  startDateTime.setHours(
    startTime.getHours(),
    startTime.getMinutes(),
    startTime.getSeconds(),
    startTime.getMilliseconds()
  );

  const endDateTime = new Date(formData.value.endDate);
  const endTime = new Date(formData.value.endTime);
  endDateTime.setHours(
    endTime.getHours(),
    endTime.getMinutes(),
    endTime.getSeconds(),
    endTime.getMilliseconds()
  );

  const eventData = {
    ...formData.value,
    start: startDateTime,
    end: endDateTime
  };

  emit('submit', eventData);
};
</script>

<style scoped>
/* Add any custom styles here */
</style>
