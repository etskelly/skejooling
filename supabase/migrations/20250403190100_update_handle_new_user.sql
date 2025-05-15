-- Update handle_new_user function to include Stripe customer creation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
AS $$
DECLARE
  new_tenant_id INTEGER;
  new_user_id INTEGER;
  stripe_customer_id TEXT;
BEGIN
  -- Create a new tenant
  INSERT INTO public."Tenants" (name, "createdAt", "updatedAt")
  VALUES (NEW.raw_user_meta_data->>'orgname', NOW(), NOW())
  RETURNING id INTO new_tenant_id;

  -- Create a new user profile in UserDetails
  INSERT INTO public."UserDetails" (
    email,
    authid,
    name,
    "createdAt",
    "updatedAt",
    "tenantId"
  )
  VALUES (
    NEW.email,
    NEW.id,
    CONCAT(NEW.raw_user_meta_data->>'forename', ' ', NEW.raw_user_meta_data->>'surname'),
    NOW(),
    NOW(),
    new_tenant_id
  )
  RETURNING id INTO new_user_id;

  -- Create Stripe customer
  SELECT stripe.create_customer(
    json_build_object(
      'email', NEW.email,
      'name', CONCAT(NEW.raw_user_meta_data->>'forename', ' ', NEW.raw_user_meta_data->>'surname'),
      'metadata', json_build_object(
        'tenantId', new_tenant_id,
        'userId', new_user_id
      )
    )
  ) INTO stripe_customer_id;

  -- Create initial subscription record
  INSERT INTO public."Subscriptions" (
    "tenantId",
    "stripeCustomerId",
    "stripeSubscriptionId",
    "status",
    "planId",
    "currentPeriodStart",
    "currentPeriodEnd"
  ) VALUES (
    new_tenant_id,
    stripe_customer_id,
    'pending',
    'trialing',
    'trial',
    NOW(),
    NOW() + INTERVAL '14 days'
  );

  -- Update the auth.users metadata
  UPDATE auth.users
  SET raw_user_meta_data = raw_user_meta_data ||
    jsonb_build_object(
      'tenantId', new_tenant_id,
      'userDetailsId', new_user_id,
      'stripeCustomerId', stripe_customer_id
    )
  WHERE id = NEW.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql; 