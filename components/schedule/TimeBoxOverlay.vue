<template>
    <div v-show="showMe" @click="showDialog" @mouseover="showDragLines(true)" @mouseout="showDragLines(false)"
        class="overlay" style="z-index: 999" :style="{ left: left, top: top, height: height, width: width }">
        <div class="resizeLine" :class="{ showLines: showLines }"></div>
        <q-icon name="event" color="white"></q-icon>
        {{ dateFrom }} to {{ dateTo }}
    </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { useElementVisibility } from '@vueuse/core'
import dayjs from 'dayjs'

import localizedFormat from 'dayjs/plugin/localizedFormat'
dayjs.extend(localizedFormat);

const { $on } = useNuxtApp()

// const bus = useEventBus()

const props = defineProps({
    dateObj: Object,
    startOfRange: null,
    endOfRange: null,
    tableRefs: Object,
    dayView: Boolean
})

// refs
const left = ref(null)
const top = ref(null)
const height = ref(null)
const width = ref(null)
const showMe = ref(false)
const dialogVisible = ref(false)
const farLeftVal = ref(null)
const farRightVal = ref(null)
const showLines = ref(false)
const containingDiv = ref(null)
const right = ref(null)

// computed
const dateFrom = computed(() => {
    return dayjs(props.dateObj.from).format("MMMM DD YYYY HH:mm")
})

const dateTo = computed(() => {
    return dayjs(props.dateObj.to).format("MMMM DD YYYY HH:mm")
})

// methods
const showDragLines = (showThem) => {
    showLines.value = showThem
}

const farLeftPos = () => {
    return containingDiv.value.getBoundingClientRect().x
}

const farRightPos = () => {
    return containingDiv.value.getBoundingClientRect().right
}

const showDialog = () => {
    dialogVisible.value = true
}

const adjustLeftForTime = (startCell, disabled = false) => {
    const boundingBox = startCell.getBoundingClientRect()
    if (disabled) return boundingBox.x

    let leftValTemp = boundingBox.x
    const tempWidth = boundingBox.width
    const startDate = dayjs(props.dateObj.from)
    let timeMillis = 86400000 //Day
    let startOfTime = startDate.startOf("day")

    if (props.dayView) {
        timeMillis = 3600000 //Hour
        startOfTime = startDate.startOf("hour")
    }

    const startTime = startOfTime.toDate().getTime()
    const endTime = props.dateObj.from.getTime()
    const elapsedMillis = endTime - startTime
    const portionOfTime = elapsedMillis / timeMillis
    leftValTemp = tempWidth * portionOfTime + leftValTemp

    return Math.round(leftValTemp)
}

const adjustRightForTime = (endCell, disabled) => {
    const boundingBox = endCell.getBoundingClientRect()
    if (disabled) right.value = boundingBox.right

    let timeMillis = 86400000
    const endDate = dayjs(props.dateObj.to)
    let endOfTimeSlot = endDate.endOf("day")

    if (props.dayView) {
        timeMillis = 3600000
        endOfTimeSlot = endDate.endOf("hour")
    }

    const endOfTime = endOfTimeSlot.toDate().getTime()
    const endTime = props.dateObj.to.getTime()
    const elapsedMillis = endOfTime - endTime
    const tempWidth = boundingBox.width
    const portionOfTime = elapsedMillis / timeMillis
    const widthToAdd = tempWidth - tempWidth * portionOfTime

    right.value = boundingBox.x + widthToAdd
}

const setPos = () => {
    let startCellRef = dayjs(props.dateObj.from).format("L")

    if (props.dayView) {
        if (dayjs().isSame(props.dateObj.from, 'day')) {
            startCellRef = props.dateObj.idx + "_h_" + (+dayjs(props.dateObj.from).format("H") + 1)
        } else {
            startCellRef = props.dateObj.idx + "_h_" + (1)
        }
    }

    // Props.tableRefs is a reference to the table cells, but is not yet passed in
    const startCell = props.tableRefs.find((ref) => {
        return ref.id === startCellRef
    })

    // const startCellParentRef = props.tableRefs[startCellRef]
    // debugger
    // let startCell = startCellParentRef?.[0]
    
    let endCellRef = dayjs(props.dateObj.to).format("L")
    if (props.dayView) {
        endCellRef = props.dateObj.idx + "_h_" + (+dayjs(props.dateObj.to).format("H") + 1)
    }

    const endCell = props.tableRefs.find((ref) => {
        return ref.id === endCellRef
    })
    // const endCellParentRef = props.tableRefs[endCellRef]
    // let endCell = null

    farRightVal.value = farRightPos()
    farLeftVal.value = farLeftPos()

    // if (endCellParentRef) {
    //     endCell = endCellParentRef[0]
        if (endCell) {
            adjustRightForTime(endCell)
            if (farRightVal.value && (farRightVal.value < right.value || right.value < 0)) {
                right.value = farRightVal.value
            }
        } else {
            if (farRightVal.value) right.value = farRightVal.value
        }
    // } else {
    //     if (farRightVal.value) right.value = farRightVal.value
    // }

    const endCellIsVisible = useElementVisibility(endCell)
    const startCellIsVisible = useElementVisibility(startCell)

    if (startCell) {
        let leftVal = adjustLeftForTime(startCell)
        if (farLeftVal.value && leftVal < farLeftVal.value) {
            leftVal = farLeftVal.value
        }

        const boundingBox = startCell.getBoundingClientRect()
        const topVal = startCell.offsetTop + 16

        left.value = leftVal + "px"
        top.value = topVal + "px"
        height.value = boundingBox.height + "px"
        width.value = right.value - leftVal + "px"
    }

    showMe.value = startCellIsVisible.value || endCellIsVisible.value
}

// lifecycle hooks
onMounted(() => {
    containingDiv.value = document.getElementsByClassName("containingDiv")[0]
    nextTick(() => {
        setPos()
    })
})


// bus.on("moveOverlays")
$on("moveOverlays", () => {
    nextTick(() => {
        setPos()
    })
})

</script>

<style scoped>
/* Styles remain the same */
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
</style>
