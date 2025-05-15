<template>
  <div class="p-2">
    <!-- View Mode Switch -->
    <div class="p-4 flex justify-between items-center">
      <div class="flex gap-2 items-center">
      <select v-model="viewMode" class="border p-1">
        <option value="day">Day</option>
        <option value="week">Week</option>
        <option value="month">Month</option>
      </select>
      </div>
      <div class="flex-1 text-center text-lg font-semibold">
      {{ formattedDateRange }}
      </div>
    </div>
    <div class="ganttcontainer mx-auto p-0 bg-white" ref="ganttContainer">
      <div>
        <div class="grid gap-0 relative"
             :style="{ 
               gridTemplateColumns: `${leftColumnWidth} repeat(${timelineCells.length}, ${cellWidth}px)`,
               gridTemplateRows: gridTemplateRows
             }">
          <!-- Header Left Column -->
          <div class="border-r bg-gray-50 border-b flex items-center justify-center sticky left-0 z-[500]" ref="headerRowEl">
            <span class="text-black text-sm">People</span>
          </div>

          <!-- Timeline Header -->
          <div v-for="cell in timelineCells" 
               :key="cell.format('YYYY-MM-DD-HH-mm')"
               class="text-center border-r border-b text-sm pt-2 pb-0 sticky top-0 z-[400]"
               :class="{ 'bg-gray-50': isOff(cell) }">
            <div class="text-black flex flex-col">
              <!-- Show date above time/day -->
              <div class="text-[10px] text-gray-500">
                {{ cell.format('D MMM') }}
              </div>
              <div class="text-[10px] text-gray-500">
                <!-- In day view, show hour; otherwise show day -->
                <template v-if="viewMode === 'day'">
                  {{ cell.format('HH:mm') }}
                </template>
                <template v-else>
                  {{ cell.format('ddd') }}
                </template>
              </div>
            </div>
          </div>

          <!-- People Names Column -->
          <div class="bg-gray-50 sticky left-0 z-[450]">
            <div v-for="person in processedPeople" 
                 :key="person.id"
                 class="p-2 border-b border-r flex items-center bg-gray-50"
                 :style="{ height: `${person.rowHeight}px` }">
              <span class="text-black text-sm">{{ person.name }}</span>
            </div>
          </div>

          <!-- Grid Cells -->
          <template v-for="(person, personIndex) in processedPeople" :key="person.id">
            <template v-for="(cell, cellIndex) in timelineCells" :key="cell.format('YYYY-MM-DD-HH-mm')">
              <div class="border-r border-b z-10"
                   :class="{ 'bg-gray-50': isOff(cell) }"
                   :style="{ 
                     gridRow: personIndex + 2,
                     gridColumn: cellIndex + 2
                   }">
              </div>
            </template>
          </template>

          <!-- Task Bars -->
          <template v-for="(person, personIndex) in processedPeople" :key="person.id">
            <div v-for="task in person.tasks" 
                 :key="task.id"
                 class="rounded-md shadow-sm relative z-[50] flex items-center"
                 :style="getTaskStyle(personIndex, task)">
              <div class="text-black text-xs p-1 truncate w-full">
                {{ task.name }}
                <div class="text-[10px] opacity-75">
                  {{ formatTime(task.start) }} - {{ formatTime(task.end) }}
                </div>
              </div>
            </div>
          </template>

          <!-- Current Time Line (Visible in all views) -->
          <div class="absolute top-0 h-full w-[1px] opacity-50 bg-red-300 z-[600]" 
               :style="{ left: `${currentTimePosition}px` }"></div>
        </div>
      </div>
    </div>
    <!-- Control Panel -->
    <div class="flex justify-between items-center bg-white p-4">
      <button @click="moveTimeline(-1, 2)" class="px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">
         <icon name="mdi:rewind" class="w-4 h-4" />
      </button>
      <button @click="moveTimeline(-1)" class="px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">
         <icon name="mdi:arrow-left" class="w-4 h-4" />
      </button>
      <button @click="jumpToNow" class="px-3 py-1 bg-gray-500 text-white rounded hover:bg-blue-600">
       Current Time
      </button>
      <button @click="moveTimeline(1)" class="px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">
        <icon name="mdi:arrow-right" class="w-4 h-4" />
      </button>
      <button @click="moveTimeline(1, 2)" class="px-3 py-1 bg-gray-500 text-white rounded hover:bg-gray-600">
        <icon name="mdi:fast-forward" class="w-4 h-4" />
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue';
import dayjs from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
dayjs.extend(isSameOrAfter);

