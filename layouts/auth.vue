<script setup lang="ts">
useHead({
  bodyAttrs: {
    class: 'dark:bg-gray-950'
  }
})
</script>

<template>
  <div class="min-h-screen overlay">
    <UHeader>
      <template #left>
        <NuxtLink to="/" class="flex items-center">
          Nuxt UI Pro <UBadge
            label="SaaS"
            variant="subtle"
            class="mb-0.5 ml-2"
          />
        </NuxtLink>
      </template>

      <!-- Add empty right/panel slots to prevent default buttons/icons showing -->
      <template #right />
      <template #panel />
    </UHeader>

    <UMain class="flex items-center justify-center">
      <div class="gradient" />
      <slot />
    </UMain>
  </div>
</template>

<style scoped>
.gradient {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: radial-gradient(50% 50% at 50% 50%, rgb(var(--color-primary-500) / 0.25) 0, #FFF 100%);
}

.dark {
  .gradient {
    background: radial-gradient(50% 50% at 50% 50%, rgb(var(--color-primary-400) / 0.1) 0, rgb(var(--color-gray-950)) 100%);
  }
}

.overlay {
  background-size: 100px 100px;
  background-image:
    linear-gradient(to right, rgb(var(--color-gray-200)) 0.5px, transparent 0.5px),
    linear-gradient(to bottom, rgb(var(--color-gray-200)) 0.5px, transparent 0.5px);
}
.dark {
  .overlay {
    background-image:
      linear-gradient(to right, rgb(var(--color-gray-900)) 0.5px, transparent 0.5px),
      linear-gradient(to bottom, rgb(var(--color-gray-900)) 0.5px, transparent 0.5px);
  }
}
</style>
