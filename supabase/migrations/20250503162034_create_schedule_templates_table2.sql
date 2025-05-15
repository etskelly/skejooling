-- Create the table to store schedule templates
CREATE TABLE public."ScheduleTemplates" (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL, -- Link to the user who created the template
    tenant_id uuid NOT NULL, -- Link to the tenant/organization owning the template (ADD CONSTRAINT LATER IF NEEDED)
    name text NOT NULL,                -- Name of the template (e.g., "Weekly Class Schedule")
    type text NOT NULL,                -- Type of template (e.g., "Classroom Timetable", "Appointments")
    description text,                  -- Optional description
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Add indexes for common lookups
CREATE INDEX idx_schedule_templates_user_id ON public."ScheduleTemplates"(user_id);
CREATE INDEX idx_schedule_templates_tenant_id ON public."ScheduleTemplates"(tenant_id);

-- Add comments
COMMENT ON TABLE public."ScheduleTemplates" IS 'Stores user-created templates for different schedule types, scoped by tenant.';
COMMENT ON COLUMN public."ScheduleTemplates".tenant_id IS 'Identifier for the tenant/organization owning this template.';

-- Enable Row Level Security (RLS)
ALTER TABLE public."ScheduleTemplates" ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies: Ensure users can only manage templates within their tenant

-- Allow users to view templates belonging to their tenant
CREATE POLICY "Allow tenant members read access"
ON public."ScheduleTemplates"
FOR SELECT
USING ((auth.jwt() ->> 'tenant_id')::uuid = tenant_id); -- Adjust claim path if needed

-- Allow users to insert new templates into their tenant
CREATE POLICY "Allow tenant members insert access"
ON public."ScheduleTemplates"
FOR INSERT
WITH CHECK ((auth.jwt() ->> 'tenant_id')::uuid = tenant_id); -- Ensures insertion matches current tenant context

-- Allow users to update templates within their tenant
CREATE POLICY "Allow tenant members update access"
ON public."ScheduleTemplates"
FOR UPDATE
USING ((auth.jwt() ->> 'tenant_id')::uuid = tenant_id) -- Check existing row tenant
WITH CHECK ((auth.jwt() ->> 'tenant_id')::uuid = tenant_id); -- Check updated row tenant (usually same check)

-- Allow users to delete templates within their tenant
CREATE POLICY "Allow tenant members delete access"
ON public."ScheduleTemplates"
FOR DELETE
USING ((auth.jwt() ->> 'tenant_id')::uuid = tenant_id);

-- Optional but recommended: Function to automatically update 'updated_at' timestamp on changes
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Optional but recommended: Trigger to call the function before any update
CREATE TRIGGER on_ScheduleTemplates_updated
BEFORE UPDATE ON public."ScheduleTemplates"
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();
