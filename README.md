# Crunchcard

## Overview

Crunchcard is a simple, collaborative flashcard webapp. It runs Svelte and Node.js for the front end and Express.js with ScylladDB for the back end.

## System Design

- folder
  - cardset
- cardset
  - card
    - question
    - answer
    - last modified
- user
  - username
  - folders
  - cardsets
  - shared

Pages
- Sign in page
- Home/profile page
  - list of folders/cardsets
- Carset editor
  - Cardset title
  - Cardset description
  - List of cards in cardset
- Cardset sharing permission (click share)
  - [ { user, p }, ... ]
- Card viewer
  - one card from cardset


# TODO: Create APIs
- INSERT card
- EDIT card
- INSERT and FETCH user 




## ScyllaDB


