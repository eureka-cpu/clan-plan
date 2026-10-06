-- Run this once in the Supabase SQL editor for your project.

create extension if not exists pgcrypto;

create table public.responses (
  id                   uuid primary key default gen_random_uuid(),
  created_at           timestamptz not null default now(),
  target_type          text not null check (target_type in ('business', 'individual')),
  sub_target           text,
  pricing_or_ownership text,
  brand_archetype      text,
  ai_centrality        text,
  free_monetization    text,
  respondent_name      text,
  product_name         text,
  general_comment      text,
  answer_path          jsonb not null,
  client_version       text default 'clan-plan-poll/0.1'
);

-- Insert-only access is enforced via plain grants, not RLS policies.
-- (RLS policies targeting `anon` — and even `public` — were observed to
-- reject inserts entirely on a project using Supabase's newer publishable-
-- key system, despite the policy being correctly registered; grants sidestep
-- whatever role-matching quirk caused that.) RLS stays disabled.
alter table public.responses disable row level security;

revoke all on public.responses from anon, authenticated, public;
grant insert on public.responses to anon, authenticated, public;
