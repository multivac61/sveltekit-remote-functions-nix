<script lang="ts">
	import {
		getPostLikes,
		getPost,
		getPosts,
		likePost,
		postComment,
		getPostComments,
	} from '$lib/api/posts.remote';

	let { params } = $props();

	const post_promise = $derived(getPost(params.slug));
	const post = $derived(await post_promise);
</script>

<div class="content">
	<div>
		<article>
			<h1>{post.title}</h1>
			<div>{@html post.content}</div>
		</article>

		<button
			onclick={() => {
				likePost(post.id).updates(getPostLikes(post.id).withOverride((likes) => likes + 1));
			}}
			class="outline"
		>
			❤️ {await getPostLikes(post.id)}
		</button>

		<div class="comments">
			<h2>Comments</h2>

			{#each await getPostComments(post.id) as { author, comment, id } (id)}
				<div class="comment">
					<h6>@{author}</h6>
					<p>{comment}</p>
				</div>
			{:else}
				<p>No comments</p>
			{/each}

			<h2>Leave a comment</h2>

			<form
				{...postComment.enhance(({ submit }) => {
					submit();
					postComment.fields.comment.set('');
				})}
			>
				<label>
					Name
					<input {...postComment.fields.author.as('text')} value="Anonymous" />
					{#each postComment.fields.author.issues() ?? [] as issue}
						<p class="issue">{issue.message}</p>
					{/each}
				</label>

				<label>
					Comment
					<textarea {...postComment.fields.comment.as('text')}></textarea>
					{#each postComment.fields.comment.issues() ?? [] as issue}
						<p class="issue">{issue.message}</p>
					{/each}
				</label>

				<input {...postComment.fields.postId.as('hidden', post.id.toString())} />

				<button type="submit" aria-busy={!!postComment.pending}>Post comment</button>
			</form>
		</div>
	</div>

	<div>
		<h2>More Svelte</h2>
		<ul>
			{#each await getPosts() as post (post.id)}
				<li>
					<a href="/{post.slug}" class="capitalize">{post.title}</a>
				</li>
			{/each}
		</ul>
	</div>
</div>