// View mode
const viewMode = ref('month');

// Add these new refs and computed properties
// const scrollContainer = ref(null);
const timelineStart = ref(dayjs().startOf(viewMode.value));
const timelineEnd = ref(dayjs().endOf(viewMode.value));


// Create timeline cells (hours for day, days for week/month)
const timelineCells = computed(() => {
  const cells = [];
  let current = timelineStart.value.clone();
  if (viewMode.value === 'day') {
    while (current.isBefore(timelineEnd.value)) {
      cells.push(current.clone());
      current = current.add(1, 'hour');
    }
  } else {
    while (current.isBefore(timelineEnd.value) || current.isSame(timelineEnd.value, 'day')) {
      cells.push(current.clone());
      current = current.add(1, 'day');
    }
  }
  return cells;
});

// Configuration for layout sizes
const leftColumnWidth = '12rem';
const leftColumnWidthPx = 12 * 16; // Convert rem to pixels
const ganttContainer = ref(null);
const cellWidth = ref(40); // default value

// Sample data
const people = ref([
  {
    id: 1,
    name: 'John Doe',
    tasks: [
      {
        id: 1,
        name: 'Design Sprint',
        start: dayjs().hour(9).minute(30).toDate(),
        end: dayjs().add(1, 'day').hour(15).minute(30).toDate(),
        color: '#3b82f6'
      },
      {
        id: 2,
        name: 'Client Meeting',
        start: dayjs().hour(11).minute(0).toDate(),
        end: dayjs().hour(12).minute(30).toDate(),
        color: '#f59e0b'
      }
    ]
  },
  {
    id: 2,
    name: 'Jane Smith',
    tasks: [
      {
        id: 1,
        name: 'Some Stuff',
        start: dayjs().hour(14).minute(0).toDate(),
        end: dayjs().hour(16).minute(45).toDate(),
        color: '#10b981'
      },
      {
        id: 2,
        name: 'Laters',
        start: dayjs().add(5, 'day').hour(10).minute(0).toDate(),
        end: dayjs().add(7, 'day').hour(11).minute(45).toDate(),
        color: '#10b981'
      }
    ]
  },
  {
    id: 3,
    name: 'Sean Keane',
    tasks: [
      {
        id: 7,
        name: 'Bananagrams',
        start: dayjs().hour(14).minute(0).toDate(),
        end: dayjs().hour(16).minute(45).toDate(),
        color: '#10b981'
      },
      {
        id: 8,
        name: 'Chillax',
        start: dayjs().add(1, 'day').hour(2).minute(0).toDate(),
        end: dayjs().add(1, 'day').hour(3).minute(10).toDate(),
        color: '#10b981'
      },
      {
        id: 9,
        name: 'Hurricane',
        start: dayjs().add(2, 'day').hour(3).minute(0).toDate(),
        end: dayjs().add(2, 'day').hour(4).minute(10).toDate(),
        color: '#FF5733'
      }
    ]
  }
]);

// Process people tasks for lane calculations (remains the same)
const processedPeople = computed(() => {
  return people.value.map(person => {
    // Filter tasks to only include those that overlap with the timeline
    const visibleTasks = person.tasks.filter(task => {
      const taskStart = dayjs(task.start);
      const taskEnd = dayjs(task.end);
      return (taskStart.isBefore(timelineEnd.value) && taskEnd.isAfter(timelineStart.value));
    });

    const sortedTasks = [...visibleTasks].map(task => ({
      ...task,
      start: dayjs(task.start),
      end: dayjs(task.end)
    })).sort((a, b) => a.start.diff(b.start));
    const lanes = [];
    sortedTasks.forEach(task => {
      let laneIndex = -1;
      for (let i = 0; i < lanes.length; i++) {
        if (task.start.isSameOrAfter(lanes[i])) {
          laneIndex = i;
          break;
        }
      }
      if (laneIndex === -1) {
        lanes.push(task.end);
        task.lane = lanes.length - 1;
      } else {
        lanes[laneIndex] = task.end;
        task.lane = laneIndex;
      }
    });
    return {
      ...person,
      tasks: sortedTasks,
      rowHeight: Math.max(1, lanes.length) * 50 // Ensure minimum height of 50px
    };
  });
});

