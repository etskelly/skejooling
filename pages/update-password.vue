<script setup lang="ts">
const supabase = useSupabaseClient()
const password = ref('')
const passwordConfirmation = ref('')
const errorMsg = ref(null)

const msg = ref('')

const updatePassword = async () => {
  try {
    const { data, error } = await supabase.auth.updateUser({
      password: password.value
    })

    if (error) {
      throw (error)
    } else {
      msg.value = "Success, please login now"
      await navigateTo('/login')
    }
  } catch (error) {
    errorMsg.value = errorMsg.value = error.message || error.fullMessage
  }
}

</script>
<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
      <h2 class="text-2xl font-bold text-center text-black">Update Password</h2>
      <form @submit.prevent="updatePassword">
        <div class="form-control">
          <label class="label">
            <span class="label-text">Password</span>
          </label>
          <input v-model="password" type="password" placeholder="Password"
            class="input input-bordered w-full text-black" />
        </div>
        <div class="form-control">
          <label class="label">
            <span class="label-text">Confirm Password</span>
          </label>
          <input v-model="passwordConfirmation" type="password" placeholder="Confirm Password"
            class="input input-bordered w-full text-black" />
        </div>

        <div class="form-control mt-6" v-if="errorMsg">
          <div class="text-red-500 text-sm">{{ errorMsg }}</div>
        </div>

        <div class="form-control mt-6" v-if="msg">
          <div class="text-green-500 text-sm">{{ msg }}</div>
        </div>

        <div class="form-control mt-6">
          <button type="submit" class="btn btn-primary w-full">Change Your Password</button>
        </div>
      </form>
    </div>
  </div>
</template>