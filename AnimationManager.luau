--!strict
local AnimationManager = {}

local animation_prefix = "rbxassetid://"
local animationTracksCache = setmetatable({} :: {
	[Animator]: {AnimationTrack}
}, {
	__mode = 'k'
})

function AnimationManager:loadAnimation(animator: Animator, animation: Animation): AnimationTrack
	local track = animator:LoadAnimation(animation)
	local tracks = animationTracksCache[animator]
	
	if tracks then
		table.insert(tracks, track)
	else
		animationTracksCache[animator] = {}
		table.insert(animationTracksCache[animator], track)
	end
	
	return track
end

function AnimationManager:loadAnimationId(animator: Animator, animation_id: number): AnimationTrack
	local animation = Instance.new('Animation')
	
	animation.AnimationId = animation_prefix..animation_id
	
	return self:loadAnimation(animator, animation)
end

function AnimationManager:animationIsLoaded(animator: Animator, animation: Animation): AnimationTrack?
	local tracks = animationTracksCache[animator]
	
	if not tracks then
		return
	end
	
	local animation_id = animation.AnimationId
	
	for _, track in tracks do
		local track_animation = track.Animation
		
		if not track_animation then continue end
		
		local track_animation_id = track_animation.AnimationId
		
		if animation_id == track_animation_id then
			return track
		end
	end
	
	return
end

function AnimationManager:animationIdIsLoaded(animator: Animator, animation_id: number): AnimationTrack?
	local tracks = animationTracksCache[animator]

	if not tracks then
		return
	end

	for _, track in tracks do
		local track_animation = track.Animation

		if not track_animation then continue end

		local track_animation_id = track_animation.AnimationId

		if animation_prefix..animation_id == track_animation_id then
			return track
		end
	end

	return
end

function AnimationManager:getLoadedAnimationsTrack(animator: Animator): {AnimationTrack}?
	return animationTracksCache[animator]
end

return AnimationManager
