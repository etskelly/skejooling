export default defineNuxtRouteMiddleware(async (to) => {
  const user = useSupabaseUser()
  const supabase = useSupabaseClient()

  // Skip middleware for subscription page and auth pages
  if (to.path === '/subscription' || to.path.startsWith('/auth')) {
    return
  }

  // If no user, allow access (auth middleware will handle redirect)
  if (!user.value) {
    return
  }

  try {
    // Check if user has an active subscription
    const { data: subscription } = await supabase
      .from('Subscriptions')
      .select('*')
      .eq('status', 'active')
      .single()

    // If no active subscription and not on subscription page, redirect
    if (!subscription && to.path !== '/subscription') {
      return navigateTo('/subscription')
    }
  } catch (error) {
    console.error('Error checking subscription:', error)
  }
}) 