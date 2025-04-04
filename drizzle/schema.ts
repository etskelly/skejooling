import { pgTable, serial, text, index, foreignKey, pgPolicy, timestamp, boolean, integer, uniqueIndex, time, numeric, primaryKey } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"



export const addresses = pgTable("Addresses", {
	id: serial().primaryKey().notNull(),
	line1: text().notNull(),
	line2: text(),
	town: text().notNull(),
	county: text(),
	country: text(),
	postcode: text().notNull(),
});

export const appointments = pgTable("Appointments", {
	id: serial().primaryKey().notNull(),
	title: text().notNull(),
	startTime: timestamp({ precision: 3, mode: 'string' }).notNull(),
	endTime: timestamp({ precision: 3, mode: 'string' }).notNull(),
	status: text().default('scheduled').notNull(),
	notes: text(),
	color: text(),
	isAllDay: boolean().default(false).notNull(),
	isRecurring: boolean().default(false).notNull(),
	recurrenceRule: text(),
	tenantId: integer().notNull(),
	teamId: integer(),
	serviceId: integer(),
	clientId: integer(),
	createdById: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	index("Appointments_clientId_idx").using("btree", table.clientId.asc().nullsLast().op("int4_ops")),
	index("Appointments_createdById_idx").using("btree", table.createdById.asc().nullsLast().op("int4_ops")),
	index("Appointments_serviceId_idx").using("btree", table.serviceId.asc().nullsLast().op("int4_ops")),
	index("Appointments_startTime_endTime_idx").using("btree", table.startTime.asc().nullsLast().op("timestamp_ops"), table.endTime.asc().nullsLast().op("timestamp_ops")),
	index("Appointments_teamId_idx").using("btree", table.teamId.asc().nullsLast().op("int4_ops")),
	index("Appointments_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.clientId],
			foreignColumns: [clients.id],
			name: "Appointments_clientId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	foreignKey({
			columns: [table.createdById],
			foreignColumns: [userDetails.id],
			name: "Appointments_createdById_fkey"
		}).onUpdate("cascade").onDelete("restrict"),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Appointments_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.teamId],
			foreignColumns: [teams.id],
			name: "Appointments_teamId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	pgPolicy("tenant_isolation_appointments_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_appointments_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_appointments_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_appointments_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const clients = pgTable("Clients", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	email: text(),
	phone: text(),
	notes: text(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	uniqueIndex("Clients_email_tenantId_key").using("btree", table.email.asc().nullsLast().op("int4_ops"), table.tenantId.asc().nullsLast().op("text_ops")).where(sql`(email IS NOT NULL)`),
	uniqueIndex("Clients_phone_tenantId_key").using("btree", table.phone.asc().nullsLast().op("text_ops"), table.tenantId.asc().nullsLast().op("int4_ops")).where(sql`(phone IS NOT NULL)`),
	index("Clients_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Clients_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	pgPolicy("tenant_isolation_clients_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_clients_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_clients_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_clients_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const holidays = pgTable("Holidays", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	startDate: timestamp({ precision: 3, mode: 'string' }).notNull(),
	endDate: timestamp({ precision: 3, mode: 'string' }).notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	index("Holidays_startDate_endDate_idx").using("btree", table.startDate.asc().nullsLast().op("timestamp_ops"), table.endDate.asc().nullsLast().op("timestamp_ops")),
	index("Holidays_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Holidays_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	pgPolicy("tenant_isolation_holidays_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_holidays_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_holidays_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_holidays_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const location = pgTable("Location", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	parentId: integer(),
	tenantId: integer(),
}, (table) => [
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Location_tenantId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	foreignKey({
			columns: [table.parentId],
			foreignColumns: [table.id],
			name: "Location_parentId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
]);

export const tenants = pgTable("Tenants", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
});

export const person = pgTable("Person", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	email: text().notNull(),
	tenantId: integer(),
}, (table) => [
	uniqueIndex("Person_email_key").using("btree", table.email.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Person_tenantId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
]);

export const resourceAvailability = pgTable("ResourceAvailability", {
	id: serial().primaryKey().notNull(),
	resourceId: integer().notNull(),
	dayOfWeek: integer(),
	specificDate: timestamp({ precision: 3, mode: 'string' }),
	startTime: time().notNull(),
	endTime: time().notNull(),
	isAvailable: boolean().default(true).notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	index("ResourceAvailability_dayOfWeek_idx").using("btree", table.dayOfWeek.asc().nullsLast().op("int4_ops")),
	index("ResourceAvailability_resourceId_idx").using("btree", table.resourceId.asc().nullsLast().op("int4_ops")),
	index("ResourceAvailability_specificDate_idx").using("btree", table.specificDate.asc().nullsLast().op("timestamp_ops")),
	index("ResourceAvailability_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.resourceId],
			foreignColumns: [resources.id],
			name: "ResourceAvailability_resourceId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	pgPolicy("tenant_isolation_resource_availability_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_resource_availability_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_resource_availability_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_resource_availability_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const resources = pgTable("Resources", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	type: text().notNull(),
	description: text(),
	capacity: integer(),
	color: text(),
	isActive: boolean().default(true).notNull(),
	tenantId: integer().notNull(),
	locationId: integer(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	index("Resources_locationId_idx").using("btree", table.locationId.asc().nullsLast().op("int4_ops")),
	index("Resources_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Resources_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.locationId],
			foreignColumns: [location.id],
			name: "Resources_locationId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	pgPolicy("tenant_isolation_resources_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_resources_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_resources_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_resources_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const roles = pgTable("Roles", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	uniqueIndex("Roles_name_key").using("btree", table.name.asc().nullsLast().op("text_ops")),
]);

export const services = pgTable("Services", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	description: text(),
	duration: integer().notNull(),
	color: text(),
	price: numeric({ precision: 10, scale:  2 }),
	isActive: boolean().default(true).notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
}, (table) => [
	index("Services_tenantId_idx").using("btree", table.tenantId.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Services_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	pgPolicy("tenant_isolation_services_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_services_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_services_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_services_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const teams = pgTable("Teams", {
	id: serial().primaryKey().notNull(),
	name: text().notNull(),
	slug: text().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	tenantId: integer(),
}, (table) => [
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "Teams_tenantId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
]);

export const userDetails = pgTable("UserDetails", {
	id: serial().primaryKey().notNull(),
	email: text().notNull(),
	authid: text().notNull(),
	name: text(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	roleId: integer(),
	tenantId: integer(),
	teamId: integer(),
}, (table) => [
	uniqueIndex("UserDetails_authid_key").using("btree", table.authid.asc().nullsLast().op("text_ops")),
	uniqueIndex("UserDetails_email_key").using("btree", table.email.asc().nullsLast().op("text_ops")),
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "UserDetails_tenantId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	foreignKey({
			columns: [table.roleId],
			foreignColumns: [roles.id],
			name: "UserDetails_roleId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
	foreignKey({
			columns: [table.teamId],
			foreignColumns: [teams.id],
			name: "UserDetails_teamId_fkey"
		}).onUpdate("cascade").onDelete("set null"),
]);

export const personLocations = pgTable("_PersonLocations", {
	a: integer("A").notNull(),
	b: integer("B").notNull(),
}, (table) => [
	uniqueIndex("_PersonLocations_AB_unique").using("btree", table.a.asc().nullsLast().op("int4_ops"), table.b.asc().nullsLast().op("int4_ops")),
	index().using("btree", table.b.asc().nullsLast().op("int4_ops")),
	foreignKey({
			columns: [table.a],
			foreignColumns: [location.id],
			name: "_PersonLocations_A_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.b],
			foreignColumns: [person.id],
			name: "_PersonLocations_B_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
]);

export const timeBoxes = pgTable("TimeBoxes", {
	id: serial().primaryKey().notNull(),
	title: text().notNull(),
	from: timestamp({ precision: 3, mode: 'string' }).notNull(),
	to: timestamp({ precision: 3, mode: 'string' }).notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
	updatedAt: timestamp({ precision: 3, mode: 'string' }).notNull(),
	type: integer().default(0).notNull(),
	notes: text(),
	halfDayFrom: boolean(),
	halfDayTo: boolean(),
	tenantId: integer().notNull(),
}, (table) => [
	foreignKey({
			columns: [table.tenantId],
			foreignColumns: [tenants.id],
			name: "TimeBoxes_tenantId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	pgPolicy("tenant_isolation_timeboxes_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_timeboxes_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_timeboxes_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_timeboxes_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const personLocation = pgTable("PersonLocation", {
	personId: integer().notNull(),
	locationId: integer().notNull(),
}, (table) => [
	foreignKey({
			columns: [table.locationId],
			foreignColumns: [location.id],
			name: "PersonLocation_locationId_fkey"
		}).onUpdate("cascade").onDelete("restrict"),
	foreignKey({
			columns: [table.personId],
			foreignColumns: [person.id],
			name: "PersonLocation_personId_fkey"
		}).onUpdate("cascade").onDelete("restrict"),
	primaryKey({ columns: [table.personId, table.locationId], name: "PersonLocation_pkey"}),
]);

export const appointmentResources = pgTable("AppointmentResources", {
	appointmentId: integer().notNull(),
	resourceId: integer().notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	foreignKey({
			columns: [table.appointmentId],
			foreignColumns: [appointments.id],
			name: "AppointmentResources_appointmentId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.resourceId],
			foreignColumns: [resources.id],
			name: "AppointmentResources_resourceId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	primaryKey({ columns: [table.appointmentId, table.resourceId], name: "AppointmentResources_pkey"}),
	pgPolicy("tenant_isolation_appointment_resources_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_appointment_resources_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_appointment_resources_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_appointment_resources_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const resourceServices = pgTable("ResourceServices", {
	resourceId: integer().notNull(),
	serviceId: integer().notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	foreignKey({
			columns: [table.resourceId],
			foreignColumns: [resources.id],
			name: "ResourceServices_resourceId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.serviceId],
			foreignColumns: [services.id],
			name: "ResourceServices_serviceId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	primaryKey({ columns: [table.resourceId, table.serviceId], name: "ResourceServices_pkey"}),
	pgPolicy("tenant_isolation_resource_services_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_resource_services_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_resource_services_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_resource_services_update", { as: "permissive", for: "update", to: ["public"] }),
]);

export const appointmentAttendees = pgTable("AppointmentAttendees", {
	appointmentId: integer().notNull(),
	personId: integer().notNull(),
	role: text().default('attendee').notNull(),
	status: text().default('pending').notNull(),
	tenantId: integer().notNull(),
	createdAt: timestamp({ precision: 3, mode: 'string' }).default(sql`CURRENT_TIMESTAMP`).notNull(),
}, (table) => [
	foreignKey({
			columns: [table.appointmentId],
			foreignColumns: [appointments.id],
			name: "AppointmentAttendees_appointmentId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	foreignKey({
			columns: [table.personId],
			foreignColumns: [person.id],
			name: "AppointmentAttendees_personId_fkey"
		}).onUpdate("cascade").onDelete("cascade"),
	primaryKey({ columns: [table.appointmentId, table.personId], name: "AppointmentAttendees_pkey"}),
	pgPolicy("tenant_isolation_appointment_attendees_delete", { as: "permissive", for: "delete", to: ["public"], using: sql`("tenantId" = get_current_tenant_id())` }),
	pgPolicy("tenant_isolation_appointment_attendees_insert", { as: "permissive", for: "insert", to: ["public"] }),
	pgPolicy("tenant_isolation_appointment_attendees_select", { as: "permissive", for: "select", to: ["public"] }),
	pgPolicy("tenant_isolation_appointment_attendees_update", { as: "permissive", for: "update", to: ["public"] }),
]);
