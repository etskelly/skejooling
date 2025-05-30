<script setup lang="ts">
import type { NavItem } from '@nuxt/content'
import { useSupabaseUser, useSupabaseClient, navigateTo } from '#imports'
import { computed } from 'vue'

const navigation = inject<Ref<NavItem[]>>('navigation', ref([]))
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const links = [{
  label: 'Docs',
  to: '/docs'
}, {
  label: 'Pricing',
  to: '/pricing'
}, {
  label: 'Blog',
  to: '/blog'
}]

const isSignedIn = computed(() => !!user.value)

const handleLogout = async () => {
  await supabase.auth.signOut()
  await navigateTo('/')
}
</script>

<template>
  <UHeader :links="links">
    <template #logo>
      Skejool <UBadge
        label="SaaS"
        variant="subtle"
        class="mb-0.5"
      />
    </template>

    <template #right>
      <UColorModeButton size="sm" class="mr-2" />
      <template v-if="!isSignedIn">
        <UButton
          label="Sign in"
          color="gray"
          to="/login"
        />
        <UButton
          label="Sign up"
          icon="i-heroicons-arrow-right-20-solid"
          trailing
          color="black"
          to="/signup"
          class="hidden lg:flex"
        />
      </template>
      <template v-else>
        <UButton
          label="Log out"
          color="gray"
          @click="handleLogout"
        />
      </template>
    </template>

    <!-- <template #panel>
      <UNavigationTree
        :links="mapContentNavigation(navigation)"
        default-open
      />
    </template> -->
  </UHeader>
</template>
