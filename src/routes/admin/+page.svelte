<script lang="ts">
	import { getUser, signout } from '$lib/api/auth.remote';

	const user = await getUser();
</script>

<h2>Admin</h2>
<p>Welcome, {user.name}!</p>

<form {...signout}>
	<button type="submit">Sign out</button>
</form>
