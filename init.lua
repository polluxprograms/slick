local math = require('math')
local gears = require('gears')

local default_args = {
  snap = 0.1,
  refresh_rate = 144,
  speed = 20
}

local set = function (self, target)
  self.target = target
  self.timer:start()
end

local update = function (self)
  self.value = self.value +
    (self.target - self.value) *
    (1 - math.exp(-self.args.speed / self.args.refresh_rate))

  if math.abs(self.value - self.target) < self.args.snap then
    self.value = self.target
    self.timer:stop()
  end

  self.args.callback(self.value)
end

local new = function (value, args)
  args = gears.table.crush(default_args, args)

  local ret = {
    value = value,
    target = value,
    args = args,
    set = set,
    update = update
  }

  local timer = gears.timer({
    timeout = 1 / args.refresh_rate,
    callback = function ()
      ret:update()
    end
  })

  ret.timer = timer
  ret:update()

  return ret
end

return new
