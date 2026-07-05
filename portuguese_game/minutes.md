# Minutes — portuguese_game

Conversation log between Takeo and Claude for the portuguese_game project.

---

## 2026-07-04

**Takeo:** I would like to create a game who can learn Brazilian portugese. I am 63 years old and it is harder to remember. I can speak Japanese and English very well

**Claude:** Created `portuguese_game/` — an adult-oriented Brazilian Portuguese learning app designed around memory support:

- **Learn:** flashcards by category; pt-BR pronunciation via Web Speech, tap to reveal meaning in **both English and Japanese**, self-grade Hard/Easy; 🐢 slow playback button
- **Review:** spaced repetition (Leitner boxes, 1/3/7/14/30-day intervals) — hard/missed words return quickly, learned words wait longer; the Review tab shows how many words are due
- **Quiz:** 10 questions, 4 choices, both directions (PT→meaning, meaning→PT); misses go back into Review
- 48 starter words/phrases in 5 categories: cumprimentos (greetings), numeros, comida, viagem, frases
- Same architecture as the Japanese game: served at `/portuguese_game/` on the Vercel domain, words in a `portuguese_words` Supabase table (`schema.sql` to run once in the SQL Editor), embedded fallback for offline
- Progress (spaced repetition) is stored per device in localStorage

**Takeo:** Thank you. It was a little easy for me. would you set up more dificult words and sentences?

**Claude:** Added three advanced categories (38 new items, 86 total): **verbos** (14 core verbs: ser/estar/ter/fazer…), **conversa** (10 full sentences: Onde você mora?, Pode falar mais devagar?…), and **negocios** (14 business/trade terms chosen for the Brazil trade company: alfândega, exportação, fatura, prazo de entrega, Vamos fechar o negócio…). Updated `schema.sql` (fresh install) and added `add_advanced_words.sql` (upgrade if the table already exists — updates category constraint and inserts the new rows). Deployed and pushed.

**Takeo:** For Greeting, delete all except prazer em conhecer and put more phrase for greeting. Also, if I want to know each word meaning, you can show for example, conhecer itself means knowing but put words with prazer em causes nice to meeting (knowing) you. For Numbers, no need from 1 to 10. Need from 11 to 20 and 30, 40, --- 100, 1000.

**Claude:** Three changes: (1) Greetings rebuilt — kept only "Prazer em conhecer", added 9 phrase-level greetings (Como você está?, Há quanto tempo!, Seja bem-vindo, Cuide-se…). (2) Added a `note` field: word-by-word literal breakdown shown on the card back (e.g. prazer = pleasure / em = in / conhecer = to know → "pleasure in knowing you"); notes added to greetings, compound numbers, and all sentence-type entries. (3) Numbers replaced 1–10 with 11–20, 30…90, 100, 1000. `schema.sql` restructured to drop-and-rebuild so it's safe to run regardless of prior state; removed `add_advanced_words.sql`.

**Takeo:** would you do the same for Phrase and Conversation like Greeting for each word explain

**Claude:** Added word-by-word breakdown notes to every sentence in Phrases and Conversation (plus the two travel phrases and "Vamos fechar o negócio") in the app's built-in fallback words, matching what schema.sql already seeds — with JA glosses and verb-conjugation hints (e.g. "morar の活用"). Deployed and pushed.

**Takeo:** you forgot to do for prazo de entrega in BUSINESS

**Claude:** Added the missing breakdown for "prazo de entrega" (prazo = deadline（期限） / de = of / entrega = delivery（納品）, from entregar) in both index.html and schema.sql. Deployed and pushed.
