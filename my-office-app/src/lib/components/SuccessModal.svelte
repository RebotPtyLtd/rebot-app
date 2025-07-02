<script>
  import { fade } from 'svelte/transition';
  import '$lib/styles/modal.css';

  export let message = "User created successfully.";
  export let onClose;
</script>

<div class="modal-backdrop" transition:fade>
  <div class="modal-content" transition:fade>
    <h2 class="text-lg font-bold mb-2">Success!</h2>
    <p>{message}</p>
    <button on:click={onClose} class="btn btn-primary mt-4">OK</button>
  </div>
</div>