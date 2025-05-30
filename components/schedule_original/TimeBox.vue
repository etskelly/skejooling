<template>
    <div v-show="showMe" @click="showDialog" @mouseover="showDragLines(true)" @mouseout="showDragLines(false)"
        class="overlay z-50 absolute bg-blue-900 border border-blue-400 text-white p-1"
        :style="{ left: left, top: top, height: height, width: width }">
        <div class="resizeLine absolute top-0 w-3 h-full cursor-w-resize" :class="{ 'border-l-4 border-dashed border-white': showLines }"></div>
        <q-icon name="event" color="white"></q-icon>
        {{ dateFrom }} to {{ dateTo }}
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { useElementVisibility } from '@vueuse/core';
import dayjs from 'dayjs';

const props = defineProps(["dateObj", "startOfRange", "endOfRange", "tableRefs", 'dayView']);

const left = ref(null);
const top = ref(null);
const height = ref(null);
const width = ref(null);
const showMe = ref(false);
const dialogVisible = ref(false);
const farleftVal = ref(null);
const farRightVal = ref(null);
const showLines = ref(false);
const containingDiv = ref(null);

const dateFrom = computed(() => {
    return dayjs(props.dateObj.from).format("MMMM DD YYYY HH:mm");
});

const dateTo = computed(() => {
    return dayjs(props.dateObj.to).format("MMMM DD YYYY HH:mm");
});

const showDragLines = (showThem) => {
    showLines.value = showThem;
};

const farLeftPos = () => {
    return containingDiv.value.getBoundingClientRect().x;
};

const farRightPos = () => {
    return containingDiv.value.getBoundingClientRect().right;
};

const showDialog = () => {
    dialogVisible.value = true;
};

const adjustLeftForTime = (startCell, disabled = false) => {
    var boundingBox = startCell.getBoundingClientRect();

    if (disabled) return boundingBox.x;

    var leftValTemp = boundingBox.x;
    var tempWidth = boundingBox.width;

    var startDate = dayjs(props.dateObj.from);

    var timeMillis = 86400000; //Day

    var startOfTime = startDate.startOf("day");

    if (props.dayView) {
        timeMillis = 3600000; //Hour
        startOfTime = startDate.startOf("hour");
    }

    var startTime = startOfTime.toDate().getTime();
    var endTime = props.dateObj.from.getTime();
    var elapsedMillis = endTime - startTime;

    var portionOfTime = elapsedMillis / timeMillis;

    leftValTemp = tempWidth * portionOfTime + leftValTemp;

    return Math.round(leftValTemp);
};

const adjustRightForTime = (endCell, disabled) => {
    var boundingBox = endCell.getBoundingClientRect();

    if (disabled) right.value = boundingBox.right;

    var timeMillis = 86400000;
    var endDate = dayjs(props.dateObj.to);

    var endOfTimeSlot = endDate.endOf("day");

    if (props.dayView) {
        timeMillis = 3600000; //Hour
        endOfTimeSlot = endDate.endOf("hour");
    }

    var endOfTime = endOfTimeSlot.toDate().getTime();
    var endTime = props.dateObj.to.getTime();

    var elapsedMillis = endOfTime - endTime;

    var tempWidth = boundingBox.width;

    var portionOfTime = elapsedMillis / timeMillis;

    var widthToAdd = tempWidth - tempWidth * portionOfTime;

    right.value = boundingBox.x + widthToAdd;
};

const setPos = () => {
    var startCellRef = dayjs(props.dateObj.from).format("L");

    if (props.dayView) {
        if (dayjs().isSame(props.dateObj.from, 'day')) {
            startCellRef = props.dateObj.idx + "_h_" + (+dayjs(props.dateObj.from).format("H") + 1);
        } else {
            startCellRef = props.dateObj.idx + "_h_" + (1);
        }
    }

    var startCellParentRef = props.tableRefs[startCellRef];

    var startCell;

    if (startCellParentRef) {
        startCell = startCellParentRef[0];
    }

    var endCell = null;
    var endCellRef = dayjs(props.dateObj.to).format("L");

    if (props.dayView) {
        endCellRef = props.dateObj.idx + "_h_" + (+dayjs(props.dateObj.to).format("H") + 1);
    }

    var endCellParentRef = props.tableRefs[endCellRef];

    farRightVal.value = farRightPos();
    farleftVal.value = farLeftPos();

    if (endCellParentRef) {
        endCell = endCellParentRef[0];
        if (endCell) {
            adjustRightForTime(endCell);

            if (farRightVal.value && (farRightVal.value < right.value || right.value < 0)) {
                right.value = farRightVal.value;
            }

        } else {
            if (farRightVal.value) right.value = farRightVal.value;
        }
    } else {
        if (farRightVal.value) right.value = farRightVal.value;
    }

    var leftVal = null;

    const endCellIsVisible = useElementVisibility(endCell);
    const startCellIsVisible = useElementVisibility(startCell);

    if (startCell) {
        leftVal = adjustLeftForTime(startCell);
        if (farleftVal.value && leftVal < farleftVal.value) {
            leftVal = farleftVal.value;
        }

        var boundingBox = startCell.getBoundingClientRect();

        var topVal = startCell.offsetTop + 16;
        left.value = leftVal + "px";
        top.value = topVal + "px";
        height.value = boundingBox.height + "px";
        width.value = right.value - leftVal + "px";
    }
    if (!startCellIsVisible.value && !endCellIsVisible.value) {
        showMe.value = false;
        return;
    }
    showMe.value = true;
};

onMounted(() => {
    containingDiv.value = document.getElementsByClassName("q-markup-table")[0];

    nextTick(() => {
        setPos();
    });

    const moveOverlaysHandler = () => {
        nextTick(() => {
            setPos();
        });
    };

    window.addEventListener("moveOverlays", moveOverlaysHandler);

    onBeforeUnmount(() => {
        window.removeEventListener("moveOverlays", moveOverlaysHandler);
    });
});
</script>

<style lang="scss" scoped>
.overlay {
    background-color: #084c61;
    border: 1px solid #56a3a6;
    height: 50px;
    color: white;
    position: absolute;
    padding: 0.25em;
}

.resizeLine {
    cursor: w-resize;
    position: absolute;
    top: 0;
    width: 12px;
    height: 100%;
}

.showLines {
    border-left: thick dashed white;
}

.start {}

.end {}
</style>
