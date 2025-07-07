<script lang="ts">
  import { fetchOffices } from '$lib/api';
  import { authStore } from '$lib/stores/authStore';

  let offices: any[] = $state([]);
  let error: string | null = $state(null);
  import { isAuthenticated } from '$lib/auth';
  import { officeStore, setOffices, type Office } from '$lib/stores/officeStore';
  import { Modal, OfficeForm, DeleteConfirmation, OfficeCard } from '$lib/components';

  let error: string | null = null;
  let offices: Office[] = $state([]);
  let showEditModal = $state(false);
  let showDeleteModal = $state(false);
  let showAddModal = $state(false);
  let editingOffice: Office | null = $state(null);
  let deletingOffice: Office | null = $state(null);
  let editForm = $state({
    name: '',
    address: '',
    maxItemsPerUser: 0
  });
  let addForm = $state({
    name: '',
    address: '',
    maxItemsPerUser: 1
  });

  $effect(() => {
    officeStore.subscribe(state => {
      offices = state.offices;
    });
  });

  // Reactive statement to fetch offices when authenticated
  $effect(async () => {
    console.log('+page.svelte: $authStore.isAuthenticated:', $authStore.isAuthenticated);
    if ($authStore.isAuthenticated) {
      console.log('+page.svelte: Authenticated, fetching offices...');
      try {
        const data = await fetchOffices();
        offices = data.offices;
        error = null; // Clear any previous errors on successful fetch
        setOffices(data.offices);
      } catch (err: any) {
        error = err.message;
        console.error('+page.svelte: Error fetching offices:', error);
      }
    } else {
      offices = []; // Clear offices if not authenticated
      error = null; // Clear error if not authenticated
      console.log('+page.svelte: Not authenticated, clearing offices and error.');
    }
  });

  function openAddModal() {
    addForm = {
      name: '',
      address: '',
      maxItemsPerUser: 1
    };
    showAddModal = true;
  }

  function openEditModal(office: Office) {
    editingOffice = office;
    editForm = {
      name: office.name,
      address: office.address,
      maxItemsPerUser: office.settings.maxItemsPerUser
    };
    showEditModal = true;
  }

  function openDeleteModal(office: Office) {
    deletingOffice = office;
    showDeleteModal = true;
  }

  function closeAddModal() {
    showAddModal = false;
  }

  function closeEditModal() {
    showEditModal = false;
    editingOffice = null;
  }

  function closeDeleteModal() {
    showDeleteModal = false;
    deletingOffice = null;
  }

  function handleAddSubmit() {
    // Create new office with a unique ID
    const newOffice: Office = {
      id: Math.max(...offices.map(o => o.id), 0) + 1,
      name: addForm.name,
      address: addForm.address,
      settings: {
        maxItemsPerUser: addForm.maxItemsPerUser
      }
    };
    
    // Add to store
    const updatedOffices = [newOffice, ...offices];
    setOffices(updatedOffices);
    closeAddModal();
  }

  function handleEditSubmit() {
    if (editingOffice) {
      // Update the office in the store
      const updatedOffices = offices.map(office => 
        office.id === editingOffice!.id 
          ? {
              ...office,
              name: editForm.name,
              address: editForm.address,
              settings: {
                ...office.settings,
                maxItemsPerUser: editForm.maxItemsPerUser
              }
            }
          : office
      );
      setOffices(updatedOffices);
      closeEditModal();
    }
  }

  function handleDeleteConfirm() {
    if (deletingOffice) {
      // Remove the office from the store
      const updatedOffices = offices.filter(office => office.id !== deletingOffice!.id);
      setOffices(updatedOffices);
      closeDeleteModal();
    }
  }
</script>

<main class="p-6">
  <div class="flex justify-between items-center mb-6">
    <h1 class="text-2xl font-bold">Offices</h1>
    <button
      on:click={openAddModal}
      class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 flex items-center space-x-2"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
      </svg>
      <span>Add Office</span>
    </button>
  </div>

  {#if error}
    <div role="alert" class="alert alert-error">
      <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
      <span>{error}</span>
    </div>
  {:else if offices.length === 0 && $authStore.isAuthenticated}
    <div class="flex items-center justify-center space-x-2">
      <span class="loading loading-spinner loading-lg text-primary"></span>
      <p class="text-lg text-neutral">Loading offices...</p>
    </div>
  {:else if offices.length === 0 && !$authStore.isAuthenticated}
    <div role="alert" class="alert alert-info">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-current shrink-0 w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
      <span>Please log in to view offices.</span>
    </div>
  {:else}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {#each offices as office}
        <OfficeCard 
          {office}
          editOffice={openEditModal}
          deleteOffice={() => openDeleteModal(office)}
        />
      {/each}
    </div>
  {/if}

</main>

<!-- Add Office Modal -->
<Modal 
  isOpen={showAddModal} 
  title="Add New Office"
  close={closeAddModal}
>
  <OfficeForm 
    bind:form={addForm}
    submitLabel="Add Office"
    cancelLabel="Cancel"
    submit={handleAddSubmit}
    cancel={closeAddModal}
  />
</Modal>

<!-- Edit Office Modal -->
<Modal 
  isOpen={showEditModal} 
  title="Edit Office"
  close={closeEditModal}
>
  <OfficeForm 
    bind:form={editForm}
    submitLabel="Save Changes"
    cancelLabel="Cancel"
    submit={handleEditSubmit}
    cancel={closeEditModal}
  />
</Modal>

<!-- Delete Confirmation Modal -->
<DeleteConfirmation 
  isOpen={showDeleteModal}
  itemName={deletingOffice?.name || ''}
  itemType="Office"
  confirm={handleDeleteConfirm}
  cancel={closeDeleteModal}
/>
