<script setup lang="ts">
definePageMeta({
  layout: 'auth',
})

useSeoMeta({
  title: 'Login'
})

const errorMsg = ref(null)

const supabase = useSupabaseClient()

interface FormState {
  email: string
  password: string
}

const fields = [{
  name: 'email',
  type: 'text' as const,
  label: 'Email',
  placeholder: 'Enter your email',
  required: true
}, {
  name: 'password',
  label: 'Password',
  type: 'password' as const,
  placeholder: 'Enter your password'
}, {
  name: 'remember',
  label: 'Remember me',
  type: 'checkbox' as const
}]

const validate = (state: any) => {
  const errors = []
  if (!state.email) errors.push({ path: 'email', message: 'Email is required' })
  if (!state.password) errors.push({ path: 'password', message: 'Password is required' })
  return errors
}

const providers = [{
  label: 'Continue with GitHub',
  icon: 'i-simple-icons-github',
  color: 'white' as const,
  click: () => {
    console.log('Redirect to GitHub')
  }
}]

// function signInWithPassword(data) {
//   console.log('Submitted', data)
//   debugger
// }

const signInWithPassword = async (event: { data: FormState }) => {
  try {
    const { error } = await supabase.auth.signInWithPassword(
      {
        email: event.data.email,
        password: event.data.password
      }
    )

    if (error) {
      throw (error)
    } else {
      await navigateTo('/dashboard')
    }
  } catch (error) {
    errorMsg.value = errorMsg.value = error.message || error.fullMessage
    // Handle the error as needed
  }
}
</script>

<!-- eslint-disable vue/multiline-html-element-content-newline -->
<!-- eslint-disable vue/singleline-html-element-content-newline -->
<template>
  <UCard class="max-w-sm w-full bg-white/75 dark:bg-white/5 backdrop-blur">
    <UAuthForm :fields="fields" :validate="validate" :providers="providers" title="Welcome back" align="top"
      icon="i-heroicons-lock-closed" :ui="{ base: 'text-center', footer: 'text-center' }"
      :submit-button="{ trailingIcon: 'i-heroicons-arrow-right-20-solid' }" @submit="signInWithPassword">
      <template #description>
        Don't have an account? <NuxtLink to="/signup" class="text-primary font-medium">Sign up</NuxtLink>.
      </template>

      <template #password-hint>
        <NuxtLink to="/passwordreset" class="text-primary font-medium">Forgot password?</NuxtLink>
      </template>

      <template #footer>
        <div class="flex items-center justify-between mb-12" v-if="errorMsg">
          <div class="flex items-center">
            <a class="font-medium no-underline ml-2 text-red text-right cursor-pointer">{{ errorMsg }}</a>
          </div>
        </div>
      </template>
    </UAuthForm>
  </UCard>
</template>
