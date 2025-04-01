-- Function to get the current tenant ID for a user
CREATE OR REPLACE FUNCTION get_current_tenant_id()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  org_id INTEGER;
BEGIN
  -- Get the organizationId from the UserDetails table for the current user
  SELECT ud.organizationId INTO org_id
  FROM "UserDetails" ud
  WHERE ud.authid = auth.uid()
  LIMIT 1;
  
  -- If no organizationId is found, raise an exception
  IF org_id IS NULL THEN
    RAISE EXCEPTION 'No organization associated with the current user';
  END IF;
  
  RETURN org_id;
END;
$$;

-- Function to automatically set tenant_id on insert
CREATE OR REPLACE FUNCTION set_tenant_id_on_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Only set tenant_id if it's not already set
  IF NEW.tenant_id IS NULL THEN
    NEW.tenant_id := get_current_tenant_id();
  END IF;
  
  RETURN NEW;
END;
$$;

-- Apply triggers to all tables with tenant_id column

-- Resources table
ALTER TABLE "Resources" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_resources_select" ON "Resources"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resources_insert" ON "Resources"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resources_update" ON "Resources"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resources_delete" ON "Resources"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_resources
  BEFORE INSERT ON "Resources"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- Services table
ALTER TABLE "Services" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_services_select" ON "Services"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_services_insert" ON "Services"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_services_update" ON "Services"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_services_delete" ON "Services"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_services
  BEFORE INSERT ON "Services"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- ResourceServices table
ALTER TABLE "ResourceServices" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_resource_services_select" ON "ResourceServices"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_services_insert" ON "ResourceServices"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_services_update" ON "ResourceServices"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_services_delete" ON "ResourceServices"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_resource_services
  BEFORE INSERT ON "ResourceServices"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- Clients table
ALTER TABLE "Clients" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_clients_select" ON "Clients"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_clients_insert" ON "Clients"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_clients_update" ON "Clients"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_clients_delete" ON "Clients"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_clients
  BEFORE INSERT ON "Clients"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- Appointments table
ALTER TABLE "Appointments" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_appointments_select" ON "Appointments"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointments_insert" ON "Appointments"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointments_update" ON "Appointments"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointments_delete" ON "Appointments"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_appointments
  BEFORE INSERT ON "Appointments"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- AppointmentResources table
ALTER TABLE "AppointmentResources" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_appointment_resources_select" ON "AppointmentResources"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_resources_insert" ON "AppointmentResources"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_resources_update" ON "AppointmentResources"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_resources_delete" ON "AppointmentResources"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_appointment_resources
  BEFORE INSERT ON "AppointmentResources"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- AppointmentAttendees table
ALTER TABLE "AppointmentAttendees" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_appointment_attendees_select" ON "AppointmentAttendees"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_attendees_insert" ON "AppointmentAttendees"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_attendees_update" ON "AppointmentAttendees"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_appointment_attendees_delete" ON "AppointmentAttendees"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_appointment_attendees
  BEFORE INSERT ON "AppointmentAttendees"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- ResourceAvailability table
ALTER TABLE "ResourceAvailability" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_resource_availability_select" ON "ResourceAvailability"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_availability_insert" ON "ResourceAvailability"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_availability_update" ON "ResourceAvailability"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_resource_availability_delete" ON "ResourceAvailability"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_resource_availability
  BEFORE INSERT ON "ResourceAvailability"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- Holidays table
ALTER TABLE "Holidays" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_holidays_select" ON "Holidays"
  FOR SELECT USING (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_holidays_insert" ON "Holidays"
  FOR INSERT WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_holidays_update" ON "Holidays"
  FOR UPDATE USING (tenant_id = get_current_tenant_id())
  WITH CHECK (tenant_id = get_current_tenant_id());
  
CREATE POLICY "tenant_isolation_holidays_delete" ON "Holidays"
  FOR DELETE USING (tenant_id = get_current_tenant_id());

CREATE TRIGGER set_tenant_id_holidays
  BEFORE INSERT ON "Holidays"
  FOR EACH ROW
  EXECUTE FUNCTION set_tenant_id_on_insert();

-- Add comments to explain the multi-tenant setup
COMMENT ON FUNCTION get_current_tenant_id() IS 'Returns the current tenant ID (organizationId) for the authenticated user';
COMMENT ON FUNCTION set_tenant_id_on_insert() IS 'Automatically sets the tenant_id on insert if not provided';

-- Note: In this system, tenant_id refers to the organizationId from the Organizations table.
-- The get_current_tenant_id() function retrieves the organizationId from UserDetails for the current user.
-- This allows for multi-tenancy where users can only access data from their organization.