// grid rows: header plus one row per person
const gridTemplateRows = computed(() => {
  const headerRow = 'auto';
  const peopleRows = processedPeople.value.map(p => `${p.rowHeight}px`).join(' ');
  return `${headerRow} ${peopleRows}`;
});

// --- NEW: Computed property to identify non-working days (weekends) ---
const nonWorkingDays = computed(() => {
  const offDays = new Set();
  let current = timelineStart.value.clone();
  while (current.isBefore(timelineEnd.value) || current.isSame(timelineEnd.value, 'day')) {
    const dayOfWeek = current.day();
    if (dayOfWeek === 0 || dayOfWeek === 6) { // Sunday (0) or Saturday (6)
      offDays.add(current.format('YYYY-MM-DD'));
    }
    current = current.add(1, 'day');
  }
  return offDays;
});

// Header row ref and height
const headerRowEl = ref(null);
const headerHeight = ref(50);
onMounted(() => {
  if (headerRowEl.value) {
    headerHeight.value = headerRowEl.value.clientHeight;
  }
});

// Calculate each person's top position
const rowPositions = computed(() => {
  let currentTop = headerHeight.value;  // Start after the header
  return processedPeople.value.map(person => {
    const position = currentTop;
    currentTop += person.rowHeight;
    return position;
  });
});

// Task positioning
const getTaskStyle = (personIndex, task) => {
  const taskStart = dayjs(task.start);
  const taskEnd = dayjs(task.end);
  
  if (viewMode.value === 'day') {
    // Clip start and end times to timeline boundaries
    const effectiveStart = taskStart.isAfter(timelineStart.value) ? taskStart : timelineStart.value;
    const effectiveEnd = taskEnd.isBefore(timelineEnd.value) ? taskEnd : timelineEnd.value;
    
    const startDiffHours = effectiveStart.diff(timelineStart.value, 'hour', true);
    const durationHours = effectiveEnd.diff(effectiveStart, 'hour', true);
    const left = startDiffHours * cellWidth.value + leftColumnWidthPx;
    const width = durationHours * cellWidth.value;
    
    return {
      position: 'absolute',
      top: `${rowPositions.value[personIndex] + (task.lane * 50)}px`,
      left: `${left}px`,
      width: `${width}px`,
      backgroundColor: task.color,
      height: '40px'
    };
  } else {
    // Clip start and end times to timeline boundaries
    const effectiveStart = taskStart.isAfter(timelineStart.value) ? taskStart : timelineStart.value;
    const effectiveEnd = taskEnd.isBefore(timelineEnd.value) ? taskEnd : timelineEnd.value;
    
    const startDiffDays = effectiveStart.diff(timelineStart.value, 'day', true);
    const durationDays = effectiveEnd.diff(effectiveStart, 'day', true);
    const left = startDiffDays * cellWidth.value + leftColumnWidthPx;
    const width = durationDays * cellWidth.value;
    
    return {
      position: 'absolute',
      top: `${rowPositions.value[personIndex] + (task.lane * 50)}px`,
      left: `${left}px`,
      width: `${width}px`,
      backgroundColor: task.color,
      height: '40px'
    };
  }
};

// Helper functions for header styling and formatting
const isOff = (cell) => {
  if (viewMode.value === 'day') {
    const h = cell.hour();
    return h >= 18 || h < 9;
  } else {
    // Mark weekends (and potentially holidays later) as off
    // Use the new computed property
    return nonWorkingDays.value.has(cell.format('YYYY-MM-DD'));
  }
};
const formatTime = (date) => dayjs(date).format('HH:mm');

