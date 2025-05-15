<template>
  <div class="min-h-screen flex items-center justify-center">
    <Toast />
    <div class="bg-card shadow-lg rounded-lg p-8 max-w-md w-full">
      <h1 class="text-2xl font-bold mb-4 dark:text-primary">Absence Form</h1>
      <form class="flex flex-col" @submit.prevent="handleSubmit">
        <div class="mb-4">
          <label for="absenceType" class="block text-sm font-medium text-primary">Absence Type</label>
          <select id="absenceType" name="absenceType"
            class="form-select mt-1 block w-full py-2 px-3 border border-input rounded-md shadow-sm focus:outline-none focus:ring focus:ring-primary focus:border-primary sm:text-sm">
            <option value="holiday">Holiday</option>
            <option value="sick">Sick Leave</option>
            <option value="personal">Personal Leave</option>
            <option value="half-day-morning">Half Day (Morning)</option>
            <option value="half-day-afternoon">Half Day (Afternoon)</option>
          </select>
        </div>

        <div class="mb-4">
          <label for="startDate" class="block text-sm font-medium text-primary">Start Date</label>
          <input id="startDate" name="startDate" type="date"
            class="form-input mt-1 block w-full py-2 px-3 border border-input rounded-md shadow-sm focus:outline-none focus:ring focus:ring-primary focus:border-primary sm:text-sm" />
          <div class="form-control">
            <label class="label cursor-pointer text-primary-foreground">
              <span class="label-text">Half Day</span>
              <input type="checkbox" class="toggle" checked="checked" />
            </label>
          </div>
        </div>

        <div class="mb-4">
          <label for="endDate" class="block text-sm font-medium text-primary">End Date</label>
          <input id="endDate" name="endDate" type="date"
            class="form-input mt-1 block w-full py-2 px-3 border border-input rounded-md shadow-sm focus:outline-none focus:ring focus:ring-primary focus:border-primary sm:text-sm" />
          <div class="form-control">
            <label class="label cursor-pointer text-primary">
              <span class="label-text">Half Day</span>
              <input type="checkbox" class="toggle" checked="checked" />
            </label>
          </div>
        </div>

        <div class="mb-4">
          <label for="reason" class="block text-sm font-medium text-primary">Reason</label>
          <textarea id="reason" name="reason"
            class="form-textarea mt-1 block w-full py-2 px-3 border border-input rounded-md shadow-sm focus:outline-none focus:ring focus:ring-primary focus:border-primary sm:text-sm"
            rows="3"></textarea>
        </div>

        <div class="mb-4 flex items-center">
          <input type="checkbox" id="halfDaySwitch" name="halfDaySwitch"
            class="form-checkbox h-5 w-5 text-primary focus:ring focus:ring-primary" />
          <label for="halfDaySwitch" class="ml-2 block text-sm font-medium text-primary">Half Day</label>
        </div>

        <div class="flex justify-end">
          <button type="submit"
            class="bg-cyan-950 text-primary-foreground rounded-md px-4 py-2 hover:bg-cyan-950/80 focus:outline-none focus:ring focus:ring-primary focus:ring-opacity-50">Save</button>
        </div>
      </form>
    </div>
  </div>

</template>

<script setup>

// import { useToast } from '#imports';
const toast = useToast();

const form = ref({
  absenceType: '',
  startDate: '',
  startHalfDay: false,
  endDate: '',
  endHalfDay: false,
  reason: '',
  halfDaySwitch: false
});

const handleSubmit = async () => {
  try {
    const response = await fetch('/api/timebox', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(form.value)
    });

    debugger;

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    const data = await response.json();

    toast.add({
      severity: 'success',
      summary: 'Saved',
      detail: 'Event Saved',
      life: 3000
    });

    console.log('Success:', data);
    // Handle success (e.g., show a success message, reset the form, etc.)
  } catch (error) {
    debugger

    toast.add({ severity: 'error', summary: 'Error Message', detail: 'Message Content', life: 3000 });

    console.error('Error:', error);
    // Handle error (e.g., show an error message)
  }
};

</script>

<style></style>