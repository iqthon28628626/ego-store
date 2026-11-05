-- EGO STORE starter schema
-- شغّل هذا الملف مرة واحدة في Supabase SQL Editor.

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  price numeric(10,2) not null default 0,
  image_url text,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone text not null,
  address text not null,
  items jsonb not null,
  subtotal numeric(10,2) not null,
  shipping numeric(10,2) not null,
  total numeric(10,2) not null,
  status text default 'new',
  created_at timestamptz default now()
);

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.admins enable row level security;

create or replace function public.is_ego_admin()
returns boolean
language sql
security definer
set search_path = ''
stable
as $$
  select exists (
    select 1 from public.admins
    where user_id = (select auth.uid())
  );
$$;

drop policy if exists "Anyone can view active products" on public.products;
create policy "Anyone can view active products" on public.products for select
using (active = true or public.is_ego_admin());

drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products" on public.products for all
using (public.is_ego_admin()) with check (public.is_ego_admin());

drop policy if exists "Admins view orders" on public.orders;
create policy "Admins view orders" on public.orders for select
using (public.is_ego_admin());

drop policy if exists "Anyone can create orders" on public.orders;
create policy "Anyone can create orders" on public.orders for insert
with check (true);

drop policy if exists "Admins manage orders" on public.orders;
create policy "Admins manage orders" on public.orders for update
using (public.is_ego_admin()) with check (public.is_ego_admin());

drop policy if exists "Admins view themselves" on public.admins;
create policy "Admins view themselves" on public.admins for select
using (user_id = (select auth.uid()));

insert into storage.buckets (id, name, public)
values ('ego-products', 'ego-products', true)
on conflict (id) do nothing;

drop policy if exists "Public can view product images" on storage.objects;
create policy "Public can view product images" on storage.objects for select
using (bucket_id = 'ego-products');

drop policy if exists "Admins upload product images" on storage.objects;
create policy "Admins upload product images" on storage.objects for insert
with check (bucket_id = 'ego-products' and public.is_ego_admin());

drop policy if exists "Admins update product images" on storage.objects;
create policy "Admins update product images" on storage.objects for update
using (bucket_id = 'ego-products' and public.is_ego_admin());

drop policy if exists "Admins delete product images" on storage.objects;
create policy "Admins delete product images" on storage.objects for delete
using (bucket_id = 'ego-products' and public.is_ego_admin());
