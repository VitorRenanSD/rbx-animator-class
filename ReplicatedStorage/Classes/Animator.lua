local Animator = {}
Animator.__index = Animator

-- Construtor do Animator
function Animator.new(model)
	local self = setmetatable({}, Animator)


	self.model = model
	self.animations = {}  -- Array pra guardar as animacoes carregadas
	self.animator = model:FindFirstChild("Humanoid"):FindFirstChildOfClass("Animator")


	if not self.animator then
		warn("sem nenhum Animator no " .. self.model.Name)
	end

	-- Carrega as animacoes do model
	for _, anim in ipairs(model:GetChildren()) do
		
		if anim:IsA("Animation") then
			self.animations[anim.Name] = self.animator:LoadAnimation(anim)
		end
		
	end


	return self
end


-- Inicia a animacao tal
function Animator:playAnimation(animationName)
	
	local animationTrack = self.animations[animationName]
	
	if animationTrack then
		animationTrack:Play()
		return animationTrack
	else
		warn(animationName .. " n encontrada no modelo " .. self.model.Name)
	end
	
end


-- Para a animacao tal
function Animator:stopAnimation(animationName)
	
	local animationTrack = self.animations[animationName]

	if animationTrack then
		
		-- Uma segunda thread pra parar a animacao ao terminar, sem afetar o resto do jogo
		coroutine.wrap(function()
			wait(animationTrack.Length)
			animationTrack:Stop()
		end)()
	end

end


return Animator
