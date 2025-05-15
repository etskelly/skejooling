<template>
    <div class="relative flex gap-6 h-screen bg-surface-0 dark:bg-surface-950 p-6">
        <div id="app-sidebar-14" class="h-full hidden lg:block lg:static absolute left-0 top-0 py-4 pl-4 lg:p-0 z-50">
            <div class="w-[18rem] h-full flex flex-col bg-surface-50 dark:bg-surface-900 rounded-2xl border border-surface-100 dark:border-surface-800">
                <a class="inline-flex items-center gap-3 px-6 py-4 cursor-pointer">
                    <svg class="fill-surface-900 dark:fill-surface-0" width="28" height="29" viewBox="0 0 28 29" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M14 28.5C21.732 28.5 28 22.232 28 14.5C28 6.76802 21.732 0.5 14 0.5C6.26801 0.5 0 6.76802 0 14.5C0 22.232 6.26801 28.5 14 28.5ZM18.3675 7.02179C18.5801 6.26664 17.8473 5.82009 17.178 6.29691L7.83519 12.9527C7.10936 13.4698 7.22353 14.5 8.00669 14.5H10.4669V14.4809H15.2618L11.3549 15.8595L9.63251 21.9782C9.41992 22.7334 10.1527 23.1799 10.822 22.7031L20.1649 16.0473C20.8907 15.5302 20.7764 14.5 19.9934 14.5H16.2625L18.3675 7.02179Z"
                        />
                    </svg>
                    <span class="font-semibold text-surface-900 dark:text-surface-0">Skejool</span>
                </a>
                <div class="w-[calc(100%-3rem)] mx-auto h-[1px] bg-surface-200 dark:bg-surface-700 px-6" />
                <div class="p-6 flex-1">
                    <ul class="flex flex-col gap-2 overflow-hidden">
                        <template v-for="(item, index) of navs" :key="index">
                            <li>
                                <div
                                    :class="
                                        selectedNav === item.label
                                            ? 'bg-surface-0 dark:bg-surface-950 text-surface-900 dark:text-surface-0 border-surface shadow-sm'
                                            : 'border-transparent hover:border-surface-200 dark:hover:border-surface-800 hover:bg-surface-0 dark:hover:bg-surface-950 text-surface-600 dark:text-surface-400'
                                    "
                                    class="z-30 relative flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-all border"
                                    @click="handleNavClick(item)"
                                >
                                    <i :class="item.icon" />
                                    <span class="flex-1 font-medium">{{ item.label }}</span>
                                    <i v-if="item?.subMenu" class="pi pi-chevron-down text-sm leading-none" />
                                </div>
                                <div
                                    v-if="selectedNav === item.label && item?.subMenu"
                                    class="relative pl-1.5 flex flex-col transition-all duration-500 mt-2"
                                    :class="selectedNav === item.label && item?.subMenu ? 'opacity-100' : 'opacity-0'"
                                >
                                    <template v-for="(subItem, index) of item.subMenu" :key="index">
                                        <div class="cursor-pointer relative px-3.5 py-2 flex items-center transition-all" @click="selectedSubNav = subItem.label">
                                            <svg width="18" height="44" viewBox="0 0 18 44" fill="none" xmlns="http://www.w3.org/2000/svg" class="absolute left-4 -top-2">
                                                <path :d="getLinePath(index, item.subMenu.length)" class="stroke-surface-300 dark:stroke-surface-600" stroke-width="2" />
                                                <path
                                                    d="M11.136 26.2862L11.1313 26.2863C11.1243 26.2863 11.1174 26.2849 11.1109 26.2823C11.1045 26.2796 11.0986 26.2756 11.0937 26.2707L11.0937 26.2707L11.0917 26.2687C11.0805 26.2575 11.0742 26.2422 11.0742 26.2263C11.0742 26.2105 11.0805 26.1953 11.0917 26.1841C11.0917 26.184 11.0917 26.184 11.0917 26.184L14.4286 22.8471L14.7822 22.4936L14.4286 22.14L11.1009 18.8123C11.0922 18.8014 11.0875 18.7878 11.0877 18.7737C11.088 18.7582 11.0943 18.7434 11.1052 18.7324C11.1162 18.7214 11.131 18.7151 11.1466 18.7149C11.1606 18.7146 11.1743 18.7193 11.1852 18.7281L14.9083 22.4512C14.9195 22.4625 14.9258 22.4777 14.9258 22.4936C14.9258 22.5095 14.9195 22.5247 14.9083 22.5359L11.1758 26.2685L11.1758 26.2685L11.1736 26.2707C11.1687 26.2756 11.1628 26.2796 11.1564 26.2823C11.1499 26.2849 11.143 26.2863 11.136 26.2862Z"
                                                    class="stroke-surface-300 fill-surface-300 dark:stroke-surface-600 dark:fill-surface-600"
                                                />
                                                <path d="M1 14V17.5C1 20.2614 3.23858 22.5 6 22.5H15" class="stroke-surface-300 dark:stroke-surface-600" stroke-width="2" />
                                                <template v-if="index === getSelectedIndex()">
                                                    <path
                                                        d="M11.136 26.2862L11.1313 26.2863C11.1243 26.2863 11.1174 26.2849 11.1109 26.2823C11.1045 26.2796 11.0986 26.2756 11.0937 26.2707L11.0937 26.2707L11.0917 26.2687C11.0805 26.2575 11.0742 26.2422 11.0742 26.2263C11.0742 26.2105 11.0805 26.1953 11.0917 26.1841C11.0917 26.184 11.0917 26.184 11.0917 26.184L14.4286 22.8471L14.7822 22.4936L14.4286 22.14L11.1009 18.8123C11.0922 18.8014 11.0875 18.7878 11.0877 18.7737C11.088 18.7582 11.0943 18.7434 11.1052 18.7324C11.1162 18.7214 11.131 18.7151 11.1466 18.7149C11.1606 18.7146 11.1743 18.7193 11.1852 18.7281L14.9083 22.4512C14.9195 22.4625 14.9258 22.4777 14.9258 22.4936C14.9258 22.5095 14.9195 22.5247 14.9083 22.5359L11.1758 26.2685L11.1758 26.2685L11.1736 26.2707C11.1687 26.2756 11.1628 26.2796 11.1564 26.2823C11.1499 26.2849 11.143 26.2863 11.136 26.2862Z"
                                                        class="stroke-surface-900 fill-surface-900 dark:stroke-surface-0 dark:fill-surface-0"
                                                    />
                                                    <path d="M1 14V17.5C1 20.2614 3.23858 22.5 6 22.5H15" class="stroke-surface-900 dark:stroke-surface-0" stroke-width="2" />
                                                </template>
                                                <path v-if="index <= getSelectedIndex()" :d="getActiveLinePath(index, getSelectedIndex())" class="stroke-surface-900 dark:stroke-surface-0" stroke-width="2" />
                                            </svg>
                                            <span
                                                class="leading-relaxed font-medium text-sm transition-all ml-8"
                                                :class="selectedSubNav === subItem.label ? 'text-surface-900 dark:text-surface-0' : 'text-surface-500 dark:text-surface-400 hover:text-surface-900 dark:hover:text-surface-0'"
                                                >{{ subItem.label }}</span
                                            >
                                        </div>
                                    </template>
                                </div>
                            </li>
                        </template>
                    </ul>
                </div>
                <ul class="flex flex-col gap-2 px-6 py-3">
                    <template v-for="(item, index) of bottomNavs" :key="index">
                        <li
                            :class="
                                selectedNav === item.label
                                    ? 'bg-surface-0 dark:bg-surface-950 text-surface-900 dark:text-surface-0 border-surface shadow-sm'
                                    : 'border-transparent hover:border-surface-200 dark:hover:border-surface-800 hover:bg-surface-0 dark:hover:bg-surface-950 text-surface-600 dark:text-surface-400'
                            "
                            class="flex items-center gap-2 px-3 py-2 rounded-lg cursor-pointer transition-all border"
                            @click="handleNavClick(item)"
                        >
                            <i :class="item.icon" />
                            <span class="flex-1 font-medium">{{ item.label }}</span>
                            <i v-if="item?.subMenu" class="pi pi-chevron-down text-sm leading-none" />
                        </li>
                    </template>
                </ul>
                <div class="w-[calc(100%-3rem)] mx-auto h-[1px] bg-surface-200 dark:bg-surface-700 px-6" />
                <div class="p-6 flex items-center gap-3 cursor-pointer">
                    <Avatar image="https://fqjltiegiezfetthbags.supabase.co/storage/v1/render/image/public/block.images/blocks/avatars/circle/avatar-f-1.png" size="large" shape="circle" class="!w-9 !h-9" />
                    <div>
                        <div class="text-sm font-semibold text-surface-900 dark:text-surface-0">Amy Elsner</div>
                        <span class="text-xs text-surface-600 dark:text-surface-400 leading-none">Description</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col gap-6">
            <div class="flex sm:items-center flex-wrap sm:flex-row flex-col lg:px-5 pt-3 pb-4 justify-between border-b border-surface gap-4">
                <div class="flex items-center gap-2">
                    <a
                        v-styleclass="{
                            selector: '#app-sidebar-14',
                            enterFromClass: 'hidden',
                            enterActiveClass: 'animate-fadeinleft',
                            leaveToClass: 'hidden',
                            leaveActiveClass: 'animate-fadeoutleft',
                            hideOnOutsideClick: true
                        }"
                        class="cursor-pointer block lg:hidden text-surface-700 dark:text-surface-100 mr-2"
                    >
                        <i class="pi pi-bars text-3xl" />
                    </a>
                    <div class="flex-1">
                        <h1 class="text-lg font-medium text-surface-900 dark:text-surface-0">Dashboard</h1>
                        <p class="text-surface-500">Excepteur sint occaecat</p>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <IconField>
                        <InputIcon class="pi pi-search" />
                        <InputText v-model="search" placeholder="Search" />
                    </IconField>
                    <Button icon="pi pi-bell" outlined severity="secondary" />
                </div>
            </div>
            <div class="flex-1 p-4 overflow-auto">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                    <!-- Upcoming Appointments Card -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Upcoming Appointments</h3>
                            <i class="pi pi-calendar text-xl text-primary"></i>
                        </div>
                        <div class="text-3xl font-bold text-primary mb-2">{{ upcomingAppointments }}</div>
                        <div class="text-sm text-surface-600 dark:text-surface-400">
                            <span class="font-medium">{{ appointmentsToday }}</span> scheduled for today
                        </div>
                    </div>

                    <!-- Resource Utilization Card -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Resource Utilization</h3>
                            <i class="pi pi-briefcase text-xl text-cyan-500"></i>
                        </div>
                        <div class="text-3xl font-bold text-cyan-500 mb-2">{{ resourceUtilization }}%</div>
                        <div class="text-sm text-surface-600 dark:text-surface-400">
                            <span :class="resourceUtilizationChange >= 0 ? 'text-green-500' : 'text-red-500'">
                                <i :class="resourceUtilizationChange >= 0 ? 'pi pi-arrow-up' : 'pi pi-arrow-down'"></i>
                                {{ Math.abs(resourceUtilizationChange) }}%
                            </span>
                            from last week
                        </div>
                    </div>

                    <!-- Upcoming Absences Card -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Upcoming Absences</h3>
                            <i class="pi pi-user-minus text-xl text-orange-500"></i>
                        </div>
                        <div class="text-3xl font-bold text-orange-500 mb-2">{{ upcomingAbsences }}</div>
                        <div class="text-sm text-surface-600 dark:text-surface-400">
                            Next: {{ nextAbsenceDate }}
                        </div>
                    </div>

                    <!-- Active Clients Card -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Active Clients</h3>
                            <i class="pi pi-users text-xl text-green-500"></i>
                        </div>
                        <div class="text-3xl font-bold text-green-500 mb-2">{{ activeClients }}</div>
                        <div class="text-sm text-surface-600 dark:text-surface-400">
                            <span class="text-green-500">
                                <i class="pi pi-plus"></i> {{ newClients }}
                            </span>
                            new this month
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                    <!-- Appointments by Day Chart -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Appointments by Day</h3>
                            <div class="flex gap-2">
                                <Button label="Week" size="small" :outlined="timeRange !== 'week'" :text="timeRange === 'week'" @click="timeRange = 'week'" />
                                <Button label="Month" size="small" :outlined="timeRange !== 'month'" :text="timeRange === 'month'" @click="timeRange = 'month'" />
                            </div>
                        </div>
                        <div ref="appointmentsByDayChart" style="height: 300px;"></div>
                    </div>

                    <!-- Resource Utilization Chart -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Resource Utilization</h3>
                            <Dropdown v-model="selectedResource" :options="resourceOptions" optionLabel="name" placeholder="Select Resource" class="w-48" />
                        </div>
                        <div ref="resourceUtilizationChart" style="height: 300px;"></div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Service Popularity Chart -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Service Popularity</h3>
                        </div>
                        <div ref="servicePopularityChart" style="height: 300px;"></div>
                    </div>

                    <!-- Absence Types Chart -->
                    <div class="bg-surface-50 dark:bg-surface-900 rounded-xl p-4 shadow-sm border border-surface-100 dark:border-surface-800">
                        <div class="flex justify-between items-center mb-4">
                            <h3 class="text-lg font-semibold text-surface-900 dark:text-surface-0">Absence Types</h3>
                        </div>
                        <div ref="absenceTypesChart" style="height: 300px;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import Avatar from 'primevue/avatar';
