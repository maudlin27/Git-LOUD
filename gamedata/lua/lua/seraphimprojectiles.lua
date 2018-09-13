---  /lua/seraphimprojectiles.lua

local SinglePolyTrailProjectile = import('/lua/sim/defaultprojectiles.lua').SinglePolyTrailProjectile
local MultiPolyTrailProjectile = import('/lua/sim/defaultprojectiles.lua').MultiPolyTrailProjectile 
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

local EffectTemplate = import('/lua/EffectTemplates.lua')

local RandomInt = import('utilities.lua').GetRandomInt

local CreateTrail = CreateTrail

SIFHuAntiNuke = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    PolyTrail = EffectTemplate.SKhuAntiNukePolyTrail,
    FxTrails = EffectTemplate.SKhuAntiNukeFxTrails,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactProjectile = EffectTemplate.SKhuAntiNukeHit,
    FxImpactUnderWater = {},
}

SIFKhuAntiNukeTendril = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SKhuAntiNukeHitTendrilFxTrails,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactProjectile = {},
    FxImpactUnderWater = {},
}

SIFKhuAntiNukeSmallTendril = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SKhuAntiNukeHitSmallTendrilFxTrails,
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactProjectile = {},
    FxImpactUnderWater = {},
}

SBaseTempProjectile = Class(EmitterProjectile) {
    FxImpactLand = EffectTemplate.AMissileHit01,
    FxImpactNone = EffectTemplate.AMissileHit01,
    FxImpactProjectile = EffectTemplate.ASaintImpact01,
    FxImpactProp = EffectTemplate.AMissileHit01,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.AMissileHit01,    
    FxTrails = EffectTemplate.SShleoCannonProjectileTrails, 
}

SChronatronCannon = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxImpactLand = EffectTemplate.SChronotronCannonLandHit,
    FxImpactNone = EffectTemplate.SChronotronCannonHit,
    FxImpactProp = EffectTemplate.SChronotronCannonLandHit,    
    FxImpactUnit = EffectTemplate.SChronotronCannonUnitHit,
    FxImpactWater = EffectTemplate.SChronotronCannonLandHit,
    FxImpactUnderWater = EffectTemplate.SChronotronCannonHit,
    FxTrails = EffectTemplate.SChronotronCannonProjectileFxTrails,
    PolyTrails = EffectTemplate.SChronotronCannonProjectileTrails,
    PolyTrailOffset = {0,0,0},
}

SChronatronCannonOverCharge = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
	FxImpactLand = EffectTemplate.SChronotronCannonOverChargeLandHit,
    FxImpactNone = EffectTemplate.SChronotronCannonOverChargeLandHit,
    FxImpactProp = EffectTemplate.SChronotronCannonOverChargeLandHit,    
    FxImpactUnit = EffectTemplate.SChronotronCannonOverChargeUnitHit,
    FxTrails = EffectTemplate.SChronotronCannonOverChargeProjectileFxTrails,
    PolyTrails = EffectTemplate.SChronotronCannonOverChargeProjectileTrails,
    PolyTrailOffset = {0,0,0},
}

SLightChronatronCannon = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxImpactLand = EffectTemplate.SLightChronotronCannonLandHit,
    FxImpactNone = EffectTemplate.SLightChronotronCannonLandHit,
    FxImpactProp = EffectTemplate.SLightChronotronCannonHit,    
    FxImpactUnit = EffectTemplate.SLightChronotronCannonUnitHit,
    PolyTrails = EffectTemplate.SLightChronotronCannonProjectileTrails,
    PolyTrailOffset = {0,0,0},
    FxTrails = EffectTemplate.SLightChronotronCannonProjectileFxTrails,
    FxImpactWater = EffectTemplate.SLightChronotronCannonLandHit,
    FxImpactUnderWater = EffectTemplate.SLightChronotronCannonHit,
}

SLightChronatronCannonOverCharge = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
    FxImpactLand = EffectTemplate.SLightChronotronCannonOverChargeHit,
    FxImpactNone = EffectTemplate.SLightChronotronCannonOverChargeHit,
    FxImpactProp = EffectTemplate.SLightChronotronCannonOverChargeHit,    
    FxImpactUnit = EffectTemplate.SLightChronotronCannonOverChargeHit,
    PolyTrails = EffectTemplate.SLightChronotronCannonOverChargeProjectileTrails,
    FxTrails = EffectTemplate.SLightChronotronCannonOverChargeProjectileFxTrails,
    PolyTrailOffset = {0,0,0},
}

