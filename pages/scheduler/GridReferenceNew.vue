<template>
    <div>
      
        <div class="grid-scroller">
            <!-- Perhaps first column should be min-width or a percentage -->
            <div ref="schedulegrid" class="grid" :style="{ gridTemplateColumns: '200px repeat(' + timePeriodValues.length + ', 1fr)' }">
                <div class="vl" :style="{left: calculateVerticalLinePosition}"></div>
                <!-- <div class="vl" style="left: calc(200px + 50%)"></div> -->
                <div class="grid-header fixed-left text-black">Name</div>
                <div v-for="n, idx in timePeriodValues" class="grid-header text-black"> {{ n.format(timePeriodFormat) }}</div>

                <template v-for="row, x in scheduleRows">

                    <div :class="x % 2 == 0 ? 'striped' : ''" class="grid-entry fixed-left text-black">{{ row.name }}</div>

                    <div :style="{ gridColumn: 'span ' + timePeriodValues.length, backgroundSize: 'calc((100%) / ' + (timePeriodValues.length) + ')' }"
                        :class="x % 2 == 0 ? 'striped' : ''" class="back">
                        <ul class="scheduler__row-bars"
                            :style="{ gridTemplateColumns: 'repeat(' + timePeriodValues.length + ', 1fr)' }">
                            <template v-for="slot in filterSlots(row.slots)">
                                <li
                                    :style="calculateColumnStartAndEnd(slot) + ` background-color: ${slot.color}; margin-left: ${adjustLeftForTimePart(slot)}; margin-right: ${adjustRightForTimePart(slot)}`">
                                    {{ slot.text }} {{ calculateColumnStartAndEnd(slot) }} {{ slot.start }} {{ slot.end }}
                                </li>
                            </template>
                        </ul>
                    </div>

                </template>
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';

const schedulegrid = ref(null)

const dayjs = useDayjs()

import advancedFormat from 'dayjs/plugin/advancedFormat'
import isBetween from 'dayjs/plugin/isBetween'
dayjs.extend(advancedFormat)
dayjs.extend(isBetween)

const startOfMonth = dayjs().startOf("month")
const startOfWeek = dayjs().startOf("week")
const endOfMonth = dayjs().endOf("month")
const endOfWeek = dayjs().endOf("week")

const startOfDay = dayjs().startOf("day")
const endOfDay = dayjs().endOf("day")

const monthName = dayjs().format("MMMM")

const props = defineProps({
    viewMode: {
        type: String,
        required: true
    }
});

watch(() => props.viewMode, () => {
    processRows();
});

const timePeriodValues = computed(() => {
    var periods = [];
    if (props.viewMode == 'month') {
        var day = startOfMonth;
        while (day <= endOfMonth) {
            periods.push(day);
            day = day.clone().add(1, "d");
        }
    } else if (props.viewMode == 'week') {
        var day = startOfWeek;
        while (day <= endOfWeek) {
            periods.push(day);
            day = day.clone().add(1, "d");
        }
    } else {
        var hour = dayjs().startOf('day');
        while (hour <= dayjs().endOf('day')) {
            periods.push(hour);
            hour = hour.clone().add(1, "h");
        }
    }
    return periods;
})

const timePeriodFormat = computed(() => {
    if (props.viewMode == 'month') {
        return 'ddd Do'
    } else if (props.viewMode == 'week') {
        return 'ddd Do'
    } else {
        return 'h A'
    }
})

function getStartOfTimePeriod() {
    if (props.viewMode == 'month') {
        return startOfMonth;
    } else if (props.viewMode == 'week') {
        return startOfWeek;
    } else {
        return dayjs().startOf('day');
    }
}


const calculateVerticalLinePosition = computed(() => {
    if (!schedulegrid.value) {
        return;
    }

    var splitNumber;

    if (props.viewMode == 'day') {
        splitNumber = 24;
    } else if (props.viewMode == 'week') {
        splitNumber = 7;
    } else {
        splitNumber = dayjs().daysInMonth();
    }

    // TODO this is still rough and ready, needs to be adjusted for the view mode, number of days/hours etc
    //Works for month and week only so far

    const gridWidth = schedulegrid.value.clientWidth

    const gridWidthAdjusted = (gridWidth - 200);

    // TODO this will need to be adjusted for the view mode and number of days/hours
    let timeUnits = dayjs().diff(getStartOfTimePeriod(), 'day')

    if (props.viewMode == 'day') {
        timeUnits = dayjs().diff(getStartOfTimePeriod(), 'hour')
    }

    const cellWidth = gridWidthAdjusted / splitNumber;
    let pos = cellWidth * timeUnits;

    let timeAdjustment;

    if (props.viewMode == 'day') {
        var hourInMilliseconds = 1000 * 60 * 60;
        var partOfHourInMilliseconds = dayjs().diff(dayjs().startOf('hour'), 'millisecond');

        var percentageOfHour = (partOfHourInMilliseconds / hourInMilliseconds) * 100;

        timeAdjustment = (cellWidth / 100) * percentageOfHour;
    } else {
        var dayInMilliseconds = 1000 * 60 * 60 * 24;
        var timeOfDayInMilliseconds = dayjs().diff(dayjs().startOf('day'), 'millisecond');
        var percentageOfDay = (timeOfDayInMilliseconds / dayInMilliseconds) * 100;
        timeAdjustment = (cellWidth / 100) * percentageOfDay;
    }

    pos = pos + timeAdjustment;

    return `calc(200px + ${pos}px)`;

})


