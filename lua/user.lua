vim.api.nvim_create_user_command('NewDomain', function(opts)
  local domain_name = opts.args
  local base_path = vim.fn.expand '%:p:h'
  local domain_path = base_path .. '/' .. domain_name
  local package_name = vim.fn.fnamemodify(domain_name, ':t')
  local upper_package = package_name:gsub('^%l', string.upper)
  vim.fn.mkdir(domain_path, 'p')

  -- Define directories and files to be created
  local directories = {
    domain_path .. '/repository',
    domain_path .. '/usecase',
    domain_path .. '/dtos',
    domain_path .. '/entities',
    domain_path .. '/delivery/http/v1',
  }

  local files = {
    {
      path = domain_path .. '/repository/repository.go',
      content = 'package repository\n\nimport (\n\t"gorm.io/gorm"\n)\n\n'
        .. 'type '
        .. package_name
        .. 'Repository struct {\n\t'
        .. 'db *gorm.DB\n}\n\n'
        .. 'func New'
        .. upper_package
        .. 'Repository(db *gorm.DB) '
        .. package_name
        .. '.'
        .. upper_package
        .. 'Repository {\n'
        .. '\treturn &'
        .. package_name
        .. 'Repository{db: db}\n'
        .. '}\n',
    },
    {
      path = domain_path .. '/usecase/usecase.go',
      content = 'package usecase\n\n'
        .. 'type usecase struct {\n\t'
        .. 'repo '
        .. package_name
        .. '.'
        .. upper_package
        .. '\n}\n\n'
        .. 'func NewUseCase'
        .. '(repo '
        .. package_name
        .. '.'
        .. upper_package
        .. ') '
        .. package_name
        .. '.'
        .. 'Usecase {\n'
        .. '\treturn &usecase{repo}\n'
        .. '}\n',
    },
    {
      path = domain_path .. '/dtos/dtos.go',
      content = 'package dtos\n\n',
    },
    {
      path = domain_path .. '/entities/entities.go',
      content = 'package entities\n\n',
    },
    {
      path = domain_path .. '/delivery/http/v1/handler.go',
      content = 'package v1\n\n'
        .. 'type handlers struct {\n\t'
        .. 'uc '
        .. package_name
        .. '.Usecase \n}\n\n'
        .. 'func NewHandler'
        .. '(uc '
        .. package_name
        .. '.Usecase'
        .. ') *handlers {\n'
        .. '\treturn &handlers{uc}\n'
        .. '}\n',
    },
    {
      path = domain_path .. '/delivery/http/v1/routes.go',
      content = 'package v1\n\n'
        .. 'import (\n "github.com/labstack/echo/v4"\n)\n\n'
        .. 'func (h *handlers) '
        .. upper_package
        .. 'Routes'
        .. '(domain *echo.Group) {\n\t'
        .. package_name
        .. ' :='
        .. 'domain.Group("/'
        .. package_name
        .. 's"'
        .. ')\n'
        .. '}\n',
    },
    {
      path = domain_path .. '/usecase.go',
      content = 'package ' .. package_name .. '\n\ntype Usecase interface{}\n',
    },
    {
      path = domain_path .. '/repository.go',
      content = 'package '
        .. package_name
        .. '\n\n'
        .. 'type '
        .. package_name:gsub('^%l', string.upper)
        .. 'Repository interface{}\n',
    },
  }

  -- Create directories
  for _, dir in ipairs(directories) do
    vim.fn.mkdir(dir, 'p')
  end

  -- Create files with optional content
  for _, file in ipairs(files) do
    vim.fn.writefile(vim.split(file.content, '\n'), file.path)
  end

  print('New domain scaffold created at: ' .. domain_path)
end, { nargs = 1 })
