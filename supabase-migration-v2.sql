-- =====================================================
-- RIG.BUILD - Migration v2
-- =====================================================
-- Adiciona o campo data_compra para projeção em meses reais.
-- Rode no SQL Editor do Supabase APENAS UMA VEZ.
-- =====================================================

-- Adiciona a coluna (com default = hoje, pra peças antigas não quebrarem)
alter table public.pecas
  add column if not exists data_compra date not null default current_date;

-- Index opcional para acelerar ordenação por data
create index if not exists pecas_data_compra_idx on public.pecas(data_compra);

-- =====================================================
-- Pronto! Recarregue o app.
-- =====================================================
