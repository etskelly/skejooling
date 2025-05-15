-- Create the set_updated_at function first
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.set_updated_at() TO authenticated;
GRANT EXECUTE ON FUNCTION public.set_updated_at() TO service_role;

-- Create subscriptions table
CREATE TABLE public."Subscriptions" (
    id SERIAL PRIMARY KEY,
    "tenantId" INTEGER NOT NULL REFERENCES public."Tenants"(id),
    "stripeCustomerId" TEXT NOT NULL,
    "stripeSubscriptionId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "currentPeriodStart" TIMESTAMP WITH TIME ZONE NOT NULL,
    "currentPeriodEnd" TIMESTAMP WITH TIME ZONE NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Add RLS policies
ALTER TABLE public."Subscriptions" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "tenant_isolation_subscriptions_select" ON public."Subscriptions"
    FOR SELECT USING ("tenantId" = get_current_tenant_id());

CREATE POLICY "tenant_isolation_subscriptions_insert" ON public."Subscriptions"
    FOR INSERT WITH CHECK ("tenantId" = get_current_tenant_id());

CREATE POLICY "tenant_isolation_subscriptions_update" ON public."Subscriptions"
    FOR UPDATE USING ("tenantId" = get_current_tenant_id())
    WITH CHECK ("tenantId" = get_current_tenant_id());

CREATE POLICY "tenant_isolation_subscriptions_delete" ON public."Subscriptions"
    FOR DELETE USING ("tenantId" = get_current_tenant_id());

-- Add indexes for better performance
CREATE INDEX "Subscriptions_tenantId_idx" ON public."Subscriptions" ("tenantId");
CREATE INDEX "Subscriptions_stripeCustomerId_idx" ON public."Subscriptions" ("stripeCustomerId");
CREATE INDEX "Subscriptions_stripeSubscriptionId_idx" ON public."Subscriptions" ("stripeSubscriptionId");

-- Add trigger for updatedAt
CREATE TRIGGER set_updated_at
    BEFORE UPDATE ON public."Subscriptions"
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at(); 