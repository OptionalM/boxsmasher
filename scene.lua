
scenes = {}
scene = {}

local curScene = "intro"
local sceneInitData = {}

local trans = false
local trans_step = 0
local trans_to = ""
local trans_alpha = 0

function scene.switch(sceneName, data, instant)
	if trans then return end

	sceneInitData = data or {}

	if instant then
		curScene = sceneName
		scene.runInit()
		return
	end

	trans = true
	trans_step = 0
	trans_to = sceneName
end

function scene.restart(instant)
	scene.switch(curScene, sceneInitData, instant or false)
end

function scene.runInit()
	if scenes[curScene].init ~= nil then
		scenes[curScene].init(sceneInitData)
	end
end

function scene.runUpdate(dt)
	if scenes[curScene].update ~= nil then
		scenes[curScene].update(dt)
	end

	if scenes[curScene].gui ~= nil then
		scenes[curScene].gui:update()
	end
end

function scene.runDraw()
	local bg
	if scenes[curScene].background then
		bg = scenes[curScene].background

		draw.background(love.math.colorFromBytes(bg[1], bg[2], bg[3]))
	end

	if scenes[curScene].draw ~= nil then
		scenes[curScene].draw()
	end

	if scenes[curScene].gui ~= nil then
		scenes[curScene].gui:draw()
	end

	if scenes[curScene].background then
		draw.backgroundLetterbox(love.math.colorFromBytes(bg[1], bg[2], bg[3]))
	end
end

function scene.runBack()
	if scenes[curScene].back ~= nil then
		scenes[curScene].back()
	end
end

function scene.isTransitioning()
	return trans
end

function scene.performTransition()
	if not trans then return end

	if trans_step < 25 then
		trans_alpha = trans_alpha + 10
	else
		trans_alpha = trans_alpha - 10
	end

	love.graphics.setColor(0,0,0,trans_alpha/255)

	love.graphics.push()
	love.graphics.origin()

	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.pop()

	trans_step = trans_step + 1

	if trans_step == 25 then
		curScene = trans_to

		scene.runInit()
	elseif trans_step == 50 then
		trans = false
	end
end
