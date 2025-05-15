<template>
  <UCard>
    <template #header>
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold leading-tight">
          Manage Scheduling Templates
        </h2>
        <UButton
          icon="i-heroicons-plus"
          label="Add New Template"
          @click="openPanel()"
        />
      </div>
    </template>

    <div v-if="loading">
      <p>Loading templates...</p>
      <!-- TODO: Add a loading skeleton -->
    </div>
    <div v-else-if="error">
      <UAlert
        title="Error Loading Templates"
        color="red"
        variant="soft"
        :description="error.message || 'Could not fetch templates.'"
      />
    </div>
    <div v-else>
      <UTable :rows="templates" :columns="columns">
        <template #actions-data="{ row }">
          <UButton
            icon="i-heroicons-pencil"
            size="sm"
            color="gray"
            variant="ghost"
            class="mr-2"
            @click="openPanel(row)"
            aria-label="Edit"
          />
          <UButton
            icon="i-heroicons-trash"
            size="sm"
            color="red"
            variant="ghost"
            @click="confirmDeleteTemplate(row)"
            aria-label="Delete"
          />
        </template>
         <template #description-data="{ row }">
           <span class="text-sm text-gray-500 dark:text-gray-400 truncate max-w-xs block">{{ row.description || '-' }}</span>
        </template>
         <template #type-data="{ row }">
           <UBadge :label="row.type" color="gray" variant="soft" />
         </template>
      </UTable>
    </div>

    <USlideover v-model="isPanelOpen">
      <UCard class="flex flex-col flex-1" :ui="{ body: { base: 'flex-1' }, ring: '', divide: 'divide-y divide-gray-100 dark:divide-gray-800' }">
        <template #header>
           <h3 class="text-lg font-semibold">{{ isEditing ? 'Edit' : 'Add New' }} Template</h3>
        </template>

        <UForm :schema="templateSchema" :state="formState" class="space-y-4 p-4" @submit="saveTemplate">
          <UFormGroup label="Template Name" name="name" required>
            <UInput v-model="formState.name" placeholder="e.g., Weekly Classroom Schedule" />
          </UFormGroup>

          <UFormGroup label="Template Type" name="type" required>
            <USelect
              v-model="formState.type"
              :options="templateTypeOptions"
              placeholder="Select type..."
            />
          </UFormGroup>

          <UFormGroup label="Description" name="description">
            <UTextarea v-model="formState.description" placeholder="Optional: Describe the purpose of this template" />
          </UFormGroup>

          <div class="flex justify-end gap-3">
             <UButton label="Cancel" color="gray" variant="ghost" @click="isPanelOpen = false" />
             <UButton type="submit" :label="isEditing ? 'Save Changes' : 'Create Template'" :loading="saving" />
          </div>
        </UForm>
      </UCard>
    </USlideover>

     <!-- Confirmation Modal (Optional but recommended for delete) -->
    <UModal v-model="isConfirmModalOpen">
       <UCard>
         <template #header>
           Confirm Deletion
         </template>
         <p>Are you sure you want to delete the template "{{ templateToDelete?.name }}"?</p>
         <template #footer>
           <UButton label="Cancel" color="gray" @click="isConfirmModalOpen = false" />
           <UButton label="Delete" color="red" @click="deleteTemplate" :loading="deleting" />
         </template>
       </UCard>
    </UModal>

  </UCard>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'

// Define the structure of a template (adjust based on your DB schema)
interface ScheduleTemplate {
  id: number | string; // Use string if UUID
  name: string;
  type: string;
  description?: string;
  // Add other fields like created_at, user_id etc. as needed
}

// Refs for UI state
const isPanelOpen = ref(false)
const isConfirmModalOpen = ref(false)
const loading = ref(true)
const saving = ref(false)
const deleting = ref(false)
const error = ref<Error | null>(null)

// Data refs
const templates = ref<ScheduleTemplate[]>([])
const selectedTemplate = ref<ScheduleTemplate | null>(null)
const templateToDelete = ref<ScheduleTemplate | null>(null)

// Determine if the panel is for editing
const isEditing = computed(() => !!selectedTemplate.value)

