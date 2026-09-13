-- قسطتك V17: جدول المزامنة
create table if not exists public.qisttak_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"customers":[],"contracts":[],"payments":[],"expenses":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.qisttak_data enable row level security;
drop policy if exists "qisttak_select_own" on public.qisttak_data;
drop policy if exists "qisttak_insert_own" on public.qisttak_data;
drop policy if exists "qisttak_update_own" on public.qisttak_data;
create policy "qisttak_select_own" on public.qisttak_data for select using (auth.uid() = user_id);
create policy "qisttak_insert_own" on public.qisttak_data for insert with check (auth.uid() = user_id);
create policy "qisttak_update_own" on public.qisttak_data for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
