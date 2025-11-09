<script lang="ts">
	import { getPost, removePost, updatePost } from '$lib/api/posts.remote';

	let { params } = $props();

	const post_promise = $derived(getPost(params.slug));
	const post = $derived(await post_promise);
	// const post = await getPost(params.slug);
</script>

<h1>Update post</h1>

<form {...updatePost.enhance(({ submit }) => submit())}>
	<label>
		Title
		<input {...updatePost.fields.title.as('text')} value={post.title} />
		{#each updatePost.fields.title.issues() ?? [] as issue}
			<p class="issue">{issue.message}</p>
		{/each}
	</label>

	<label>
		Slug
		<input {...updatePost.fields.slug.as('text')} value={post.slug} />
		{#each updatePost.fields.slug.issues() ?? [] as issue}
			<p class="issue">{issue.message}</p>
		{/each}
	</label>

	<label>
		Content
		<textarea {...updatePost.fields.content.as('text')} value={post.content}></textarea>
		{#each updatePost.fields.content.issues() ?? [] as issue}
			<p class="issue">{issue.message}</p>
		{/each}
	</label>

	<input {...updatePost.fields.id.as('hidden', post.id.toString())} />

	<button type="submit" aria-busy={!!updatePost.pending}>Update</button>
	<button {...removePost.buttonProps} aria-busy={!!removePost.pending}>Delete</button>
</form>
