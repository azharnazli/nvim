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
          'eslint.config.js',
          'eslint.config.ts',
          'eslint.config.mjs',
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
      -- vim.api.nvim_create_autocmd('BufWritePre', {
      --   group = lint_augroup,
      --   callback = function()
      --     if
      --       vim.bo.filetype == 'javascript'
      --       or vim.bo.filetype == 'javascriptreact'
      --       or vim.bo.filetype == 'typescript'
      --       or vim.bo.filetype == 'typescriptreact'
      --     then
      --       if has_eslint_config() then
      --         vim.cmd 'EslintFixAll'
      --       end
      --     end
      --   end,
      -- })
    end,
  },
}
