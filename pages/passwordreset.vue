<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})

useSeoMeta({
  title: 'Reset Password'
})

const errorMsg = ref<string | null>(null)
const successMsg = ref<string | null>(null)

const supabase = useSupabaseClient()

interface FormState {
  email: string
}

const fields = [{
  name: 'email',
  type: 'text' as const,
  label: 'Email',
  placeholder: 'Enter your email',
  required: true
}]

const validate = (state: Record<string, any>) => {
  const errors = []
  if (!state.email) errors.push({ path: 'email', message: 'Email is required' })
  return errors
}

const resetPassword = async (event: { data: FormState }) => {
  try {
    const { error } = await supabase.auth.resetPasswordForEmail(event.data.email, {
      redirectTo: `${window.location.origin}/update-password`
    })

    if (error) {
      throw error
    } else {
      successMsg.value = 'Password reset instructions have been sent to your email'
    }
  } catch (error: any) {
    errorMsg.value = error.message || error.fullMessage
  }
}
</script>

<template>
  <UCard class="max-w-sm w-full bg-white/75 dark:bg-white/5 backdrop-blur">
    <UAuthForm
      :fields="fields"
      :validate="validate"
      title="Reset Password"
      align="top"
      icon="i-heroicons-lock-closed"
      :ui="{ root: 'text-center', footer: 'text-center' }"
      :submit-button="{ label: 'Send Reset Instructions', trailingIcon: 'i-heroicons-arrow-right-20-solid' }"
      @submit="resetPassword"
    >
      <template #description>
        Remember your password? <NuxtLink
          to="/login"
          class="text-primary font-medium"
        >Sign in</NuxtLink>.
      </template>

      <template #footer>
        <div class="flex items-center justify-between mb-12" v-if="errorMsg">
          <div class="flex items-center">
            <a class="font-medium no-underline ml-2 text-red text-right cursor-pointer">{{ errorMsg }}</a>
          </div>
        </div>
        <div class="flex items-center justify-between mb-12" v-if="successMsg">
          <div class="flex items-center">
            <a class="font-medium no-underline ml-2 text-green text-right cursor-pointer">{{ successMsg }}</a>
          </div>
        </div>
      </template>
    </UAuthForm>
  </UCard>
</template>
