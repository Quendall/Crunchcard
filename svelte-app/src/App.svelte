<!-- App.svelte -->

<script>
    import { onMount } from 'svelte';
    let cards = [];

    onMount(async () => {
        const res = await fetch('http://localhost:5000/cards');
        cards = await res.json();
    });
</script>


<main>
    <h1>Cards</h1>
    {#each cards as card}
        <div>
            <h2>{card.question}</h2>
            <p>{card.answer}</p>
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

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>