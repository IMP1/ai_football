local Timer = {}
Timer.__index = Timer

function Timer.new()
    local self = {}
    setmetatable(self, Timer)

    self.tick_delay    = 0.5
    self.half_duration = 60 * 45
    self.extra_time_half_duration = 60 * 15

    self.time = 0
    self.tick_timer = 0
    self.tick = 0
    self.unchecked_ticks = 0
    self.half = 0
    self.extra_time = 0

    return self
end

function Timer:ticks()
    local ticks = self.unchecked_ticks
    self.unchecked_ticks = 0
    return ticks
end

function Timer:update(dt)
    self.time = self.time + dt
    self.tick_timer = self.tick_timer + dt
    if self.tick_timer > self.tick_delay then
        self.tick_timer = self.tick_timer - self.tick_delay
        self.tick = self.tick + 1
        self.unchecked_ticks = self.unchecked_ticks + 1
    end
end

return Timer