SPhasicAutogun = Class(MultiPolyTrailProjectile) {
    FxImpactLand = EffectTemplate.PhasicAutoGunHit,
    FxImpactNone = EffectTemplate.PhasicAutoGunHit,
    FxImpactProp = EffectTemplate.PhasicAutoGunHitUnit,    
    FxImpactUnit = EffectTemplate.PhasicAutoGunHitUnit,
    PolyTrails = EffectTemplate.PhasicAutoGunProjectileTrail,
    PolyTrailOffset = {0,0},
}

SHeavyPhasicAutogun = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.HeavyPhasicAutoGunHit,
    FxImpactNone = EffectTemplate.HeavyPhasicAutoGunHit,
    FxImpactProp = EffectTemplate.HeavyPhasicAutoGunHitUnit,    
    FxImpactUnit = EffectTemplate.HeavyPhasicAutoGunHitUnit,
    FxImpactWater = EffectTemplate.HeavyPhasicAutoGunHit,
    FxImpactUnderWater = EffectTemplate.HeavyPhasicAutoGunHitUnit,
    PolyTrails = EffectTemplate.HeavyPhasicAutoGunProjectileTrail,
    FxTrails = EffectTemplate.HeavyPhasicAutoGunProjectileTrailGlow,
    PolyTrailOffset = {0,0},
}

---Adjustment for XSA0203 projectile speed.
SHeavyPhasicAutogun02 = Class(SHeavyPhasicAutogun) {
    PolyTrails = EffectTemplate.HeavyPhasicAutoGunProjectileTrail02,
    FxTrails = EffectTemplate.HeavyPhasicAutoGunProjectileTrailGlow02,
}

SOhCannon = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.OhCannonHit,
    FxImpactNone = EffectTemplate.OhCannonHit,
    FxImpactProp = EffectTemplate.OhCannonHitUnit,    
    FxImpactUnit = EffectTemplate.OhCannonHitUnit,
    FxTrails = {},
    PolyTrails = EffectTemplate.OhCannonProjectileTrail,
    PolyTrailOffset = {0,0},
}

SOhCannon02 = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.OhCannonHit,
    FxImpactNone = EffectTemplate.OhCannonHit,
    FxImpactProp = EffectTemplate.OhCannonHitUnit,    
    FxImpactUnit = EffectTemplate.OhCannonHitUnit,
    FxTrails = {},
    PolyTrails = EffectTemplate.OhCannonProjectileTrail02,
    PolyTrailOffset = {0,0,0},
}

SShriekerAutoCannon = Class(MultiPolyTrailProjectile) {

	FxImpactLand = EffectTemplate.ShriekerCannonHit,
    FxImpactNone = EffectTemplate.ShriekerCannonHit,
    FxImpactProp = EffectTemplate.ShriekerCannonHit,    
    FxImpactUnit = EffectTemplate.ShriekerCannonHitUnit,
    PolyTrails = EffectTemplate.ShriekerCannonPolyTrail,
    FxImpactWater = EffectTemplate.ShriekerCannonHit,
    FxImpactUnderWater = EffectTemplate.ShriekerCannonHit,
    PolyTrailOffset = {0,0,0},
}

SAireauBolter = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.SAireauBolterHit,
    FxImpactNone = EffectTemplate.SAireauBolterHit,
    FxImpactProp = EffectTemplate.SAireauBolterHit,    
    FxImpactUnit = EffectTemplate.SAireauBolterHit,
    FxTrails = EffectTemplate.SAireauBolterProjectileFxTrails,
    PolyTrailOffset = {0,0,0},
    PolyTrails = EffectTemplate.SAireauBolterProjectilePolyTrails,    
}

STauCannon = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.STauCannonHit,
    FxImpactNone = EffectTemplate.STauCannonHit,
    FxImpactProp = EffectTemplate.STauCannonHit,    
    FxImpactUnit = EffectTemplate.STauCannonHit,
    FxTrails = EffectTemplate.STauCannonProjectileTrails,
    PolyTrailOffset = {0,0},    
    PolyTrails = EffectTemplate.STauCannonProjectilePolyTrails,
}

