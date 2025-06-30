<script lang="ts">

  import type { Office } from '$lib/stores/officeStore';
  
  let { office, editOffice, deleteOffice } = $props<{
    office: Office;
    editOffice: (office: Office) => void;
    deleteOffice: () => void;
  }>();

  function handleEdit() {
    editOffice(office);
  }
  
</script>

<li class="p-4 bg-white rounded-xl shadow hover:shadow-lg transition-shadow">
  <div class="flex justify-between items-start">
    <div class="flex-1 cursor-pointer" on:click={handleEdit}>
      <h2 class="text-lg font-semibold">{office.name}</h2>
      <p class="text-sm text-gray-600">{office.address}</p>
      <p class="text-xs text-gray-400">Max items per user: {office.settings.maxItemsPerUser}</p>
    </div>
    <button
      on:click={deleteOffice}
      class="ml-4 px-3 py-1 text-red-600 cursor-pointer hover:text-red-800 hover:bg-red-50 rounded-md transition-colors"
      title="Delete office"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
      </svg>
    </button>
  </div>
</li> 