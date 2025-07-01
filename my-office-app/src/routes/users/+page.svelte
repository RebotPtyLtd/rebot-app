

<script lang="ts">
  import { onMount } from 'svelte';
  import {
    getUsers,
    createUser,
    updateUser,
    deleteUser,
    type UserPayload
  } from '$lib/api';
  import { isAuthenticated } from '$lib/auth';

  let users: UserPayload[] = [];
  let editingId: number | null = null;
  let deletedUserIds: number[] = [];
  let editUser: UserPayload = {
    username: '',
    email: '',
    role: 'User',
    officeId: 1,
    firstName: '',
    lastName: ''
  };

  let newUser: UserPayload = {
    username: '',
    email: '',
    role: 'User',
    officeId: 1,
    firstName: '',
    lastName: ''
  };

  async function handleCreate() {
    try {
        const created = await createUser(newUser);
        const tempId = Math.max(0, ...users.map(u=> u.id ?? 0)) + 1;
        const newUserWithId = {
            ...newUser,
            id: created.id ?? tempId
        };
        users = [...users, newUserWithId];

        newUser = {
            username: '',
            email: '',
            role: 'user',
            officeId: 1,
            firstName: '',
            lastName: '',
        };
    } catch (err) {
        console.error('Failed to create user:', err);
    }
  }

  function startEdit(user: UserPayload & { id: number }){
    editingId = user.id;
    editUser  = {...user };
  }

  async function handleUpdate() {
    if (editingId !== null) {
      try {
        const updatedUser = await updateUser(editingId, editUser);

        users = users.map((u) =>
         u.id === editingId ? { ...editUser, id: editingId } : u
        );
        editingId = null;
        
        toast.success('User updated successfully!');
      } catch (err) {
        toast.error('Failed to update user:', err);
        console.error(err);
      }
    }
  }

  function isNotDeleted(user: UserPayload) {
    return user.id !== undefined && !deletedUserIds.includes(user.id);
  }
  
  async function handleDelete(userId: number) {
    if (!confirm('Are you sure you want to delete this user?')) return;

    try {
      await deleteUser(userId);


      deletedUserIds = [...deletedUserIds, userId];
      console.log('User is deleted successfully!');
    } catch (err) {
      console.error('Failed to delete user:', err);
    }
  }

  onMount(async() => {
    if (isAuthenticated()){
        try {
            const data = await getUsers();
            users = data.users.map((u,i) => ({
              ...u,
              id: u.id ?? i + 1
            }));
        } catch (err: any) {
          error = err.message;
        }
    } else {
        error = 'Not Authenticated. Please log in.';
    }
  });

</script>

<h1>User Management</h1>

<!-- CREATE USER -->
<h2>Create User</h2>
<form on:submit|preventDefault={handleCreate}>
  <input bind:value={newUser.username} placeholder="Username" required />
  <input bind:value={newUser.email} placeholder="Email" required />
  <input bind:value={newUser.firstName} placeholder="First Name" required />
  <input bind:value={newUser.lastName} placeholder="Last Name" required />
  <select bind:value={newUser.role}>
    <option value="User">User</option>
    <option value="OfficeAdmin">OfficeAdmin</option>
  </select>
  <input type="number" bind:value={newUser.officeId} placeholder="Office ID" required />
  <button type="submit">Add User</button>
</form>


<!-- LIST USERS -->
<h2>Users</h2>
<table>
  <thead>
    <tr>
      <th>User Id</th><th>Username</th><th>Email</th><th>Role</th><th>Office</th><th>Actions</th>
    </tr>
  </thead>
  <tbody>
    {#each users.filter(user => !deletedUserIds.includes(user.id)) as user}
      <tr>
        {#if editingId === user.id}
          <td><input bind:value={editUser.username} /></td>
          <td><input bind:value={editUser.email} /></td>
          <td>
            <select bind:value={editUser.role}>
              <option value="User">User</option>
              <option value="OfficeAdmin">OfficeAdmin</option>
            </select>
          </td>
          <td><input type="number" bind:value={editUser.officeId}/></td>
          <td>
            <button on:click={handleUpdate}>Save</button>
            <button on:click={() => (editingId = null)}>Cancel</button>
          </td>
        {:else}
          <td>{user.id}</td>
          <td>{user.username}</td>
          <td>{user.email}</td>
          <td>{user.role}</td>
          <td>{user.officeId}</td>
          <td>
            <button on:click={() => startEdit(user)}>Edit</button>
            <button on:click={() => handleDelete(user.id)}>Delete</button>
          </td>
        {/if}
      </tr>   
    {/each}
  </tbody>
</table>
