<template>
  <div class="flex">
    <div class="w-2/3 p-4">
      <TimeslotsTable/>
    </div>
    <div class="w-1/3 p-4">
      <AbsenceForm/>
    </div>
  </div>
</template>

<script setup>
// import {ref} from 'vue/'
definePageMeta({
  middleware: 'auth'
})

import AbsenceForm from '~/components/absences/AbsenceForm.vue';
import TimeslotsTable from '~/components/absences/TimeslotsTable.vue';

</script>

<style></style>