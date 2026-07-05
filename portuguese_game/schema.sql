-- portuguese_words table for the Portuguese learning game
-- Run this once in the Supabase SQL Editor (takeo-apps project):
-- https://supabase.com/dashboard/project/pujgfojebzyetxypwytg/sql
--
-- Same pattern as japanese_words: the game reads this table with the
-- public anon key (read-only via RLS). Add/edit words in the Table
-- Editor; the game picks up changes on next load. Keep at least
-- 4 words per category (the quiz shows 4 choices). Categories:
-- cumprimentos, numeros, comida, viagem, frases

create table if not exists portuguese_words (
  id bigint generated always as identity primary key,
  category text not null check (category in ('cumprimentos', 'numeros', 'comida', 'viagem', 'frases')),
  pt text not null,
  en text,
  ja text,
  sort_order int not null default 0
);

alter table portuguese_words enable row level security;

create policy "Public read access" on portuguese_words
  for select using (true);

insert into portuguese_words (category, pt, en, ja, sort_order) values
  -- cumprimentos あいさつ
  ('cumprimentos', 'Oi',                 'Hi',                   'やあ',            1),
  ('cumprimentos', 'Bom dia',            'Good morning',         'おはよう',        2),
  ('cumprimentos', 'Boa tarde',          'Good afternoon',       'こんにちは',      3),
  ('cumprimentos', 'Boa noite',          'Good evening / night', 'こんばんは',      4),
  ('cumprimentos', 'Tudo bem?',          'How are you?',         '元気ですか？',    5),
  ('cumprimentos', 'Obrigado',           'Thank you',            'ありがとう',      6),
  ('cumprimentos', 'Por favor',          'Please',               'お願いします',    7),
  ('cumprimentos', 'Desculpa',           'Sorry',                'ごめんなさい',    8),
  ('cumprimentos', 'Tchau',              'Bye',                  'じゃあね',        9),
  ('cumprimentos', 'Prazer em conhecer', 'Nice to meet you',     'はじめまして',    10),
  -- numeros 数字
  ('numeros', 'um',     'one',   '一', 1),
  ('numeros', 'dois',   'two',   '二', 2),
  ('numeros', 'três',   'three', '三', 3),
  ('numeros', 'quatro', 'four',  '四', 4),
  ('numeros', 'cinco',  'five',  '五', 5),
  ('numeros', 'seis',   'six',   '六', 6),
  ('numeros', 'sete',   'seven', '七', 7),
  ('numeros', 'oito',   'eight', '八', 8),
  ('numeros', 'nove',   'nine',  '九', 9),
  ('numeros', 'dez',    'ten',   '十', 10),
  -- comida 食べ物
  ('comida', 'água',    'water',   '水',        1),
  ('comida', 'café',    'coffee',  'コーヒー',  2),
  ('comida', 'pão',     'bread',   'パン',      3),
  ('comida', 'arroz',   'rice',    'ご飯',      4),
  ('comida', 'feijão',  'beans',   '豆',        5),
  ('comida', 'carne',   'meat',    '肉',        6),
  ('comida', 'frango',  'chicken', '鶏肉',      7),
  ('comida', 'peixe',   'fish',    '魚',        8),
  ('comida', 'fruta',   'fruit',   '果物',      9),
  ('comida', 'cerveja', 'beer',    'ビール',    10),
  -- viagem 旅行
  ('viagem', 'aeroporto',              'airport',               '空港',              1),
  ('viagem', 'hotel',                  'hotel',                 'ホテル',            2),
  ('viagem', 'banheiro',               'bathroom',              'トイレ',            3),
  ('viagem', 'ônibus',                 'bus',                   'バス',              4),
  ('viagem', 'táxi',                   'taxi',                  'タクシー',          5),
  ('viagem', 'praia',                  'beach',                 'ビーチ',            6),
  ('viagem', 'dinheiro',               'money',                 'お金',              7),
  ('viagem', 'Quanto custa?',          'How much is it?',       'いくらですか？',    8),
  ('viagem', 'Onde fica o banheiro?',  'Where is the bathroom?','トイレはどこですか？', 9),
  ('viagem', 'ajuda',                  'help',                  '助け',              10),
  -- frases 便利なフレーズ
  ('frases', 'Eu não entendo',     'I don''t understand',    'わかりません',            1),
  ('frases', 'Fala inglês?',       'Do you speak English?',  '英語を話せますか？',      2),
  ('frases', 'Meu nome é Takeo',   'My name is Takeo',       '私の名前はタケオです',    3),
  ('frases', 'Pode repetir?',      'Can you repeat?',        'もう一度お願いします',    4),
  ('frases', 'Eu sou do Japão',    'I am from Japan',        '日本から来ました',        5),
  ('frases', 'Quero isso',         'I want this',            'これがほしいです',        6),
  ('frases', 'A conta, por favor', 'The check, please',      'お会計お願いします',      7),
  ('frases', 'Está bom',           'It''s good / OK',        'いいですね',              8);