SHeavyQuarnonCannon = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.SHeavyQuarnonCannonLandHit,
    FxImpactNone = EffectTemplate.SHeavyQuarnonCannonHit,
    FxImpactProp = EffectTemplate.SHeavyQuarnonCannonHit,    
    FxImpactUnit = EffectTemplate.SHeavyQuarnonCannonUnitHit,
    PolyTrails = EffectTemplate.SHeavyQuarnonCannonProjectilePolyTrails,
    PolyTrailOffset = {0,0,0},
    FxTrails = EffectTemplate.SHeavyQuarnonCannonProjectileFxTrails,
    FxImpactWater = EffectTemplate.SHeavyQuarnonCannonWaterHit,
}

SLaanseTacticalMissile = Class(SinglePolyTrailProjectile) {
    FxImpactLand = EffectTemplate.SLaanseMissleHit,
    FxImpactProp = EffectTemplate.SLaanseMissleHitUnit,
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SLaanseMissleHitUnit,    
    FxTrails = EffectTemplate.SLaanseMissleExhaust02,
    PolyTrail = EffectTemplate.SLaanseMissleExhaust01,

    OnCreate = function(self)
        SinglePolyTrailProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
    end,
}

SZthuthaamArtilleryShell = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.SZthuthaamArtilleryHit,
	FxImpactWater = EffectTemplate.SZthuthaamArtilleryHit,
    FxImpactNone = EffectTemplate.SZthuthaamArtilleryHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SZthuthaamArtilleryHit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SZthuthaamArtilleryUnitHit,    
    FxTrails = EffectTemplate.SZthuthaamArtilleryProjectileFXTrails,
    PolyTrails = EffectTemplate.SZthuthaamArtilleryProjectilePolyTrails, 
    PolyTrailOffset = {0,0},
}

SSuthanusArtilleryShell = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = false,
	FxImpactLand = EffectTemplate.SRifterArtilleryHit,
	FxImpactWater = EffectTemplate.SRifterArtilleryWaterHit,
    FxImpactNone = EffectTemplate.SRifterArtilleryHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SRifterArtilleryHit,    
    FxImpactUnderWater = EffectTemplate.SRifterArtilleryWaterHit,
    FxImpactUnit = EffectTemplate.SRifterArtilleryHit,    
    FxTrails = EffectTemplate.SRifterArtilleryProjectileFxTrails,
    PolyTrail = EffectTemplate.SRifterArtilleryProjectilePolyTrail,
}

SSuthanusMobileArtilleryShell = Class(SinglePolyTrailProjectile) {
	-- This will make ist so that the projectile effects are the in the space of the world 
	FxImpactTrajectoryAligned = false,
	FxImpactLand = EffectTemplate.SRifterMobileArtilleryHit,
	FxImpactWater = EffectTemplate.SRifterMobileArtilleryWaterHit,
    FxImpactNone = EffectTemplate.SRifterMobileArtilleryHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SRifterMobileArtilleryHit,    
    FxImpactUnderWater = EffectTemplate.SRifterMobileArtilleryWaterHit,
    FxImpactUnit = EffectTemplate.SRifterMobileArtilleryHit,    
    FxTrails = EffectTemplate.SRifterMobileArtilleryProjectileFxTrails,
    PolyTrail = EffectTemplate.SRifterArtilleryProjectilePolyTrail,
}

SThunthoArtilleryShell = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
	FxImpactLand = EffectTemplate.SThunderStormCannonHit,
    FxImpactNone = EffectTemplate.SThunderStormCannonHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SThunderStormCannonHit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SThunderStormCannonHit,    
    FxTrails = EffectTemplate.SThunderStormCannonProjectileTrails,
    PolyTrails = EffectTemplate.SThunderStormCannonProjectilePolyTrails,
    PolyTrailOffset = {0,0},    
}


