<template>
  <div class="bg-surface-50 dark:bg-surface-950 px-6 py-20 md:px-12 lg:px-20">
    <div class="bg-surface-0 dark:bg-surface-900 p-6 shadow rounded-border w-full lg:w-6/12 mx-auto">
      <div class="text-center mb-8">
          <div class="flex justify-center mb-8">
            <Image alt="Logo" src="/skejool_logo_new.png" width="250" class="mx-auto" />
          </div>
        <div class="text-surface-900 dark:text-surface-0 text-3xl font-medium mb-4">Register</div>
        <span class="text-surface-600 dark:text-surface-200 font-medium leading-normal">Already have an account?</span>
        <NuxtLink to="/login">
          <p class="font-medium no-underline ml-2 text-primary cursor-pointer">Login Here!</p>
        </NuxtLink>
      </div>

      <div>
        <form @submit.prevent="signUp">
          <label for="email" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Email</label>
          <InputText id="email" v-model="email" type="email" placeholder="Email address" class="w-full mb-4" />

          <label for="forename" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Forename</label>
          <InputText id="forename" v-model="forename" placeholder="Forename" class="w-full mb-4" />

          <label for="surname" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Surname</label>
          <InputText id="surname" v-model="surname" placeholder="Surname" class="w-full mb-4" />

          <label for="orgName" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Business Name</label>
          <InputText id="orgName" v-model="orgName" placeholder="Organisation" class="w-full mb-4" />

          <label for="password" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Password</label>
          <InputText id="password" v-model="password" type="password" placeholder="Password" class="w-full mb-4" />

          <label for="passwordConfirmation" class="text-surface-900 dark:text-surface-0 font-medium mb-2 block">Confirm Password</label>
          <InputText id="passwordConfirmation" v-model="passwordConfirmation" type="password" placeholder="Confirm Password" class="w-full mb-4" />

          <div class="flex items-center justify-between mb-12" v-if="authError">
            <div class="flex items-center">
              <a class="font-medium no-underline ml-2 text-red text-right cursor-pointer">{{ authError }}</a>
            </div>
          </div>

          <div class="flex items-center justify-between mb-12" v-if="authMsg">
            <div class="flex items-center">
              <a class="font-medium no-underline ml-2 text-green text-right cursor-pointer">{{ authMsg }}</a>
            </div>
          </div>

          <Button label="Sign Up" type="submit" icon="pi pi-user" class="w-full" :disabled="loading" />
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import Image from 'primevue/image';

const client = useSupabaseClient();

const email = ref('');
const password = ref('');
const passwordConfirmation = ref('');
const orgName = ref('');
const forename = ref('');
const surname = ref('');

const loading = ref(false);

const authError = ref('');
const authMsg = ref('');

const signUp = async () => {
  loading.value = true;
  try {
    const { error, data } = await client.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        data: {
          forename: forename.value,
          surname: surname.value,
          orgname: orgName.value,
          status: 'exists'
        },
      },
    });

    if (error) {
      throw error;
    } else {
      loading.value = false;
      authMsg.value = "Registered Successfully";
    }
  } catch (e) {
    loading.value = false;
    authError.value = e.fullMessage;
  }
};
</script>