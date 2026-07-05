-- portuguese_words table for the Portuguese learning game
-- Run this in the Supabase SQL Editor (takeo-apps project):
-- https://supabase.com/dashboard/project/pujgfojebzyetxypwytg/sql
--
-- Safe to run at ANY time, even if the table already exists: it rebuilds
-- the word list from scratch. (Learning progress is NOT stored here —
-- it lives in each device's browser — so nothing is lost.)
--
-- The game reads this table with the public anon key (read-only via RLS).
-- Add/edit words in the Table Editor; the game picks up changes on next
-- load. Keep at least 4 words per category (the quiz shows 4 choices).
-- The optional `note` column is the word-by-word breakdown shown on the
-- back of the flashcard.

drop table if exists portuguese_words;

create table portuguese_words (
  id bigint generated always as identity primary key,
  category text not null check (category in ('cumprimentos', 'numeros', 'comida', 'viagem', 'frases', 'verbos', 'conversa', 'negocios')),
  pt text not null,
  en text,
  ja text,
  note text,
  sort_order int not null default 0
);

alter table portuguese_words enable row level security;

create policy "Public read access" on portuguese_words
  for select using (true);

insert into portuguese_words (category, pt, en, ja, note, sort_order) values
  -- cumprimentos あいさつ
  ('cumprimentos', 'Prazer em conhecer', 'Nice to meet you', 'はじめまして',
   'prazer = pleasure（喜び） / em = in / conhecer = to know（知る） → "pleasure in knowing you"', 1),
  ('cumprimentos', 'Como você está?', 'How are you?', 'お元気ですか？',
   'como = how / você = you / está = are（estar の活用）', 2),
  ('cumprimentos', 'Como vai?', 'How''s it going?', '調子はどうですか？',
   'como = how / vai = goes（ir の活用） → "how goes it?"', 3),
  ('cumprimentos', 'Há quanto tempo!', 'Long time no see!', 'お久しぶりです！',
   'há = it has been / quanto = how much / tempo = time（時間） → "it''s been so much time!"', 4),
  ('cumprimentos', 'Seja bem-vindo', 'Welcome', 'ようこそ',
   'seja = be（ser の命令形） / bem = well（よく） / vindo = come（来た） → "be well-come"', 5),
  ('cumprimentos', 'Até logo', 'See you soon', 'また後でね',
   'até = until（〜まで） / logo = soon（すぐ）', 6),
  ('cumprimentos', 'Até amanhã', 'See you tomorrow', 'また明日',
   'até = until（〜まで） / amanhã = tomorrow（明日）', 7),
  ('cumprimentos', 'Bom fim de semana', 'Have a good weekend', 'よい週末を',
   'bom = good / fim = end（終わり） / de = of / semana = week（週） → "good end of week"', 8),
  ('cumprimentos', 'Faz tempo que não te vejo', 'I haven''t seen you in a while', 'しばらく会っていませんでしたね',
   'faz tempo = it''s been a while / que = that / não te vejo = I don''t see you（te = あなたを, vejo = 見る）', 9),
  ('cumprimentos', 'Cuide-se', 'Take care', '気をつけてね・お大事に',
   'cuidar = to take care（世話する） + se = yourself（自分を）', 10),
  -- numeros 数字
  ('numeros', 'onze',      'eleven (11)',        '十一', null, 1),
  ('numeros', 'doze',      'twelve (12)',        '十二', null, 2),
  ('numeros', 'treze',     'thirteen (13)',      '十三', null, 3),
  ('numeros', 'catorze',   'fourteen (14)',      '十四', null, 4),
  ('numeros', 'quinze',    'fifteen (15)',       '十五', null, 5),
  ('numeros', 'dezesseis', 'sixteen (16)',       '十六', 'dez (10) + e (と) + seis (6)', 6),
  ('numeros', 'dezessete', 'seventeen (17)',     '十七', 'dez (10) + e (と) + sete (7)', 7),
  ('numeros', 'dezoito',   'eighteen (18)',      '十八', 'dez (10) + oito (8)', 8),
  ('numeros', 'dezenove',  'nineteen (19)',      '十九', 'dez (10) + nove (9)', 9),
  ('numeros', 'vinte',     'twenty (20)',        '二十', null, 10),
  ('numeros', 'trinta',    'thirty (30)',        '三十', null, 11),
  ('numeros', 'quarenta',  'forty (40)',         '四十', 'quatro (4) が語源', 12),
  ('numeros', 'cinquenta', 'fifty (50)',         '五十', 'cinco (5) が語源', 13),
  ('numeros', 'sessenta',  'sixty (60)',         '六十', 'seis (6) が語源', 14),
  ('numeros', 'setenta',   'seventy (70)',       '七十', 'sete (7) が語源', 15),
  ('numeros', 'oitenta',   'eighty (80)',        '八十', 'oito (8) が語源', 16),
  ('numeros', 'noventa',   'ninety (90)',        '九十', 'nove (9) が語源', 17),
  ('numeros', 'cem',       'one hundred (100)',  '百',   null, 18),
  ('numeros', 'mil',       'one thousand (1000)', '千',  null, 19),
  -- comida 食べ物
  ('comida', 'água',    'water',   '水',       null, 1),
  ('comida', 'café',    'coffee',  'コーヒー', null, 2),
  ('comida', 'pão',     'bread',   'パン',     null, 3),
  ('comida', 'arroz',   'rice',    'ご飯',     null, 4),
  ('comida', 'feijão',  'beans',   '豆',       null, 5),
  ('comida', 'carne',   'meat',    '肉',       null, 6),
  ('comida', 'frango',  'chicken', '鶏肉',     null, 7),
  ('comida', 'peixe',   'fish',    '魚',       null, 8),
  ('comida', 'fruta',   'fruit',   '果物',     null, 9),
  ('comida', 'cerveja', 'beer',    'ビール',   null, 10),
  -- viagem 旅行
  ('viagem', 'aeroporto',             'airport',                '空港',               null, 1),
  ('viagem', 'hotel',                 'hotel',                  'ホテル',             null, 2),
  ('viagem', 'banheiro',              'bathroom',               'トイレ',             null, 3),
  ('viagem', 'ônibus',                'bus',                    'バス',               null, 4),
  ('viagem', 'táxi',                  'taxi',                   'タクシー',           null, 5),
  ('viagem', 'praia',                 'beach',                  'ビーチ',             null, 6),
  ('viagem', 'dinheiro',              'money',                  'お金',               null, 7),
  ('viagem', 'Quanto custa?',         'How much is it?',        'いくらですか？',     'quanto = how much / custa = costs（custar）', 8),
  ('viagem', 'Onde fica o banheiro?', 'Where is the bathroom?', 'トイレはどこですか？', 'onde = where / fica = is located（ficar） / o banheiro = the bathroom', 9),
  ('viagem', 'ajuda',                 'help',                   '助け',               null, 10),
  -- frases 便利なフレーズ
  ('frases', 'Eu não entendo',     'I don''t understand',   'わかりません',         'eu = I / não = not / entendo = understand（entender）', 1),
  ('frases', 'Fala inglês?',       'Do you speak English?', '英語を話せますか？',   'fala = speak（falar） / inglês = English', 2),
  ('frases', 'Meu nome é Takeo',   'My name is Takeo',      '私の名前はタケオです', 'meu = my / nome = name / é = is（ser）', 3),
  ('frases', 'Pode repetir?',      'Can you repeat?',       'もう一度お願いします', 'pode = can（poder） / repetir = to repeat', 4),
  ('frases', 'Eu sou do Japão',    'I am from Japan',       '日本から来ました',     'eu sou = I am（ser） / do = from the / Japão = Japan', 5),
  ('frases', 'Quero isso',         'I want this',           'これがほしいです',     'quero = I want（querer） / isso = this', 6),
  ('frases', 'A conta, por favor', 'The check, please',     'お会計お願いします',   'a conta = the bill / por favor = please', 7),
  ('frases', 'Está bom',           'It''s good / OK',       'いいですね',           'está = is（estar） / bom = good', 8),
  -- verbos 動詞
  ('verbos', 'ser',       'to be (permanent)', '〜である（永続的）', null, 1),
  ('verbos', 'estar',     'to be (right now)', '〜である（一時的）', null, 2),
  ('verbos', 'ter',       'to have',           '持つ',               null, 3),
  ('verbos', 'fazer',     'to do / to make',   'する・作る',         null, 4),
  ('verbos', 'ir',        'to go',             '行く',               null, 5),
  ('verbos', 'querer',    'to want',           'ほしい・〜したい',   null, 6),
  ('verbos', 'poder',     'can / may',         'できる',             null, 7),
  ('verbos', 'falar',     'to speak',          '話す',               null, 8),
  ('verbos', 'comer',     'to eat',            '食べる',             null, 9),
  ('verbos', 'beber',     'to drink',          '飲む',               null, 10),
  ('verbos', 'comprar',   'to buy',            '買う',               null, 11),
  ('verbos', 'vender',    'to sell',           '売る',               null, 12),
  ('verbos', 'trabalhar', 'to work',           '働く',               null, 13),
  ('verbos', 'entender',  'to understand',     '理解する',           null, 14),
  -- conversa 会話文
  ('conversa', 'Onde você mora?',              'Where do you live?',            'どこに住んでいますか？',
   'onde = where / você = you / mora = live（morar）', 1),
  ('conversa', 'Eu moro no Japão',             'I live in Japan',               '日本に住んでいます',
   'eu = I / moro = live（morar） / no = in the / Japão = Japan', 2),
  ('conversa', 'O que você recomenda?',        'What do you recommend?',        'おすすめは何ですか？',
   'o que = what / você = you / recomenda = recommend（recomendar）', 3),
  ('conversa', 'Pode falar mais devagar?',     'Can you speak more slowly?',    'もっとゆっくり話してもらえますか？',
   'pode = can（poder） / falar = to speak / mais = more / devagar = slowly', 4),
  ('conversa', 'Estou aprendendo português',   'I am learning Portuguese',      'ポルトガル語を勉強しています',
   'estou = I am（estar） / aprendendo = learning（aprender） / português = Portuguese', 5),
  ('conversa', 'Que horas são?',               'What time is it?',              'いま何時ですか？',
   'que = what / horas = hours（時間） / são = are（ser）', 6),
  ('conversa', 'Hoje está muito quente',       'Today is very hot',             '今日はとても暑いです',
   'hoje = today / está = is（estar） / muito = very / quente = hot', 7),
  ('conversa', 'Vai chover amanhã?',           'Will it rain tomorrow?',        '明日は雨が降りますか？',
   'vai = will（ir） / chover = to rain / amanhã = tomorrow', 8),
  ('conversa', 'Quanto tempo demora?',         'How long does it take?',        'どのくらい時間がかかりますか？',
   'quanto = how much / tempo = time / demora = takes（demorar）', 9),
  ('conversa', 'Foi um prazer falar com você', 'It was a pleasure talking with you', 'お話しできてうれしかったです',
   'foi = was（ser） / um prazer = a pleasure / falar = to talk / com você = with you', 10),
  -- negocios ビジネス・貿易
  ('negocios', 'empresa',          'company',                 '会社',       null, 1),
  ('negocios', 'reunião',          'meeting',                 '会議',       null, 2),
  ('negocios', 'contrato',         'contract',                '契約',       null, 3),
  ('negocios', 'preço',            'price',                   '価格',       null, 4),
  ('negocios', 'imposto',          'tax',                     '税金',       null, 5),
  ('negocios', 'alfândega',        'customs',                 '税関',       null, 6),
  ('negocios', 'exportação',       'export',                  '輸出',       null, 7),
  ('negocios', 'importação',       'import',                  '輸入',       null, 8),
  ('negocios', 'frete',            'freight / shipping cost', '運賃・送料', null, 9),
  ('negocios', 'fatura',           'invoice',                 '請求書',     null, 10),
  ('negocios', 'prazo de entrega', 'delivery deadline',       '納期',       null, 11),
  ('negocios', 'fornecedor',       'supplier',                '仕入先',     null, 12),
  ('negocios', 'cliente',          'customer',                '顧客',       null, 13),
  ('negocios', 'Vamos fechar o negócio', 'Let''s close the deal', '取引をまとめましょう',
   'vamos = let''s go（ir） / fechar = to close（閉める） / o negócio = the deal（取引）', 14);
