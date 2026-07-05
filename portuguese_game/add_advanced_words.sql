-- Upgrade: add advanced categories (verbos, conversa, negocios)
-- Use this file ONLY if the portuguese_words table already exists
-- (i.e., you already ran the original schema.sql).
-- Run in the Supabase SQL Editor (takeo-apps project).

alter table portuguese_words drop constraint if exists portuguese_words_category_check;
alter table portuguese_words add constraint portuguese_words_category_check
  check (category in ('cumprimentos', 'numeros', 'comida', 'viagem', 'frases', 'verbos', 'conversa', 'negocios'));

insert into portuguese_words (category, pt, en, ja, sort_order) values  -- verbos 動詞
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
