setup
==========

The following commands were used to push the initial package to Github:

```bash
git init
git add -A
git commit -m "initial commit"
git remote add origin git@github.com:mjfrigaard/dopingdata.git
git branch -M main
git push -u origin main
```

```
Enumerating objects: 230, done.
Counting objects: 100% (230/230), done.
Delta compression using up to 12 threads
Compressing objects: 100% (224/224), done.
Writing objects: 100% (230/230), 10.09 MiB | 2.42 MiB/s, done.
Total 230 (delta 16), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (16/16), done.
To github.com:mjfrigaard/dopingdata.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

## `pkgdown` setup 

``` r
usethis::use_pkgdown()
✔ Setting active project to '/Users/mjfrigaard/projects/dopingdata'
✔ Adding '^_pkgdown\\.yml$', '^docs$', '^pkgdown$' to '.Rbuildignore'
✔ Adding 'docs' to '.gitignore'
✔ Writing '_pkgdown.yml'
• Modify '_pkgdown.yml'
```

``` r
pkgdown::build_site()
```

The site is built:

```
-- Installing package into temporary library -----------------------------------------
== Building pkgdown site =======================================================
Reading from: '/Users/mjfrigaard/projects/dopingdata'
Writing to:   '/Users/mjfrigaard/projects/dopingdata/docs'
-- Initialising site -----------------------------------------------------------
Copying '../../Library/Caches/org.R-project.R/R/renv/cache/v5/R-4.2/x86_64-apple-darwin17.0/pkgdown/2.0.7/16fa15449c930bf3a7761d3c68f8abf9/pkgdown/BS5/assets/link.svg' to 'link.svg'
Copying '../../Library/Caches/org.R-project.R/R/renv/cache/v5/R-4.2/x86_64-apple-darwin17.0/pkgdown/2.0.7/16fa15449c930bf3a7761d3c68f8abf9/pkgdown/BS5/assets/pkgdown.js' to 'pkgdown.js'
-- Building home ---------------------------------------------------------------
Writing 'authors.html'
Reading 'CODE_OF_CONDUCT.md'
Writing 'CODE_OF_CONDUCT.html'
Reading '_setup.md'
Writing '_setup.html'
Reading 'LICENSE.md'
Writing 'LICENSE.html'
Writing 'LICENSE-text.html'
Writing '404.html'
-- Building function reference -------------------------------------------------
Writing 'reference/index.html'
Reading 'man/check_rtxt.Rd'
Writing 'reference/check_rtxt.html'
Reading 'man/create_dir_date.Rd'
Writing 'reference/create_dir_date.html'
Reading 'man/create_regex_wb.Rd'
Writing 'reference/create_regex_wb.html'
Reading 'man/dtstamp.Rd'
Writing 'reference/dtstamp.html'
Reading 'man/get_recent_data_file.Rd'
Writing 'reference/get_recent_data_file.html'
Reading 'man/get_recent_version.Rd'
Writing 'reference/get_recent_version.html'
Reading 'man/guess_basename.Rd'
Writing 'reference/guess_basename.html'
Reading 'man/nin.Rd'
Writing 'reference/nin.html'
Reading 'man/otherwise.Rd'
Writing 'reference/otherwise.html'
Reading 'man/polite_download_file.Rd'
Writing 'reference/polite_download_file.html'
Reading 'man/polite_fetch_rtxt.Rd'
Writing 'reference/polite_fetch_rtxt.html'
Reading 'man/polite_read_html.Rd'
Writing 'reference/polite_read_html.html'
Reading 'man/process_text.Rd'
Writing 'reference/process_text.html'
Reading 'man/run_app.Rd'
Writing 'reference/run_app.html'
Reading 'man/str_extract_matches.Rd'
Writing 'reference/str_extract_matches.html'
Reading 'man/str_parse_term.Rd'
Writing 'reference/str_parse_term.html'
Reading 'man/theme_ggp2g.Rd'
Writing 'reference/theme_ggp2g.html'
-- Building articles -----------------------------------------------------------
Writing 'articles/index.html'
Reading 'vignettes/sanction-aaf-substances.Rmd'
Writing 'articles/sanction-aaf-substances.html'
Reading 'vignettes/sanction-adrv-substances.Rmd'
Writing 'articles/sanction-adrv-substances.html'
Reading 'vignettes/sanction-dates.Rmd'
Writing 'articles/sanction-dates.html'
Reading 'vignettes/sanction-sports.Rmd'
Writing 'articles/sanction-sports.html'
Reading 'vignettes/scraping-usada-proh-assoc.Rmd'
Writing 'articles/scraping-usada-proh-assoc.html'
Reading 'vignettes/scraping-usada-sanctions.Rmd'
Writing 'articles/scraping-usada-sanctions.html'
-- Building news ---------------------------------------------------------------
Writing 'news/index.html'
Writing 'sitemap.xml'
-- Building search index -------------------------------------------------------
== DONE ========================================================================
-- Previewing site ------------------------------------------------------------
```

And deployed locally from:

file:///Users/mjfrigaard/projects/dopingdata/docs/index.html

## Deploying using github pages

To setup GitHub pages, run the following: 

``` r
usethis::use_pkgdown_github_pages()
```

which completes the following tasks:

```
Overwrite pre-existing file '_pkgdown.yml'?