import Button from 'primevue/button';
import Dropdown from 'primevue/dropdown';
import IconField from 'primevue/iconfield';
import InputIcon from 'primevue/inputicon';
import InputText from 'primevue/inputtext';
import { ref, onMounted, onBeforeUnmount, watch, nextTick } from 'vue';
import { useSupabaseClient, navigateTo } from '#imports';
import * as echarts from 'echarts';

const supabase = useSupabaseClient();
const search = ref('');
const selectedNav = ref('Dashboard');
const selectedSubNav = ref(null);
const bottomNavs = ref([
    {
        icon: 'pi pi-question-circle',
        label: 'Help'
    },
    {
        icon: 'pi pi-cog',
        label: 'Settings'
    }
]);

// Dashboard data
const upcomingAppointments = ref(12);
const appointmentsToday = ref(3);
const resourceUtilization = ref(68);
const resourceUtilizationChange = ref(5);
const upcomingAbsences = ref(4);
const nextAbsenceDate = ref('Mar 15 - Mar 18');
const activeClients = ref(42);
const newClients = ref(7);

// Chart references
const appointmentsByDayChart = ref(null);
const resourceUtilizationChart = ref(null);
const servicePopularityChart = ref(null);
const absenceTypesChart = ref(null);

// Chart instances
let appointmentsByDayChartInstance = null;
let resourceUtilizationChartInstance = null;
let servicePopularityChartInstance = null;
let absenceTypesChartInstance = null;

