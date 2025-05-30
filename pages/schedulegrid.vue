<template>
    <div class="min-h-[400px] bg-white text-slate-900" ref="containingDiv">
        <div class="shadow rounded-lg p-4">
            <div class="flex justify-between items-center mb-4">
                <!-- Navigation buttons remain the same -->
                <div class="space-x-2">
                    <button @click="previousMonth" class="px-3 py-1 border rounded">Previous</button>
                    <button @click="nextMonth" class="px-3 py-1 border rounded">Next</button>
                </div>

                <pre class="text-black">{{ datesForOverlay }}</pre>
            </div>

            <div class="overflow-x-auto">
                <div class="schedule-grid">
                    <!-- Header -->
                    <div class="header-cell text-black"></div>
                    <div class="header-cell text-black"></div>
                    <div class="header-cell month-header text-black" :style="{ gridColumn: `span ${datesOfMonth.length + 2}` }">
                        {{ monthName }}
                    </div>

                    <!-- Date headers -->
                    <div class="header-spacer text-black">
                        Person
                    </div>
                    <div class="header-spacer text-black">
                        Location
                    </div>
                    <div v-for="(d, idx) in datesOfMonth" :key="idx" class="date-header text-black">
                        {{ d.date() }}
                    </div>

                    <!-- Grid content -->
                    <div class="content-cell text-black">Orla</div>
                    <div class="content-cell text-black">Home</div>
                    <div v-for="(d, idx) in datesOfMonth" :key="idx" :ref="d.format('L')" class="date-cell text-black">
                        <!-- {{ d.format('L') }} -->
                    </div>
                </div>

                <time-box-overlay v-for="(dateObj, idx) in datesForOverlay" :key="idx"
                    :startOfRange="startOfMonthRange.toDate()" :endOfRange="endOfMonthRange.toDate()" :dateObj="dateObj"
                    :tableRefs="refs" />
            </div>

            <!-- Debug info -->
            <div class="mt-4 text-sm text-black">
                <div>Start of month range: {{ startOfMonthRange?.format('L') }}</div>
                <div>End of month range: {{ endOfMonthRange?.format('L') }}</div>
                <div>Dates in month: {{ datesOfMonth?.length }}</div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, useTemplateRef } from 'vue'
import TimeBoxOverlay from "@/components/schedule/TimeBoxOverlay.vue"
// import AddTimeData from "@/Pages/Scheduler/AddTimeData.vue"
import { useDebounceFn } from '@vueuse/core'
import { useEventBus } from '@vueuse/core'
import dayjs from 'dayjs'

import isBeween from  'dayjs/plugin/isBetween'

dayjs.extend(isBeween)

const {$emit} = useNuxtApp()

const bus = useEventBus()
const tbody = useTemplateRef('tablebody')
const containingDiv = useTemplateRef('containingDiv')
const tableCells = ref([])
const scrollPanel = ref(null)

const startOfMonthRange = ref(dayjs().startOf("month"))

debugger
const endOfMonthRange = ref(dayjs().endOf("month"))
const monthName = ref(dayjs().format("MMMM"))
const datesOfMonth = ref([])

const dateRangesToTest = ref([
  {
    from: new Date(2025, 0, 1, 0, 0),
    to: new Date(2025, 2, 7, 22, 0)
  },
  {
    from: new Date(2025, 0, 13),
    to: new Date(2025, 0, 16, 24, 0)
  },
])

const datesForOverlay = computed(() => {
  return dateRangesToTest.value.filter(dateTest => {
    return (
      dayjs(dateTest.from).isBetween(
        startOfMonthRange.value,
        endOfMonthRange.value,
        null,
        []
      ) ||
      dayjs(dateTest.to).isBetween(
        startOfMonthRange.value,
        endOfMonthRange.value,
        null,
        []
      )
    )
  })
})

// TODO set days of timeperiod
const setDaysOfMonth = () => {
  const startDate = startOfMonthRange.value
  datesOfMonth.value = []
  
  if (startDate.format("MMMM") === endOfMonthRange.value.format("MMMM")) {
    monthName.value = startDate.format("MMMM")
  } else {
    monthName.value = `${startDate.format("MMMM")} - ${endOfMonthRange.value.format("MMMM")}`
  }

  let day = startDate
  while (day <= endOfMonthRange.value) {
    datesOfMonth.value.push(day)
    day = day.clone().add(1, "d")
  }

  debugger

  nextTick(() => {
    $emit("moveOverlays")
  })
}

const current = () => {
  startOfMonthRange.value = dayjs().startOf("month")
  endOfMonthRange.value = dayjs().endOf("month")
  setDaysOfMonth()
}

const back = () => {
  const holdDate = endOfMonthRange.value.clone().subtract(1, "M")
  startOfMonthRange.value = holdDate.clone().startOf("month")
  endOfMonthRange.value = holdDate.clone().endOf("month")
  setDaysOfMonth()
}

const forward = () => {
  const holdDate = startOfMonthRange.value.clone().add(1, "M")
  startOfMonthRange.value = holdDate.clone().startOf("month")
  endOfMonthRange.value = holdDate.clone().endOf("month")
  setDaysOfMonth()
}

const onScroll = () => {
  $emit("moveOverlays")
}

// watchEffect(() => {
//    if (tbody.value) {
//     debugger
//     tableCells.value = tbody.value.getElementsByTagName("td")
//     scrollPanel.value = tbody.value
//   }
// })  

onMounted(() => {
  debugger
    tableCells.value = tbody.value.getElementsByTagName("td")
    scrollPanel.value = tbody.value

  const delayScrollEvent = useDebounceFn(() => {
    onScroll()
  }, 300)

  containingDiv.value.addEventListener("scroll", delayScrollEvent)
  // window.addEventListener("resize", delayScrollEvent)

  setDaysOfMonth()
})

onBeforeUnmount(() => {
  bus.off("moveOverlays")
  // window.removeEventListener("resize", "delayScrollEvent")
//   containingDiv.value?.removeEventListener('scroll')
})
</script>


<style scoped>
.schedule-grid {
    display: grid;
    grid-template-columns: auto auto repeat(v-bind(datesOfMonth.length), minmax(50px, 1fr));
    gap: 1px;
    background-color: #e5e7eb;
    /* border color */
    border: 1px solid #e5e7eb;
}

.header-cell,
.content-cell,
.date-header,
.header-spacer,
.date-cell {
    background-color: white;
    padding: 0.5rem;
    text-align: center;
}

.header-cell,
.date-header {
    font-weight: bold;
}

.month-header {
    text-align: center;
}

.date-cell {
    min-width: 50px;
}
</style>
