
<template>
    <form @submit.prevent="submit">
      <div>
        <label for="name" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Name</label>
        <InputText id="name" v-model="form.name" type="text" class="w-full mb-4" required autofocus />
        <small v-if="form.errors.name" class="p-error">{{ form.errors.name }}</small>
      </div>
  
      <div class="mt-4">
        <label for="description" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Description</label>
        <InputTextarea id="description" v-model="form.description" class="w-full mb-4" placeholder="Description" />
        <small v-if="form.errors.description" class="p-error">{{ form.errors.description }}</small>
      </div>
  
      <div class="mt-4">
        <label for="from" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Date Time From</label>
        <Calendar v-model="form.from" :min-date="new Date()" showTime class="w-full mb-4" />
        <small v-if="form.errors.from" class="p-error">{{ form.errors.from }}</small>
      </div>
  
      <div class="mt-4">
        <label for="to" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Date Time To</label>
        <Calendar v-model="form.to" :min-date="form.from" showTime class="w-full mb-4" />
        <small v-if="form.errors.to" class="p-error">{{ form.errors.to }}</small>
      </div>
  
      <div class="mt-4">
        <label for="type" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Choose Event Type</label>
        <Dropdown v-model="form.type" :options="eventTypes" optionLabel="label" optionValue="value" class="w-full mb-4" />
        <small v-if="form.errors.type" class="p-error">{{ form.errors.type }}</small>
      </div>
  
      <div class="flex items-center justify-end mt-4">
        <Button label="Save" type="submit" icon="pi pi-check" class="w-full" :disabled="form.processing" />
      </div>
    </form>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  import { useForm } from '@inertiajs/vue3';
  import InputText from 'primevue/inputtext';
  import InputTextarea from 'primevue/inputtextarea';
  import Calendar from 'primevue/calendar';
  import Dropdown from 'primevue/dropdown';
  import Button from 'primevue/button';
  
  const form = useForm({
    name: '',
    description: '',
    from: new Date(),
    to: new Date(),
    type: null,
  });
  
  const eventTypes = [
    { label: 'Appointment', value: 1 },
    { label: 'Absence', value: 2 },
    { label: 'Event', value: 3 },
  ];
  
  const submit = () => {
    form.post('events', {
      onError: (error) => {
        console.error(error);
      },
      onSuccess: (data) => {
        form.reset();
        // TODO: show success message and emit so close modal
      },
    });
  };
  </script>
  
  <style>
  .p-error {
    color: red;
  }
  </style>