<template>
  <div>
    <UPageHero
      title="Smarter Scheduling, Simplified."
      description="Manage your classes, bookings, appointments, and team tasks effortlessly with Skejool’s central visual planner. See who’s doing what, where, and when."
      :links="[{ label: 'Get Started Free', to: '/signup', size: 'lg', trailingIcon: 'i-heroicons-arrow-right' }, { label: 'Learn More', to: '#features', variant: 'outline', size: 'lg', color: 'neutral' }]"
    />

    <UPageGrid
      id="features"
      title="Everything Organized in One Place"
      class="scroll-mt-[calc(var(--header-height)+72px+128px)]"
    >
      <UPageCard
        title="Visual Scheduling"
        description="Plan and view classes, appointments, and tasks on an intuitive timeline. Easily spot conflicts and availability."
        icon="i-heroicons-calendar-days"
      />
      <UPageCard
        title="Resource Management"
        description="Assign tasks and resources efficiently. Know who is working on what, and where they need to be."
        icon="i-heroicons-users"
      />
      <UPageCard
        title="Centralized Overview"
        description="Get a clear picture of all activities in one central hub. Make informed decisions and manage time effectively."
        icon="i-heroicons-viewfinder-circle"
      />
    </UPageGrid>

    <UPageColumns title="Built for Teams and Individuals">
       <div class="prose dark:prose-invert max-w-none">
         <p>Whether you're coordinating a large team, managing a small studio, or organizing your personal appointments, Skejool adapts to your needs. Our flexible platform ensures everyone stays synchronized and productive.</p>
         <ul>
           <li>Track team availability and assign tasks</li>
           <li>Manage class schedules and student bookings</li>
           <li>Organize personal appointments and projects</li>
         </ul>
       </div>
       <Placeholder class="aspect-video rounded-lg" />
    </UPageColumns>

    <UPageCTA
      title="Ready to streamline your schedule?"
      description="Sign up for Skejool today and experience effortless organization."
      :links="[{ label: 'Get Started Free', to: '/signup', size: 'lg' }]"
      card
    />
  </div>
</template>

<script setup lang="ts">
// Optional: Define page meta if needed
// definePageMeta({
//   // layout: 'landing' // Example: if you have a specific landing page layout
// })

useHead({
  title: 'Skejool - Smarter Scheduling, Simplified.',
  meta: [
    { name: 'description', content: 'Manage your classes, bookings, appointments, and team tasks effortlessly with Skejool’s central visual planner.' }
  ]
})
</script>