// Template type options
const templateTypeOptions = [
  'Classroom Timetable',
  'Appointments',
  'Restaurant Bookings',
  'Staff Holidays',
  'General'
]

// Form state and schema
const templateSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  type: z.enum(templateTypeOptions as [string, ...string[]], { required_error: 'Type is required' }),
  description: z.string().optional()
})

type TemplateSchema = z.output<typeof templateSchema>

const formState = reactive<Partial<TemplateSchema>>({
  name: undefined,
  type: undefined,
  description: undefined
})

// Table columns definition
const columns = [
  { key: 'name', label: 'Name', sortable: true },
  { key: 'type', label: 'Type', sortable: true },
  { key: 'description', label: 'Description' },
  { key: 'actions', label: 'Actions', class: 'w-24 text-right' }
]

// --- Placeholder Functions ---

const fetchTemplates = async () => {
  loading.value = true
  error.value = null
  console.log('Fetching templates...')
  try {
    // Placeholder: Replace with API call
    // const data = await $fetch<ScheduleTemplate[]>('/api/templates')
    // templates.value = data
    // Mock data for now:
    await new Promise(resolve => setTimeout(resolve, 500)); // Simulate network delay
     templates.value = [
       { id: 1, name: 'Weekly Class Schedule', type: 'Classroom Timetable', description: 'Standard 5-day week schedule.' },
       { id: 2, name: 'Doctor Appointments', type: 'Appointments', description: 'Patient booking template.' },
       { id: 3, name: 'Restaurant Dinner Service', type: 'Restaurant Bookings' }
     ];
    console.log('Fetched templates:', templates.value)
  } catch (err) {
    console.error('Error fetching templates:', err)
    error.value = err as Error
    templates.value = [] // Clear templates on error
  } finally {
    loading.value = false
  }
}

const saveTemplate = async (event: FormSubmitEvent<TemplateSchema>) => {
   saving.value = true
   error.value = null
   console.log('Saving template...', event.data)
   const method = isEditing.value ? 'PUT' : 'POST';
   const url = isEditing.value ? `/api/templates/${selectedTemplate.value?.id}` : '/api/templates';

   try {
     // Placeholder: Replace with API call
     // const savedTemplate = await $fetch<ScheduleTemplate>(url, {
     //   method,
     //   body: event.data
     // });
     await new Promise(resolve => setTimeout(resolve, 500)); // Simulate network delay
     console.log('Template saved:', event.data); // Replace with actual savedTemplate

     isPanelOpen.value = false
     await fetchTemplates() // Refresh the list
   } catch (err) {
     console.error('Error saving template:', err)
     error.value = err as Error
     // Optionally show error to user in the form/panel
   } finally {
     saving.value = false
   }
}

const confirmDeleteTemplate = (template: ScheduleTemplate) => {
  templateToDelete.value = template;
  isConfirmModalOpen.value = true;
}

const deleteTemplate = async () => {
   if (!templateToDelete.value) return;
   deleting.value = true;
   error.value = null;
   console.log('Deleting template...', templateToDelete.value.id);

   try {
     // Placeholder: Replace with API call
     // await $fetch(`/api/templates/${templateToDelete.value.id}`, { method: 'DELETE' });
     await new Promise(resolve => setTimeout(resolve, 500)); // Simulate network delay
     console.log('Template deleted');

     isConfirmModalOpen.value = false;
     templateToDelete.value = null;
     await fetchTemplates(); // Refresh the list
   } catch (err) {
     console.error('Error deleting template:', err)
     error.value = err as Error
     // Optionally show error to user in the modal
   } finally {
     deleting.value = false;
   }
}

// --- Helper Functions ---

const openPanel = (template: ScheduleTemplate | null = null) => {
  selectedTemplate.value = template
  if (template) {
    // Populate form for editing
    formState.name = template.name
    formState.type = template.type
    formState.description = template.description
  } else {
    // Reset form for adding
    formState.name = undefined
    formState.type = undefined
    formState.description = undefined
  }
  isPanelOpen.value = true
}

// --- Lifecycle Hooks ---

onMounted(() => {
  fetchTemplates()
})

// Set page title
useHead({
  title: 'Manage Templates - Skejool'
})
</script>

<style scoped>
/* Add any specific styles if needed */
</style>
