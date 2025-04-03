-- Create a function to handle user creation and tenant setup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  new_tenant_id INTEGER;
  new_user_id INTEGER;
BEGIN
  -- Create a new tenant
  INSERT INTO public."Tenants" (name, createdAt, updatedAt)
  VALUES (NEW.raw_user_meta_data->>'orgname', NOW(), NOW())
  RETURNING id INTO new_tenant_id;

  -- Create a new user profile in UserDetails
  INSERT INTO public."UserDetails" (
    email,
    authid,
    name,
    createdAt,
    updatedAt,
    tenantId
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

  -- Update the auth.users metadata with the tenant ID
  UPDATE auth.users
  SET raw_user_meta_data = raw_user_meta_data || 
    jsonb_build_object(
      'tenantId', new_tenant_id,
      'userDetailsId', new_user_id
    )
  WHERE id = NEW.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a trigger to run the function when a new user is created
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO authenticated;
GRANT EXECUTE ON FUNCTION public.handle_new_user() TO service_role; 