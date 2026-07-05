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
