local module = {}

function module.get_pane_with_info(pane)
  local current_pane_id = pane:pane_id()

  local tab = pane:tab()
  if tab == nil then
    -- this is a detached pane
    return nil
  end

  local panes = tab:panes_with_info()
  for _, p in ipairs(panes) do
    if p.pane:pane_id() == current_pane_id then
      return p
    end
  end

  return nil
end

return module
