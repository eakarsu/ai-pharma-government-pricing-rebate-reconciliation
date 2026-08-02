CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_amp"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_product" TEXT NOT NULL,
  "data_quarter" TEXT NOT NULL,
  "data_grossSales" NUMERIC(16,2) NOT NULL,
  "data_exclusionRationale" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_amp_due ON "op_amp"(due_date);

CREATE TABLE IF NOT EXISTS "op_best_price"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_product" TEXT NOT NULL,
  "data_customerClass" TEXT NOT NULL,
  "data_netPrice" NUMERIC(16,2) NOT NULL,
  "data_arrangement" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_best_price_due ON "op_best_price"(due_date);

CREATE TABLE IF NOT EXISTS "op_medicaid_rebate"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_state" TEXT NOT NULL,
  "data_invoiceQuarter" TEXT NOT NULL,
  "data_invoiceAmount" NUMERIC(16,2) NOT NULL,
  "data_unitVariance" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_medicaid_rebate_due ON "op_medicaid_rebate"(due_date);

CREATE TABLE IF NOT EXISTS "op_inflation_rebate"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_program" TEXT NOT NULL,
  "data_product" TEXT NOT NULL,
  "data_applicablePeriod" TEXT NOT NULL,
  "data_estimatedLiability" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_inflation_rebate_due ON "op_inflation_rebate"(due_date);

CREATE TABLE IF NOT EXISTS "op_discount_program"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_invoiceId" TEXT NOT NULL,
  "data_contract" TEXT NOT NULL,
  "data_discountAmount" NUMERIC(16,2) NOT NULL,
  "data_varianceReason" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_discount_program_due ON "op_discount_program"(due_date);

CREATE TABLE IF NOT EXISTS "op_restatement"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_metric" TEXT NOT NULL,
  "data_period" TEXT NOT NULL,
  "data_financialImpact" NUMERIC(16,2) NOT NULL,
  "data_restatementReason" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_restatement_due ON "op_restatement"(due_date);

CREATE TABLE IF NOT EXISTS "op_class_of_trade"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_customer" TEXT NOT NULL,
  "data_channel" TEXT NOT NULL,
  "data_proposedClass" TEXT NOT NULL,
  "data_classificationEvidence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_class_of_trade_due ON "op_class_of_trade"(due_date);

CREATE TABLE IF NOT EXISTS "op_audit_package"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_auditPeriod" TEXT NOT NULL,
  "data_productScope" TEXT NOT NULL,
  "data_openExceptions" NUMERIC(16,2) NOT NULL,
  "data_packageNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_audit_package_due ON "op_audit_package"(due_date);

CREATE TABLE IF NOT EXISTS "op_product_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_product" TEXT NOT NULL,
  "data_ndc" TEXT NOT NULL,
  "data_packageSize" TEXT NOT NULL,
  "data_launchDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_product_master_due ON "op_product_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_class_of_trade_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_customer" TEXT NOT NULL,
  "data_customerId" TEXT NOT NULL,
  "data_channel" TEXT NOT NULL,
  "data_classOfTrade" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_class_of_trade_master_due ON "op_class_of_trade_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_state_invoice_ledger"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_state" TEXT NOT NULL,
  "data_quarter" TEXT NOT NULL,
  "data_units" NUMERIC(16,2) NOT NULL,
  "data_invoiceAmount" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_state_invoice_ledger_due ON "op_state_invoice_ledger"(due_date);

CREATE TABLE IF NOT EXISTS "op_rebate_programs"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_program" TEXT NOT NULL,
  "data_programType" TEXT NOT NULL,
  "data_calculationBasis" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_rebate_programs_due ON "op_rebate_programs"(due_date);
