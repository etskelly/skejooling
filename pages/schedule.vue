<template>
  <div class="bg-gray-100 p-4">
    <!--div class="shadow rounded-lg p-4"> -->
      <!-- <div class="flex justify-between items-center mb-4">
        <div></div>
        <div class="flex space-x-2">
          <button @click="back()" class="p-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            <Icon name="material-symbols:skip-previous" />
          </button>
          <button @click="current()" class="p-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            <Icon name="material-symbols:today" />
          </button>
          <button @click="forward()" class="p-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            <Icon name="material-symbols:skip-next" />
          </button>
        </div>
      </div> -->

      <div class='bg-white w-full overflow-x-auto' ref="containingDiv">
        <table class="w-full max-w-9/10 border-collapse border border-gray-200">
          <thead>
            <tr>
              <th class="font-bold border border-gray-200 p-2">Person</th>
              <th class="font-bold border border-gray-200 p-2">Location</th>
              <th :colspan="datesOfMonth.length" class="font-bold border border-gray-200 p-2 text-center text-black">
                {{ monthName }}
              </th>
            </tr>
            <tr>
              <th colspan="2" class="border border-gray-200">&nbsp;</th>
              <th 
                v-for="(d, idx) in datesOfMonth" 
                :key="idx"
                class="w-[3.58%] border border-gray-200 p-2 text-black text-center"
              >
                {{ d.date() }}
              </th>
            </tr>
          </thead>
          <tbody ref="tablebody">
            <tr>
              <th scope="row" class="border border-gray-200 p-2 text-black">Orla</th>
              <th scope="row" class="border border-gray-200 p-2 text-black">Home</th>
              <td 
                v-for="(d, idx) in datesOfMonth" 
                :key="idx" 
                :id="d.format('L')"
                ref="dateItems"
                class="border border-gray-200 p-2 text-black text-center"
              >
                <!-- {{ d.format('L') }} -->
              </td>
            </tr>
          </tbody>
        </table>

        <!-- <time-box-overlay
          v-for="(dateObj, idx) in datesForOverlay"
          :key="idx"
          :startOfRange="startOfMonthRange.toDate()"
          :endOfRange="endOfMonthRange.toDate()"
          :dateObj="dateObj"
          :tableRefs="dateItems"
        /> -->
      </div>

      <div class="mt-4 space-y-2">
        <pre>StartOfMonthRange: {{ startOfMonthRange }}</pre>
        <pre>EndOfMonthRange: {{ endOfMonthRange }}</pre>
        <pre>Dates:{{ datesForOverlay }}</pre>
        <!-- <add-time-data :date-objs="dateRangesToTest" /> -->
      </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, useTemplateRef } from 'vue'
// import TimeBoxOverlay from "@/components/schedule/TimeBoxOverlay.vue"
// import AddTimeData from "@/Pages/Scheduler/AddTimeData.vue"
import { useDebounceFn } from '@vueuse/core'
import { useEventBus } from '@vueuse/core'
import dayjs from 'dayjs'
import isBeween from  'dayjs/plugin/isBetween'
import localizedFormat from 'dayjs/plugin/localizedFormat'
dayjs.extend(isBeween)
dayjs.extend(localizedFormat);

const bus = useEventBus()
const tbody = useTemplateRef('tablebody')
const containingDiv = useTemplateRef('containingDiv')
const tableCells = ref([])
const scrollPanel = ref(null)

const dateItems = useTemplateRef('dateItems')

const startOfMonthRange = ref(dayjs().startOf("month"))
const endOfMonthRange = ref(dayjs().endOf("month"))
const monthName = ref(dayjs().format("MMMM"))
const datesOfMonth = ref([])

const dateRangesToTest = ref([
  {
    from: new Date(2025, 0, 16, 0, 0),
    to: new Date(2025, 0, 17, 22, 0)
  },
  {
    from: new Date(2025, 0, 1),
    to: new Date(2025, 0, 5, 24, 0)
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

debugger

onMounted(() => {

  debugger
  tableCells.value = tbody.value.getElementsByTagName("td")
  scrollPanel.value = tbody.value

  const delayScrollEvent = useDebounceFn(() => {
    bus.emit("moveOverlays")
  }, 300)

  containingDiv.value.addEventListener("scroll", delayScrollEvent)
  // window.addEventListener("resize", delayScrollEvent)

  setDaysOfMonth()
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
    bus.emit("moveOverlays")
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
  bus.emit("moveOverlays")
}

// watchEffect(() => {

//    if (tbody.value) {
//     debugger
//     tableCells.value = tbody.value.getElementsByTagName("td")
//     scrollPanel.value = tbody.value
//   }
// })  


onBeforeUnmount(() => {
  bus.off("moveOverlays")
  // window.removeEventListener("resize", "delayScrollEvent")
  containingDiv.value?.removeEventListener('scroll')
})
</script>
