-- CreateTable
CREATE TABLE "Resources" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "description" TEXT,
    "capacity" INTEGER,
    "color" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "organizationId" INTEGER NOT NULL,
    "locationId" INTEGER,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Resources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Services" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "duration" INTEGER NOT NULL, -- Duration in minutes
    "color" TEXT,
    "price" DECIMAL(10,2),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "organizationId" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Services_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResourceServices" (
    "resourceId" INTEGER NOT NULL,
    "serviceId" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ResourceServices_pkey" PRIMARY KEY ("resourceId","serviceId")
);

-- CreateTable
CREATE TABLE "Clients" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "notes" TEXT,
    "organizationId" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Appointments" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'scheduled', -- scheduled, confirmed, cancelled, completed
    "notes" TEXT,
    "color" TEXT,
    "isAllDay" BOOLEAN NOT NULL DEFAULT false,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "recurrenceRule" TEXT,
    "organizationId" INTEGER NOT NULL,
    "teamId" INTEGER,
    "serviceId" INTEGER,
    "clientId" INTEGER,
    "createdById" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Appointments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AppointmentResources" (
    "appointmentId" INTEGER NOT NULL,
    "resourceId" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppointmentResources_pkey" PRIMARY KEY ("appointmentId","resourceId")
);

-- CreateTable
CREATE TABLE "AppointmentAttendees" (
    "appointmentId" INTEGER NOT NULL,
    "personId" INTEGER NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'attendee', -- attendee, host, optional
    "status" TEXT NOT NULL DEFAULT 'pending', -- pending, accepted, declined
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppointmentAttendees_pkey" PRIMARY KEY ("appointmentId","personId")
);

-- CreateTable
CREATE TABLE "ResourceAvailability" (
    "id" SERIAL NOT NULL,
    "resourceId" INTEGER NOT NULL,
    "dayOfWeek" INTEGER, -- 0-6 for Sunday-Saturday, NULL for specific date
    "specificDate" TIMESTAMP(3), -- NULL for recurring weekly schedule
    "startTime" TIME NOT NULL,
    "endTime" TIME NOT NULL,
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ResourceAvailability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Holidays" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "tenant_id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Holidays_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Resources_organizationId_idx" ON "Resources"("organizationId");
CREATE INDEX "Resources_locationId_idx" ON "Resources"("locationId");
CREATE INDEX "Resources_tenant_id_idx" ON "Resources"("tenant_id");

-- CreateIndex
CREATE INDEX "Services_organizationId_idx" ON "Services"("organizationId");
CREATE INDEX "Services_tenant_id_idx" ON "Services"("tenant_id");

-- CreateIndex
CREATE INDEX "Clients_organizationId_idx" ON "Clients"("organizationId");
CREATE INDEX "Clients_tenant_id_idx" ON "Clients"("tenant_id");
CREATE UNIQUE INDEX "Clients_email_organizationId_key" ON "Clients"("email", "organizationId") WHERE email IS NOT NULL;
CREATE UNIQUE INDEX "Clients_phone_organizationId_key" ON "Clients"("phone", "organizationId") WHERE phone IS NOT NULL;

-- CreateIndex
CREATE INDEX "Appointments_organizationId_idx" ON "Appointments"("organizationId");
CREATE INDEX "Appointments_teamId_idx" ON "Appointments"("teamId");
CREATE INDEX "Appointments_serviceId_idx" ON "Appointments"("serviceId");
CREATE INDEX "Appointments_clientId_idx" ON "Appointments"("clientId");
CREATE INDEX "Appointments_createdById_idx" ON "Appointments"("createdById");
CREATE INDEX "Appointments_startTime_endTime_idx" ON "Appointments"("startTime", "endTime");
CREATE INDEX "Appointments_tenant_id_idx" ON "Appointments"("tenant_id");

-- CreateIndex
CREATE INDEX "ResourceAvailability_resourceId_idx" ON "ResourceAvailability"("resourceId");
CREATE INDEX "ResourceAvailability_dayOfWeek_idx" ON "ResourceAvailability"("dayOfWeek");
CREATE INDEX "ResourceAvailability_specificDate_idx" ON "ResourceAvailability"("specificDate");
CREATE INDEX "ResourceAvailability_tenant_id_idx" ON "ResourceAvailability"("tenant_id");

-- CreateIndex
CREATE INDEX "Holidays_organizationId_idx" ON "Holidays"("organizationId");
CREATE INDEX "Holidays_startDate_endDate_idx" ON "Holidays"("startDate", "endDate");
CREATE INDEX "Holidays_tenant_id_idx" ON "Holidays"("tenant_id");

-- AddForeignKey
ALTER TABLE "Resources" ADD CONSTRAINT "Resources_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Resources" ADD CONSTRAINT "Resources_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Services" ADD CONSTRAINT "Services_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceServices" ADD CONSTRAINT "ResourceServices_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ResourceServices" ADD CONSTRAINT "ResourceServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Services"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Clients" ADD CONSTRAINT "Clients_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Teams"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Services"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Clients"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Appointments" ADD CONSTRAINT "Appointments_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "UserDetails"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AppointmentResources" ADD CONSTRAINT "AppointmentResources_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "Appointments"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "AppointmentResources" ADD CONSTRAINT "AppointmentResources_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AppointmentAttendees" ADD CONSTRAINT "AppointmentAttendees_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "Appointments"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "AppointmentAttendees" ADD CONSTRAINT "AppointmentAttendees_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResourceAvailability" ADD CONSTRAINT "ResourceAvailability_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "Resources"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Holidays" ADD CONSTRAINT "Holidays_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;
