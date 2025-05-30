import { useSupabaseUser, useSupabaseClient } from '#imports'

interface UserDetails {
  tenantId: string
}

interface CheckoutResponse {
  url: string
}

export const useSubscription = () => {
  const user = useSupabaseUser()
  const supabase = useSupabaseClient()
  const config = useRuntimeConfig()

  const createSubscription = async (priceId: string) => {
    if (!user.value) {
      throw new Error('User must be logged in to create a subscription')
    }

    try {
      // Get the user's tenant ID from UserDetails
      const { data: userDetails, error: userDetailsError } = await supabase
        .from('UserDetails')
        .select('tenantId')
        .eq('userId', user.value.id)
        .single()

      if (userDetailsError) {
        throw new Error('Failed to get user details')
      }

      const typedUserDetails = userDetails as UserDetails | null
      if (!typedUserDetails?.tenantId) {
        throw new Error('User is not associated with a tenant')
      }

      // Create a Stripe checkout session
      const response = await $fetch<CheckoutResponse>('/api/create-checkout-session', {
        method: 'POST',
        body: {
          priceId,
          tenantId: typedUserDetails.tenantId,
          userId: user.value.id,
          email: user.value.email
        }
      })

      // Redirect to Stripe Checkout
      if (response.url) {
        window.location.href = response.url
      } else {
        throw new Error('Failed to create checkout session')
      }
    } catch (error) {
      console.error('Error creating subscription:', error)
      throw error
    }
  }

  const getCurrentSubscription = async () => {
    if (!user.value) {
      throw new Error('User must be logged in to get subscription details')
    }

    try {
      const { data: userDetails, error: userDetailsError } = await supabase
        .from('UserDetails')
        .select('tenantId')
        .eq('userId', user.value.id)
        .single()

      if (userDetailsError) {
        throw new Error('Failed to get user details')
      }

      const typedUserDetails = userDetails as UserDetails | null
      if (!typedUserDetails?.tenantId) {
        throw new Error('User is not associated with a tenant')
      }

      const { data: subscription, error: subscriptionError } = await supabase
        .from('Subscriptions')
        .select('*')
        .eq('tenantId', typedUserDetails.tenantId)
        .eq('status', 'active')
        .single()

      if (subscriptionError) {
        throw new Error('Failed to get subscription details')
      }

      return subscription
    } catch (error) {
      console.error('Error getting subscription:', error)
      throw error
    }
  }

  return {
    createSubscription,
    getCurrentSubscription
  }
} 