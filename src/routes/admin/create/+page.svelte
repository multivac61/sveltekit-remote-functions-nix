<script lang="ts">
  import { createPost } from "$lib/api/posts.remote";
</script>

<h1>Create new post</h1>

<form {...createPost}>
  <label>
    Title
    <input {...createPost.fields.title.as("text")} />
    {#each createPost.fields.title.issues() ?? [] as issue}
      <p class="issue">{issue.message}</p>
    {/each}
  </label>

  <label>
    Slug
    <input {...createPost.fields.slug.as("text")} />
    {#each createPost.fields.slug.issues() ?? [] as issue}
      <p class="issue">{issue.message}</p>
    {/each}
  </label>

  <label>
    Content
    <textarea {...createPost.fields.content.as("text")}></textarea>
    {#each createPost.fields.content.issues() ?? [] as issue}
      <p class="issue">{issue.message}</p>
    {/each}
  </label>

  <button type="submit" aria-busy={!!createPost.pending}>Publish</button>
</form>
