// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },

  modules: [
    '@nuxt/fonts',
    '@nuxt/icon',
    '@nuxt/image',
    '@nuxt/scripts',
    '@nuxt/test-utils',
    '@nuxt/ui-pro',
    '@nuxt/content',
    '@nuxt/eslint',
    '@nuxtjs/supabase',
    '@pinia/nuxt',
    'dayjs-nuxt',
    '@unlok-co/nuxt-stripe',
    '@nuxt/icon',
    '@vueuse/nuxt',
  ],

  css: ["@/assets/main.css"]
})