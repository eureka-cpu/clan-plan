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
  general_comment      text,
  answer_path          jsonb not null,
  client_version       text default 'clan-plan-poll/0.1'
);

alter table public.responses enable row level security;

-- Anonymous (public) clients may INSERT only.
create policy "anon_insert_only"
  on public.responses
  for insert
  to anon
  with check (true);

-- Deliberately no SELECT/UPDATE/DELETE policy for anon or authenticated:
-- with RLS enabled and no permissive policy, those ops return zero rows,
-- not an error — respondents can submit but never read back others' answers.