function adjustRightForTimePart(slot) {
    var start = slot.start;
    var end = slot.end;

    var right = 0;

    if (props.viewMode == 'day') {
        var hourInMilliseconds = 1000 * 60 * 60;
        var partOfHourInMilliseconds = dayjs(end).endOf('hour').diff(dayjs(end), 'millisecond');

        var percentageOfHour = (partOfHourInMilliseconds / hourInMilliseconds) * 100;

        var noOfHours = dayjs(end).diff(dayjs(start), 'hour');

        if (dayjs(start).isBefore(getStartOfTimePeriod())) {
            noOfHours = dayjs(getStartOfTimePeriod()).diff(dayjs(start), 'hour');
        }

        if (noOfHours < 1) {
            noOfHours = 1;
        }

        // TODO should it be percentage of width of column?
        right = (100 - percentageOfHour.toFixed(2)) / noOfHours;
    } else {
        var dayInMilliseconds = 1000 * 60 * 60 * 24;
        var timeOfDayInMilliseconds = dayjs(end).endOf('day').diff(dayjs(end), 'millisecond');

        var percentageOfDay = (timeOfDayInMilliseconds / dayInMilliseconds) * 100;

        var noOfDays = dayjs(end).diff(dayjs(start), 'day');

        if (dayjs(start).isBefore(getStartOfTimePeriod())) {
            noOfDays = dayjs(getStartOfTimePeriod()).diff(dayjs(start), 'day');
        }

        if (noOfDays < 1) {
            noOfDays = 1;
        }

        right = (percentageOfDay.toFixed(2)) / noOfDays;
    }

    if (dayjs(end).isBefore(getStartOfTimePeriod())) {
        right = 0;
    }

    // NOTE it needs to push into the hour, but for others is should be taken from the end
    return `-${right}%`;
}

function adjustLeftForTimePart(slot) {
    var start = slot.start;
    var end = slot.end;

    var left = 0;

    if (props.viewMode == 'day') {
        var hourInMilliseconds = 1000 * 60 * 60;

        var partOfHourInMilliseconds = dayjs(start).diff(dayjs(start).startOf('hour'), 'millisecond');

        var percentageOfHour = (partOfHourInMilliseconds / hourInMilliseconds) * 100;

        // TODO incorrectly named
        var noOfHours = dayjs(end).diff(dayjs(start), 'hour');

        left = percentageOfHour / (noOfHours + 1);
    } else {
        var dayInMilliseconds = 1000 * 60 * 60 * 24;

        var timeOfDayInMilliseconds = dayjs(start).diff(dayjs(start).startOf('day'), 'millisecond');

        var percentageOfDay = (timeOfDayInMilliseconds / dayInMilliseconds) * 100;

        var noOfDays = dayjs(end).diff(dayjs(start), 'day');

        left = percentageOfDay / (noOfDays + 1);
    }

    if (dayjs(start).isBefore(getStartOfTimePeriod())) {
        left = 0;
    }
    return `${left}%`;
}

function filterSlots(slots) {
    return slots.filter(slot => {
        return dayjs(slot.start).isBetween(startOfWeek, endOfWeek) || dayjs(slot.end).isBetween(startOfWeek, endOfWeek)
    });
}

