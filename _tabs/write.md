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
    <span>Import Markdown</span>
    <input id="post-import" type="file" accept=".md,text/markdown" />
  </div>
  <div class="write-field">
    <span>Image</span>
    <input id="post-image" type="file" accept="image/*" />
    <input id="post-image-alt" type="text" placeholder="Alt text (optional)" />
    <img id="post-image-preview" alt="" />
    <div class="write-actions">
      <button id="post-image-insert" type="button">Insert Image Markdown</button>
      <button id="post-image-download" type="button">Download Image</button>
    </div>
    <p class="write-hint">Suggested path: <code>/assets/img/posts/YYYY-MM-DD/filename</code></p>
  </div>
  <div class="write-actions">
    <button id="post-download" type="button">Download Markdown</button>
    <button id="post-copy" type="button">Copy to Clipboard</button>
    <button id="post-clear" type="button">Clear Form</button>
    <button id="post-clear-draft" type="button">Clear Draft</button>
  </div>
  <div class="write-meta">
    <span id="post-wordcount">0 words</span>
    <span id="post-reading-time">0 min read</span>
  </div>
  <div class="write-preview">
    <div class="write-preview-header">
      <span>Preview</span>
      <button id="post-frontmatter-toggle" type="button">Show Front Matter</button>
    </div>
    <pre id="post-frontmatter" class="write-frontmatter" hidden></pre>
    <div id="post-preview" class="write-preview-body"></div>
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
  .write-actions button#post-clear,
  .write-actions button#post-clear-draft,
  .write-actions button#post-image-download {
    background: #ffffff;
    color: #111111;
  }
  .write-meta {
    display: flex;
    gap: 1rem;
    margin-top: 0.25rem;
    color: #555555;
    font-size: 0.95rem;
  }
  .write-preview {
    margin-top: 1.2rem;
    padding: 1rem;
    border: 1px solid var(--border-color, #e0e0e0);
    border-radius: 12px;
    background: #ffffff;
  }
  .write-preview-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.75rem;
  }
  .write-preview-header button {
    padding: 0.35rem 0.9rem;
    border-radius: 999px;
    border: 1px solid #111111;
    background: #ffffff;
    color: #111111;
    cursor: pointer;
  }
  .write-frontmatter {
    margin: 0 0 0.75rem;
    padding: 0.75rem;
    border-radius: 8px;
    background: #f4f4f4;
    white-space: pre-wrap;
  }
  .write-preview-body img {
    max-width: 100%;
    height: auto;
  }
  #post-image-preview {
    margin-top: 0.5rem;
    max-width: 220px;
    border-radius: 8px;
    border: 1px solid var(--border-color, #e0e0e0);
    display: none;
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
  const importInput = document.getElementById("post-import");
  const downloadButton = document.getElementById("post-download");
  const copyButton = document.getElementById("post-copy");
  const clearButton = document.getElementById("post-clear");
  const clearDraftButton = document.getElementById("post-clear-draft");
  const statusLine = document.getElementById("post-status");
  const imageInput = document.getElementById("post-image");
  const imageAltInput = document.getElementById("post-image-alt");
  const imagePreview = document.getElementById("post-image-preview");
  const imageInsertButton = document.getElementById("post-image-insert");
  const imageDownloadButton = document.getElementById("post-image-download");
  const wordCountLine = document.getElementById("post-wordcount");
  const readingTimeLine = document.getElementById("post-reading-time");
  const previewBody = document.getElementById("post-preview");
  const frontMatterPreview = document.getElementById("post-frontmatter");
  const frontMatterToggle = document.getElementById("post-frontmatter-toggle");

  const today = new Date().toISOString().slice(0, 10);
  dateInput.value = today;
  const draftKey = "write-draft-v1";
  let saveTimeout = null;

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

  const escapeHtml = (text) =>
    text.replace(/[&<>"]/g, (match) => {
      if (match === "&") return "&amp;";
      if (match === "<") return "&lt;";
      if (match === ">") return "&gt;";
      return "&quot;";
    });

  const renderInlineMarkdown = (text) => {
    let output = text;
    output = output.replace(/`([^`]+)`/g, "<code>$1</code>");
    output = output.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
    output = output.replace(/\*([^*]+)\*/g, "<em>$1</em>");
    output = output.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img alt="$1" src="$2" />');
    output = output.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
    return output;
  };

  const renderMarkdown = (text) => {
    const escaped = escapeHtml(text);
    const parts = escaped.split(/```/);
    const rendered = parts.map((part, index) => {
      if (index % 2 === 1) {
        return `<pre><code>${part}</code></pre>`;
      }
      const lines = part.split(/\n/);
      let html = "";
      let listType = null;
      lines.forEach((line) => {
        if (/^\s*$/.test(line)) {
          if (listType) {
            html += `</${listType}>`;
            listType = null;
          }
          return;
        }
        const headingMatch = line.match(/^(#{1,6})\s+(.*)$/);
        if (headingMatch) {
          if (listType) {
            html += `</${listType}>`;
            listType = null;
          }
          const level = headingMatch[1].length;
          html += `<h${level}>${renderInlineMarkdown(headingMatch[2])}</h${level}>`;
          return;
        }
        const quoteMatch = line.match(/^>\s+(.*)$/);
        if (quoteMatch) {
          if (listType) {
            html += `</${listType}>`;
            listType = null;
          }
          html += `<blockquote>${renderInlineMarkdown(quoteMatch[1])}</blockquote>`;
          return;
        }
        const unorderedMatch = line.match(/^[-*]\s+(.*)$/);
        if (unorderedMatch) {
          if (listType && listType !== "ul") {
            html += `</${listType}>`;
            listType = null;
          }
          if (!listType) {
            html += "<ul>";
            listType = "ul";
          }
          html += `<li>${renderInlineMarkdown(unorderedMatch[1])}</li>`;
          return;
        }
        const orderedMatch = line.match(/^\d+\.\s+(.*)$/);
        if (orderedMatch) {
          if (listType && listType !== "ol") {
            html += `</${listType}>`;
            listType = null;
          }
          if (!listType) {
            html += "<ol>";
            listType = "ol";
          }
          html += `<li>${renderInlineMarkdown(orderedMatch[1])}</li>`;
          return;
        }
        if (listType) {
          html += `</${listType}>`;
          listType = null;
        }
        html += `<p>${renderInlineMarkdown(line)}</p>`;
      });
      if (listType) {
        html += `</${listType}>`;
      }
      return html;
    });
    return rendered.join("");
  };

  const updateStats = () => {
    const bodyText = bodyInput.value.trim();
    const wordCount = bodyText ? bodyText.split(/\s+/).length : 0;
    const minutes = Math.max(1, Math.ceil(wordCount / 200));
    wordCountLine.textContent = `${wordCount} words`;
    readingTimeLine.textContent = `${wordCount ? minutes : 0} min read`;
  };

  const updatePreview = () => {
    const { frontMatter } = buildFrontMatter();
    frontMatterPreview.textContent = frontMatter;
    previewBody.innerHTML = renderMarkdown(bodyInput.value || "");
  };

  const saveDraft = () => {
    const draft = {
      title: titleInput.value,
      slug: slugInput.value,
      date: dateInput.value,
      categories: categoriesInput.value,
      tags: tagsInput.value,
      body: bodyInput.value,
      imageAlt: imageAltInput.value
    };
    localStorage.setItem(draftKey, JSON.stringify(draft));
  };

  const scheduleSave = () => {
    if (saveTimeout) {
      clearTimeout(saveTimeout);
    }
    saveTimeout = setTimeout(saveDraft, 300);
  };

  const loadDraft = () => {
    const stored = localStorage.getItem(draftKey);
    if (!stored) return;
    try {
      const draft = JSON.parse(stored);
      titleInput.value = draft.title || "";
      slugInput.value = draft.slug || "";
      dateInput.value = draft.date || today;
      categoriesInput.value = draft.categories || "blog";
      tagsInput.value = draft.tags || "";
      bodyInput.value = draft.body || "";
      imageAltInput.value = draft.imageAlt || "";
      statusLine.textContent = "Draft restored from this browser.";
    } catch (error) {
      localStorage.removeItem(draftKey);
    }
  };

  const parseFrontMatter = (text) => {
    const match = text.match(/^---\s*([\s\S]*?)\s*---\s*([\s\S]*)$/);
    if (!match) {
      return { frontMatter: {}, body: text };
    }
    const raw = match[1];
    const body = match[2].trimStart();
    const frontMatter = {};
    raw.split("\n").forEach((line) => {
      const pair = line.match(/^([a-zA-Z0-9_-]+):\s*(.*)$/);
      if (!pair) return;
      frontMatter[pair[1]] = pair[2];
    });
    return { frontMatter, body };
  };

  const parseListValue = (value) => {
    const trimmed = value.trim();
    if (!trimmed) return "";
    const listMatch = trimmed.match(/^\[(.*)\]$/);
    if (listMatch) {
      return listMatch[1]
        .split(",")
        .map((item) => item.trim())
        .filter(Boolean)
        .join(", ");
    }
    return trimmed;
  };

  const importMarkdown = (text) => {
    const { frontMatter, body } = parseFrontMatter(text);
    if (frontMatter.title) {
      titleInput.value = frontMatter.title.replace(/^"|"$/g, "");
    }
    if (frontMatter.date) {
      dateInput.value = frontMatter.date.trim().slice(0, 10);
    }
    if (frontMatter.categories) {
      categoriesInput.value = parseListValue(frontMatter.categories);
    }
    if (frontMatter.tags) {
      tagsInput.value = parseListValue(frontMatter.tags);
    }
    bodyInput.value = body || "";
    if (!slugInput.value.trim() && titleInput.value.trim()) {
      slugInput.value = slugify(titleInput.value);
    }
    statusLine.textContent = "Markdown loaded.";
    updateStats();
    updatePreview();
    scheduleSave();
  };
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
    scheduleSave();
    updatePreview();
  });

  [slugInput, dateInput, categoriesInput, tagsInput, bodyInput, imageAltInput].forEach(
    (field) => {
      field.addEventListener("input", () => {
        scheduleSave();
        updateStats();
        updatePreview();
      });
    }
  );

  importInput.addEventListener("change", async () => {
    const file = importInput.files && importInput.files[0];
    if (!file) return;
    const text = await file.text();
    importMarkdown(text);
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

  clearButton.addEventListener("click", () => {
    titleInput.value = "";
    slugInput.value = "";
    dateInput.value = today;
    categoriesInput.value = "blog";
    tagsInput.value = "";
    bodyInput.value = "";
    imageAltInput.value = "";
    imageInput.value = "";
    imagePreview.src = "";
    imagePreview.style.display = "none";
    statusLine.textContent = "Form cleared.";
    updateStats();
    updatePreview();
    scheduleSave();
  });

  clearDraftButton.addEventListener("click", () => {
    localStorage.removeItem(draftKey);
    statusLine.textContent = "Draft cleared.";
  });

  frontMatterToggle.addEventListener("click", () => {
    const isHidden = frontMatterPreview.hasAttribute("hidden");
    if (isHidden) {
      frontMatterPreview.removeAttribute("hidden");
      frontMatterToggle.textContent = "Hide Front Matter";
    } else {
      frontMatterPreview.setAttribute("hidden", "hidden");
      frontMatterToggle.textContent = "Show Front Matter";
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
    updateStats();
    updatePreview();
    scheduleSave();
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

  imageInput.addEventListener("change", () => {
    const file = imageInput.files && imageInput.files[0];
    if (!file) {
      imagePreview.style.display = "none";
      imagePreview.src = "";
      return;
    }
    const url = URL.createObjectURL(file);
    imagePreview.src = url;
    imagePreview.style.display = "block";
  });

  loadDraft();
  updateStats();
  updatePreview();
</script>