// Chart data
const timeRange = ref('week');
const selectedResource = ref(null);
const resourceOptions = ref([
    { id: 1, name: 'Meeting Room A' },
    { id: 2, name: 'Conference Room' },
    { id: 3, name: 'Equipment Set 1' },
    { id: 4, name: 'John Smith (Staff)' }
]);

// Fetch dashboard data
const fetchDashboardData = async () => {
    try {
        // In a real application, you would fetch this data from your API
        // For now, we'll use mock data
        
        // Fetch upcoming appointments
        const { data: appointmentsData, error: appointmentsError } = await supabase
            .from('Appointments')
            .select('*')
            .gte('startTime', new Date().toISOString())
            .order('startTime', { ascending: true })
            .limit(20);
            
        if (!appointmentsError && appointmentsData) {
            upcomingAppointments.value = appointmentsData.length;
            
            // Count appointments for today
            const today = new Date();
            const todayStart = new Date(today.getFullYear(), today.getMonth(), today.getDate()).toISOString();
            const todayEnd = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59).toISOString();
            
            appointmentsToday.value = appointmentsData.filter(
                app => app.startTime >= todayStart && app.startTime <= todayEnd
            ).length;
        }
        
        // Fetch absences
        const { data: absencesData, error: absencesError } = await supabase
            .from('Absences')
            .select('*')
            .gte('startDate', new Date().toISOString())
            .order('startDate', { ascending: true })
            .limit(10);
            
        if (!absencesError && absencesData && absencesData.length > 0) {
            upcomingAbsences.value = absencesData.length;
            
            // Format next absence date
            const nextAbsence = absencesData[0];
            const startDate = new Date(nextAbsence.startDate);
            const endDate = new Date(nextAbsence.endDate);
            
            nextAbsenceDate.value = `${startDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - ${endDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
        }
        
        // Fetch clients
        const { data: clientsData, error: clientsError } = await supabase
            .from('Clients')
            .select('*');
            
        if (!clientsError && clientsData) {
            activeClients.value = clientsData.length;
            
            // Count new clients this month
            const firstDayOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 1).toISOString();
            newClients.value = clientsData.filter(
                client => client.created_at >= firstDayOfMonth
            ).length;
        }
    } catch (error) {
        console.error('Error fetching dashboard data:', error);
    }
};

// Initialize charts
const initCharts = () => {
    // Initialize Appointments by Day Chart
    appointmentsByDayChartInstance = echarts.init(appointmentsByDayChart.value);
    updateAppointmentsByDayChart();
    
    // Initialize Resource Utilization Chart
    resourceUtilizationChartInstance = echarts.init(resourceUtilizationChart.value);
    updateResourceUtilizationChart();
    
    // Initialize Service Popularity Chart
    servicePopularityChartInstance = echarts.init(servicePopularityChart.value);
    updateServicePopularityChart();
    
    // Initialize Absence Types Chart
    absenceTypesChartInstance = echarts.init(absenceTypesChart.value);
    updateAbsenceTypesChart();
    
    // Add resize event listener
    window.addEventListener('resize', handleResize);
};

// Handle window resize
const handleResize = () => {
    appointmentsByDayChartInstance?.resize();
    resourceUtilizationChartInstance?.resize();
    servicePopularityChartInstance?.resize();
    absenceTypesChartInstance?.resize();
};

// Update Appointments by Day Chart
const updateAppointmentsByDayChart = () => {
    const days = timeRange.value === 'week' 
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
        
    const data = timeRange.value === 'week'
        ? [5, 7, 10, 8, 12, 3, 2]
        : [28, 35, 42, 30];
        
    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: days,
            axisTick: {
                alignWithLabel: true
            }
        },
        yAxis: {
            type: 'value'
        },
        series: [
            {
                name: 'Appointments',
                type: 'bar',
                barWidth: '60%',
                data: data,
                itemStyle: {
                    color: '#2196f3'
                }
            }
        ]
    };
    
    appointmentsByDayChartInstance.setOption(option);
};

// Update Resource Utilization Chart
const updateResourceUtilizationChart = () => {
    const dates = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const data = [45, 62, 78, 90, 70, 55, 40];
    
    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'line'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'category',
            data: dates
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: '{value}%'
            },
            max: 100
        },
        series: [
            {
                name: 'Utilization',
                type: 'line',
                data: data,
                smooth: true,
                lineStyle: {
                    width: 4
                },
                itemStyle: {
                    color: '#00bcd4'
                },
                areaStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        {
                            offset: 0,
                            color: 'rgba(0, 188, 212, 0.5)'
                        },
                        {
                            offset: 1,
                            color: 'rgba(0, 188, 212, 0.1)'
                        }
                    ])
                }
            }
        ]
    };
    
    resourceUtilizationChartInstance.setOption(option);
};

// Update Service Popularity Chart
const updateServicePopularityChart = () => {
    const option = {
        tooltip: {
            trigger: 'item'
        },
        legend: {
            orient: 'vertical',
            left: 'left'
        },
        series: [
            {
                name: 'Service Bookings',
                type: 'pie',
                radius: '70%',
                data: [
                    { value: 35, name: 'Consultation' },
                    { value: 25, name: 'Training Session' },
                    { value: 18, name: 'Workshop' },
                    { value: 15, name: 'Presentation' },
                    { value: 7, name: 'Other' }
                ],
                emphasis: {
                    itemStyle: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                    }
                },
                label: {
                    formatter: '{b}: {d}%'
                }
            }
        ]
    };
    
    servicePopularityChartInstance.setOption(option);
};

// Update Absence Types Chart
const updateAbsenceTypesChart = () => {
    const option = {
        tooltip: {
            trigger: 'item'
        },
        legend: {
            orient: 'vertical',
            left: 'left'
        },
        series: [
            {
                name: 'Absence Types',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: 16,
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: [
                    { value: 45, name: 'Holiday' },
                    { value: 25, name: 'Sick Leave' },
                    { value: 15, name: 'Personal Leave' },
                    { value: 10, name: 'Half Day (Morning)' },
                    { value: 5, name: 'Half Day (Afternoon)' }
                ]
            }
        ]
    };
    
    absenceTypesChartInstance.setOption(option);
};

// Watch for changes in timeRange
watch(timeRange, () => {
    updateAppointmentsByDayChart();
});

// Watch for changes in selectedResource
watch(selectedResource, () => {
    updateResourceUtilizationChart();
});

// Lifecycle hooks
onMounted(() => {
    fetchDashboardData();
    
    // Initialize charts after DOM is updated
    nextTick(() => {
        initCharts();
    });
});

onBeforeUnmount(() => {
    // Clean up chart instances and event listeners
    appointmentsByDayChartInstance?.dispose();
    resourceUtilizationChartInstance?.dispose();
    servicePopularityChartInstance?.dispose();
    absenceTypesChartInstance?.dispose();
    window.removeEventListener('resize', handleResize);
});

// Navigation data
const navs = ref([
    {
        icon: 'pi pi-home',
        label: 'Dashboard',
        subMenu: [
            {
                label: 'Analytics'
            },
            {
                label: 'Reports'
            },
            {
                label: 'Wallet'
            }
        ]
    },
    {
        icon: 'pi pi-bookmark',
        label: 'Bookmarks'
    },
    {
        icon: 'pi pi-users',
        label: 'Team'
    },
    {
        icon: 'pi pi-comments',
        label: 'Messages'
    },
    {
        icon: 'pi pi-calendar',
        label: 'Calendar'
    },
    {
        icon: 'pi pi-calendar-plus',
        label: 'Scheduling',
        to: '/scheduling'
    }
]);

const getLinePath = (index, totalItems) => {
    if (index === 0) {
        return `M1 0 V40`;
    } else if (index === totalItems - 1) {
        return `M1 -4 V14`;
    } else {
        return `M1 -4 V40`;
    }
};

const getActiveLinePath = (index, selectedIndex) => {
    if (index === 0) {
        return `M1 0 V${index === selectedIndex ? '14' : '40'}`;
    } else if (index === selectedIndex) {
        return `M1 -4 V14`;
    } else {
        return `M1 -4 V40`;
    }
};

const getSelectedIndex = () => {
    return navs.value[0].subMenu.findIndex((subItem) => subItem.label === selectedSubNav.value);
};

const handleNavClick = (item) => {
    selectedNav.value = item.label;
    
    // If the item has a 'to' property, navigate to that route
    if (item.to) {
        navigateTo(item.to);
    }
};
</script>