SThunthoArtilleryShell2 = Class(MultiPolyTrailProjectile) {
	FxImpactTrajectoryAligned = false,
	FxImpactLand = EffectTemplate.SThunderStormCannonLandHit,
	FxImpactWater= EffectTemplate.SThunderStormCannonLandHit,
    FxImpactNone = EffectTemplate.SThunderStormCannonHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SThunderStormCannonHit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SThunderStormCannonUnitHit,    
    FxTrails = {},
    PolyTrails = EffectTemplate.SThunderStormCannonProjectilePolyTrails,
    PolyTrailOffset = {0,0},    
}

SShleoAACannon = Class(EmitterProjectile) {
    FxImpactAirUnit = EffectTemplate.SShleoCannonUnitHit,
    FxImpactLand = EffectTemplate.SShleoCannonLandHit,
    FxImpactWater = EffectTemplate.SShleoCannonLandHit,
    FxImpactNone = EffectTemplate.SShleoCannonHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SShleoCannonHit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SShleoCannonUnitHit,    
    FxTrails = {},
    PolyTrails = EffectTemplate.SShleoCannonProjectilePolyTrails,
    
    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
		
        local PolytrailGroup = self.PolyTrails[RandomInt(1,table.getn( self.PolyTrails ))]

        for k, v in PolytrailGroup do
            CreateTrail(self, -1, self:GetArmy(), v )
        end
    end,    
}

SOlarisAAArtillery = Class(MultiPolyTrailProjectile) {
    FxImpactAirUnit = EffectTemplate.SOlarisCannonHit,
	FxImpactLand = EffectTemplate.SOlarisCannonHit,
    FxImpactNone = EffectTemplate.SOlarisCannonHit,
    FxImpactProp = EffectTemplate.SOlarisCannonHit,    
    FxImpactUnit = EffectTemplate.SOlarisCannonHit,
    FxTrails = EffectTemplate.SOlarisCannonTrails,
    PolyTrails = EffectTemplate.SOlarisCannonProjectilePolyTrail,
    PolyTrailOffset = {0,0}
}

SLosaareAAAutoCannon = Class(MultiPolyTrailProjectile) {

	FxImpactLand = EffectTemplate.SLosaareAutoCannonHit,
    FxImpactNone= EffectTemplate.SLosaareAutoCannonHit,
    FxImpactProp = EffectTemplate.SLosaareAutoCannonHit,    
    FxImpactAirUnit = EffectTemplate.SLosaareAutoCannonHit,
    PolyTrails = EffectTemplate.SLosaareAutoCannonProjectileTrail,
    PolyTrailOffset = {0,0},
}

SLosaareAAAutoCannon02 = Class(SLosaareAAAutoCannon) {

    PolyTrails = EffectTemplate.SLosaareAutoCannonProjectileTrail02,
    PolyTrailOffset = {0,0},
}

SOtheTacticalBomb= Class(SinglePolyTrailProjectile) {
	FxImpactLand =			EffectTemplate.SOtheBombHit,
    FxImpactNone =			EffectTemplate.SOtheBombHit,
    FxImpactProjectile =	{},
    FxImpactProp =			EffectTemplate.SOtheBombHitUnit,    
    FxImpactUnderWater =	EffectTemplate.SOtheBombHit,
    FxImpactUnit =			EffectTemplate.SOtheBombHitUnit,    
    FxTrails =				EffectTemplate.SOtheBombFxTrails,
    PolyTrail =				EffectTemplate.SOtheBombPolyTrail,
}

SAnaitTorpedo = Class(MultiPolyTrailProjectile) {
    FxImpactUnderWater =	EffectTemplate.SAnaitTorpedoHit,
    FxUnderWaterHitScale =	1,
    FxImpactUnit =			EffectTemplate.SAnaitTorpedoHit,    
    FxImpactNone =			EffectTemplate.SAnaitTorpedoHit,
    FxTrails =				EffectTemplate.SAnaitTorpedoFxTrails,
    PolyTrails =			EffectTemplate.SAnaitTorpedoPolyTrails,
    PolyTrailOffset =		{0,0},
    
    OnCreate = function(self, inWater)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        MultiPolyTrailProjectile.OnCreate(self, inWater)
    end,
}

