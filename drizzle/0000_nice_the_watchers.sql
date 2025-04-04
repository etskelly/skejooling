-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE TABLE "Addresses" (
	"id" serial PRIMARY KEY NOT NULL,
	"line1" text NOT NULL,
	"line2" text,
	"town" text NOT NULL,
	"county" text,
	"country" text,
	"postcode" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "Appointments" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"startTime" timestamp(3) NOT NULL,
	"endTime" timestamp(3) NOT NULL,
	"status" text DEFAULT 'scheduled' NOT NULL,
	"notes" text,
	"color" text,
	"isAllDay" boolean DEFAULT false NOT NULL,
	"isRecurring" boolean DEFAULT false NOT NULL,
	"recurrenceRule" text,
	"tenantId" integer NOT NULL,
	"teamId" integer,
	"serviceId" integer,
	"clientId" integer,
	"createdById" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "Appointments" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Clients" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"email" text,
	"phone" text,
	"notes" text,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "Clients" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Holidays" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"startDate" timestamp(3) NOT NULL,
	"endDate" timestamp(3) NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "Holidays" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Location" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"parentId" integer,
	"tenantId" integer
);
--> statement-breakpoint
CREATE TABLE "Tenants" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE TABLE "Person" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"email" text NOT NULL,
	"tenantId" integer
);
--> statement-breakpoint
CREATE TABLE "ResourceAvailability" (
	"id" serial PRIMARY KEY NOT NULL,
	"resourceId" integer NOT NULL,
	"dayOfWeek" integer,
	"specificDate" timestamp(3),
	"startTime" time NOT NULL,
	"endTime" time NOT NULL,
	"isAvailable" boolean DEFAULT true NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "ResourceAvailability" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Resources" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"type" text NOT NULL,
	"description" text,
	"capacity" integer,
	"color" text,
	"isActive" boolean DEFAULT true NOT NULL,
	"tenantId" integer NOT NULL,
	"locationId" integer,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "Resources" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Roles" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "Services" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"duration" integer NOT NULL,
	"color" text,
	"price" numeric(10, 2),
	"isActive" boolean DEFAULT true NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL
);
--> statement-breakpoint
ALTER TABLE "Services" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "Teams" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"slug" text NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"tenantId" integer
);
--> statement-breakpoint
CREATE TABLE "UserDetails" (
	"id" serial PRIMARY KEY NOT NULL,
	"email" text NOT NULL,
	"authid" text NOT NULL,
	"name" text,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"roleId" integer,
	"tenantId" integer,
	"teamId" integer
);
--> statement-breakpoint
CREATE TABLE "_PersonLocations" (
	"A" integer NOT NULL,
	"B" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "TimeBoxes" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" text NOT NULL,
	"from" timestamp(3) NOT NULL,
	"to" timestamp(3) NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) NOT NULL,
	"type" integer DEFAULT 0 NOT NULL,
	"notes" text,
	"halfDayFrom" boolean,
	"halfDayTo" boolean,
	"tenantId" integer NOT NULL
);
--> statement-breakpoint
ALTER TABLE "TimeBoxes" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "PersonLocation" (
	"personId" integer NOT NULL,
	"locationId" integer NOT NULL,
	CONSTRAINT "PersonLocation_pkey" PRIMARY KEY("personId","locationId")
);
--> statement-breakpoint
CREATE TABLE "AppointmentResources" (
	"appointmentId" integer NOT NULL,
	"resourceId" integer NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "AppointmentResources_pkey" PRIMARY KEY("appointmentId","resourceId")
);
--> statement-breakpoint
ALTER TABLE "AppointmentResources" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "ResourceServices" (
	"resourceId" integer NOT NULL,
	"serviceId" integer NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "ResourceServices_pkey" PRIMARY KEY("resourceId","serviceId")
);
--> statement-breakpoint
ALTER TABLE "ResourceServices" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
CREATE TABLE "AppointmentAttendees" (
	"appointmentId" integer NOT NULL,
	"personId" integer NOT NULL,
	"role" text DEFAULT 'attendee' NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"tenantId" integer NOT NULL,
	"createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT "AppointmentAttendees_pkey" PRIMARY KEY("appointmentId","personId")
);
--> statement-breakpoint
ALTER TABLE "AppointmentAttendees" ENABLE ROW LEVEL SECURITY;--> statement-breakpoint
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "public"."Clients"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "public"."UserDetails"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "public"."Teams"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Clients" ADD CONSTRAINT "Clients_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Holidays" ADD CONSTRAINT "Holidays_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Location" ADD CONSTRAINT "Location_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Location" ADD CONSTRAINT "Location_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "public"."Location"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Person" ADD CONSTRAINT "Person_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "ResourceAvailability" ADD CONSTRAINT "ResourceAvailability_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Resources" ADD CONSTRAINT "Resources_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Resources" ADD CONSTRAINT "Resources_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."Location"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Services" ADD CONSTRAINT "Services_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "Teams" ADD CONSTRAINT "Teams_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "UserDetails" ADD CONSTRAINT "UserDetails_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "UserDetails" ADD CONSTRAINT "UserDetails_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."Roles"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "UserDetails" ADD CONSTRAINT "UserDetails_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "public"."Teams"("id") ON DELETE set null ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "_PersonLocations" ADD CONSTRAINT "_PersonLocations_A_fkey" FOREIGN KEY ("A") REFERENCES "public"."Location"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "_PersonLocations" ADD CONSTRAINT "_PersonLocations_B_fkey" FOREIGN KEY ("B") REFERENCES "public"."Person"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "TimeBoxes" ADD CONSTRAINT "TimeBoxes_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "PersonLocation" ADD CONSTRAINT "PersonLocation_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."Location"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "PersonLocation" ADD CONSTRAINT "PersonLocation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "public"."Person"("id") ON DELETE restrict ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "AppointmentResources" ADD CONSTRAINT "AppointmentResources_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."Appointments"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "AppointmentResources" ADD CONSTRAINT "AppointmentResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "ResourceServices" ADD CONSTRAINT "ResourceServices_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "ResourceServices" ADD CONSTRAINT "ResourceServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "AppointmentAttendees" ADD CONSTRAINT "AppointmentAttendees_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."Appointments"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
ALTER TABLE "AppointmentAttendees" ADD CONSTRAINT "AppointmentAttendees_personId_fkey" FOREIGN KEY ("personId") REFERENCES "public"."Person"("id") ON DELETE cascade ON UPDATE cascade;--> statement-breakpoint
CREATE INDEX "Appointments_clientId_idx" ON "Appointments" USING btree ("clientId" int4_ops);--> statement-breakpoint
CREATE INDEX "Appointments_createdById_idx" ON "Appointments" USING btree ("createdById" int4_ops);--> statement-breakpoint
CREATE INDEX "Appointments_serviceId_idx" ON "Appointments" USING btree ("serviceId" int4_ops);--> statement-breakpoint
CREATE INDEX "Appointments_startTime_endTime_idx" ON "Appointments" USING btree ("startTime" timestamp_ops,"endTime" timestamp_ops);--> statement-breakpoint
CREATE INDEX "Appointments_teamId_idx" ON "Appointments" USING btree ("teamId" int4_ops);--> statement-breakpoint
CREATE INDEX "Appointments_tenantId_idx" ON "Appointments" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "Clients_email_tenantId_key" ON "Clients" USING btree ("email" int4_ops,"tenantId" text_ops) WHERE (email IS NOT NULL);--> statement-breakpoint
CREATE UNIQUE INDEX "Clients_phone_tenantId_key" ON "Clients" USING btree ("phone" text_ops,"tenantId" int4_ops) WHERE (phone IS NOT NULL);--> statement-breakpoint
CREATE INDEX "Clients_tenantId_idx" ON "Clients" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE INDEX "Holidays_startDate_endDate_idx" ON "Holidays" USING btree ("startDate" timestamp_ops,"endDate" timestamp_ops);--> statement-breakpoint
CREATE INDEX "Holidays_tenantId_idx" ON "Holidays" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "Person_email_key" ON "Person" USING btree ("email" text_ops);--> statement-breakpoint
CREATE INDEX "ResourceAvailability_dayOfWeek_idx" ON "ResourceAvailability" USING btree ("dayOfWeek" int4_ops);--> statement-breakpoint
CREATE INDEX "ResourceAvailability_resourceId_idx" ON "ResourceAvailability" USING btree ("resourceId" int4_ops);--> statement-breakpoint
CREATE INDEX "ResourceAvailability_specificDate_idx" ON "ResourceAvailability" USING btree ("specificDate" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ResourceAvailability_tenantId_idx" ON "ResourceAvailability" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE INDEX "Resources_locationId_idx" ON "Resources" USING btree ("locationId" int4_ops);--> statement-breakpoint
CREATE INDEX "Resources_tenantId_idx" ON "Resources" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "Roles_name_key" ON "Roles" USING btree ("name" text_ops);--> statement-breakpoint
CREATE INDEX "Services_tenantId_idx" ON "Services" USING btree ("tenantId" int4_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "UserDetails_authid_key" ON "UserDetails" USING btree ("authid" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "UserDetails_email_key" ON "UserDetails" USING btree ("email" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "_PersonLocations_AB_unique" ON "_PersonLocations" USING btree ("A" int4_ops,"B" int4_ops);--> statement-breakpoint
CREATE INDEX "_PersonLocations_B_index" ON "_PersonLocations" USING btree ("B" int4_ops);--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointments_delete" ON "Appointments" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointments_insert" ON "Appointments" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointments_select" ON "Appointments" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointments_update" ON "Appointments" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_clients_delete" ON "Clients" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_clients_insert" ON "Clients" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_clients_select" ON "Clients" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_clients_update" ON "Clients" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_holidays_delete" ON "Holidays" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_holidays_insert" ON "Holidays" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_holidays_select" ON "Holidays" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_holidays_update" ON "Holidays" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_availability_delete" ON "ResourceAvailability" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_availability_insert" ON "ResourceAvailability" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_availability_select" ON "ResourceAvailability" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_availability_update" ON "ResourceAvailability" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resources_delete" ON "Resources" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_resources_insert" ON "Resources" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resources_select" ON "Resources" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resources_update" ON "Resources" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_services_delete" ON "Services" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_services_insert" ON "Services" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_services_select" ON "Services" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_services_update" ON "Services" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_timeboxes_delete" ON "TimeBoxes" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_timeboxes_insert" ON "TimeBoxes" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_timeboxes_select" ON "TimeBoxes" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_timeboxes_update" ON "TimeBoxes" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_resources_delete" ON "AppointmentResources" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_resources_insert" ON "AppointmentResources" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_resources_select" ON "AppointmentResources" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_resources_update" ON "AppointmentResources" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_services_delete" ON "ResourceServices" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_services_insert" ON "ResourceServices" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_services_select" ON "ResourceServices" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_resource_services_update" ON "ResourceServices" AS PERMISSIVE FOR UPDATE TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_attendees_delete" ON "AppointmentAttendees" AS PERMISSIVE FOR DELETE TO public USING (("tenantId" = get_current_tenant_id()));--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_attendees_insert" ON "AppointmentAttendees" AS PERMISSIVE FOR INSERT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_attendees_select" ON "AppointmentAttendees" AS PERMISSIVE FOR SELECT TO public;--> statement-breakpoint
CREATE POLICY "tenant_isolation_appointment_attendees_update" ON "AppointmentAttendees" AS PERMISSIVE FOR UPDATE TO public;
*/