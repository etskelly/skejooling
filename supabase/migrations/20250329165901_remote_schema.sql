SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgsodium";
COMMENT ON SCHEMA "public" IS 'standard public schema';
CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE OR REPLACE FUNCTION "public"."get_current_tenant_id"() RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  tenant_id INTEGER;
BEGIN
  -- Get the tenantId from the UserDetails table for the current user
  SELECT ud.tenantId INTO tenant_id
  FROM "UserDetails" ud
  WHERE ud.authid = auth.uid()
  LIMIT 1;
  
  -- If no tenantId is found, raise an exception
  IF tenant_id IS NULL THEN
    RAISE EXCEPTION 'No tenant associated with the current user';
  END IF;
  
  RETURN tenant_id;
END;
$$;

ALTER FUNCTION "public"."get_current_tenant_id"() OWNER TO "postgres";
COMMENT ON FUNCTION "public"."get_current_tenant_id"() IS 'Returns the current tenant ID (tenantId) for the authenticated user';

CREATE OR REPLACE FUNCTION "public"."set_tenant_id_on_insert"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  -- Only set tenant_id if it's not already set
  IF NEW.tenantId IS NULL THEN
    NEW.tenantId := get_current_tenant_id();
  END IF;
  
  RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."set_tenant_id_on_insert"() OWNER TO "postgres";
COMMENT ON FUNCTION "public"."set_tenant_id_on_insert"() IS 'Automatically sets the tenant_id on insert if not provided';

SET default_tablespace = '';
SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."Addresses" (
    "id" integer NOT NULL,
    "line1" "text" NOT NULL,
    "line2" "text",
    "town" "text" NOT NULL,
    "county" "text",
    "country" "text",
    "postcode" "text" NOT NULL
);

ALTER TABLE "public"."Addresses" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."AddressesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."AddressesId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."AddressesId_seq" OWNED BY "public"."Addresses"."id";