SHeavyCavitationTorpedo = Class(MultiPolyTrailProjectile) {
	FxImpactLand =			EffectTemplate.SHeavyCavitationTorpedoHit,
    FxImpactNone =			EffectTemplate.SHeavyCavitationTorpedoHit,
    FxImpactProjectile =	{},
    FxImpactProp =			EffectTemplate.SHeavyCavitationTorpedoHit,    
    FxImpactUnderWater =	EffectTemplate.SHeavyCavitationTorpedoHit,
    FxImpactUnit =			EffectTemplate.SHeavyCavitationTorpedoHit,    
    FxTrails =				{},
    PolyTrails =			EffectTemplate.SHeavyCavitationTorpedoPolyTrails,
    PolyTrailOffset =		{0,0},	

    OnCreate = function(self, inWater)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        MultiPolyTrailProjectile.OnCreate(self, inWater)
    end,
}

SUallCavitationTorpedo = Class(SinglePolyTrailProjectile) {

    FxImpactUnderWater =	EffectTemplate.SUallTorpedoHit,

    FxUnderWaterHitScale =	1,

    FxTrails =				EffectTemplate.SUallTorpedoFxTrails,
    PolyTrail =				EffectTemplate.SUallTorpedoPolyTrail,
    
    OnCreate = function(self, inWater)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
        SinglePolyTrailProjectile.OnCreate(self, inWater)
    end,
}

SIFInainoStrategicMissile = Class(EmitterProjectile) {

	ExitWaterTicks = 9,
	FxExitWaterEmitter = EffectTemplate.DefaultProjectileWaterImpact,
    FxInitialAtEntityEmitter = {},
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    FxLaunchTrails = {},
    FxOnEntityEmitter = {},
    FxSplashScale = 0.65,
    FxTrailOffset = -0.5,
    FxTrails = {'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',},
    FxUnderWaterTrail = {'/effects/emitters/missile_cruise_munition_underwater_trail_01_emit.bp',},
}

SExperimentalStrategicMissile = Class(MultiPolyTrailProjectile) {

	ExitWaterTicks = 9,
	FxExitWaterEmitter = EffectTemplate.DefaultProjectileWaterImpact,
    FxInitialAtEntityEmitter = {},
    FxImpactUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    FxLaunchTrails = {},
    FxOnEntityEmitter = {},
    FxSplashScale = 0.65,
    FxTrails = EffectTemplate.SIFExperimentalStrategicMissileFXTrails,
    PolyTrails = EffectTemplate.SIFExperimentalStrategicMissilePolyTrails,
    PolyTrailOffset = {0,0,0},
    FxUnderWaterTrail = {'/effects/emitters/missile_cruise_munition_underwater_trail_01_emit.bp',},
}

SIMAntiMissile01 = Class(MultiPolyTrailProjectile) {
	FxImpactLand = EffectTemplate.SElectrumMissleDefenseHit,
    FxImpactNone= EffectTemplate.SElectrumMissleDefenseHit,
    FxImpactProjectile = EffectTemplate.SElectrumMissleDefenseHit,
    FxImpactProp = EffectTemplate.SElectrumMissleDefenseHit,    
    FxImpactUnit = EffectTemplate.SElectrumMissleDefenseHit,
    PolyTrails = EffectTemplate.SElectrumMissleDefenseProjectilePolyTrail,
    PolyTrailOffset = {0,0},
}

SExperimentalStrategicBomb = Class(SBaseTempProjectile) {
    FxImpactTrajectoryAligned = false,
}

SIFNukeWaveTendril = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    #FxTrails = EffectTemplate.SInfernoHitWaveTendril,  ###TODO: Assingn something to this one that is usable.
    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactProjectile = {},
    FxImpactUnderWater = {},
}

SIFNukeSpiralTendril = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,

    FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactNone = {},
    FxImpactLand = {},
    FxImpactProjectile = {},
    FxImpactUnderWater = {},
}

SEnergyLaser = Class(SBaseTempProjectile) {
}

SZhanaseeBombProjectile = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SZhanaseeBombFxTrails01,
	FxImpactUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactProp = EffectTemplate.SZhanaseeBombHit01,
    FxImpactAirUnit = EffectTemplate.SZhanaseeBombHit01,
    FxImpactLand = EffectTemplate.SZhanaseeBombHit01,
    FxImpactUnderWater = {},
}

