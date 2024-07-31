return {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        '*'; -- Activar colorizer en todos los archivos
        css = { rgb_fn = true; }; -- También activar funciones RGB en archivos CSS
        html = { names = false; }; -- Desactivar nombres de colores en archivos HTML
        rasi = { css = true; }; -- Activar colorizer en archivos .rasi
      })
    end
}
