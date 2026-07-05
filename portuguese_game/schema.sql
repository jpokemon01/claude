-- portuguese_words table for the Portuguese learning game
-- Run this once in the Supabase SQL Editor (takeo-apps project):
-- https://supabase.com/dashboard/project/pujgfojebzyetxypwytg/sql
--
-- Same pattern as japanese_words: the game reads this table with the
-- public anon key (read-only via RLS). Add/edit words in the Table
-- Editor; the game picks up changes on next load. Keep at least
-- 4 words per category (the quiz shows 4 choices). Categories:
-- cumprimentos, numeros, comida, viagem, frases, verbos, conversa, negocios
--
-- NOTE: if you already ran an older version of this file (table exists),
-- run add_advanced_words.sql instead — this file is for a fresh setup.

create table if not exists portuguese_words (
  id bigint generated always as identity primary key,
  category text not null check (category in ('cumprimentos', 'numeros', 'comida', 'viagem', 'frases', 'verbos', 'conversa', 'negocios')),
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
  ('frases', 'Está bom',           'It''s good / OK',        'いいですね',              8),
  -- verbos 動詞
  ('verbos', 'ser',       'to be (permanent)', '〜である（永続的）', 1),
  ('verbos', 'estar',     'to be (right now)', '〜である（一時的）', 2),
  ('verbos', 'ter',       'to have',           '持つ',               3),
  ('verbos', 'fazer',     'to do / to make',   'する・作る',         4),
  ('verbos', 'ir',        'to go',             '行く',               5),
  ('verbos', 'querer',    'to want',           'ほしい・〜したい',   6),
  ('verbos', 'poder',     'can / may',         'できる',             7),
  ('verbos', 'falar',     'to speak',          '話す',               8),
  ('verbos', 'comer',     'to eat',            '食べる',             9),
  ('verbos', 'beber',     'to drink',          '飲む',               10),
  ('verbos', 'comprar',   'to buy',            '買う',               11),
  ('verbos', 'vender',    'to sell',           '売る',               12),
  ('verbos', 'trabalhar', 'to work',           '働く',               13),
  ('verbos', 'entender',  'to understand',     '理解する',           14),
  -- conversa 会話文
  ('conversa', 'Onde você mora?',              'Where do you live?',         'どこに住んでいますか？',             1),
  ('conversa', 'Eu moro no Japão',             'I live in Japan',            '日本に住んでいます',                 2),
  ('conversa', 'O que você recomenda?',        'What do you recommend?',     'おすすめは何ですか？',               3),
  ('conversa', 'Pode falar mais devagar?',     'Can you speak more slowly?', 'もっとゆっくり話してもらえますか？', 4),
  ('conversa', 'Estou aprendendo português',   'I am learning Portuguese',   'ポルトガル語を勉強しています',       5),
  ('conversa', 'Que horas são?',               'What time is it?',           'いま何時ですか？',                   6),
  ('conversa', 'Hoje está muito quente',       'Today is very hot',          '今日はとても暑いです',               7),
  ('conversa', 'Vai chover amanhã?',           'Will it rain tomorrow?',     '明日は雨が降りますか？',             8),
  ('conversa', 'Quanto tempo demora?',         'How long does it take?',     'どのくらい時間がかかりますか？',     9),
  ('conversa', 'Foi um prazer falar com você', 'It was a pleasure talking with you', 'お話しできてうれしかったです', 10),
  -- negocios ビジネス・貿易
  ('negocios', 'empresa',          'company',                 '会社',           1),
  ('negocios', 'reunião',          'meeting',                 '会議',           2),
  ('negocios', 'contrato',         'contract',                '契約',           3),
  ('negocios', 'preço',            'price',                   '価格',           4),
  ('negocios', 'imposto',          'tax',                     '税金',           5),
  ('negocios', 'alfândega',        'customs',                 '税関',           6),
  ('negocios', 'exportação',       'export',                  '輸出',           7),
  ('negocios', 'importação',       'import',                  '輸入',           8),
  ('negocios', 'frete',            'freight / shipping cost', '運賃・送料',     9),
  ('negocios', 'fatura',           'invoice',                 '請求書',         10),
  ('negocios', 'prazo de entrega', 'delivery deadline',       '納期',           11),
  ('negocios', 'fornecedor',       'supplier',                '仕入先',         12),
  ('negocios', 'cliente',          'customer',                '顧客',           13),
  ('negocios', 'Vamos fechar o negócio', 'Let''s close the deal', '取引をまとめましょう', 14);
