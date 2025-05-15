-- Create the table to store schedule templates
CREATE TABLE public.schedule_templates (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL, -- Link to the user who owns the template
    name text NOT NULL,                -- Name of the template (e.g., "Weekly Class Schedule")
    type text NOT NULL,                -- Type of template (e.g., "Classroom Timetable", "Appointments")
    description text,                  -- Optional description
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Add a comment describing the table's purpose
COMMENT ON TABLE public.schedule_templates IS 'Stores user-created templates for different schedule types.';

-- Enable Row Level Security (RLS) to protect user data
ALTER TABLE public.schedule_templates ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies: Ensure users can only manage their own templates

-- Allow users to view their own templates
CREATE POLICY "Allow individual user read access"
ON public.schedule_templates
FOR SELECT
USING (auth.uid() = user_id);

-- Allow users to insert new templates linked to their ID
CREATE POLICY "Allow individual user insert access"
ON public.schedule_templates
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own templates
CREATE POLICY "Allow individual user update access"
ON public.schedule_templates
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own templates
CREATE POLICY "Allow individual user delete access"
ON public.schedule_templates
FOR DELETE
USING (auth.uid() = user_id);

-- Optional but recommended: Function to automatically update 'updated_at' timestamp on changes
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Optional but recommended: Trigger to call the function before any update
CREATE TRIGGER on_schedule_templates_updated
BEFORE UPDATE ON public.schedule_templates
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();