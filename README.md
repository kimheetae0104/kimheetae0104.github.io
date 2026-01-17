# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

When installing the [**Chirpy**][chirpy] theme through [RubyGems.org][gem], Jekyll can only read files in the folders
`_data`, `_layouts`, `_includes`, `_sass` and `assets`, as well as a small part of options of the `_config.yml` file
from the theme's gem. If you have ever installed this theme gem, you can use the command
`bundle info --path jekyll-theme-chirpy` to locate these files.

The Jekyll team claims that this is to leave the ball in the user’s court, but this also results in users not being
able to enjoy the out-of-the-box experience when using feature-rich themes.

To fully use all the features of **Chirpy**, you need to copy the other critical files from the theme's gem to your
Jekyll site. The following is a list of targets:

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

To save you time, and also in case you lose some files while copying, we extract those files/configurations of the
latest version of the **Chirpy** theme and the [CD][CD] workflow to here, so that you can start writing in minutes.

## Usage

Check out the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy/wiki).

## Contributing

This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository][chirpy] to provide feedback.

## License

This work is published under [MIT][mit] License.

## Writing Posts (Quick Start)

- Create a new file under `_posts/` with filename format `YYYY-MM-DD-your-title.md`.
- You can copy `POST_TEMPLATE.md` as a starting point and fill in `title`, `date`, `tags`, etc.
- For drafts, use the `_drafts/` folder (no date prefix required).
- Local helper: `tools/new-post.sh "Title" [slug] [date]` creates a ready-to-edit post file.
- Template options: `-t` uses the body from `POST_TEMPLATE.md`, `-b` sets inline body text, `-B` loads body from a file.
- Web helper: open the `Write` tab in the site to download a ready-to-upload Markdown file.
- Preview locally (requires Ruby + Jekyll):

```bash
bundle install
bundle exec jekyll serve --livereload
```

- Or let GitHub Pages build the site automatically after you push to `main`.


[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE
