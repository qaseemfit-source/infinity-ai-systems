-- ============================================================
-- Infinity AI Systems — Supabase V1 Schema
-- ============================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── CLIENTS ──────────────────────────────────────────────────
create table if not exists clients (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null,
  industry      text,
  mrr           integer default 0,
  health_score  integer default 100 check (health_score between 0 and 100),
  status        text default 'active' check (status in ('active','paused','churned')),
  phone         text,
  email         text,
  address       text,
  notes         text,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- ── LEADS ─────────────────────────────────────────────────────
create table if not exists leads (
  id            uuid primary key default uuid_generate_v4(),
  place_id      text unique,               -- Google Places ID (dedup key)
  name          text not null,
  category      text,
  address       text,
  phone         text,
  city          text,
  has_website   boolean default false,
  website_url   text,
  rating        numeric(3,1),
  review_count  integer default 0,
  status        text default 'new' check (status in ('new','called','interested','closed','lost')),
  notes         text,
  created_at    timestamptz default now()
);

-- ── PIPELINE DEALS ────────────────────────────────────────────
create table if not exists pipeline_deals (
  id            uuid primary key default uuid_generate_v4(),
  client_id     uuid references clients(id) on delete cascade,
  lead_id       uuid references leads(id) on delete set null,
  title         text not null,
  stage         text default 'prospect' check (stage in ('prospect','proposal','negotiation','closed_won','closed_lost')),
  value         integer default 0,         -- monthly retainer value
  probability   integer default 50 check (probability between 0 and 100),
  notes         text,
  expected_close date,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- ── USER SETTINGS ─────────────────────────────────────────────
create table if not exists user_settings (
  id            uuid primary key default uuid_generate_v4(),
  key           text unique not null,
  value         text,
  updated_at    timestamptz default now()
);

-- ── ROW LEVEL SECURITY ────────────────────────────────────────
alter table clients        enable row level security;
alter table leads          enable row level security;
alter table pipeline_deals enable row level security;
alter table user_settings  enable row level security;

-- Allow anon key full access (single-user app — tighten per team setup)
create policy "anon_all_clients"        on clients        for all using (true) with check (true);
create policy "anon_all_leads"          on leads          for all using (true) with check (true);
create policy "anon_all_pipeline_deals" on pipeline_deals for all using (true) with check (true);
create policy "anon_all_user_settings"  on user_settings  for all using (true) with check (true);

-- ── SEED DATA ─────────────────────────────────────────────────
insert into clients (name, industry, mrr, health_score, status) values
  ('Crestwood Med Spa',  'Med Spa',   3500, 83, 'active'),
  ('Hudson Salon',       'Hair Salon', 1500, 63, 'active'),
  ('Iron Forge Gym',     'Gym',        6500, 81, 'active'),
  ('Bright Smile Dental','Dental',     1500, 87, 'active')
on conflict do nothing;

insert into user_settings (key, value) values
  ('agency_name',  'Qaseem AI'),
  ('owner_name',   'Qaseem'),
  ('default_city', 'Woodbridge, VA'),
  ('places_key',   'AIzaSyCLjVD8cEgHqNfrsXxSPoFoSwtrB-BKYAc')
on conflict (key) do nothing;
