<script setup lang="ts">
const supabase = useSupabaseClient()
const email = ref('')
const password = ref('')

const errorMsg = ref(null)


const signInWithPassword = async () => {
  try {
    const { error } = await supabase.auth.signInWithPassword(
      {
        email: email.value,
        password: password.value
      }
    )

    if (error) {
      throw (error)
    } else {
      await navigateTo('/')
    }
  } catch (error) {
    errorMsg.value = errorMsg.value = error.message || error.fullMessage
    // Handle the error as needed
  }
}

const signInWithOtp = async () => {
  debugger
  const { error } = await supabase.auth.signInWithOtp({
    email: email.value,
    options: {
      emailRedirectTo: 'http://localhost:3000/confirm',
    }
  })
  debugger
  if (error) console.log(error)
}
</script>
<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
      <h2 class="text-2xl font-bold text-center text-black">Login</h2>
      <form @submit.prevent="signInWithPassword">
        <div class="form-control">
          <label class="label">
            <span class="label-text">Email</span>
          </label>
          <input v-model="email" type="email" placeholder="Email" class="input input-bordered w-full text-black" />
        </div>
        <div class="form-control">
          <label class="label">
            <span class="label-text">Password</span>
          </label>
          <input v-model="password" type="password" placeholder="Password"
            class="input input-bordered w-full text-black" />
        </div>
        <div class="form-control mt-6" v-if="errorMsg">
          <div class="text-red-500 text-sm">{{ errorMsg }}</div>
        </div>
        <div class="form-control mt-6">
          <button type="submit" class="btn btn-primary w-full">Login</button>
        </div>
      </form>
    </div>
  </div>
</template>