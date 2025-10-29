<script lang="ts">
	import { getAuthorPosts } from '$lib/api/posts.remote';

	let { children } = $props();
</script>

<section class="dashboard">
	<aside>
		<div class="heading">
			<h2>🪶 Posts</h2>
			<a href="/admin/create" role="button">+Create</a>
		</div>

		<ul>
			{#each await getAuthorPosts() as post}
				<li>
					<a href="/admin/edit/{post.slug}" class="truncate-text capitalize">
						{post.title}
					</a>
				</li>
			{/each}
		</ul>
	</aside>

	<div>
		{@render children?.()}
	</div>
</section>
