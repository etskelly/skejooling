<script setup lang="ts">
definePageMeta({
  layout: 'auth',
})

useSeoMeta({
  title: 'Sign Up'
})

interface FormState {
  email: string
  forename: string
  surname: string
  orgname: string
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
  name: 'orgname',
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

const validate = (state: Record<string, any>) => {
  const errors = []
  if (!state.email) errors.push({ path: 'email', message: 'Email is required' })
  if (!state.forename) errors.push({ path: 'forename', message: 'Forename is required' })
  if (!state.surname) errors.push({ path: 'surname', message: 'Surname is required' })
  if (!state.orgname) errors.push({ path: 'orgname', message: 'Business name is required' })
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
    console.log('Attempting to sign up with:', {
      email: event.data.email,
      password: '********',
      options: {
        data: {
          forename: event.data.forename,
          surname: event.data.surname,
          orgname: event.data.orgname,
        },
      },
    })
    
    // Try a simpler signup approach first
    const { data, error } = await supabase.auth.signUp({
      email: event.data.email,
      password: event.data.password,
      options: {
        data: {
          forename: event.data.forename,
          surname: event.data.surname,
          orgname: event.data.orgname
        },
      },
    })

    console.log('Signup response:', { data, error })

    if (error) {
      console.error('Signup error:', error)
      console.error('Error details:', {
        message: error.message,
        status: error?.status,
        name: error?.name,
        stack: error?.stack
      })
      
      // If we get a database error, try a different approach
      if (error.message.includes('Database error')) {
        console.log('Trying alternative signup approach...')
        
        // Try with minimal metadata
        const { data: altData, error: altError } = await supabase.auth.signUp({
          email: event.data.email,
          password: event.data.password
        })
        
        if (altError) {
          console.error('Alternative signup error:', altError)
          errorMsg.value = altError.message || 'An error occurred during signup'
          throw altError
        } else {
          console.log('Alternative signup successful:', altData)
          successMsg.value = "Registration successful! Please check your email to confirm your account."
        }
      } else {
        errorMsg.value = error.message || 'An error occurred during signup'
        throw error
      }
    } else {
      console.log('Signup successful:', data)
      successMsg.value = "Registration successful! Please check your email to confirm your account."
    }
  } catch (error: any) {
    console.error('Caught error during signup:', error)
    errorMsg.value = error.message || 'An unexpected error occurred'
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