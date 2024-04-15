// flashcard.js
let flashcards = [
    { question: 'Question 1', answer: 'Answer 1' },
    { question: 'Question 2', answer: 'Answer 2' },
    // Add more flashcards as needed
];

let currentCard = 0;

document.getElementById('question').innerText = flashcards[currentCard].question;
document.getElementById('answer').innerText = flashcards[currentCard].answer;

document.getElementById('flashcard').addEventListener('click', function() {
    this.classList.toggle('flipped');
});

document.getElementById('next').addEventListener('click', function() {
    currentCard = (currentCard + 1) % flashcards.length;
    document.getElementById('question').innerText = flashcards[currentCard].question;
    document.getElementById('answer').innerText = flashcards[currentCard].answer;
    document.getElementById('flashcard').classList.remove('flipped');
});