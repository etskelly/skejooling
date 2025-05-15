<template>

  <Panel toggleable>
    <template #header>
      <!-- <div class="flex items-center gap-2">
            <Avatar image="https://primefaces.org/cdn/primevue/images/avatar/amyelsner.png" size="large" shape="circle" />
            <span class="font-bold">Amy Elsner</span>
        </div> -->

      <Toolbar>
        <template #start>
          <Button icon="pi pi-plus" class="mr-2" severity="secondary" text />
          <Button icon="pi pi-print" class="mr-2" severity="secondary" text />
          <Button icon="pi pi-upload" severity="secondary" text />
        </template>

        <template #center>
          <IconField>
            <InputIcon>
              <i class="pi pi-search" />
            </InputIcon>
            <InputText placeholder="Search" />
          </IconField>
        </template>

        <template #end>
          <SplitButton label="Save" :model="items"></SplitButton>
        </template>
      </Toolbar>
    </template>

    <DataTable :value="times" tableStyle="min-width: 50rem">
      <Column field="id" header="ID"></Column>
      <Column field="title" header="Title"></Column>
      <Column field="from" header="From"></Column>
      <Column field="to" header="To"></Column>
    </DataTable>

    <template #footer>
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex items-center gap-2">
          <Button icon="pi pi-user" rounded text></Button>
          <Button icon="pi pi-bookmark" severity="secondary" rounded text></Button>
        </div>
        <span class="text-surface-500 dark:text-surface-400">Updated 2 hours ago</span>
      </div>
    </template>
    <template #icons>
      <Button icon="pi pi-cog" severity="secondary" rounded text @click="toggle" />
      <Menu ref="menu" id="config_menu" :model="items" popup />
    </template>
    <p class="m-0">
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
      magna
      aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
      consequat.
      Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur
      sint
      occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
  </Panel>

</template>

<script lang="ts" setup>
import { ref } from 'vue';

const items = ref([
  {
    label: 'Update',
    icon: 'pi pi-refresh'
  },
  {
    label: 'Delete',
    icon: 'pi pi-times'
  }
])

const times = ref([])

const { data, status, error } = await useFetch('/api/times')

debugger

times.value = data.value?.timeboxes;
</script>

<style></style>