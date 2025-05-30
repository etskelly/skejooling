<script setup>

// import MainGrid from '@/pages/scheduler/GridExperimental.vue';
// import DialogModal from '@/Components/DialogModal.vue';
// import PrimaryButton from '@/Components/PrimaryButton.vue';
// import  from '@/pages/scheduler/EventForm.vue';

import ScheduleView from '@/components/schedule_original/ScheduleView.vue';

import { ref } from 'vue';

definePageMeta({
  layout: 'main'
});

const showEventForm = ref(false);
const title = ref('Event Form');
const content = ref('Event Form Content');

const viewMode = ref('month');
</script>

<template>
    <div>
        <div class="py-3">

            <div class="grid grid-cols-3 gap-4">

                <div class="drawer" style="z-index: 999;">
                    <input id="my-drawer" type="checkbox" class="drawer-toggle" />
                    <div class="drawer-content">
                        <label for="my-drawer" class="ml-4 btn btn-primary drawer-button">Add Event</label>
                    </div>
                    <div class="drawer-side">
                        <ul class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
                        <label for="my-drawer" class="drawer-overlay">Add Event</label>
                            <li>
                                <a class="btn btn-primary" @click="showEventForm = false">Close</a>
                            </li>
                            <!-- <EventForm /> -->
                        </ul>
                    </div>
                </div>

                <div></div>

                <!-- <button @click="showEventForm = true" class="ml-6 btn btn-primary">Add Event</button> -->

                <div>
                    <ul class="menu menu-vertical lg:menu-horizontal bg-cyan-700 rounded-box float-right">
                        <li><a @click="viewMode = 'month'" :class="viewMode == 'month' ? 'active' : ''">Month</a></li>
                        <li><a @click="viewMode = 'week'" :class="viewMode == 'week' ? 'active' : ''">Week</a></li>
                        <li><a @click="viewMode = 'day'" :class="viewMode == 'day' ? 'active' : ''">Day</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="py-12">
            <div class="max-w-8xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white shadow-xl sm:rounded-lg">
                    <ScheduleView />
                    <!-- <MainGrid :view-mode="viewMode" /> -->
                </div>
            </div>
        </div>
    </div>
</template>
