-- =====================================================
-- RIG.BUILD - Setup do banco no Supabase (v2)
-- =====================================================
-- Cole tudo no SQL Editor do Supabase e clique em Run.
-- Cria a tabela de peças com isolamento por usuário.
-- =====================================================

create table if not exists public.pecas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null check (length(trim(nome)) > 0),
  valor numeric(10, 2) not null check (valor > 0),
  forma text not null check (forma in ('avista', 'parcelado')),
  parcelas integer not null default 1 check (parcelas between 1 and 12),
  data_compra date not null default current_date,
  created_at timestamptz not null default now()
);

create index if not exists pecas_user_id_idx on public.pecas(user_id);
create index if not exists pecas_data_compra_idx on public.pecas(data_compra);

alter table public.pecas enable row level security;

drop policy if exists "users_select_own" on public.pecas;
create policy "users_select_own"
  on public.pecas for select
  using (auth.uid() = user_id);

drop policy if exists "users_insert_own" on public.pecas;
create policy "users_insert_own"
  on public.pecas for insert
  with check (auth.uid() = user_id);

drop policy if exists "users_update_own" on public.pecas;
create policy "users_update_own"
  on public.pecas for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "users_delete_own" on public.pecas;
create policy "users_delete_own"
  on public.pecas for delete
  using (auth.uid() = user_id);
