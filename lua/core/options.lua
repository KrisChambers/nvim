local o = vim.o

o.number = true
o.relativenumber = true

o.signcolumn = 'yes'
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true

o.smartindent = true
o.autoindent = true

o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true
o.updatetime = 250
o.wrap = false

o.termguicolors = true

o.guicursor =
"n-v-c:block,i-ci-ve:ver100,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Keep the cursor in the middle of the window
o.scrolloff = 999
o.updatetime = 250

-- Remove the highlighting after our search is complete
-- Only highlights the first search result
o.hlsearch = false
o.incsearch = true