function calculateColumnStartAndEnd(slot) {
    var start = slot.start;
    var end = slot.end;

    //    TODO if not a day, we will need to change isSame to hour month etc
    var startColumn = timePeriodValues.value.findIndex(d => d.isSame(start, 'day'));
    var endColumn = timePeriodValues.value.findIndex(d => d.isSame(end, 'day'));
    if (props.viewMode == 'day') {
        // Days will need better logic to cover multiple days
        if (dayjs(start).isBefore(startOfDay)) {
            startColumn = 1;
        } else {
            startColumn = timePeriodValues.value.findIndex(d => d.isSame(start, 'hour')) + 1;
        }
        if (dayjs(end).isAfter(endOfDay)) {
            endColumn = 25;
        } else {
            endColumn = timePeriodValues.value.findIndex(d => d.isSame(end, 'hour'));
        }
    } else if (props.viewMode == 'month') {
        if (dayjs(start).isBefore(startOfMonth)) {
            startColumn = 1;
        } else {
            startColumn = timePeriodValues.value.findIndex(d => d.isSame(start, 'day')) + 1;
        }
        if (dayjs(end).isAfter(endOfMonth)) {
            endColumn = dayjs(endOfMonth).diff(startOfMonth, 'day');
        } else {
            endColumn = timePeriodValues.value.findIndex(d => d.isSame(end, 'day'));
        }
    } else if (props.viewMode == 'week') {
        if (dayjs(start).isBefore(startOfWeek)) {
            startColumn = 1;
        } else {
            startColumn = timePeriodValues.value.findIndex(d => d.isSame(start, 'day')) + 1;
        }
        if (dayjs(end).isAfter(endOfWeek)) {
            endColumn = dayjs(endOfWeek).diff(startOfWeek, 'day');
        } else {
            endColumn = timePeriodValues.value.findIndex(d => d.isSame(end, 'day'));
        }
    }

    // 0 is the name column
    if (startColumn == -1) {
        startColumn = 1;
    } else {
        // startColumn += 1;
    }

    if (endColumn == -1) {
        endColumn = 8;
    } else {
        endColumn += 1;
    }

    // Max should be 8, so if it's above 8, set it to 8
    return `grid-column-start: ${startColumn}; grid-column-end: ${endColumn};`
}

const rows = ref([]);

// Months are zero based
const scheduleRows = ref([
    {
        name: "Eamon Skelly",
        slots: [
            // { start: new Date(2023, 9, 30, 18, 0), end: new Date(2023, 9, 31, 6), text: "hello", color: "red" },
            // { start: new Date(2023, 10, 1, 18, 0), end: new Date(2023, 10, 3, 12), text: "hello", color: "red" },

            { start: new Date(2025, 0, 9, 6, 0), end: new Date(2025, 0, 13, 12, 0), text: "Blue:", color: "blue" },
            { start: new Date(2024, 2, 26, 1, 30), end: new Date(2024, 3, 7, 21, 30), text: "Show", color: "purple" },
            { start: new Date(2024, 3, 9, 10, 30), end: new Date(2024, 3, 10, 21, 45), text: "XYZ", color: "red" },


            // { start: new Date(2023, 10, 1, 18, 0), end: new Date(2023, 10, 3, 12), text: "hello", color: "red" },

            // { start: 9, end: 19, text: "hello", color: "gray" },
            // { start: 12, end: 17, text: "bye", color: "blue" },
            // { start: 1, end: 19, text: "hello", color: "red" },
            // { start: 15, end: 18, text: "bye", color: "green" },
            // { start: 4, end: 10, text: "hello", color: "purple" },
            // { start: 15, end: 17, text: "bye", color: "blue" },
        ]
    },
    {
        name: "Eimear Skelly",
        slots: [
            { start: new Date(2025, 0, 13, 4, 0), end: new Date(2025, 0, 10, 18, 0), text: "Added Time", color: "magenta" },
            { start: new Date(2025, 0, 12, 16, 0), end: new Date(2025, 0, 10, 8, 30), text: "bad", color: "black" },
            { start: new Date(2025, 0, 12, 16, 0), end: new Date(2025, 0, 10, 8, 30), text: "bad", color: "green" },
        ]
    },
]);

// TODO Note - any ENDs exceeding the no of columns will distort the following slots withing a row
// const scheduleRows = ref([
//     {
//         name: "Eamon Skelly",
//         slots: [
//             { start: 1, end: 6, text: "hello", color: "red" },
//             { start: 3, end: 7, text: "bye", color: "blue" },
//             { start: 1, end: 3, text: "hello", color: "gray" },
//             { start: 3, end: 5, text: "bye", color: "blue" },
//             { start: 1, end: 2, text: "hello", color: "red" },
//             { start: 5, end: 7, text: "bye", color: "green" },
//             { start: 4, end: 5, text: "hello", color: "purple"},
//             { start: 2, end: 5, text: "bye", color: "blue" },
//         ]
//     },
//     {
//         name: "Eimear Skelly", slots: [
//             { start: 1, end: 3, text: "good", color: "green" },
//             { start: 4, end: 7, text: "bad", color: "black" },
//         ]
//     },
//     {
//         name: "Eamon Skelly",
//         slots: [
//             { start: 2, end: 5, text: "hello", color: "red" },
//             { start: 6, end: 7, text: "bye", color: "purple" },
//         ]
//     }
// ]);

