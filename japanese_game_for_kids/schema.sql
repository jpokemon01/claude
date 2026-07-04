-- japanese_words table for the Japanese kids game
-- Run this once in the Supabase SQL Editor:
-- https://supabase.com/dashboard/project/pujgfojebzyetxypwytg/sql
--
-- The game reads this table with the public anon key (read-only via RLS).
-- To add/edit words later, use the Table Editor in the Supabase dashboard —
-- the game picks up changes on next load. Keep at least 3 words per category
-- (the quiz shows 3 choices). Categories must be one of:
-- animals, food, colors, numbers (the game's home-screen buttons are fixed).

create table if not exists japanese_words (
  id bigint generated always as identity primary key,
  category text not null check (category in ('animals', 'food', 'colors', 'numbers')),
  emoji text not null,
  ja text not null,
  en text,
  sort_order int not null default 0
);

alter table japanese_words enable row level security;

-- Anyone may read; nobody may write with the anon key
-- (manage words via the dashboard, which uses the service role).
create policy "Public read access" on japanese_words
  for select using (true);

insert into japanese_words (category, emoji, ja, en, sort_order) values
  -- animals どうぶつ
  ('animals', '🐱', 'ねこ',   'cat',      1),
  ('animals', '🐶', 'いぬ',   'dog',      2),
  ('animals', '🐰', 'うさぎ', 'rabbit',   3),
  ('animals', '🐘', 'ぞう',   'elephant', 4),
  ('animals', '🐟', 'さかな', 'fish',     5),
  ('animals', '🐦', 'とり',   'bird',     6),
  ('animals', '🐻', 'くま',   'bear',     7),
  ('animals', '🐷', 'ぶた',   'pig',      8),
  -- food たべもの
  ('food', '🍎', 'りんご',       'apple',      1),
  ('food', '🍌', 'バナナ',       'banana',     2),
  ('food', '🍓', 'いちご',       'strawberry', 3),
  ('food', '🍙', 'おにぎり',     'rice ball',  4),
  ('food', '🍞', 'パン',         'bread',      5),
  ('food', '🥛', 'ぎゅうにゅう', 'milk',       6),
  -- colors いろ
  ('colors', '🔴', 'あか',   'red',    1),
  ('colors', '🔵', 'あお',   'blue',   2),
  ('colors', '🟡', 'きいろ', 'yellow', 3),
  ('colors', '🟢', 'みどり', 'green',  4),
  ('colors', '⚪', 'しろ',   'white',  5),
  ('colors', '⚫', 'くろ',   'black',  6),
  -- numbers かず
  ('numbers', '1️⃣', 'いち', 'one',   1),
  ('numbers', '2️⃣', 'に',   'two',   2),
  ('numbers', '3️⃣', 'さん', 'three', 3),
  ('numbers', '4️⃣', 'よん', 'four',  4),
  ('numbers', '5️⃣', 'ご',   'five',  5);
