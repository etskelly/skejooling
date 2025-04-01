-- Rename column in tables
ALTER TABLE "public"."AppointmentAttendees" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."AppointmentResources" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."Appointments" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."Clients" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."Holidays" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."ResourceAvailability" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."ResourceServices" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."Resources" RENAME COLUMN "tenant_id" TO "tenantId";
ALTER TABLE "public"."Services" RENAME COLUMN "tenant_id" TO "tenantId";

-- Drop existing policies
DROP POLICY IF EXISTS "tenant_isolation_appointment_attendees_delete" ON "public"."AppointmentAttendees";
DROP POLICY IF EXISTS "tenant_isolation_appointment_attendees_insert" ON "public"."AppointmentAttendees";
DROP POLICY IF EXISTS "tenant_isolation_appointment_attendees_select" ON "public"."AppointmentAttendees";
DROP POLICY IF EXISTS "tenant_isolation_appointment_attendees_update" ON "public"."AppointmentAttendees";

DROP POLICY IF EXISTS "tenant_isolation_appointment_resources_delete" ON "public"."AppointmentResources";
DROP POLICY IF EXISTS "tenant_isolation_appointment_resources_insert" ON "public"."AppointmentResources";
DROP POLICY IF EXISTS "tenant_isolation_appointment_resources_select" ON "public"."AppointmentResources";
DROP POLICY IF EXISTS "tenant_isolation_appointment_resources_update" ON "public"."AppointmentResources";

DROP POLICY IF EXISTS "tenant_isolation_appointments_delete" ON "public"."Appointments";
DROP POLICY IF EXISTS "tenant_isolation_appointments_insert" ON "public"."Appointments";
DROP POLICY IF EXISTS "tenant_isolation_appointments_select" ON "public"."Appointments";
DROP POLICY IF EXISTS "tenant_isolation_appointments_update" ON "public"."Appointments";

DROP POLICY IF EXISTS "tenant_isolation_clients_delete" ON "public"."Clients";
DROP POLICY IF EXISTS "tenant_isolation_clients_insert" ON "public"."Clients";
DROP POLICY IF EXISTS "tenant_isolation_clients_select" ON "public"."Clients";
DROP POLICY IF EXISTS "tenant_isolation_clients_update" ON "public"."Clients";

DROP POLICY IF EXISTS "tenant_isolation_holidays_delete" ON "public"."Holidays";
DROP POLICY IF EXISTS "tenant_isolation_holidays_insert" ON "public"."Holidays";
DROP POLICY IF EXISTS "tenant_isolation_holidays_select" ON "public"."Holidays";
DROP POLICY IF EXISTS "tenant_isolation_holidays_update" ON "public"."Holidays";

DROP POLICY IF EXISTS "tenant_isolation_resource_availability_delete" ON "public"."ResourceAvailability";
DROP POLICY IF EXISTS "tenant_isolation_resource_availability_insert" ON "public"."ResourceAvailability";
DROP POLICY IF EXISTS "tenant_isolation_resource_availability_select" ON "public"."ResourceAvailability";
DROP POLICY IF EXISTS "tenant_isolation_resource_availability_update" ON "public"."ResourceAvailability";

DROP POLICY IF EXISTS "tenant_isolation_resource_services_delete" ON "public"."ResourceServices";
DROP POLICY IF EXISTS "tenant_isolation_resource_services_insert" ON "public"."ResourceServices";
DROP POLICY IF EXISTS "tenant_isolation_resource_services_select" ON "public"."ResourceServices";
DROP POLICY IF EXISTS "tenant_isolation_resource_services_update" ON "public"."ResourceServices";

DROP POLICY IF EXISTS "tenant_isolation_resources_delete" ON "public"."Resources";
DROP POLICY IF EXISTS "tenant_isolation_resources_insert" ON "public"."Resources";
DROP POLICY IF EXISTS "tenant_isolation_resources_select" ON "public"."Resources";
DROP POLICY IF EXISTS "tenant_isolation_resources_update" ON "public"."Resources";

DROP POLICY IF EXISTS "tenant_isolation_services_delete" ON "public"."Services";
DROP POLICY IF EXISTS "tenant_isolation_services_insert" ON "public"."Services";
DROP POLICY IF EXISTS "tenant_isolation_services_select" ON "public"."Services";
DROP POLICY IF EXISTS "tenant_isolation_services_update" ON "public"."Services";

