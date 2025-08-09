create table "public"."crosswords" (
    "id" uuid not null primary key default gen_random_uuid(),
    "user_id" uuid not null references auth.users(id) on delete set null,
    "title" text not null,
    "description" text,
    "settings" jsonb not null default '{}'::jsonb,
    "rows" smallint not null,
    "columns" smallint not null,
    "dimensions" text GENERATED ALWAYS as (rows || 'x' || columns) STORED,
    "grid" jsonb not null default '{}'::jsonb,
    "across_entries" jsonb not null default '{}'::jsonb,
    "down_entries" jsonb not null default '{}'::jsonb,
    "blackbox_count" smallint not null default 0,
    "average_word_length" smallint not null default 0,
    "letter_frequencies" jsonb not null default '{}'::jsonb,
    "word_lengths" jsonb not null default '{}'::jsonb,
    "word_count" smallint not null default 0,
    "is_public" boolean not null default false,
    "difficulty_level" smallint default null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now()
);

create table "public"."crossword_solutions" (
    "id" uuid not null primary key default gen_random_uuid(),
    "crossword_id" uuid not null references public.crosswords(id) on delete cascade,
    "solution" jsonb not null default '{}'::jsonb,
    "is_primary" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now()
);

alter table "public"."crosswords" enable row level security;
alter table "public"."crossword_solutions" enable row level security;

create policy "Anyone can view public crosswords, owners can view own"
    on "public"."crosswords"
    for select
    to authenticated, anon
    using (
        is_public = true
        or user_id = (SELECT auth.uid())
    );

create policy "Auth users can insert crosswords"
    on "public"."crosswords"
    for insert
    to authenticated
    with check (
        true
    );

create policy "Auth users can update their own crosswords"
    on "public"."crosswords"
    for update
    to authenticated
    using (
        user_id = (SELECT auth.uid())
    )
    with check (
        user_id = (SELECT auth.uid())
    );

create policy "Auth users can delete their own crosswords"
    on "public"."crosswords"
    for delete
    to authenticated
    using (
        user_id = (SELECT auth.uid())
    );

create policy "Auth users can view own crossword solutions"
    on "public"."crossword_solutions"
    for select
    to authenticated
    using (
        crossword_id in (
            SELECT id
            FROM public.crosswords
            WHERE user_id = (SELECT auth.uid()))
    );

create policy "Auth users can insert crossword solutions"
    on "public"."crossword_solutions"
    for insert
    to authenticated
    with check (
        true
    );

create policy "Auth users can update own crossword solutions"
    on "public"."crossword_solutions"
    for update
    to authenticated
    using (
        crossword_id in (
            SELECT id
            FROM public.crosswords
            WHERE user_id = (SELECT auth.uid()))
    )
    with check (
        crossword_id in (
            SELECT id
            FROM public.crosswords
            WHERE user_id = (SELECT auth.uid()))
    );

create policy "Auth users can delete own crossword solutions"
    on "public"."crossword_solutions"
    for delete
    to authenticated
    using (
        crossword_id in (
            SELECT id
            FROM public.crosswords
            WHERE user_id = (SELECT auth.uid()))
    );
