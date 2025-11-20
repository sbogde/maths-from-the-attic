-- Lua filter to replace tikzcd environments with SVG images
local diagram_counter = 0

-- Handle display math that contains tikzcd
function Para(para)
  local result = {}
  local modified = false
  
  for i, el in ipairs(para.content) do
    if el.t == "Math" and el.mathtype == "DisplayMath" then
      if string.match(el.text, "\\begin{tikzcd}") then
        local img_path = string.format("diagrams/diagram_%d.svg", diagram_counter)
        diagram_counter = diagram_counter + 1
        
        local html = string.format('<img src="%s" alt="Commutative diagram" style="max-width: 100%%; height: auto; display: block; margin: 1em auto;">', img_path)
        table.insert(result, pandoc.RawInline("html", html))
        modified = true
      else
        table.insert(result, el)
      end
    else
      table.insert(result, el)
    end
  end
  
  if modified then
    return pandoc.Para(result)
  end
  return para
end

-- Handle raw LaTeX blocks
function RawBlock(el)
  if el.format == "latex" then
    if string.match(el.text, "\\begin{tikzcd}") then
      local img_path = string.format("diagrams/diagram_%d.svg", diagram_counter)
      diagram_counter = diagram_counter + 1
      
      local html = string.format('<p><img src="%s" alt="Commutative diagram" style="max-width: 100%%; height: auto; display: block; margin: 1em auto;"></p>', img_path)
      return pandoc.RawBlock("html", html)
    end
  end
  return el
end
