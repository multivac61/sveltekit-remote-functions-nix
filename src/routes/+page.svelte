<script lang="ts">
	import { getPosts } from '$lib/api/posts.remote';
</script>

<h1>🔥 Latest posts</h1>

<div class="posts">
	{#each await getPosts() as post (post.id)}
		<article>
			<a href="/{post.slug}" class="capitalize">{post.title}</a>
		</article>
	{:else}
		<p>No posts found</p>
	{/each}
</div>
