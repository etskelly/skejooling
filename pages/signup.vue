<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})

useSeoMeta({
  title: 'Sign Up'
})

interface FormState {
  email: string
  forename: string
  surname: string
  orgName: string
  password: string
  passwordConfirmation: string
}

const errorMsg = ref<string | null>(null)
const successMsg = ref<string | null>(null)

const supabase = useSupabaseClient()

const fields = [{
  name: 'email',
  type: 'text' as const,
  label: 'Email',
  placeholder: 'Enter your email',
  required: true
}, {
  name: 'forename',
  type: 'text' as const,
  label: 'Forename',
  placeholder: 'Enter your forename',
  required: true
}, {
  name: 'surname',
  type: 'text' as const,
  label: 'Surname',
  placeholder: 'Enter your surname',
  required: true
}, {
  name: 'orgName',
  type: 'text' as const,
  label: 'Business Name',
  placeholder: 'Enter your business name',
  required: true
}, {
  name: 'password',
  label: 'Password',
  type: 'password' as const,
  placeholder: 'Enter your password',
  required: true
}, {
  name: 'passwordConfirmation',
  label: 'Confirm Password',
  type: 'password' as const,
  placeholder: 'Confirm your password',
  required: true
}]

const validate = (state: FormState) => {
  const errors = []
  if (!state.email) errors.push({ path: 'email', message: 'Email is required' })
  if (!state.forename) errors.push({ path: 'forename', message: 'Forename is required' })
  if (!state.surname) errors.push({ path: 'surname', message: 'Surname is required' })
  if (!state.orgName) errors.push({ path: 'orgName', message: 'Business name is required' })
  if (!state.password) errors.push({ path: 'password', message: 'Password is required' })
  if (!state.passwordConfirmation) errors.push({ path: 'passwordConfirmation', message: 'Password confirmation is required' })
  if (state.password !== state.passwordConfirmation) {
    errors.push({ path: 'passwordConfirmation', message: 'Passwords do not match' })
  }
  return errors
}

const providers = [{
  label: 'Continue with GitHub',
  icon: 'i-simple-icons-github',
  color: 'neutral' as const,
  click: () => {
    console.log('Redirect to GitHub')
  }
}]

const signUp = async (event: { data: FormState }) => {
  try {
    const { error } = await supabase.auth.signUp({
      email: event.data.email,
      password: event.data.password,
      options: {
        data: {
          forename: event.data.forename,
          surname: event.data.surname,
          orgname: event.data.orgName,
          status: 'exists'
        },
      },
    })

    if (error) {
      debugger
      alert("Some error")
      throw error
    } else {
      debugger
      alert("No error")
      successMsg.value = "Registered Successfully"
    }
  } catch (error: any) {
    debugger
    alert('Some proper error')
    errorMsg.value = error.message || error.fullMessage
  }
}
</script>

<template>
  <UCard class="max-w-sm w-full bg-white/75 dark:bg-white/5 backdrop-blur">
    <UAuthForm
      :fields="fields"
      :validate="validate"
      :providers="providers"
      title="Create an account"
      align="top"
      icon="i-heroicons-user-plus"
      :ui="{ root: 'text-center', footer: 'text-center' }"
      :submit-button="{ trailingIcon: 'i-heroicons-arrow-right-20-solid' }"
      @submit="signUp"
    >
      <template #description>
        Already have an account? <NuxtLink
          to="/login"
          class="text-primary font-medium"
        >Login</NuxtLink>.
      </template>

      <template #footer>
        <div v-if="errorMsg" class="mb-4">
          <UAlert
            type="error"
            :title="errorMsg"
            class="w-full"
          />
        </div>
        <div v-if="successMsg" class="mb-4">
          <UAlert
            type="success"
            :title="successMsg"
            class="w-full"
          />
        </div>
      </template>
    </UAuthForm>
  </UCard>
</template> 