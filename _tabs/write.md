---
layout: page
title: Write
icon: fas fa-pen
order: 2
---

<p>Use this page to generate a Markdown post file, then download it into <code>_posts/</code>.</p>

<div class="write-card">
  <label class="write-field">
    <span>Title</span>
    <input id="post-title" type="text" placeholder="e.g. 안녕하세요 코복입니다" />
  </label>
  <label class="write-field">
    <span>Slug</span>
    <input id="post-slug" type="text" placeholder="e.g. hello-cobok" />
  </label>
  <label class="write-field">
    <span>Date</span>
    <input id="post-date" type="date" />
  </label>
  <label class="write-field">
    <span>Categories</span>
    <input id="post-categories" type="text" value="blog" placeholder="comma separated" />
  </label>
  <label class="write-field">
    <span>Tags</span>
    <input id="post-tags" type="text" placeholder="comma separated" />
  </label>
  <label class="write-field">
    <span>Body</span>
    <textarea id="post-body" rows="10" placeholder="Write your post..."></textarea>
  </label>
  <div class="write-field">
    <span>Image</span>
    <input id="post-image" type="file" accept="image/*" />
    <input id="post-image-alt" type="text" placeholder="Alt text (optional)" />
    <div class="write-actions">
      <button id="post-image-insert" type="button">Insert Image Markdown</button>
      <button id="post-image-download" type="button">Download Image</button>
    </div>
    <p class="write-hint">Suggested path: <code>/assets/img/posts/YYYY-MM-DD/filename</code></p>
  </div>
  <div class="write-actions">
    <button id="post-download" type="button">Download Markdown</button>
    <button id="post-copy" type="button">Copy to Clipboard</button>
  </div>
  <p id="post-status" class="write-status" aria-live="polite"></p>
</div>

<style>
  .write-card {
    margin-top: 1.5rem;
    padding: 1.5rem;
    border: 1px solid var(--border-color, #e0e0e0);
    border-radius: 12px;
    background: linear-gradient(135deg, #f8f6f2 0%, #ffffff 60%);
  }
  .write-field {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    margin-bottom: 1rem;
  }
  .write-field span {
    font-weight: 600;
  }
  .write-field input,
  .write-field textarea {
    padding: 0.6rem 0.8rem;
    border: 1px solid var(--border-color, #e0e0e0);
    border-radius: 8px;
    background: #ffffff;
  }
  .write-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-top: 0.5rem;
  }
  .write-actions button {
    padding: 0.55rem 1.2rem;
    border-radius: 999px;
    border: 1px solid #111111;
    background: #111111;
    color: #ffffff;
    cursor: pointer;
  }
  .write-actions button#post-copy {
    background: #ffffff;
    color: #111111;
  }
  .write-status {
    margin-top: 0.75rem;
    min-height: 1.2rem;
    color: #444444;
  }
  .write-hint {
    margin: 0.4rem 0 0;
    color: #666666;
    font-size: 0.9rem;
  }
</style>

<script>
  const titleInput = document.getElementById("post-title");
  const slugInput = document.getElementById("post-slug");
  const dateInput = document.getElementById("post-date");
  const categoriesInput = document.getElementById("post-categories");
  const tagsInput = document.getElementById("post-tags");
  const bodyInput = document.getElementById("post-body");
  const downloadButton = document.getElementById("post-download");
  const copyButton = document.getElementById("post-copy");
  const statusLine = document.getElementById("post-status");
  const imageInput = document.getElementById("post-image");
  const imageAltInput = document.getElementById("post-image-alt");
  const imageInsertButton = document.getElementById("post-image-insert");
  const imageDownloadButton = document.getElementById("post-image-download");

  const today = new Date().toISOString().slice(0, 10);
  dateInput.value = today;

  const slugify = (text) =>
    text
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "");

  const escapeQuotes = (text) => text.replace(/"/g, '\\"');

  const listFromInput = (value) =>
    value
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);

  const buildFrontMatter = () => {
    const title = titleInput.value.trim() || "Untitled";
    const slug = slugInput.value.trim() || slugify(title) || "untitled";
    const date = dateInput.value || today;
    const categories = listFromInput(categoriesInput.value || "blog");
    const tags = listFromInput(tagsInput.value);
    const body = bodyInput.value.trim();

    const frontMatter = [
      "---",
      "layout: post",
      `title: "${escapeQuotes(title)}"`,
      `date: ${date} 00:00:00 +0900`,
      `categories: [${categories.join(", ")}]`,
      `tags: [${tags.join(", ")}]`,
      "comments: true",
      "toc: true",
      "---",
      "",
      body,
      ""
    ].join("\n");

    return { frontMatter, filename: `${date}-${slug}.md` };
  };

  const getImagePath = (file, date) => {
    if (!file) return "";
    const safeName = file.name.replace(/\s+/g, "-");
    return `/assets/img/posts/${date}/${safeName}`;
  };

  titleInput.addEventListener("input", () => {
    if (!slugInput.value.trim()) {
      slugInput.value = slugify(titleInput.value);
    }
  });

  downloadButton.addEventListener("click", () => {
    const { frontMatter, filename } = buildFrontMatter();
    const blob = new Blob([frontMatter], { type: "text/markdown" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    link.click();
    URL.revokeObjectURL(link.href);
    statusLine.textContent = `Downloaded ${filename}.`;
  });

  copyButton.addEventListener("click", async () => {
    const { frontMatter } = buildFrontMatter();
    try {
      await navigator.clipboard.writeText(frontMatter);
      statusLine.textContent = "Copied to clipboard.";
    } catch (error) {
      statusLine.textContent = "Copy failed. Please use Download instead.";
    }
  });

  imageInsertButton.addEventListener("click", () => {
    const file = imageInput.files && imageInput.files[0];
    if (!file) {
      statusLine.textContent = "Select an image first.";
      return;
    }
    const date = dateInput.value || today;
    const imagePath = getImagePath(file, date);
    const altText = imageAltInput.value.trim();
    const markdown = `![${altText}](${imagePath})`;
    bodyInput.value = `${bodyInput.value.trim()}\n\n${markdown}\n`;
    statusLine.textContent = `Inserted image markdown: ${imagePath}`;
  });

  imageDownloadButton.addEventListener("click", () => {
    const file = imageInput.files && imageInput.files[0];
    if (!file) {
      statusLine.textContent = "Select an image first.";
      return;
    }
    const date = dateInput.value || today;
    const safeName = file.name.replace(/\s+/g, "-");
    const suggestedName = `${date}-${safeName}`;
    const link = document.createElement("a");
    link.href = URL.createObjectURL(file);
    link.download = suggestedName;
    link.click();
    URL.revokeObjectURL(link.href);
    statusLine.textContent = `Downloaded image as ${suggestedName}.`;
  });
</script>
