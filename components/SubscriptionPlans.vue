<template>
  <div class="subscription-plans">
    <h2 class="text-2xl font-bold mb-6">Choose Your Plan</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="plan in plans" :key="plan.id" 
           class="border rounded-lg p-6 hover:shadow-lg transition-shadow"
           :class="{ 'border-primary-500': selectedPlan === plan.id }">
        <div class="text-center">
          <h3 class="text-xl font-semibold mb-2">{{ plan.name }}</h3>
          <div class="text-3xl font-bold mb-4">
            ${{ plan.price }}<span class="text-sm font-normal">/month</span>
          </div>
          <ul class="text-left space-y-2 mb-6">
            <li v-for="feature in plan.features" :key="feature" class="flex items-center">
              <Icon name="heroicons:check-circle" class="text-green-500 mr-2" />
              {{ feature }}
            </li>
          </ul>
          <UButton
            :color="selectedPlan === plan.id ? 'primary' : 'gray'"
            @click="selectPlan(plan.id)"
            class="w-full"
          >
            {{ selectedPlan === plan.id ? 'Selected' : 'Select Plan' }}
          </UButton>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const plans = [
  {
    id: 'basic',
    name: 'Basic',
    price: 9.99,
    features: [
      'Up to 5 users',
      'Basic scheduling',
      'Email support',
      '1GB storage'
    ]
  },
  {
    id: 'pro',
    name: 'Professional',
    price: 19.99,
    features: [
      'Up to 20 users',
      'Advanced scheduling',
      'Priority support',
      '5GB storage',
      'Custom branding'
    ]
  },
  {
    id: 'enterprise',
    name: 'Enterprise',
    price: 49.99,
    features: [
      'Unlimited users',
      'Full feature access',
      '24/7 support',
      'Unlimited storage',
      'Custom branding',
      'API access'
    ]
  }
];

const selectedPlan = ref('pro'); // Default to pro plan

const emit = defineEmits(['update:selectedPlan']);

function selectPlan(planId: string) {
  selectedPlan.value = planId;
  emit('update:selectedPlan', planId);
}
</script> 