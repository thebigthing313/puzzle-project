create table "public"."crossword_solutions" (
    "id" uuid not null default gen_random_uuid(),
    "crossword_id" uuid not null,
    "solution" jsonb not null default '{}'::jsonb,
    "is_primary" boolean not null default false,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now()
);


alter table "public"."crossword_solutions" enable row level security;

create table "public"."crosswords" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "title" text not null,
    "description" text,
    "settings" jsonb not null default '{}'::jsonb,
    "rows" smallint not null,
    "columns" smallint not null,
    "dimensions" text generated always as (((rows || 'x'::text) || columns)) stored,
    "grid" jsonb not null default '{}'::jsonb,
    "across_entries" jsonb not null default '{}'::jsonb,
    "down_entries" jsonb not null default '{}'::jsonb,
    "blackbox_count" smallint not null default 0,
    "average_word_length" smallint not null default 0,
    "letter_frequencies" jsonb not null default '{}'::jsonb,
    "word_lengths" jsonb not null default '{}'::jsonb,
    "word_count" smallint not null default 0,
    "is_public" boolean not null default false,
    "difficulty_level" smallint,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone default now()
);


alter table "public"."crosswords" enable row level security;

CREATE UNIQUE INDEX crossword_solutions_pkey ON public.crossword_solutions USING btree (id);

CREATE UNIQUE INDEX crosswords_pkey ON public.crosswords USING btree (id);

alter table "public"."crossword_solutions" add constraint "crossword_solutions_pkey" PRIMARY KEY using index "crossword_solutions_pkey";

alter table "public"."crosswords" add constraint "crosswords_pkey" PRIMARY KEY using index "crosswords_pkey";

alter table "public"."crossword_solutions" add constraint "crossword_solutions_crossword_id_fkey" FOREIGN KEY (crossword_id) REFERENCES crosswords(id) ON DELETE CASCADE not valid;

alter table "public"."crossword_solutions" validate constraint "crossword_solutions_crossword_id_fkey";

alter table "public"."crosswords" add constraint "crosswords_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."crosswords" validate constraint "crosswords_user_id_fkey";

grant delete on table "public"."crossword_solutions" to "anon";

grant insert on table "public"."crossword_solutions" to "anon";

grant references on table "public"."crossword_solutions" to "anon";

grant select on table "public"."crossword_solutions" to "anon";

grant trigger on table "public"."crossword_solutions" to "anon";

grant truncate on table "public"."crossword_solutions" to "anon";

grant update on table "public"."crossword_solutions" to "anon";

grant delete on table "public"."crossword_solutions" to "authenticated";

grant insert on table "public"."crossword_solutions" to "authenticated";

grant references on table "public"."crossword_solutions" to "authenticated";

grant select on table "public"."crossword_solutions" to "authenticated";

grant trigger on table "public"."crossword_solutions" to "authenticated";

grant truncate on table "public"."crossword_solutions" to "authenticated";

grant update on table "public"."crossword_solutions" to "authenticated";

grant delete on table "public"."crossword_solutions" to "service_role";

grant insert on table "public"."crossword_solutions" to "service_role";

grant references on table "public"."crossword_solutions" to "service_role";

grant select on table "public"."crossword_solutions" to "service_role";

grant trigger on table "public"."crossword_solutions" to "service_role";

grant truncate on table "public"."crossword_solutions" to "service_role";

grant update on table "public"."crossword_solutions" to "service_role";

grant delete on table "public"."crosswords" to "anon";

grant insert on table "public"."crosswords" to "anon";

grant references on table "public"."crosswords" to "anon";

grant select on table "public"."crosswords" to "anon";

grant trigger on table "public"."crosswords" to "anon";

grant truncate on table "public"."crosswords" to "anon";

grant update on table "public"."crosswords" to "anon";

grant delete on table "public"."crosswords" to "authenticated";

grant insert on table "public"."crosswords" to "authenticated";

grant references on table "public"."crosswords" to "authenticated";

grant select on table "public"."crosswords" to "authenticated";

grant trigger on table "public"."crosswords" to "authenticated";

grant truncate on table "public"."crosswords" to "authenticated";

grant update on table "public"."crosswords" to "authenticated";

grant delete on table "public"."crosswords" to "service_role";

grant insert on table "public"."crosswords" to "service_role";

grant references on table "public"."crosswords" to "service_role";

grant select on table "public"."crosswords" to "service_role";

grant trigger on table "public"."crosswords" to "service_role";

grant truncate on table "public"."crosswords" to "service_role";

grant update on table "public"."crosswords" to "service_role";

create policy "Auth users can delete own crossword solutions"
on "public"."crossword_solutions"
as permissive
for delete
to authenticated
using ((crossword_id IN ( SELECT crosswords.id
   FROM crosswords
  WHERE (crosswords.user_id = ( SELECT auth.uid() AS uid)))));


create policy "Auth users can insert crossword solutions"
on "public"."crossword_solutions"
as permissive
for insert
to authenticated
with check (true);


create policy "Auth users can update own crossword solutions"
on "public"."crossword_solutions"
as permissive
for update
to authenticated
using ((crossword_id IN ( SELECT crosswords.id
   FROM crosswords
  WHERE (crosswords.user_id = ( SELECT auth.uid() AS uid)))))
with check ((crossword_id IN ( SELECT crosswords.id
   FROM crosswords
  WHERE (crosswords.user_id = ( SELECT auth.uid() AS uid)))));


create policy "Auth users can view own crossword solutions"
on "public"."crossword_solutions"
as permissive
for select
to authenticated
using ((crossword_id IN ( SELECT crosswords.id
   FROM crosswords
  WHERE (crosswords.user_id = ( SELECT auth.uid() AS uid)))));


create policy "Anyone can view public crosswords, owners can view own"
on "public"."crosswords"
as permissive
for select
to authenticated, anon
using (((is_public = true) OR (user_id = ( SELECT auth.uid() AS uid))));


create policy "Auth users can delete their own crosswords"
on "public"."crosswords"
as permissive
for delete
to authenticated
using ((user_id = ( SELECT auth.uid() AS uid)));


create policy "Auth users can insert crosswords"
on "public"."crosswords"
as permissive
for insert
to authenticated
with check (true);


create policy "Auth users can update their own crosswords"
on "public"."crosswords"
as permissive
for update
to authenticated
using ((user_id = ( SELECT auth.uid() AS uid)))
with check ((user_id = ( SELECT auth.uid() AS uid)));