SAAHotheFlareProjectile = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.AAntiMissileFlare,
    FxImpactUnit = {},
    FxImpactAirUnit = {},
    FxImpactNone = EffectTemplate.AAntiMissileFlareHit,
    FxImpactProjectile = EffectTemplate.AAntiMissileFlareHit,
    FxOnKilled = EffectTemplate.AAntiMissileFlareHit,
    FxUnitHitScale = 0.4,
    FxLandHitScale = 0.4,
    FxWaterHitScale = 0.4,
    FxUnderWaterHitScale = 0.4,
    FxAirUnitHitScale = 0.4,
    FxNoneHitScale = 0.4,
    FxImpactLand = {},
    FxImpactUnderWater = {},
    --DestroyOnImpact = false,

    -- We only destroy when we hit the ground/water.
    OnImpact = function(self, TargetType, targetEntity)
        if type == 'Terrain' or type == 'Water' then
			EmitterProjectile.OnImpact(self, TargetType, targetEntity)
			if TargetType == 'Terrain' or TargetType == 'Water' or TargetType == 'Prop' then
				if self.Trash then
					self.Trash:Destroy()
				end
				self:Destroy()
			end
		end
    end,
}

SOhwalliStrategicBombProjectile = Class(MultiPolyTrailProjectile) {
    FxTrails = EffectTemplate.SOhwalliBombFxTrails01,
    PolyTrails = EffectTemplate.SOhwalliBombPolyTrails, 
	FxImpactUnit = {},
    FxImpactProp = {},
    FxImpactAirUnit = {},
    FxImpactLand = {},
    FxImpactUnderWater = {},
    PolyTrailOffset = {0,0}, 
}

SAnjelluTorpedoDefenseProjectile = Class(MultiPolyTrailProjectile) {
    FxImpactProjectileUnderWater = EffectTemplate.SDFAjelluAntiTorpedoHit01,
    PolyTrails = EffectTemplate.SDFAjelluAntiTorpedoPolyTrail01,  
    PolyTrailOffset = {0,0},    
}

SDFSniperShotNormal = Class(MultiPolyTrailProjectile) {
    FxImpactLand = EffectTemplate.SDFSniperShotNormalHit,
    FxImpactNone = EffectTemplate.SDFSniperShotNormalHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SDFSniperShotNormalHitUnit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SDFSniperShotNormalHitUnit,    
    FxTrails = {},
    PolyTrails = EffectTemplate.SDFSniperShotNormalPolytrail,    
    PolyTrailOffset = {0,0},  
}

SDFSniperShot = Class(MultiPolyTrailProjectile) {
    FxImpactLand = EffectTemplate.SDFSniperShotHit,
    FxImpactNone = EffectTemplate.SDFSniperShotHit,
    FxImpactProjectile = {},
    FxImpactProp = EffectTemplate.SDFSniperShotHitUnit,    
    FxImpactUnderWater = {},
    FxImpactUnit = EffectTemplate.SDFSniperShotHitUnit,    
    FxTrails = EffectTemplate.SDFSniperShotTrails,
    PolyTrails = EffectTemplate.SDFSniperShotPolytrail,  
    PolyTrailOffset = {0,0},  
}

SDFExperimentalPhasonProjectile = Class(EmitterProjectile) {
	FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxImpactUnit = EffectTemplate.SDFExperimentalPhasonProjHitUnit,
    FxImpactProp = EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxImpactLand = EffectTemplate.SDFExperimentalPhasonProjHit01,
    FxImpactWater = EffectTemplate.SDFExperimentalPhasonProjHit01,
}

SDFSinnuntheWeaponProjectile = Class(EmitterProjectile) {
    FxTrails = EffectTemplate.SDFSinnutheWeaponFXTrails01,
    FxImpactUnit = EffectTemplate.SDFSinnutheWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFSinnutheWeaponHit,
    FxImpactLand = EffectTemplate.SDFSinnutheWeaponHit,
    FxImpactWater = EffectTemplate.SDFSinnutheWeaponHit,
}

SDFAireauProjectile = Class(MultiPolyTrailProjectile) {
    FxImpactNone = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactUnit = EffectTemplate.SDFAireauWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactLand = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactWater= EffectTemplate.SDFAireauWeaponHit01,
    RandomPolyTrails = 1,
    
    PolyTrails = EffectTemplate.SDFAireauWeaponPolytrails01,
    PolyTrailOffset = {0,0,0},
}
