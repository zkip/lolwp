---@diagnostic disable: trailing-space, undefined-global
AddStategraphState('wilson',State{
    name = "lol_wp_blank_sg",
    onenter = function(inst)
        inst:PerformBufferedAction()
    end,
})

AddStategraphState('wilson_client',State{
    name = 'lol_wp_blank_sg',
    onenter = function(inst)
        inst:PerformPreviewBufferedAction()
    end,
})
