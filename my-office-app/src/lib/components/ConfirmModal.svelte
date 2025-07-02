<script>
  import { fade } from 'svelte/transition';
  import '$lib/styles/modal.css';
  
  export let message = "Are you sure?";
  export let onConfirm;
  export let onCancel;
</script>

<div class="modal-backdrop" transition:fade>
  <div class="modal-content" transition:fade>
    <h2 class="text-lg font-bold mb-2">Confirm Delete</h2>
    <p>{message}</p>
    <div class="mt-4 flex justify-center gap-4">
      <button on:click={onConfirm} class="btn btn-danger">Delete</button>
      <button on:click={onCancel} class="btn btn-secondary">Cancel</button>
    </div>
  </div>
</div>