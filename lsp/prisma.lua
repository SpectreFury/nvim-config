return {
    cmd = { "prisma-language-server", "--stdio" },
    filetypes = { "prisma" },
    root_markers = { "schema.prisma", ".git", "package.json" },
    settings = {
      prisma = {
        prismaSchemaPath = "prisma/schema.prisma"
      }
    }
}
