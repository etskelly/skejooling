<template>
    <div class="min-h-[400px] bg-white">
        <div class="p-4 shadow-md rounded-md">
            <div class="flex justify-between items-center">
                <div>
                    <!-- TODO on toggle have to recalculate and redo -->
                    <ToggleButton v-model="viewType" @change="changeViewType" :options="[
                        { label: 'Week', value: 'week' },
                        { label: 'Month', value: 'month' }
                    ]" />
                </div>
                <div class="flex space-x-2">
                    <Button @click="back()" icon="pi pi-step-backward" class="p-button-primary"></Button>
                    <Button @click="backADay()" icon="pi pi-chevron-left" class="p-button-primary"></Button>
                    <Button @click="current()" icon="pi pi-plus-circle" class="p-button-primary"></Button>
                    <Button @click="forwardADay()" icon="pi pi-chevron-right" class="p-button-primary"></Button>
                    <Button @click="forward()" icon="pi pi-step-forward" class="p-button-primary"></Button>
                </div>
            </div>

            <div class="mt-4">
                <table class="w-full border-collapse">
                    <thead>
                        <tr>
                            <th class="font-bold w-1/10">Person</th>
                            <th class="font-bold w-1/10">Location</th>
                            <th :colspan="datesOfPeriod.length" class="font-bold text-center">{{ monthName }}</th>
                        </tr>
                        <tr>
                            <th colspan="2">&nbsp;</th>
                            <th v-for="(d, idx) in datesOfPeriod" :key="idx" class="w-1/28 text-center">
                                {{ d.format('Do MMM') }}
                            </th>
                        </tr>
                    </thead>
                    <tbody ref="tbody">
                        <tr>
                            <th scope="row">Orla</th>
                            <th scope="row">Home</th>
                            <td v-for="(d, idx) in datesOfPeriod" :key="idx" :ref="d.format('L')" class="text-center">
                                {{ d.format('L') }}
                            </td>
                        </tr>
                    </tbody>
                </table>

                <TimeBoxOverlay v-for="(dateObj, idx) in datesForOverlay" :key="idx"
                    :startOfRange="startOfPeriodRange.toDate()" :endOfRange="endOfPeriodRange.toDate()" :dateObj="dateObj"
                    :tableRefs="$refs">
                </TimeBoxOverlay>
            </div>

            <div class="mt-4">
                <pre>StartOfRange: {{ startOfPeriodRange }}</pre>
                <pre>EndOfRange: {{ endOfPeriodRange }}</pre>
                <pre>Dates:{{ datesForOverlay }}</pre>
                <!-- <AddTimeData :date-objs="dateRangesToTest"></AddTimeData> -->
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed, nextTick } from 'vue';
import { useDebounceFn } from '@vueuse/core';
import TimeBoxOverlay from '@/components/schedule/TimeBoxOverlay.vue';
// import { Button, ToggleButton } from 'primevue/button';

const viewType = ref('month');
const monthName = ref('');
const datesOfPeriod = ref([]);
const tableCells = ref([]);
const scrollPanel = ref(null);
const dateRangesToTest = ref([
    {
        from: new Date(2023, 2, 5, 0, 0),
        to: new Date(2023, 2, 7, 22, 0)
    },
    {
        from: new Date(2023, 3, 1),
        to: new Date(2023, 3, 2, 24, 0)
    },
]);

const startOfPeriodRange = computed(() => {
    return this.$dayjs().startOf(viewType.value);
});

const endOfPeriodRange = computed(() => {
    return this.$dayjs().endOf(viewType.value);
});

const datesForOverlay = computed(() => {
    return dateRangesToTest.value.filter(dateTest => {
        return (
            this.$dayjs(dateTest.from).isBetween(
                startOfPeriodRange.value,
                endOfPeriodRange.value,
                null,
                []
            ) ||
            this.$dayjs(dateTest.to).isBetween(
                startOfPeriodRange.value,
                endOfPeriodRange.value,
                null,
                []
            )
        );
    });
});

const changeViewType = (val) => {
    viewType.value = val;
    setDaysOfPeriod();
};

const onScroll = () => {
    this.$bus.emit("moveOverlays");
};

const current = () => {
    currentPeriod();
};

const back = () => {
    backAPeriod();
};

const forward = () => {
    forwardAPeriod();
};

const backADay = () => {
    startOfPeriodRange.value = startOfPeriodRange.value.subtract(1, "d");
    endOfPeriodRange.value = endOfPeriodRange.value.subtract(1, "d");
    setDaysOfPeriod();
};

const forwardADay = () => {
    startOfPeriodRange.value = startOfPeriodRange.value.add(1, "d");
    endOfPeriodRange.value = endOfPeriodRange.value.add(1, "d");
    setDaysOfPeriod();
};

const currentPeriod = () => {
    startOfPeriodRange.value = this.$dayjs().startOf(viewType.value);
    endOfPeriodRange.value = this.$dayjs().endOf(viewType.value);
    setDaysOfPeriod();
};

const backAPeriod = () => {
    var changePeriod = viewType.value == "month" ? "M" : "w";
    var holdDate = endOfPeriodRange.value.clone().subtract(1, changePeriod);
    startOfPeriodRange.value = holdDate.clone().startOf(viewType.value);
    endOfPeriodRange.value = holdDate.clone().endOf(viewType.value);
    setDaysOfPeriod();
};

const forwardAPeriod = () => {
    var changePeriod = viewType.value == "month" ? "M" : "w";
    var holdDate = startOfPeriodRange.value.clone().add(1, changePeriod);
    startOfPeriodRange.value = holdDate.clone().startOf(viewType.value);
    endOfPeriodRange.value = holdDate.clone().endOf(viewType.value);
    setDaysOfPeriod();
};

const setDaysOfPeriod = () => {
    createDaysOfPeriod();

    nextTick(() => {
        this.$bus.emit("moveOverlays");
    });
};

const createDaysOfPeriod = () => {
    var startDate = startOfPeriodRange.value;

    datesOfPeriod.value = [];

    if (startDate.format("MMMM") == endOfPeriodRange.value.format("MMMM")) {
        monthName.value = startDate.format("MMMM");
    } else {
        monthName.value =
            startDate.format("MMMM") +
            " - " +
            endOfPeriodRange.value.format("MMMM");
    }

    let day = startDate;
    while (day <= endOfPeriodRange.value) {
        datesOfPeriod.value.push(day);
        day = day.clone().add(1, "d");
    }
};

onMounted(() => {
    createDaysOfPeriod();
    tableCells.value = this.$refs.tbody.getElementsByTagName("td");
    scrollPanel.value = this.$refs.scrollPanel;

    const delayScrollEvent = useDebounceFn(() => {
        onScroll();
    }, 300);

    const containingDiv = document.getElementsByClassName("q-markup-table")[0];
    containingDiv.addEventListener("scroll", delayScrollEvent);

    // window.addEventListener("resize", delayScrollEvent);

    nextTick(() => {
        // this.$bus.emit("moveOverlays");
    });
});

onBeforeUnmount(() => {
    this.$bus.off("moveOverlays");
    // window.removeEventListener("resize");
    const containingDiv = document.getElementsByClassName("q-markup-table")[0];
    containingDiv.removeEventListener('scroll');
});
</script>

<style scoped>
/* Add any additional styles here */
</style>
