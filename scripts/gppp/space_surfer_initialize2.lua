print("initializing gameworld")
do -- Physics world
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0, 0, 0)
	cinfo.worldSize = 200000.0
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
end

PhysicsSystem:setDebugDrawingEnabled(true)

-- do -- debugCam
	-- debugCam = GameObjectManager:createGameObject("debugCam")
	-- debugCam.cc = debugCam:createCameraComponent()
	-- debugCam.cc:setPosition(Vec3(-600.0, 0.0, 0.0))
	-- debugCam.cc:setViewDirection(Vec3(1.0, 0.0, 0.0))
	-- debugCam.baseViewDir = Vec3(1.0, 0.0, 0.0)
	-- debugCam.cc:setBaseViewDirection(debugCam.baseViewDir)
-- end

homeWorldSize = 200
do -- homeWorld
	homeWorld = {}
	homeWorld.go = GameObjectManager:createGameObject("homeWorld")
	homeWorld.pc = homeWorld.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.position = Vec3(0,0,0)
	cinfo.shape = PhysicsFactory:createSphere(200)
	cinfo.motionType = MotionType.Character
	cinfo.restitution = 0
	cinfo.friction = 0
	cinfo.gravityFactor = 0
	cinfo.mass = 900000
	cinfo.maxLinearVelocity = 200


	homeWorld.rb = homeWorld.pc:createRigidBody(cinfo)
	homeWorld.sc = homeWorld.go:createScriptComponent()
--	homeWorld.sc:setUpdateFunction(updateHomePlanet)
	local renderComponent = homeWorld.go:createRenderComponent()
	renderComponent:setPath("data/models/proto_home.thModel")
	homeWorld.go:setComponentStates(ComponentState.Active)
end

do	-- Character
	character = {}
	character.go = GameObjectManager:createGameObject("character")
	character.pc = character.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(20, 20, 20))
	cinfo.motionType = MotionType.Character
	cinfo.restitution = 0
	cinfo.friction = 0
	cinfo.position = Vec3(0,0,500)
	cinfo.gravityFactor = 10
	cinfo.mass = 90
	cinfo.maxLinearVelocity = 1000

	cinfo.linearDamping = 1
	cinfo.angularDamping = 1
	character.rb = character.pc:createRigidBody(cinfo)
	character.sc = character.go:createScriptComponent()
	local renderComponent = character.go:createRenderComponent()
	--renderComponent:setPath("data/models/mario/mario.thModel")
	renderComponent:setPath("data/models/robot.thModel")
	character.go:setComponentStates(ComponentState.Active)
	-- collision event
	--character.pc:getContactPointEvent():registerListener(collisionCharacter)
	character.grounded = false
	
	-- Additional
	character.go.firstPersonMode = false
	character.go.currentAngularVelocity = Vec3()
	character.go.angularVelocitySwapped = false
	character.go.viewUpDown = 0.0
end

planetSize = 50
do	-- Planet
	planet = {}
	planet.go = GameObjectManager:createGameObject("planet")
	planet.pc = planet.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(planetSize)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = Vec3(-40, 400, 40)
	cinfo.mass = 2
	cinfo.friction = 0.4
	cinfo.restitution = 0.8
	cinfo.gravityFactor = 0
	planet.rb = planet.pc:createRigidBody(cinfo)
	planet.sc = planet.go:createScriptComponent()
	planet.go:setComponentStates(ComponentState.Active)
	planet.size = planetSize
end

planetSize = 100
do	-- planetTwo
	planetTwo = {}
	planetTwo.go = GameObjectManager:createGameObject("planetTwo")
	planetTwo.pc = planetTwo.go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(planetSize)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = Vec3(-40, -400, 40)
	cinfo.mass = 2
	cinfo.friction = 0.4
	cinfo.restitution = 0.8
	cinfo.gravityFactor = 0
	planetTwo.rb = planetTwo.pc:createRigidBody(cinfo)
	planetTwo.sc = planetTwo.go:createScriptComponent()
	planetTwo.go:setComponentStates(ComponentState.Active)
	planetTwo.size = planetSize
end

-- neu

function createCollisionBox(guid, halfExtends, position)
	local box = GameObjectManager:createGameObject(guid)
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(halfExtends)
	cinfo.motionType = MotionType.Fixed
	cinfo.position = position
	box.pc.rb = box.pc:createRigidBody(cinfo)
	return box
end

function createDefaultCam(guid)
	local cam = GameObjectManager:createGameObject(guid)
	cam.cc = cam:createCameraComponent()
	cam.cc:setPosition(Vec3(0.0, 0.0, 0.0))
	cam.cc:setViewDirection(Vec3(1.0, 0.0, 0.0))
	cam.baseViewDir = Vec3(1.0, 0.0, 0.0)
	cam.cc:setBaseViewDirection(cam.baseViewDir)
	return cam
end

--
-- debugCam
--
debugCam = createDefaultCam("debugCam")

--
-- normalCam
--
normalCam = {}

normalCam.firstPerson = createDefaultCam("firstPerson")

normalCam.thirdPerson = createDefaultCam("thirdPerson")
normalCam.thirdPerson.pc = normalCam.thirdPerson:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(2.5)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 50.0
cinfo.restitution = 0.0
cinfo.friction = 0.0
cinfo.maxLinearVelocity = 3000
cinfo.linearDamping = 5.0
cinfo.gravityFactor = 0.0
normalCam.thirdPerson.pc.rb = normalCam.thirdPerson.pc:createRigidBody(cinfo)
normalCam.thirdPerson.pc:setState(ComponentState.Inactive)
normalCam.thirdPerson.calcPosTo = function()
	return character.go:getWorldPosition() + character.go:getViewDirection():mulScalar(-150.0) + Vec3(0.0, 0.0, 50.0)
end

normalCam.isometric = createDefaultCam("isometric")
normalCam.isometric.cc:look(Vec2(0.0, 20.0))

