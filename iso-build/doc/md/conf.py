# Configuration file for the Sphinx documentation builder.
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------

project = 'debian-live-config'
author = 'nodiscc@gmail.com'
version = '3.0.0'
release = '3.0.0'
html_show_copyright = True

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ['recommonmark', 'sphinx_rtd_theme']

# Only parse .md files
source_suffix = ['.md']

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'
html_show_sphinx = True

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
html_css_files = ['style.css']

# The master toctree document.
master_doc = 'index'

html_theme_options = {
    'display_version': True,
    'prev_next_buttons_location': 'bottom',
    'style_external_links': False,
    'vcs_pageview_mode': 'edit',
    'collapse_navigation': False,
    'sticky_navigation': True,
    'navigation_depth': 2, # Defines sidebar navigation depth
    'titles_only': False
}

html_context = {
    "display_gitlab": True, # Integrate Gitlab
    "gitlab_host": "gitlab.com",
    "gitlab_user": "nodiscc", # Username
    "gitlab_repo": "debian-live-config", # Repo name
    "gitlab_version": "master", # Version
    "conf_py_path": "/doc/md/" # Path in the checkout to the docs root
}

exclude_patterns = ['README.md']

# Load the recommonmark auto TOC generator
# It will find any section named as defined in 'auto_toc_tree_section',
# find any bullet lists of relative markdown links
# And use it to generate a TOC and populate the sidebar
from recommonmark.parser import CommonMarkParser
from recommonmark.transform import AutoStructify
def setup(app):
    app.add_config_value('recommonmark_config', {
        'enable_auto_toc_tree': True,
        'auto_toc_tree_section': 'Documentation',
        'auto_toc_maxdepth': 1, # Defines in-place generated TOC depth, not the sidebar depth
    }, True)
    app.add_transform(AutoStructify)

#TODO markdown tables are note rendered in sphinx
