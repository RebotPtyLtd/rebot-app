<script lang="ts">
  let { submit, cancel, form = $bindable(), submitLabel, cancelLabel } = $props();
  
  function handleSubmit() {
    submit();
  }
  
  function handleCancel() {
    cancel();
  }
</script>

<form on:submit|preventDefault={handleSubmit} class="space-y-4">
  <div>
    <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Office Name</label>
    <input
      type="text"
      id="name"
      bind:value={form.name}
      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      required
    />
  </div>
  
  <div>
    <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Address</label>
    <input
      type="text"
      id="address"
      bind:value={form.address}
      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      required
    />
  </div>
  
  <div>
    <label for="maxItems" class="block text-sm font-medium text-gray-700 mb-1">Max Items Per User</label>
    <input
      type="number"
      id="maxItems"
      bind:value={form.maxItemsPerUser}
      min="1"
      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      required
    />
  </div>
  
  <div class="flex space-x-3 pt-4">
    <button
      type="button"
      on:click={handleCancel}
      class="flex-1 px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500"
    >
      {cancelLabel}
    </button>
    <button
      type="submit"
      class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
    >
      {submitLabel}
    </button>
  </div>
</form> 