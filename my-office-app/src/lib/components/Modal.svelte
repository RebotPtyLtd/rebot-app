<script lang="ts">
  let { isOpen = $bindable(), title = $bindable(), close } = $props();

  function handleBackdropClick() {
    close();
  }
  
  function handleContentClick(event: Event) {
    event.stopPropagation();
  }
</script>

{#if isOpen}
  <div 
    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
    on:click={handleBackdropClick}
  >
    <div 
      class="bg-white rounded-lg p-6 w-full max-w-md mx-4" 
      on:click={handleContentClick}
    >
      <h2 class="text-xl font-bold mb-4">{title}</h2>
      <slot />
    </div>
  </div>
{/if} 