<template>
    <div class="grid-scroller">
        <div class="grid" :style="{ gridTemplateColumns: '200px repeat(' + 7 + ', 1fr)' }">
            <div class="grid-header fixed-left">Name</div>
            <div v-for="n, idx in datesOfWeek" class="grid-header"> {{ n.format('ddd Do') }}</div>

            <template v-for="row, x in scheduleRows">

                <div :class="x % 2 == 0 ? 'striped' : ''" class="grid-entry fixed-left">{{ row.name }}</div>

                <div :style="{ gridColumn: 'span ' + datesOfWeek.length }" :class="x % 2 == 0 ? 'striped' : ''" class="back">
                    <ul class="scheduler__row-bars"
                        :style="{ gridTemplateColumns: 'repeat(' + datesOfWeek.length + ', 1fr)' }">
                        <template v-for="slot in filterSlots(row.slots)">
                            <li
                                :style="calculateColumnStartAndEnd(slot) + ` background-color: ${slot.color}; margin-left: ${adjustLeftForTimeOfDay(slot)}; margin-right: ${adjustRightForTimeOfDay(slot)}`">
                                {{ slot.text }} {{ calculateColumnStartAndEnd(slot) }} {{ slot.start }} {{ slot.end }}
                            </li>
                        </template>
                    </ul>
                </div>

            </template>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import dayjs from 'dayjs';

import advancedFormat from 'dayjs/plugin/advancedFormat'
import isBetween from 'dayjs/plugin/isBetween'
dayjs.extend(advancedFormat)
dayjs.extend(isBetween)

const startOfMonth = dayjs().startOf("month")
const startOfWeek = dayjs().startOf("week")
const endOfMonth = dayjs().endOf("month")
const endOfWeek = dayjs().endOf("week")
const monthName = dayjs().format("MMMM")

// These can become the same, we don't care which is which, we just want the dates
const datesOfWeek = ref([])
const datesOfMonth = ref([])

setDaysOfWeek();

function setDaysOfWeek() {
    var day = startOfWeek;
    while (day <= endOfWeek) {
        datesOfWeek.value.push(day);
        day = day.clone().add(1, "d");
    }
}

function adjustRightForTimeOfDay(slot) {
    // TODO not working correctly for all
    var start = slot.start;
    var end = slot.end;

    var dayInMilliseconds = 1000 * 60 * 60 * 24;
    // var timeOfDayInMilliseconds = dayjs(end).diff(dayjs(end).endOf('day'), 'millisecond');
    var timeOfDayInMilliseconds = dayjs(end).endOf('day').diff(dayjs(end), 'millisecond');

    var percentageOfDay = (timeOfDayInMilliseconds / dayInMilliseconds) * 100;

    var percentageOfDay = 100 - percentageOfDay; //Need the inverse

    var noOfDays = dayjs(end).diff(dayjs(start), 'day');

    if (noOfDays < 1) {
        noOfDays = 1;
    }

    var right = (percentageOfDay / (noOfDays));

    // Has to be negative to add on the right
    return `-${right}%`;
}

function adjustLeftForTimeOfDay(slot) {
    var start = slot.start;
    var end = slot.end;

    var dayInMilliseconds = 1000 * 60 * 60 * 24;

    var timeOfDayInMilliseconds = dayjs(start).diff(dayjs(start).startOf('day'), 'millisecond');

    var percentageOfDay = (timeOfDayInMilliseconds / dayInMilliseconds) * 100;

    var noOfDays = dayjs(end).diff(dayjs(start), 'day');

    var left = percentageOfDay / (noOfDays + 1);

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
    var startColumn = datesOfWeek.value.findIndex(d => d.isSame(start, 'day'));
    var endColumn = datesOfWeek.value.findIndex(d => d.isSame(end, 'day'));

    if (startColumn == -1) {
        startColumn = 1;
    } else {
        startColumn += 1;
    }

    if (endColumn == -1) {
        endColumn = 8;
    } else {
        endColumn += 1;
    }

    // debugger

    // Max should be 8, so if it's above 8, set it to 8
    return `grid-column: ${startColumn}/${endColumn};`
}

const scheduleRows = ref([
    {
        name: "Eamon Skelly",
        slots: [
            // { start: new Date(2023, 9, 30, 18, 0), end: new Date(2023, 9, 31, 6), text: "hello", color: "red" },
            // { start: new Date(2023, 10, 1, 18, 0), end: new Date(2023, 10, 3, 12), text: "hello", color: "red" },

            { start: new Date(2023, 10, 1, 6, 0), end: new Date(2023, 10, 4, 12, 0), text: "Blue:", color: "blue" },
            { start: new Date(2023, 9, 3, 18), end: new Date(2023, 9, 5), text: "should not show", color: "purple" },
            { start: new Date(2023, 9, 30, 18, 0), end: new Date(2023, 9, 31, 6), text: "hello", color: "red" },
            { start: new Date(2023, 10, 1, 18, 0), end: new Date(2023, 10, 3, 12), text: "hello", color: "red" },


            // { start: 9, end: 19, text: "hello", color: "gray" },
            // { start: 12, end: 17, text: "bye", color: "blue" },
            // { start: 1, end: 19, text: "hello", color: "red" },
            // { start: 15, end: 18, text: "bye", color: "green" },
            // { start: 4, end: 10, text: "hello", color: "purple" },
            // { start: 15, end: 17, text: "bye", color: "blue" },
        ]
    },
    // {
    //     name: "Eimear Skelly",
    //     slots: [
    //         { start: new Date(2023, 10, 2, 0, 0), end: new Date(2023, 10, 4, 18, 0), text: "Added Time", color: "magenta" },
    //         { start: new Date(2023, 10, 3, 0, 0), end: new Date(2023, 10, 4, 0, 0), text: "bad", color: "black" },
    //     ]
    // },
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

</script>
<style>
body {
    margin: 0;
}

.grid-scroller {
    overflow: scroll;
    height: 100vh;
}

.back {
    /* TODO part of this will have to be in vue (size) */
    background: linear-gradient(90deg, gray 1px, transparent 1px);
    background-size: calc(100%/7) 100%;
}

.grid {
    display: grid;
    border-radius: 12px;
    /* grid-template-columns: 200px repeat(7, 1fr); */
    box-sizing: border-box;
    box-shadow: 0 75px 125px -57px #7e8f94;
    width: 2000px;
}

.grid-entry,
.grid-header {
    padding: 7px;
    background-color: white;
    border-right: 1px solid gray;
    border-bottom: 1px solid gray;
}

.grid-entry.last,
.grid-header.last {
    border-right: none;
}

.grid-header {
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

