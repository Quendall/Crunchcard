<!-- App.svelte -->

<script>
  import { onMount } from "svelte";
  let cards = [];

  onMount(async () => {
    const res = await fetch("http://localhost:5000/cards");
    cards = await res.json();
  });

  async function saveCard(index) {
    const card = cards[index];
    // Update the card on the server
    await fetch(`http://localhost:5000/cards/${index}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(card),
    });
  }
</script>

<main>
  <h1>Cards</h1>
  {#each cards as card, i (i)}
    <div class="card">
      <div class="question">
        <h3>question</h3>
        <input bind:value={card.question} />
      </div>

      <div class="answer">
        <h3>answer</h3>
        <input bind:value={card.answer} />
      </div>

      <button on:click={() => saveCard(i)}>Save</button>
    </div>
  {/each}
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  .card {
    background-color: #f9f9f9;
    border-radius: 5px;
    padding: 1em;
    margin: 1em 0;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
