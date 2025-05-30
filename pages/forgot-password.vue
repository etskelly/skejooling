<template>
  <div class="bg-surface-50 dark:bg-surface-950 px-6 py-20 md:px-12 lg:px-20">
    <div class="bg-surface-0 dark:bg-surface-900 p-6 shadow rounded-border w-full lg:w-6/12 mx-auto">
      <div class="text-center mb-8">
        <div class="flex justify-center mb-8">
          <img alt="Logo" src="/skejool_logo_new.png" width="250" class="mx-auto" />
        </div>
        <div class="text-surface-900 dark:text-surface-0 text-3xl font-medium mb-4">Forgot Password</div>
        <span class="text-surface-600 dark:text-surface-200 font-medium leading-normal">Remembered your password?</span>

        <NuxtLink to="/login">
          <p class="font-medium no-underline ml-2 text-primary cursor-pointer">Sign In</p>
        </NuxtLink>
      </div>

      <div>
        <form @submit.prevent="forgotPassword">
          <label for="email1" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Email</label>
          <InputText id="email1" v-model="email" :invalid="!!errorMsg" type="email" placeholder="Email address"
            class="w-full mb-4" />

          <div class="flex items-center justify-between mb-12" v-if="errorMsg">
            <div class="flex items-center">
              <a class="font-medium no-underline ml-2 text-red text-right cursor-pointer">{{ errorMsg }}</a>
            </div>
          </div>

          <div class="flex items-center justify-between mb-12" v-if="msg">
            <div class="flex items-center">
              <a class="font-medium no-underline ml-2 text-green text-right cursor-pointer">{{ msg }}</a>
            </div>
          </div>

          <Button label="Send Password Reset" type="submit" icon="pi pi-envelope" class="w-full" />
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const supabase = useSupabaseClient();
const email = ref('');
const errorMsg = ref(null);
const msg = ref('');

const forgotPassword = async () => {
  try {
    const { data, error } = await supabase.auth.resetPasswordForEmail(email.value, {
      redirectTo: `${window.location.origin}/update-password`
    });

    if (error) {
      throw error;
    } else {
      msg.value = "Check your email";
    }
  } catch (error) {
    errorMsg.value = error.message || error.fullMessage;
  }
};
</script>