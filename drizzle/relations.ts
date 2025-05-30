import { relations } from "drizzle-orm/relations";
import { clients, appointments, userDetails, tenants, teams, holidays, location, person, resources, resourceAvailability, services, roles, personLocations, timeBoxes, personLocation, appointmentResources, resourceServices, appointmentAttendees } from "./schema";

export const appointmentsRelations = relations(appointments, ({one, many}) => ({
	client: one(clients, {
		fields: [appointments.clientId],
		references: [clients.id]
	}),
	userDetail: one(userDetails, {
		fields: [appointments.createdById],
		references: [userDetails.id]
	}),
	tenant: one(tenants, {
		fields: [appointments.tenantId],
		references: [tenants.id]
	}),
	team: one(teams, {
		fields: [appointments.teamId],
		references: [teams.id]
	}),
	appointmentResources: many(appointmentResources),
	appointmentAttendees: many(appointmentAttendees),
}));

export const clientsRelations = relations(clients, ({one, many}) => ({
	appointments: many(appointments),
	tenant: one(tenants, {
		fields: [clients.tenantId],
		references: [tenants.id]
	}),
}));

export const userDetailsRelations = relations(userDetails, ({one, many}) => ({
	appointments: many(appointments),
	tenant: one(tenants, {
		fields: [userDetails.tenantId],
		references: [tenants.id]
	}),
	role: one(roles, {
		fields: [userDetails.roleId],
		references: [roles.id]
	}),
	team: one(teams, {
		fields: [userDetails.teamId],
		references: [teams.id]
	}),
}));

export const tenantsRelations = relations(tenants, ({many}) => ({
	appointments: many(appointments),
	clients: many(clients),
	holidays: many(holidays),
	locations: many(location),
	people: many(person),
	resources: many(resources),
	services: many(services),
	teams: many(teams),
	userDetails: many(userDetails),
	timeBoxes: many(timeBoxes),
}));

export const teamsRelations = relations(teams, ({one, many}) => ({
	appointments: many(appointments),
	tenant: one(tenants, {
		fields: [teams.tenantId],
		references: [tenants.id]
	}),
	userDetails: many(userDetails),
}));

export const holidaysRelations = relations(holidays, ({one}) => ({
	tenant: one(tenants, {
		fields: [holidays.tenantId],
		references: [tenants.id]
	}),
}));

export const locationRelations = relations(location, ({one, many}) => ({
	tenant: one(tenants, {
		fields: [location.tenantId],
		references: [tenants.id]
	}),
	location: one(location, {
		fields: [location.parentId],
		references: [location.id],
		relationName: "location_parentId_location_id"
	}),
	locations: many(location, {
		relationName: "location_parentId_location_id"
	}),
	resources: many(resources),
	personLocations_a: many(personLocations),
	personLocations_locationId: many(personLocation),
}));

export const personRelations = relations(person, ({one, many}) => ({
	tenant: one(tenants, {
		fields: [person.tenantId],
		references: [tenants.id]
	}),
	personLocations_b: many(personLocations),
	personLocations_personId: many(personLocation),
	appointmentAttendees: many(appointmentAttendees),
}));

export const resourceAvailabilityRelations = relations(resourceAvailability, ({one}) => ({
	resource: one(resources, {
		fields: [resourceAvailability.resourceId],
		references: [resources.id]
	}),
}));

export const resourcesRelations = relations(resources, ({one, many}) => ({
	resourceAvailabilities: many(resourceAvailability),
	tenant: one(tenants, {
		fields: [resources.tenantId],
		references: [tenants.id]
	}),
	location: one(location, {
		fields: [resources.locationId],
		references: [location.id]
	}),
	appointmentResources: many(appointmentResources),
	resourceServices: many(resourceServices),
}));

export const servicesRelations = relations(services, ({one, many}) => ({
	tenant: one(tenants, {
		fields: [services.tenantId],
		references: [tenants.id]
	}),
	resourceServices: many(resourceServices),
}));

export const rolesRelations = relations(roles, ({many}) => ({
	userDetails: many(userDetails),
}));

export const personLocationsRelations = relations(personLocations, ({one}) => ({
	location: one(location, {
		fields: [personLocations.a],
		references: [location.id]
	}),
	person: one(person, {
		fields: [personLocations.b],
		references: [person.id]
	}),
}));

export const timeBoxesRelations = relations(timeBoxes, ({one}) => ({
	tenant: one(tenants, {
		fields: [timeBoxes.tenantId],
		references: [tenants.id]
	}),
}));

export const personLocationRelations = relations(personLocation, ({one}) => ({
	location: one(location, {
		fields: [personLocation.locationId],
		references: [location.id]
	}),
	person: one(person, {
		fields: [personLocation.personId],
		references: [person.id]
	}),
}));

export const appointmentResourcesRelations = relations(appointmentResources, ({one}) => ({
	appointment: one(appointments, {
		fields: [appointmentResources.appointmentId],
		references: [appointments.id]
	}),
	resource: one(resources, {
		fields: [appointmentResources.resourceId],
		references: [resources.id]
	}),
}));

export const resourceServicesRelations = relations(resourceServices, ({one}) => ({
	resource: one(resources, {
		fields: [resourceServices.resourceId],
		references: [resources.id]
	}),
	service: one(services, {
		fields: [resourceServices.serviceId],
		references: [services.id]
	}),
}));

export const appointmentAttendeesRelations = relations(appointmentAttendees, ({one}) => ({
	appointment: one(appointments, {
		fields: [appointmentAttendees.appointmentId],
		references: [appointments.id]
	}),
	person: one(person, {
		fields: [appointmentAttendees.personId],
		references: [person.id]
	}),
}));