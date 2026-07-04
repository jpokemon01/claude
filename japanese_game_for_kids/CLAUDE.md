# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in the `japanese_game_for_kids/` directory.

## Overview

A browser-based game for a 3-year-old to learn Japanese vocabulary. Not deployed — open `index.html` directly in a browser (works offline, no build step, no dependencies).

## How It Works

- Single self-contained file: `index.html` (HTML + CSS + JavaScript)
- Audio uses the browser's Web Speech API with a Japanese (`ja-JP`) voice — Chrome and Edge on Windows include one by default
- Two modes: **カード (Flashcards)** — tap a card to see the emoji and hear the word; **クイズ (Quiz)** — hear a word, tap the matching picture out of 3, earn stars and confetti
- Four categories: どうぶつ (animals), たべもの (food), いろ (colors), かず (numbers 1–5)
- Designed for a toddler: giant tap targets, no reading required, no failure states, gentle retry on wrong answers

## Adding Vocabulary

Edit the `WORDS` object in `index.html` — each entry is `{ emoji, ja, en }`. New categories need a matching button on the home screen.
