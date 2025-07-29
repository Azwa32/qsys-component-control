------------------------------------------
-- Component Control
------------------------------------------
sendBuffer = {}                             -- table for outgoing commands      
sendDelay = .2                              -- delay for outgoing commands
sendDelayTimer = Timer.New() 

-- Component Control Queued
function queueComponentCtrl(componentName, ctrlName, value) -- insert into queue
  local queuedCommand = {componentName, ctrlName, value}
  table.insert(sendBuffer, queuedCommand)
  if #sendBuffer == 1 then 
    sendDelayTimer:Start(sendDelay)
  end 
end

-- on tick send command
sendDelayTimer.EventHandler = function()
  if #sendBuffer == 0 then 
    sendDelayTimer:Stop()
    return
  end
  local command = table.remove(sendBuffer, 1)
  local componentName = command[1]
  local ctrlName = command[2]
  local value = command[3]
  print("["..componentName.."] ["..ctrlName.."] ["..tostring(value).."]")  --uncomment for testing
  if type(value) == "boolean" then 
    Component.New(componentName)[ctrlName].Boolean = value
  elseif type(value) == "number" then 
    Component.New(componentName)[ctrlName].Value = value
  elseif type(value) == "string" then 
    Component.New(componentName)[ctrlName].String = value
  end
end

function pulseCmd(componentName, ctrlName, pulseLength)
  queueComponentCtrl(componentName, ctrlName, true)
  Timer.CallAfter(function()
    queueComponentCtrl(componentName, ctrlName, false)
  end, pulseLength)
end