-- Drop existing triggers
DROP TRIGGER IF EXISTS "set_tenant_id_appointment_attendees" ON "public"."AppointmentAttendees";
DROP TRIGGER IF EXISTS "set_tenant_id_appointment_resources" ON "public"."AppointmentResources";
DROP TRIGGER IF EXISTS "set_tenant_id_appointments" ON "public"."Appointments";
DROP TRIGGER IF EXISTS "set_tenant_id_clients" ON "public"."Clients";
DROP TRIGGER IF EXISTS "set_tenant_id_holidays" ON "public"."Holidays";
DROP TRIGGER IF EXISTS "set_tenant_id_resource_availability" ON "public"."ResourceAvailability";
DROP TRIGGER IF EXISTS "set_tenant_id_resource_services" ON "public"."ResourceServices";
DROP TRIGGER IF EXISTS "set_tenant_id_resources" ON "public"."Resources";
DROP TRIGGER IF EXISTS "set_tenant_id_services" ON "public"."Services";

-- Drop existing function
DROP FUNCTION IF EXISTS "public"."set_tenant_id_on_insert"();

-- Create new function with updated name
CREATE OR REPLACE FUNCTION "public"."set_tenant_id_on_insert"() 
RETURNS "trigger" LANGUAGE "plpgsql" SECURITY DEFINER AS $$
BEGIN
  -- Only set tenantId if it's not already set
  IF NEW."tenantId" IS NULL THEN
    NEW."tenantId" := get_current_tenant_id();
  END IF;
  
  RETURN NEW;
END;
$$;

-- Create new triggers
CREATE TRIGGER "set_tenant_id_appointment_attendees" BEFORE INSERT ON "public"."AppointmentAttendees" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_appointment_resources" BEFORE INSERT ON "public"."AppointmentResources" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_appointments" BEFORE INSERT ON "public"."Appointments" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_clients" BEFORE INSERT ON "public"."Clients" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_holidays" BEFORE INSERT ON "public"."Holidays" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_resource_availability" BEFORE INSERT ON "public"."ResourceAvailability" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_resource_services" BEFORE INSERT ON "public"."ResourceServices" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_resources" BEFORE INSERT ON "public"."Resources" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE TRIGGER "set_tenant_id_services" BEFORE INSERT ON "public"."Services" 
FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

-- Create new policies with updated column name
CREATE POLICY "tenant_isolation_appointment_attendees_delete" ON "public"."AppointmentAttendees" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_attendees_insert" ON "public"."AppointmentAttendees" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_attendees_select" ON "public"."AppointmentAttendees" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_attendees_update" ON "public"."AppointmentAttendees" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_resources_delete" ON "public"."AppointmentResources" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_resources_insert" ON "public"."AppointmentResources" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_resources_select" ON "public"."AppointmentResources" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointment_resources_update" ON "public"."AppointmentResources" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointments_delete" ON "public"."Appointments" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointments_insert" ON "public"."Appointments" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointments_select" ON "public"."Appointments" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_appointments_update" ON "public"."Appointments" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_clients_delete" ON "public"."Clients" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_clients_insert" ON "public"."Clients" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_clients_select" ON "public"."Clients" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_clients_update" ON "public"."Clients" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_holidays_delete" ON "public"."Holidays" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_holidays_insert" ON "public"."Holidays" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_holidays_select" ON "public"."Holidays" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_holidays_update" ON "public"."Holidays" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_availability_delete" ON "public"."ResourceAvailability" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_availability_insert" ON "public"."ResourceAvailability" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_availability_select" ON "public"."ResourceAvailability" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_availability_update" ON "public"."ResourceAvailability" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_services_delete" ON "public"."ResourceServices" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_services_insert" ON "public"."ResourceServices" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_services_select" ON "public"."ResourceServices" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resource_services_update" ON "public"."ResourceServices" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resources_delete" ON "public"."Resources" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resources_insert" ON "public"."Resources" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resources_select" ON "public"."Resources" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_resources_update" ON "public"."Resources" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_services_delete" ON "public"."Services" 
FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_services_insert" ON "public"."Services" 
FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_services_select" ON "public"."Services" 
FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));

CREATE POLICY "tenant_isolation_services_update" ON "public"."Services" 
FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) 
WITH CHECK (("tenantId" = "public"."get_current_tenant_id"())); 