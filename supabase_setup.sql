-- ══════════════════════════════════════════════
-- Control de Gastos — Setup SQL para Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ══════════════════════════════════════════════

-- 1. Tabla de categorías
create table if not exists cg_categories (
  id          text primary key,
  user_id     uuid references auth.users(id) on delete cascade not null,
  name        text not null,
  emoji       text not null,
  type        text not null check (type in ('gasto','ingreso','ambos')),
  created_at  timestamptz default now()
);

-- 2. Tabla de transacciones
create table if not exists cg_transactions (
  id          text primary key,
  user_id     uuid references auth.users(id) on delete cascade not null,
  type        text not null check (type in ('gasto','ingreso')),
  name        text not null,
  cat         text not null,
  amount      numeric not null,
  date        text,
  year        int not null,
  month       int not null,
  created_at  timestamptz default now()
);

-- 3. Activar Row Level Security (cada usuario solo ve sus datos)
alter table cg_categories  enable row level security;
alter table cg_transactions enable row level security;

-- 4. Políticas RLS
create policy "Categorías propias" on cg_categories
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Transacciones propias" on cg_transactions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
