export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser()
  const isAuthPage = to.path.match(/^\/(login|signup|passwordreset)/)
  const isPublicPage = to.path === '/' || to.path === '/about' || to.path === '/contact'
  const isProtectedPage = !isAuthPage && !isPublicPage

  // If user is authenticated and trying to access auth pages, redirect to dashboard
  if (user.value && isAuthPage) {
    return navigateTo('/dashboard')
  }

  // If user is not authenticated and trying to access protected pages, redirect to login
  if (!user.value && isProtectedPage) {
    return navigateTo('/login')
  }
}) 