1: Yeah
2: Nope
3: Not now

Selection: 1
✔ Writing '_pkgdown.yml'
• Modify '_pkgdown.yml'
✔ Initializing empty, orphan 'gh-pages' branch in GitHub repo 'mjfrigaard/dopingdata'
✔ GitHub Pages is publishing from:
• URL: 'https://mjfrigaard.github.io/dopingdata/'
• Branch: 'gh-pages'
• Path: '/'
✔ Creating '.github/'
✔ Adding '^\\.github$' to '.Rbuildignore'
✔ Adding '*.html' to '.github/.gitignore'
✔ Creating '.github/workflows/'
✔ Saving 'r-lib/actions/examples/pkgdown.yaml@v2' to '.github/workflows/pkgdown.yaml'
• Learn more at <https://github.com/r-lib/actions/blob/v2/examples/README.md>.
✔ Recording 'https://mjfrigaard.github.io/dopingdata/' as site's url in '_pkgdown.yml'
✔ Adding 'https://mjfrigaard.github.io/dopingdata/' to URL field in DESCRIPTION
✔ Setting 'https://mjfrigaard.github.io/dopingdata/' as homepage of GitHub repo 'mjfrigaard/dopingdata'
```

Add some spice to your package website!

```yml
url: https://mjfrigaard.github.io/dopingdata/
template:
  bootstrap: 5
  bootswatch: minty
  theme: gruvbox-dark
  bslib:
    base_font:
      google: Ubuntu Mono
    heading_font:
      google: Ubuntu
```

Now set the branch to `gh-pages` on GitHub and deploy from the `docs/` folder. 

## Issues 

These are a collection of issues I've found while using `pkgdown` with `gh-pages`. I'm always somehow able to get the site deployed, but it takes some extra effort! 

If the `pkgdown` build is giving the following error during GitHub actions: 

```bash
The deploy step encountered an error: The process '/usr/bin/git' failed with exit code 1 ❌
```

You might have one of the following issues

## Deployment issues with Git LFS

Apparently this *might* be caused by Git LFS (large file system), which we can either 1) remove following the instructions [here](https://github.com/git-lfs/git-lfs/issues/3026) and [here](https://gist.github.com/everttrollip/198ed9a09bba45d2663ccac99e662201), 

First check to see if `lfs` is installed and tracking any files.

```bash
git lfs ls-files
```

If nothing, you're good to go! 

```bash
git lfs uninstall
Hooks for this repository have been removed.
Global Git LFS configuration has been removed.
# check files
git lfs ls-files
# remove files
rm -rf .git/lfs
# check files again
git lfs ls-files
```

or 2) adding `lfs` to the [`actions/checkout` step](https://github.com/JamesIves/github-pages-deploy-action/issues/1139): 

```yml
    steps:
      - uses: actions/checkout@v3
        with:
          lfs: true
```

## Limited Github Actions Permissions 

After a few failed attempts with `pkgdown`, I noticed the actions were successful until the `git push`. Below we can see a new `gh-pages` branch is checked out: 

```bash
/usr/bin/git checkout -B gh-pages origin/gh-pages
Previous HEAD position was 287eac9 pkgdown build gh-pages
Switched to a new branch 'gh-pages'
branch 'gh-pages' set up to track 'origin/gh-pages'.
```

Then when GitHub actions attempts to push the changes 

```bash
Force-pushing changes...
push --force ***github.com/mjfrigaard/dopingdata.git github-pages-deploy-action/8znmd9sst:gh-pages
remote: Permission to mjfrigaard/dopingdata.git denied to github-actions[bot].
fatal: unable to access 'https://github.com/mjfrigaard/dopingdata.git/': The requested URL returned error: 403
Running post deployment cleanup jobs… 🗑️
```

Which results in the following error: 

```bash
Error: The deploy step encountered an error: The process '/usr/bin/git' failed with exit code 128 ❌
Notice: Deployment failed! ❌
```

Change the settings under **Settings** > **Actions** > **General**: 

Under **Workflow permissions** at the bottom, 

*Choose the default permissions granted to the GITHUB_TOKEN when running workflows in this repository. You can specify more granular permissions in the workflow using YAML...*

- [x] **Read and write permissions**  
   - Workflows have read and write permissions in the repository for all scopes.

https://github.com/ad-m/github-push-action/issues/96#issuecomment-1396347833

## Updating 

Check out this post on [SO](https://stackoverflow.com/questions/71728269/solution-to-keep-gh-pages-up-to-day-with-a-master-main-branch): 

```bash
git add -A
# to see what changes are going to be committed
git status 
# commit changes
git commit -m 'changes'
# push
git push origin main
# go to the gh-pages branch
git checkout gh-pages 
# bring gh-pages up to date with main
git rebase main
# push the changes
git push origin gh-pages 
# return to the main branch
git checkout main
```

```
git branch --set-upstream-to=origin/<branch> gh-pages
git branch --set-upstream-to=origin/main gh-pages
```
=======
To deploy on main, I added a `.nojekyll` file: 

```bash
touch .nojekyll
```


