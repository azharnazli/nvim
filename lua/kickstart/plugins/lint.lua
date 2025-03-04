return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft['markdown'] = { 'markdownlint' }

      local function has_eslint_config()
        local filenames = {
          '.eslintrc',
          '.eslintrc.json',
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintrc.yaml',
          '.eslintrc.yml',
        }
        for _, filename in ipairs(filenames) do
          if vim.fn.glob(filename) ~= '' then
            return {
              file = filename,
              found = true,
            }
          end
        end
        return {
          file = nil,
          found = false,
        }
      end

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      lint.linters_by_ft['json'] = nil
      lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      lint.linters_by_ft['text'] = nil

      local eslint_config = has_eslint_config()

      if eslint_config.found then
        lint.linters_by_ft['javascript'] = { 'eslint_d' }
        lint.linters_by_ft['javascriptreact'] = { 'eslint_d' }
        lint.linters_by_ft['typescript'] = { 'eslint_d' }
        lint.linters_by_ft['typescriptreact'] = { 'eslint_d' }

        vim.api.nvim_create_user_command('EslintFixAll', function()
          local filepath = vim.fn.expand '%:p' -- Get the full path of the current file
          local eslint_cmd = string.format(
            'eslint_d --fix %s %s',
            eslint_config.file,
            vim.fn.shellescape(filepath)
          )

          vim.fn.system(eslint_cmd)
          vim.cmd 'e!' -- Reload the file to reflect the changes
        end, {})
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd(
        { 'BufEnter', 'BufWritePost', 'InsertLeave' },
        {
          group = lint_augroup,
          callback = function()
            if vim.opt_local.modifiable:get() then
              lint.try_lint()
            end
          end,
        }
      )

      -- Add ESLint fix on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = lint_augroup,
        callback = function()
          if
            vim.bo.filetype == 'javascript'
            or vim.bo.filetype == 'javascriptreact'
            or vim.bo.filetype == 'typescript'
            or vim.bo.filetype == 'typescriptreact'
          then
            if has_eslint_config() then
              vim.cmd 'EslintFixAll'
            end
          end
        end,
      })
    end,
  },
}