processRows();

function processRows() {
    // TODO this is only needed for days, as others will be filtered out automatically
    scheduleRows.value.forEach(row => {
        row.slots = row.slots.filter(slot => {
            if (props.viewMode == 'month') {
                return true;
                // return dayjs(slot.start).isBetween(startOfMonth, endOfMonth) || dayjs(slot.end).isBetween(startOfMonth, endOfMonth)
            } else if (props.viewMode == 'week') {
                return true;
                // return dayjs(slot.start).isBetween(startOfWeek, endOfWeek) || dayjs(slot.end).isBetween(startOfWeek, endOfWeek)
            } else {
                return dayjs(slot.start).isBetween(startOfDay, endOfDay) || dayjs(slot.end).isBetween(startOfDay, endOfDay) || (dayjs(slot.start).isBefore(startOfDay) && dayjs(slot.end).isAfter(endOfDay))
            }
        });
    });

    scheduleRows.value = scheduleRows.value.filter(row => {
        return row.slots.length > 0;
    });
}

// getEvents();

// function getEvents() {
//     axios
//         .get("/events")
//         .then(resp => {
//            scheduleRows.value = resp.data;
//         })
//         .catch(function (error) {
//             debugger
//             console.log(error);
//         });

// }

</script>
<style scoped>
.grid-scroller {
    overflow: scroll;
    height: 100vh;
}

.back {
    /* TODO part of this will have to be in vue (size) */
    background: linear-gradient(90deg, gray 1px, transparent 1px);
    /* background-size: calc(100%/7) 100%; */
    border-bottom: 1px solid gray;
}

.grid {
    display: grid;
    border-radius: 12px;
    box-sizing: border-box;
    box-shadow: 0 75px 125px -57px #7e8f94;
    margin: 10px;
    width: 95%;
    position: relative;/* Needs this for the vl absolute to work within */
}

.vl {
  border-left: 2px dashed red;
  height:100%;
  position: absolute;
  opacity: 0.5;
  z-index: 999;
  top: 0;
}

.grid-entry,
.grid-header {
    background-color: white;
    border-bottom: 1px solid gray;
    text-align: center;
}

.grid-entry.last,
.grid-header.last {
    border-right: none;
}

.grid-header {
    /* font-size: calc(0.5vw + 0.5vh); */
    /* Without overflow, affects size and therefore position */
    overflow-x: hidden;
    box-sizing: border-box !important;
    border-right: 1px solid darkgray !important;
    color: #fff;
    background-color: #0a3444;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    font-weight: bold;
    position: sticky;
    top: 0;
    z-index: 2;
}

.grid-header div {
    text-align: center;
    font-size: 13px;
    align-self: center;
    font-weight: bold;
    padding: 20px 0;
}

.grid-header.fixed-left {
    z-index: 3;
}

.fixed-left {
    position: sticky;
    left: 0;
    z-index: 2;
}

/* .fixed-right {
    border-left: 1px solid gray;
    border-right: none;
    position: sticky;
    right: 0;
}

.fixed-right2 {
    border-left: 1px solid gray;
    border-right: none;
    position: sticky;
    right: 200px;
} */

.placeholder {
    grid-column-start: 1;
    grid-column-end: 21;
    border-right: none;
}

.striped {
    background-color: #f2f2f2;
}


/* Rename these if they work */
.scheduler__row-bars {
    list-style: none;
    display: grid;
    padding: 2px 0;
    margin: 0;
    grid-gap: 8px 0;
    border-top: 1px solid rgba(221, 221, 221, 0.8);
}

.scheduler__row-bars li {
    font-weight: 500;
    text-align: left;
    font-size: 14px;
    min-height: 15px;
    background-color: #55de84;
    padding: 5px 12px;
    color: #fff;
    overflow: hidden;
    position: relative;
    cursor: pointer;
    border-radius: 10px;
}

.scheduler__row-bars li.stripes {
    background-image: repeating-linear-gradient(45deg, transparent, transparent 5px, rgba(255, 255, 255, 0.1) 5px, rgba(255, 255, 255, 0.1) 12px);
}

.scheduler__row-bars li:before,
.scheduler__row-bars li:after {
    content: "";
    height: 100%;
    top: 0;
    z-index: 4;
    position: absolute;
    background-color: rgba(0, 0, 0, 0.3);
}

.scheduler__row-bars li:before {
    left: 0;
}

.scheduler__row-bars li:after {
    right: 0;
}
</style>
