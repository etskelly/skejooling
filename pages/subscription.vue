<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-7xl mx-auto">
      <div class="text-center">
        <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
          Choose Your Plan
        </h2>
        <p class="mt-4 text-xl text-gray-600">
          Select the plan that best fits your needs
        </p>
      </div>

      <div class="mt-12 space-y-4 sm:mt-16 sm:space-y-0 sm:grid sm:grid-cols-2 sm:gap-6 lg:max-w-4xl lg:mx-auto xl:max-w-none xl:mx-0 xl:grid-cols-3">
        <!-- Basic Plan -->
        <div class="border border-gray-200 rounded-lg shadow-sm divide-y divide-gray-200">
          <div class="p-6">
            <h2 class="text-lg leading-6 font-medium text-gray-900">Basic</h2>
            <p class="mt-4 text-sm text-gray-500">Perfect for small teams getting started</p>
            <p class="mt-8">
              <span class="text-4xl font-extrabold text-gray-900">$10</span>
              <span class="text-base font-medium text-gray-500">/mo</span>
            </p>
            <button
              @click="selectPlan('price_basic')"
              class="mt-8 block w-full bg-indigo-600 border border-transparent rounded-md py-2 text-sm font-semibold text-white text-center hover:bg-indigo-700"
            >
              Select Basic
            </button>
          </div>
          <div class="pt-6 pb-8 px-6">
            <h3 class="text-xs font-medium text-gray-900 tracking-wide uppercase">What's included</h3>
            <ul class="mt-6 space-y-4">
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Up to 5 users</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Basic features</span>
              </li>
            </ul>
          </div>
        </div>

        <!-- Pro Plan -->
        <div class="border border-gray-200 rounded-lg shadow-sm divide-y divide-gray-200">
          <div class="p-6">
            <h2 class="text-lg leading-6 font-medium text-gray-900">Pro</h2>
            <p class="mt-4 text-sm text-gray-500">For growing teams that need more</p>
            <p class="mt-8">
              <span class="text-4xl font-extrabold text-gray-900">$25</span>
              <span class="text-base font-medium text-gray-500">/mo</span>
            </p>
            <button
              @click="selectPlan('price_pro')"
              class="mt-8 block w-full bg-indigo-600 border border-transparent rounded-md py-2 text-sm font-semibold text-white text-center hover:bg-indigo-700"
            >
              Select Pro
            </button>
          </div>
          <div class="pt-6 pb-8 px-6">
            <h3 class="text-xs font-medium text-gray-900 tracking-wide uppercase">What's included</h3>
            <ul class="mt-6 space-y-4">
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Up to 20 users</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Advanced features</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Priority support</span>
              </li>
            </ul>
          </div>
        </div>

        <!-- Enterprise Plan -->
        <div class="border border-gray-200 rounded-lg shadow-sm divide-y divide-gray-200">
          <div class="p-6">
            <h2 class="text-lg leading-6 font-medium text-gray-900">Enterprise</h2>
            <p class="mt-4 text-sm text-gray-500">For large organizations with custom needs</p>
            <p class="mt-8">
              <span class="text-4xl font-extrabold text-gray-900">$100</span>
              <span class="text-base font-medium text-gray-500">/mo</span>
            </p>
            <button
              @click="selectPlan('price_enterprise')"
              class="mt-8 block w-full bg-indigo-600 border border-transparent rounded-md py-2 text-sm font-semibold text-white text-center hover:bg-indigo-700"
            >
              Select Enterprise
            </button>
          </div>
          <div class="pt-6 pb-8 px-6">
            <h3 class="text-xs font-medium text-gray-900 tracking-wide uppercase">What's included</h3>
            <ul class="mt-6 space-y-4">
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Unlimited users</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">All features</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">24/7 support</span>
              </li>
              <li class="flex space-x-3">
                <svg class="flex-shrink-0 h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-sm text-gray-500">Custom integrations</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { createSubscription } = useSubscription()

const selectPlan = async (priceId: string) => {
  try {
    await createSubscription(priceId)
  } catch (error) {
    console.error('Error selecting plan:', error)
    // You might want to show an error message to the user here
  }
}
</script> 