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
    "solution" jsonb not null default '{}'::jsonb
    "is_primary" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now()
);