// Current time indicator
const currentTime = ref(dayjs());
const currentTimePosition = ref(0);
const updateCurrentTimePosition = () => {
  const minutesSinceStart = currentTime.value.diff(timelineStart.value, 'minute');
  const totalMinutes = timelineEnd.value.diff(timelineStart.value, 'minute');
  
  // Prevent division by zero or negative duration if timeline is invalid
  if (totalMinutes <= 0) {
    currentTimePosition.value = leftColumnWidthPx; // Position at the start
    return;
  }

  const totalTimelinePixelWidth = timelineCells.value.length * cellWidth.value;
  const position = (minutesSinceStart / totalMinutes) * totalTimelinePixelWidth;

  // Calculate final position, ensuring it stays within the timeline boundaries
  const finalPosition = leftColumnWidthPx + Math.max(0, Math.min(position, totalTimelinePixelWidth));
  currentTimePosition.value = finalPosition;
};

// Update cell width based on container size
const updateCellWidth = () => {
  if (ganttContainer.value) {
    const containerWidth = ganttContainer.value.clientWidth - leftColumnWidthPx;
    if (viewMode.value === 'day') {
      cellWidth.value = containerWidth / 24;
    } else {
      cellWidth.value = containerWidth / timelineCells.value.length;
    }
  }
};

// Function to move the timeline
const moveTimeline = (direction, amount=1) => {

  let adjustedAmount = amount;

  let unit = viewMode.value;

  if (viewMode.value === 'day') {
    if (amount === 2) adjustedAmount = 24;
    unit = 'hour';
  } else if (viewMode.value === 'week') {
    if (amount === 2) adjustedAmount = 7;
    unit = 'day';
  } else if (viewMode.value === 'month') {
    // this is not correct, need to get the number of days in the month
    if (amount === 2) adjustedAmount = 30;
    unit = 'day';
  }

  // Update timeline start and end based on the new visible time start
  timelineStart.value =  timelineStart.value.add(direction * adjustedAmount, unit);
  timelineEnd.value = timelineEnd.value.add(direction * adjustedAmount, unit);

  // Force update the grid
  nextTick(() => {
    updateCellWidth();
    updateCurrentTimePosition();
  });
};

// Update the watch for viewMode to reset to current period
watch(viewMode, (newMode) => {
  timelineStart.value = dayjs().startOf(newMode);
  timelineEnd.value = dayjs().endOf(newMode);

  nextTick(() => {
    updateCellWidth();
    updateCurrentTimePosition();
  });
});

// Update the jumpToNow function
const jumpToNow = () => {
  timelineStart.value = dayjs().startOf(viewMode.value);
  timelineEnd.value = dayjs().endOf(viewMode.value);
  
  nextTick(() => {
    updateCellWidth();
  });
};

// Debounced update for smoother performance
const debouncedUpdate = (() => {
  let timeout;
  return (fn) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(fn, 16); // ~60fps
  };
})();


// Update onMounted to set initial scroll position
onMounted(() => {
  updateCellWidth();
  updateCurrentTimePosition();
  
  const interval = setInterval(() => {
    currentTime.value = dayjs();
    updateCurrentTimePosition();
  }, 60000);
  
  window.addEventListener('resize', () => {
    debouncedUpdate(updateCellWidth);
  });
  
  nextTick(() => {
    updateCellWidth();
  });
  
  onUnmounted(() => {
    clearInterval(interval);
    window.removeEventListener('resize', updateCellWidth);
  });
});


// Computed property to format the date range
const formattedDateRange = computed(() => {
  if (viewMode.value === 'day') {
    return timelineStart.value.format('dddd, D MMMM');
  } else if (viewMode.value === 'week') {
    const start = timelineStart.value.format('D MMMM');
    const end = timelineEnd.value.format('D MMMM');
    return `${start} - ${end}`;
  } else if (viewMode.value === 'month') {
    if (timelineStart.value.date() === 1) {
      return timelineStart.value.format('MMMM YYYY');
    }
    const start = timelineStart.value.format('D MMMM');
    const end = timelineEnd.value.format('D MMMM');
    return `${start} - ${end}`;
  }
  return '';
});
</script>


<style scoped>
.ganttcontainer {
  width: 100%;
  max-width: 100vw;
  overflow-x: auto;
}
.border-r {
  border-right: 1px solid #e5e7eb;
}
.border-b {
  border-bottom: 1px solid #e5e7eb;
}
.z-\[50\] { z-index: 50; }
.z-\[400\] { z-index: 400; }
.z-\[450\] { z-index: 450; }
.z-\[500\] { z-index: 500; }
.z-\[600\] { z-index: 600; }
</style>