CREATE TABLE IF NOT EXISTS "public"."AppointmentAttendees" (
    "appointmentId" integer NOT NULL,
    "personId" integer NOT NULL,
    "role" "text" DEFAULT 'attendee'::"text" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE "public"."AppointmentAttendees" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."AppointmentResources" (
    "appointmentId" integer NOT NULL,
    "resourceId" integer NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE "public"."AppointmentResources" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."Appointments" (
    "id" integer NOT NULL,
    "title" "text" NOT NULL,
    "startTime" timestamp(3) without time zone NOT NULL,
    "endTime" timestamp(3) without time zone NOT NULL,
    "status" "text" DEFAULT 'scheduled'::"text" NOT NULL,
    "notes" "text",
    "color" "text",
    "isAllDay" boolean DEFAULT false NOT NULL,
    "isRecurring" boolean DEFAULT false NOT NULL,
    "recurrenceRule" "text",
    "tenantId" integer NOT NULL,
    "teamId" integer,
    "serviceId" integer,
    "clientId" integer,
    "createdById" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Appointments" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."AppointmentsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."AppointmentsId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."AppointmentsId_seq" OWNED BY "public"."Appointments"."id";

CREATE TABLE IF NOT EXISTS "public"."Clients" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "email" "text",
    "phone" "text",
    "notes" "text",
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Clients" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."ClientsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."ClientsId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."ClientsId_seq" OWNED BY "public"."Clients"."id";

CREATE TABLE IF NOT EXISTS "public"."Holidays" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Holidays" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."HolidaysId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."HolidaysId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."HolidaysId_seq" OWNED BY "public"."Holidays"."id";

CREATE TABLE IF NOT EXISTS "public"."Location" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "parentId" integer,
    "tenantId" integer
);

ALTER TABLE "public"."Location" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."LocationId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."LocationId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."LocationId_seq" OWNED BY "public"."Location"."id";

CREATE TABLE IF NOT EXISTS "public"."Tenants" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE "public"."Tenants" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."TenantsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."TenantsId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."TenantsId_seq" OWNED BY "public"."Tenants"."id";

CREATE TABLE IF NOT EXISTS "public"."Person" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "email" "text" NOT NULL,
    "tenantId" integer
);

ALTER TABLE "public"."Person" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."PersonLocation" (
    "personId" integer NOT NULL,
    "locationId" integer NOT NULL
);

ALTER TABLE "public"."PersonLocation" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."PersonId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."PersonId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."PersonId_seq" OWNED BY "public"."Person"."id";

CREATE TABLE IF NOT EXISTS "public"."ResourceAvailability" (
    "id" integer NOT NULL,
    "resourceId" integer NOT NULL,
    "dayOfWeek" integer,
    "specificDate" timestamp(3) without time zone,
    "startTime" time without time zone NOT NULL,
    "endTime" time without time zone NOT NULL,
    "isAvailable" boolean DEFAULT true NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."ResourceAvailability" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."ResourceAvailabilityId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."ResourceAvailabilityId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."ResourceAvailabilityId_seq" OWNED BY "public"."ResourceAvailability"."id";

CREATE TABLE IF NOT EXISTS "public"."ResourceServices" (
    "resourceId" integer NOT NULL,
    "serviceId" integer NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

ALTER TABLE "public"."ResourceServices" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."Resources" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "type" "text" NOT NULL,
    "description" "text",
    "capacity" integer,
    "color" "text",
    "isActive" boolean DEFAULT true NOT NULL,
    "tenantId" integer NOT NULL,
    "locationId" integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Resources" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."ResourcesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."ResourcesId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."ResourcesId_seq" OWNED BY "public"."Resources"."id";

CREATE TABLE IF NOT EXISTS "public"."Roles" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Roles" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."RolesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."RolesId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."RolesId_seq" OWNED BY "public"."Roles"."id";

CREATE TABLE IF NOT EXISTS "public"."Services" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "duration" integer NOT NULL,
    "color" "text",
    "price" numeric(10,2),
    "isActive" boolean DEFAULT true NOT NULL,
    "tenantId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);

ALTER TABLE "public"."Services" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."ServicesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."ServicesId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."ServicesId_seq" OWNED BY "public"."Services"."id";

CREATE TABLE IF NOT EXISTS "public"."Teams" (
    "id" integer NOT NULL,
    "name" "text" NOT NULL,
    "slug" "text" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "tenantId" integer
);

ALTER TABLE "public"."Teams" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."TeamsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."TeamsId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."TeamsId_seq" OWNED BY "public"."Teams"."id";

CREATE TABLE IF NOT EXISTS "public"."TimeBoxes" (
    "id" integer NOT NULL,
    "title" "text" NOT NULL,
    "from" timestamp(3) without time zone NOT NULL,
    "to" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "type" integer DEFAULT 0 NOT NULL,
    "notes" "text",
    "halfDayFrom" boolean,
    "halfDayTo" boolean,
    "tenantId" integer NOT NULL
);

ALTER TABLE "public"."TimeBoxes" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."TimeBoxesId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."TimeBoxesId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."TimeBoxesId_seq" OWNED BY "public"."TimeBoxes"."id";

CREATE TABLE IF NOT EXISTS "public"."UserDetails" (
    "id" integer NOT NULL,
    "email" "text" NOT NULL,
    "authid" "text" NOT NULL,
    "name" "text",
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "roleId" integer,
    "tenantId" integer,
    "teamId" integer
);

ALTER TABLE "public"."UserDetails" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."UserDetailsId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."UserDetailsId_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."UserDetailsId_seq" OWNED BY "public"."UserDetails"."id";

CREATE TABLE IF NOT EXISTS "public"."_PersonLocations" (
    "A" integer NOT NULL,
    "B" integer NOT NULL
);

ALTER TABLE "public"."_PersonLocations" OWNER TO "postgres";

ALTER TABLE ONLY "public"."Addresses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."AddressesId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Appointments" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."AppointmentsId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Clients" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ClientsId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Holidays" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."HolidaysId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Location" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."LocationId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Tenants" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."TenantsId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Person" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."PersonId_seq"'::"regclass");

ALTER TABLE ONLY "public"."ResourceAvailability" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ResourceAvailabilityId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Resources" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ResourcesId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Roles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."RolesId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Services" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ServicesId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Teams" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."TeamsId_seq"'::"regclass");

ALTER TABLE ONLY "public"."TimeBoxes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."TimeBoxesId_seq"'::"regclass");

ALTER TABLE ONLY "public"."UserDetails" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."UserDetailsId_seq"'::"regclass");

ALTER TABLE ONLY "public"."Addresses"
    ADD CONSTRAINT "Addresses_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."AppointmentAttendees"
    ADD CONSTRAINT "AppointmentAttendees_pkey" PRIMARY KEY ("appointmentId", "personId");

ALTER TABLE ONLY "public"."AppointmentResources"
    ADD CONSTRAINT "AppointmentResources_pkey" PRIMARY KEY ("appointmentId", "resourceId");

ALTER TABLE ONLY "public"."Appointments"
    ADD CONSTRAINT "Appointments_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Clients"
    ADD CONSTRAINT "Clients_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Holidays"
    ADD CONSTRAINT "Holidays_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Location"
    ADD CONSTRAINT "Location_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Tenants"
    ADD CONSTRAINT "Tenants_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."PersonLocation"
    ADD CONSTRAINT "PersonLocation_pkey" PRIMARY KEY ("personId", "locationId");

ALTER TABLE ONLY "public"."Person"
    ADD CONSTRAINT "Person_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."ResourceAvailability"
    ADD CONSTRAINT "ResourceAvailability_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."ResourceServices"
    ADD CONSTRAINT "ResourceServices_pkey" PRIMARY KEY ("resourceId", "serviceId");

ALTER TABLE ONLY "public"."Resources"
    ADD CONSTRAINT "Resources_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Roles"
    ADD CONSTRAINT "Roles_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Services"
    ADD CONSTRAINT "Services_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Teams"
    ADD CONSTRAINT "Teams_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."TimeBoxes"
    ADD CONSTRAINT "TimeBoxes_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."UserDetails"
    ADD CONSTRAINT "UserDetails_pkey" PRIMARY KEY ("id");

CREATE INDEX "Appointments_clientId_idx" ON "public"."Appointments" USING "btree" ("clientId");

CREATE INDEX "Appointments_createdById_idx" ON "public"."Appointments" USING "btree" ("createdById");

CREATE INDEX "Appointments_serviceId_idx" ON "public"."Appointments" USING "btree" ("serviceId");

CREATE INDEX "Appointments_startTime_endTime_idx" ON "public"."Appointments" USING "btree" ("startTime", "endTime");

CREATE INDEX "Appointments_teamId_idx" ON "public"."Appointments" USING "btree" ("teamId");

CREATE INDEX "Appointments_tenantId_idx" ON "public"."Appointments" USING "btree" ("tenantId");

CREATE UNIQUE INDEX "Clients_email_tenantId_key" ON "public"."Clients" USING "btree" ("email", "tenantId") WHERE ("email" IS NOT NULL);

CREATE INDEX "Clients_tenantId_idx" ON "public"."Clients" USING "btree" ("tenantId");

CREATE UNIQUE INDEX "Clients_phone_tenantId_key" ON "public"."Clients" USING "btree" ("phone", "tenantId") WHERE ("phone" IS NOT NULL);

CREATE INDEX "Holidays_tenantId_idx" ON "public"."Holidays" USING "btree" ("tenantId");

CREATE INDEX "Holidays_startDate_endDate_idx" ON "public"."Holidays" USING "btree" ("startDate", "endDate");

CREATE UNIQUE INDEX "Person_email_key" ON "public"."Person" USING "btree" ("email");

CREATE INDEX "ResourceAvailability_dayOfWeek_idx" ON "public"."ResourceAvailability" USING "btree" ("dayOfWeek");

CREATE INDEX "ResourceAvailability_resourceId_idx" ON "public"."ResourceAvailability" USING "btree" ("resourceId");

CREATE INDEX "ResourceAvailability_specificDate_idx" ON "public"."ResourceAvailability" USING "btree" ("specificDate");

CREATE INDEX "ResourceAvailability_tenantId_idx" ON "public"."ResourceAvailability" USING "btree" ("tenantId");

CREATE INDEX "Resources_locationId_idx" ON "public"."Resources" USING "btree" ("locationId");

CREATE INDEX "Resources_tenantId_idx" ON "public"."Resources" USING "btree" ("tenantId");

CREATE UNIQUE INDEX "Roles_name_key" ON "public"."Roles" USING "btree" ("name");

CREATE INDEX "Services_tenantId_idx" ON "public"."Services" USING "btree" ("tenantId");

CREATE UNIQUE INDEX "UserDetails_authid_key" ON "public"."UserDetails" USING "btree" ("authid");

CREATE UNIQUE INDEX "UserDetails_email_key" ON "public"."UserDetails" USING "btree" ("email");

CREATE UNIQUE INDEX "_PersonLocations_AB_unique" ON "public"."_PersonLocations" USING "btree" ("A", "B");

CREATE INDEX "_PersonLocations_B_index" ON "public"."_PersonLocations" USING "btree" ("B");

CREATE OR REPLACE TRIGGER "set_tenant_id_appointment_attendees" BEFORE INSERT ON "public"."AppointmentAttendees" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_appointment_resources" BEFORE INSERT ON "public"."AppointmentResources" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_appointments" BEFORE INSERT ON "public"."Appointments" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_clients" BEFORE INSERT ON "public"."Clients" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_holidays" BEFORE INSERT ON "public"."Holidays" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_resource_availability" BEFORE INSERT ON "public"."ResourceAvailability" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_resource_services" BEFORE INSERT ON "public"."ResourceServices" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_resources" BEFORE INSERT ON "public"."Resources" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

CREATE OR REPLACE TRIGGER "set_tenant_id_services" BEFORE INSERT ON "public"."Services" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

ALTER TABLE ONLY "public"."AppointmentAttendees"
    ADD CONSTRAINT "AppointmentAttendees_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."Appointments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."AppointmentAttendees"
    ADD CONSTRAINT "AppointmentAttendees_personId_fkey" FOREIGN KEY ("personId") REFERENCES "public"."Person"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."AppointmentResources"
    ADD CONSTRAINT "AppointmentResources_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "public"."Appointments"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."AppointmentResources"
    ADD CONSTRAINT "AppointmentResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Appointments"
    ADD CONSTRAINT "Appointments_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "public"."Clients"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."Appointments"
    ADD CONSTRAINT "Appointments_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "public"."UserDetails"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."Appointments" ADD CONSTRAINT "Appointments_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Appointments"
    ADD CONSTRAINT "Appointments_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "public"."Teams"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."Clients" ADD CONSTRAINT "Clients_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Holidays" ADD CONSTRAINT "Holidays_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Location" ADD CONSTRAINT "Location_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."Location"
    ADD CONSTRAINT "Location_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "public"."Location"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."PersonLocation"
    ADD CONSTRAINT "PersonLocation_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."Location"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."PersonLocation"
    ADD CONSTRAINT "PersonLocation_personId_fkey" FOREIGN KEY ("personId") REFERENCES "public"."Person"("id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."Person" ADD CONSTRAINT "Person_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY "public"."ResourceAvailability"
    ADD CONSTRAINT "ResourceAvailability_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."ResourceServices"
    ADD CONSTRAINT "ResourceServices_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "public"."Resources"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."ResourceServices"
    ADD CONSTRAINT "ResourceServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "public"."Services"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Resources" ADD CONSTRAINT "Resources_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Resources"
    ADD CONSTRAINT "Resources_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."Location"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."Services" ADD CONSTRAINT "Services_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."Teams" ADD CONSTRAINT "Teams_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."UserDetails" ADD CONSTRAINT "UserDetails_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."UserDetails"
    ADD CONSTRAINT "UserDetails_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."Roles"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."UserDetails"
    ADD CONSTRAINT "UserDetails_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "public"."Teams"("id") ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE ONLY "public"."_PersonLocations"
    ADD CONSTRAINT "_PersonLocations_A_fkey" FOREIGN KEY ("A") REFERENCES "public"."Location"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY "public"."_PersonLocations"
    ADD CONSTRAINT "_PersonLocations_B_fkey" FOREIGN KEY ("B") REFERENCES "public"."Person"("id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "public"."AppointmentAttendees" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."AppointmentResources" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."Appointments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."Clients" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."Holidays" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ResourceAvailability" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."ResourceServices" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."Resources" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."Services" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tenant_isolation_appointment_attendees_delete" ON "public"."AppointmentAttendees" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_attendees_insert" ON "public"."AppointmentAttendees" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_attendees_select" ON "public"."AppointmentAttendees" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_attendees_update" ON "public"."AppointmentAttendees" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_resources_delete" ON "public"."AppointmentResources" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_resources_insert" ON "public"."AppointmentResources" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_resources_select" ON "public"."AppointmentResources" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointment_resources_update" ON "public"."AppointmentResources" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointments_delete" ON "public"."Appointments" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointments_insert" ON "public"."Appointments" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointments_select" ON "public"."Appointments" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_appointments_update" ON "public"."Appointments" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_clients_delete" ON "public"."Clients" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_clients_insert" ON "public"."Clients" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_clients_select" ON "public"."Clients" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_clients_update" ON "public"."Clients" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_holidays_delete" ON "public"."Holidays" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_holidays_insert" ON "public"."Holidays" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_holidays_select" ON "public"."Holidays" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_holidays_update" ON "public"."Holidays" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_availability_delete" ON "public"."ResourceAvailability" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_availability_insert" ON "public"."ResourceAvailability" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_availability_select" ON "public"."ResourceAvailability" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_availability_update" ON "public"."ResourceAvailability" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_services_delete" ON "public"."ResourceServices" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_services_insert" ON "public"."ResourceServices" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_services_select" ON "public"."ResourceServices" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resource_services_update" ON "public"."ResourceServices" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resources_delete" ON "public"."Resources" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resources_insert" ON "public"."Resources" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resources_select" ON "public"."Resources" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_resources_update" ON "public"."Resources" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_services_delete" ON "public"."Services" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_services_insert" ON "public"."Services" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_services_select" ON "public"."Services" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_services_update" ON "public"."Services" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT ALL ON FUNCTION "public"."get_current_tenant_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_current_tenant_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_current_tenant_id"() TO "service_role";
GRANT ALL ON FUNCTION "public"."set_tenant_id_on_insert"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_tenant_id_on_insert"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_tenant_id_on_insert"() TO "service_role";
GRANT ALL ON TABLE "public"."Addresses" TO "anon";
GRANT ALL ON TABLE "public"."Addresses" TO "authenticated";
GRANT ALL ON TABLE "public"."Addresses" TO "service_role";
GRANT ALL ON SEQUENCE "public"."AddressesId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."AddressesId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."AddressesId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."AppointmentAttendees" TO "anon";
GRANT ALL ON TABLE "public"."AppointmentAttendees" TO "authenticated";
GRANT ALL ON TABLE "public"."AppointmentAttendees" TO "service_role";
GRANT ALL ON TABLE "public"."AppointmentResources" TO "anon";
GRANT ALL ON TABLE "public"."AppointmentResources" TO "authenticated";
GRANT ALL ON TABLE "public"."AppointmentResources" TO "service_role";
GRANT ALL ON TABLE "public"."Appointments" TO "anon";
GRANT ALL ON TABLE "public"."Appointments" TO "authenticated";
GRANT ALL ON TABLE "public"."Appointments" TO "service_role";
GRANT ALL ON SEQUENCE "public"."AppointmentsId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."AppointmentsId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."AppointmentsId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Clients" TO "anon";
GRANT ALL ON TABLE "public"."Clients" TO "authenticated";
GRANT ALL ON TABLE "public"."Clients" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ClientsId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ClientsId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ClientsId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Holidays" TO "anon";
GRANT ALL ON TABLE "public"."Holidays" TO "authenticated";
GRANT ALL ON TABLE "public"."Holidays" TO "service_role";
GRANT ALL ON SEQUENCE "public"."HolidaysId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."HolidaysId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."HolidaysId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Location" TO "anon";
GRANT ALL ON TABLE "public"."Location" TO "authenticated";
GRANT ALL ON TABLE "public"."Location" TO "service_role";
GRANT ALL ON SEQUENCE "public"."LocationId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."LocationId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."LocationId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Tenants" TO "anon";
GRANT ALL ON TABLE "public"."Tenants" TO "authenticated";
GRANT ALL ON TABLE "public"."Tenants" TO "service_role";
GRANT ALL ON SEQUENCE "public"."TenantsId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."TenantsId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."TenantsId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Person" TO "anon";
GRANT ALL ON TABLE "public"."Person" TO "authenticated";
GRANT ALL ON TABLE "public"."Person" TO "service_role";
GRANT ALL ON TABLE "public"."PersonLocation" TO "anon";
GRANT ALL ON TABLE "public"."PersonLocation" TO "authenticated";
GRANT ALL ON TABLE "public"."PersonLocation" TO "service_role";
GRANT ALL ON SEQUENCE "public"."PersonId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."PersonId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."PersonId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ResourceAvailability" TO "anon";
GRANT ALL ON TABLE "public"."ResourceAvailability" TO "authenticated";
GRANT ALL ON TABLE "public"."ResourceAvailability" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ResourceAvailabilityId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ResourceAvailabilityId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ResourceAvailabilityId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."ResourceServices" TO "anon";
GRANT ALL ON TABLE "public"."ResourceServices" TO "authenticated";
GRANT ALL ON TABLE "public"."ResourceServices" TO "service_role";
GRANT ALL ON TABLE "public"."Resources" TO "anon";
GRANT ALL ON TABLE "public"."Resources" TO "authenticated";
GRANT ALL ON TABLE "public"."Resources" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ResourcesId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ResourcesId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ResourcesId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Roles" TO "anon";
GRANT ALL ON TABLE "public"."Roles" TO "authenticated";
GRANT ALL ON TABLE "public"."Roles" TO "service_role";
GRANT ALL ON SEQUENCE "public"."RolesId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."RolesId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."RolesId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Services" TO "anon";
GRANT ALL ON TABLE "public"."Services" TO "authenticated";
GRANT ALL ON TABLE "public"."Services" TO "service_role";
GRANT ALL ON SEQUENCE "public"."ServicesId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ServicesId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ServicesId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."Teams" TO "anon";
GRANT ALL ON TABLE "public"."Teams" TO "authenticated";
GRANT ALL ON TABLE "public"."Teams" TO "service_role";
GRANT ALL ON SEQUENCE "public"."TeamsId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."TeamsId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."TeamsId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."TimeBoxes" TO "anon";
GRANT ALL ON TABLE "public"."TimeBoxes" TO "authenticated";
GRANT ALL ON TABLE "public"."TimeBoxes" TO "service_role";
GRANT ALL ON SEQUENCE "public"."TimeBoxesId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."TimeBoxesId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."TimeBoxesId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."UserDetails" TO "anon";
GRANT ALL ON TABLE "public"."UserDetails" TO "authenticated";
GRANT ALL ON TABLE "public"."UserDetails" TO "service_role";
GRANT ALL ON SEQUENCE "public"."UserDetailsId_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."UserDetailsId_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."UserDetailsId_seq" TO "service_role";
GRANT ALL ON TABLE "public"."_PersonLocations" TO "anon";
GRANT ALL ON TABLE "public"."_PersonLocations" TO "authenticated";
GRANT ALL ON TABLE "public"."_PersonLocations" TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";
RESET ALL;

ALTER TABLE ONLY "public"."TimeBoxes" ADD CONSTRAINT "TimeBoxes_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenants"("id") ON UPDATE CASCADE ON DELETE CASCADE;

CREATE OR REPLACE TRIGGER "set_tenant_id_timeboxes" BEFORE INSERT ON "public"."TimeBoxes" FOR EACH ROW EXECUTE FUNCTION "public"."set_tenant_id_on_insert"();

ALTER TABLE "public"."TimeBoxes" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_timeboxes_delete" ON "public"."TimeBoxes" FOR DELETE USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_timeboxes_insert" ON "public"."TimeBoxes" FOR INSERT WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_timeboxes_select" ON "public"."TimeBoxes" FOR SELECT USING (("tenantId" = "public"."get_current_tenant_id"()));
CREATE POLICY "tenant_isolation_timeboxes_update" ON "public"."TimeBoxes" FOR UPDATE USING (("tenantId" = "public"."get_current_tenant_id"())) WITH CHECK (("tenantId" = "public"."get_current_tenant_id"()));
