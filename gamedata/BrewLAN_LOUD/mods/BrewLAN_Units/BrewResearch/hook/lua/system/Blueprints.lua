--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Author: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    RNDPrepareScript(all_blueprints.Unit)

    -- Determine if Lucky Dip is active, and if LDip interaction is enabled
    -- in R&D's mod configs
    local ldipEnabled = false
    local ldipConfig = 'off'
    for _, v in __active_mods do
        if v.uid == '25D57D85-9JA7-LOUD-BREW-RESEARCH00005' then
            if v.config['LuckyDip'] == 'on' then
                ldipConfig = 'on'
            end
        elseif v.uid == '25D57D85-7D84-27HT-A502-LDIPS0000002' then
            ldipEnabled = true
        end
    end

    -- Allow user to play R&D with LDip but without normal research locking
    -- RESEARCHLOCKED needs to be dumped to exist if this is the case
    if ldipEnabled and ldipConfig == 'no_researchlock' then
        LOG("R&D: Disabling normal research locks (LuckyDip)")
        DumpOldBuiltByCategories(all_blueprints,Unit, 'RESEARCHLOCKED')
    else
        RestrictExistingBlueprints(all_blueprints.Unit)
    end

    GenerateResearchItemBPs(all_blueprints.Unit)

    -- After generating normal research items, do the same for LDip if
    -- interaction is taking place
    if ldipEnabled and ldipConfig ~= 'off' then
        LOG("R&D: Generating research items for LuckyDip interaction")
        GenerateLuckyDipBPs(all_blueprints.Unit)
    end

    -- RESEARCHLOCKEDTECH1 needs to exist somewhere, so dump it
    DumpOldBuiltByCategories(all_blueprints.Unit, 'RESEARCHLOCKEDTECH1')
end

--------------------------------------------------------------------------------
-- Things in preparation of RND
--------------------------------------------------------------------------------
function RNDPrepareScript(all_bps)
    for id, bp in all_bps do
        -- Hard link upgrades, instead of soft-category linking, to prevent splurged links
        -- If they don't have a buildable category, we probably don't want to mess with it,
        -- and the upgrade tag is probably a mistake. Also make sure the thing exists.
        if bp.General.UpgradesTo and bp.Economy.BuildableCategory and not table.find(bp.Economy.BuildableCategory, bp.General.UpgradesTo) and all_bps[bp.General.UpgradesTo] then
            table.insert(bp.Economy.BuildableCategory, bp.General.UpgradesTo)
            table.remove(all_bps[bp.General.UpgradesTo].Categories, TableFindSubstrings(all_bps[bp.General.UpgradesTo].Categories, 'BUILTBY', 'FACTORY'))
        end
        if bp.Categories and id ~= 'zzz6969' then -- zzz6969 is a cat dump unit for compatibility
            -- RAT: We're keeping the LOUD status quo on engineer/ACU capability dynamics.
            -- Tech 3 sitution is deliberate and stays (for now).
            -- Tech 1 is on the table, but AI spews to log if it can't build hydros or storage
            
            -- Create extended tech 1 restriction and allow the ACU to build them after the research
            -- if table.find(bp.Categories, 'BUILTBYTIER1ENGINEER') and not table.find(bp.Categories, 'BUILTBYCOMMANDER') then
                -- table.insert(bp.Categories, 'RESEARCHLOCKEDTECH1')
                -- table.insert(bp.Categories, 'BUILTBYCOMMANDER')
            -- end

            -- Kill off TIER N requirements from all build categories
            -- Levels the playing field for tech, so it's handled entirely by the research
            CategoryArrayRemoveTierN(all_bps, bp.Economy.BuildableCategory)
            CategoryArrayRemoveTierN(all_bps, bp.Categories)
            -- Construction sort down on existing units will now cause upgrades 
            -- to be appearing on a tech level below where players will expect.
            -- so it gets removed here. The tech level researches still use them.
            if table.find(bp.Categories, 'CONSTRUCTIONSORTDOWN') then
                table.removeByValue(bp.Categories, 'CONSTRUCTIONSORTDOWN')
            end

            -- Harmonise built by commander and built by engineer
            --[[
            if table.find(bp.Categories, 'BUILTBYCOMMANDER') and not table.find(bp.Categories, 'BUILTBYENGINEER') then
                table.insert(bp.Categories, 'BUILTBYENGINEER')
            elseif not table.find(bp.Categories, 'BUILTBYCOMMANDER') and table.find(bp.Categories, 'BUILTBYENGINEER') then
                table.insert(bp.Categories, 'BUILTBYCOMMANDER')
            end
            --]]
        end
    end
end

--------------------------------------------------------------------------------
-- Restrict a few vanilla units (Additional units for use with LOUD)
--------------------------------------------------------------------------------
function RestrictExistingBlueprints(all_bps)
    local restrict = {
        'ueb1101', 'uab1101', 'urb1101', 'xsb1101', -- T1 power generators
        'xra0105', -- Jester
		-- T1 heavy point defences
		'brnt1hpd', -- UEF AT Defense
		'brmt1pd', -- Cybran Improved Point Defense
		'brot1hpd', -- Aeon Enhanced Point Defense
		'brpt1pd', -- Sera Heavy Point Defense
		-- T1 multi-role point defences
		'brnt1expd', -- Mayor
		'brmt1expd', -- Pen
		'brot1expd', -- Mizura
		-- (Seraphim don't have a multi-role T1 PD.)
		-- T1 amph
		'uel0107', -- Caiman
		'brmt1bt', -- Mite
		'brot1bt', -- Hervour
		'brpt1ht', -- Yenshavoh
		-- T1 heavy land
		'uel0108', -- Crusher
		'brmt1exm1', -- Proton
		'brot1exm1', -- Medusa
        'brpt1exm1', -- Othazyne

        'ueb1201', 'uab1201', 'urb1201', 'xsb1201', -- T2 power generators
		'uab1104', 'ueb1104', 'urb1104', 'xsb1104', -- T2 mass fabs
		'bab1202', 'beb1202', 'brb1202', 'bsb1202', -- T2 hydrocarbons
		-- T2 Point Defense
		'brnt2pd2', -- Angry Ace
		'brnt2epd', -- Tower Boss
		'beb2303', -- Hellstorm
		'brmt2pd', -- Slingshot
		'brmt2epd', -- Anode
		'brb2303', -- Squall
		'brot2epd', -- Daelek
		'bab2303', -- Archangel
		'brpt2pd', -- Ve-Us

        -- T3.5
        'brot3hm', -- Mogul
        'brnt3abb', -- IronFist
        'brmt3bm2', -- Dervish
        'brpt3bot', -- Thaam-Thuum
        -- Penetrator fighters
        'sea0313', -- Tomcat
        'sra0313', -- Twilight Patron
        'ssa0313', -- Ialosaare
        -- Penetrator bombers
        'saa0314', -- Shrieker
        'sea0314', -- Lancer
        'sra0314', -- Sanguine Tyrant
        'ssa0314', -- Sinnaino
        -- Nuclear silos
        'uab2305', -- Apocalypse
        'ueb2305', -- Stonager
        'urb2305', -- Liberator
        'xsb2305', -- Hastue
        -- Nuclear submarines
        'uas0304', -- Silencer
        'ues0304', -- Ace
        'urs0304', -- Plan B
        -- T3 advanced intel structures
        'xab3301', -- Eye of Rhianne
        'seb3303', -- Novax
        'xrb3301', -- Soothsayer
        'ssb3301', -- Aezselen

        -- FA
        'xab2307', -- Salvation
        'ueb2401', -- Mavor
        'url0401', -- Scathis
        'xsb2401', -- Yolona Oss
        -- TM
        'brot3ncm', -- Eliash
        'brnt3shbm', -- Mayhem
        'brmt3ava', -- Avalanche
        'brpexshbm', -- Thaez-Atha
        -- BlackOps
        'bal0401', -- Inquisitor
        'bel0402', -- Goliath
        'brl0401', -- Basilisk
        'bsb0405', -- Uttaus-Athellu
        -- LOUD Unit Additions
        'wel0405', -- King Kraptor
        'lea0401', -- Lucidity
        'wrl0404', -- Megaroach
        'wsl0405', -- Echibum
        'sab4401', 'seb4401', 'srb4401', 'ssb4401', -- BrewLAN T4 shields
    }
    for i, id in restrict do
        if all_bps[id] then
            table.insert(all_bps[id].Categories, 'RESEARCHLOCKED')
        end
    end
end

--------------------------------------------------------------------------------
-- Make some research items
--------------------------------------------------------------------------------
function GenerateResearchItemBPs(all_bps)
    local tablesize = 0
    for id, bp in all_bps do
        tablesize = tablesize + 1
        if bp.Categories and table.find(bp.Categories, 'RESEARCHLOCKED') then
            local newid = id .. 'rnd'
            RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)

            RNDGiveCategoriesAndDefineCosts(all_bps, newid, bp)
            RNDGiveIndicativeAbilities(all_bps, newid, bp)
            RNDGiveUniqueMeshBlueprints(all_bps, newid, bp)
        end
    end

    -- This is to prevent it from regenerating them during disk watch.
    -- It could probably be ~= 1, but I wanted to be safe.
    if tablesize > 10 then
        local techresearch = {
            RESEARCHLOCKEDTECH1 = {
                techid = 1,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 130,
                    BuildCostMass = 26,
                    BuildTime = 26,
                    ResearchMult = 1,
                },
                Categories = {'TECH1'},
                Description = '<LOC srnd9100_desc>Tech Level Research',
            },
            TECH2 = {
                techid = 2,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 8040,
                    BuildCostMass = 960,
                    BuildTime = 960,
                    ResearchMult = 1,
                },
                Categories = {'TECH2'},
                Description = '<LOC srnd9200_desc>Tech Level Research',
            },
            TECH3 = {
                techid = 3,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 31500,
                    BuildCostMass = 3640,
                    BuildTime = 3640,
                    ResearchMult = 1,
                },
                Categories = {'TECH3'},
                Description = '<LOC srnd9300_desc>Tech Level Research',
            },
            EXPERIMENTAL = {
                techid = 4,
                BuildIconSortPriority = 0,
                Economy = {
                    BuildCostEnergy = 123415,
                    BuildCostMass = 13800,
                    BuildTime = 13800,
                    ResearchMult = 1,
                },
                Categories = {'EXPERIMENTAL'},
                Description = '<LOC srnd9400_desc>Experimental Tech Level Research',
            },
        }
        for tech, bp in techresearch do
            for faction, uid in {Aeon = 'sar9', UEF = 'ser9', Cybran = 'srr9', Seraphim = 'ssr9'} do
                local newid = uid .. bp.techid .. '00'
                local id = tech
                bp.Categories[2] = string.upper(faction)
                bp.Categories[3] = 'SORTCONSTRUCTION'
                if tech ~= 'RESEARCHLOCKEDTECH1' then
                    bp.Categories[4] = 'CONSTRUCTIONSORTDOWN'
                end
                if not bp.General then
                    bp.General = {}
                end
                if not bp.Display then
                    bp.Display = {}
                end
                bp.Display.IconName = newid
                bp.General.FactionName = faction
                RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)
                RNDGiveCategoriesAndDefineCosts(all_bps, newid, bp)
                all_bps[newid].Display.BuildMeshBlueprint = '/mods/brewlan_units/brewresearch/meshes/tech'..bp.techid..'_mesh'
                all_bps[newid].Display.MeshBlueprint = '/mods/brewlan_units/brewresearch/meshes/tech'..bp.techid..'_mesh'
                -- LOG(repr(all_bps[newid]))
            end
        end
    end
end

--------------------------------------------------------------------------------
-- All units possibly affected by LuckyDip will need research items
--------------------------------------------------------------------------------
function GenerateLuckyDipBPs(all_bps)
    doscript '/mods/BrewLAN_RNG/LuckyDip/bag.lua'
    for array, group in LuckyDipUnitBag do
        for _, id in group do
            local bp = all_bps[id]
            if bp then
                local newid = id .. 'rnd'
                RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)
    
                RNDGiveCategoriesAndDefineCosts(all_bps, newid, bp)
                RNDGiveIndicativeAbilities(all_bps, newid, bp)
                RNDGiveUniqueMeshBlueprints(all_bps, newid, bp)
            end
        end
    end
end

function RNDGenerateBaseResearchItemBlueprint(all_bps, newid, id, bp)
    local sizescale = math.max( ((bp.Physics.SkirtSizeX or bp.SizeX or 4) / 2), ((bp.Physics.SkirtSizeZ or bp.SizeZ or 4) / 2) )
    all_bps[newid] = {
        BlueprintId = newid,
        ResearchId = id,
        BuildIconSortPriority = bp.BuildIconSortPriority or 5,
        Categories = {
            'PRODUCTBREWLANRND',
            'BUILTBYRESEARCH',
            -- Engine stuff?
            'VISIBLETORECON',
            'BENIGN',
            -- And now some lies.
            'SELECTABLE',
            --'MOBILE',
        },
        Defense = {
            ArmorType = 'Normal',
            Health = 5000,
            MaxHealth = 5000,
        },
        Description = bp.Description,
        Display = {
            Abilities = {
                '<LOC ability_rnd_unlock>Research Unlock',
            },
            IconName = bp.Display.IconName,
            UniformScale = (bp.Display.UniformScale or 0.2) / sizescale, -- calculate properly based on footprint size
        },
        Footprint = {
            SizeX = 2,
            SizeZ = 2,
        },
        Economy = {
            BuildCostEnergy = bp.Economy.BuildCostEnergy * (bp.Economy.ResearchMultEnergy or bp.Economy.ResearchMult or  1),
            BuildCostMass = bp.Economy.BuildCostMass * (bp.Economy.ResearchMultMass or bp.Economy.ResearchMult or  1),
            BuildTime = bp.Economy.BuildTime * 10 * (bp.Economy.ResearchMultTime or bp.Economy.ResearchMult or  1),
        },
        Interface = {
            HelpText = bp.Description,
        },
        LifeBarHeight = 0.075,
        LifeBarOffset = 1.25,
        LifeBarSize = 2.5,
        General = {
            CapCost = 0,
            FactionName = bp.General.FactionName,
            Icon = bp.General.Icon or 'air',
            TechLevel = 'RULEUTL_Advanced',
            UnitName = bp.General.UnitName,
            UnitWeight = 1,
        },
        Physics = {
            MeshExtentsX = (bp.Physics.MeshExtentsX or bp.SizeX or sizescale * 2) / sizescale,
            MeshExtentsY = (bp.Physics.MeshExtentsY or bp.SizeY or sizescale) / sizescale,
            MeshExtentsZ = (bp.Physics.MeshExtentsZ or bp.SizeZ or sizescale * 2) / sizescale,
            -- And now some more lies.
            MaxSpeed = 1,
            MotionType = 'RULEUMT_Amphibious',
        },
        ScriptClass = 'ResearchItem',
        ScriptModule = '/lua/defaultunits.lua',
        SizeX = 2,
        SizeY = (bp.SizeY or sizescale) / sizescale,
        SizeZ = 2,
        Source = bp.Source or all_bps.seb9101.Source,
        StrategicIconName = bp.StrategicIconName,
    }
    if not all_bps[newid].Display.IconName then
        all_bps[newid].Display.IconName = id
    end
end

function RNDGiveCategoriesAndDefineCosts(all_bps, newid, ref)
    local bp = all_bps[newid]
    local cats = {
        'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL', 'UEF', 'CYBRAN', 'SERAPHIM', 'AEON',
        'SORTSTRATEGIC', 'SORTCONSTRUCTION', 'SORTDEFENSE', 'SORTECONOMY', 'SORTINTEL',
        'CONSTRUCTIONSORTDOWN', 'RESEARCHLOCKEDTECH1', 'AIR', 'LAND', 'NAVAL'
    }
    for i, v in cats do
        if table.find(ref.Categories, v) then
            -- If the source has the cat, the research item also needs it.
            table.insert(bp.Categories, v)
            if i < 5 then -- if I is less than 5 we are dealing with T1, T2, T3, or Experimental
                local CostMults = {1, 1.25, 1.5, 1} -- Resource cost multiplier per tech level.
                local maxOutput = { -- Maximum research output of a tech 1
                    {5, 50},
                    {10, 100},
                    {15, 150},
                    {20, 200},
                }
                -- If we haven't got a pre-defined cost multiplier, then we use the defaults defined in CostMults.
                -- Units should only exist in one of the first four cats, so this shouldn't stack, except for mods that dont count Experimental as == Tech 4
                if not (ref.Economy.ResearchMultEnergy or ref.Economy.ResearchMult) then
                    bp.Economy.BuildCostEnergy = bp.Economy.BuildCostEnergy * CostMults[1]
                end
                if not (ref.Economy.ResearchMultMass or ref.Economy.ResearchMult) then
                    bp.Economy.BuildCostMass = bp.Economy.BuildCostMass * CostMults[1]
                end
                -- Research times based on max cost per second instead.
                bp.Economy.BuildTime = math.floor(math.max(bp.Economy.BuildCostMass / maxOutput[i][1] * 50, bp.Economy.BuildCostEnergy / maxOutput[i][2] * 50 ))
            end
        end
    end
end

function RNDGiveIndicativeAbilities(all_bps, newid, ref)
    local bp = all_bps[newid]
    local TFS = TableFindSubstrings
    local TF = table.find
    local CATs = ref.Categories
    if ref.General.UpgradesFrom then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_updade>Built as upgrade')
    end
    if TFS(CATs,'BUILTBY','ENGINEER') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_engineer>Built by engineer')
    end
    if TFS(CATs,'BUILTBY','FIELD')
    or TFS(CATs,'BUILTBY','ENGINEER') and (TF(CATs, 'DEFENSE') or TF(CATs, 'INDIRECTFIRE'))
    then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_field>Built by field engineer')
    end
    if TFS(CATs,'BUILTBY','COMMANDER') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_command>Built by command unit')
    end
    if TFS(CATs,'BUILTBY','FACTORY') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_factory>Built by factory')
    end
    if TF(CATs, 'BUILTBYGANTRY') or TF(CATs, 'BUILTBYIENGINE') or TF(CATs, 'BUILTBYARTHROLAB') or TF(CATs, 'BUILTBYSOUIYA') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_gantry>Built by experimental factory')
    end
    if TFS(CATs,'BUILTBY','WALL') then
        table.insert(bp.Display.Abilities,'<LOC ability_rnd_wall>Built on wall')
    end
end

function TableFindSubstrings(table, string1, string2)
    for i, cat in table do
        if string.find(cat,string1) and string.find(cat,string2 or string1) then
            return i
        end
    end
end

-- Making unique mesh, so it can be a glowy hologram
function RNDGiveUniqueMeshBlueprints(all_bps, newid, ref)
    local bp = all_bps[newid]
    for i, mesh in {'BuildMeshBlueprint', 'MeshBlueprint'} do
        local refid = ref.Display[mesh]
        local meshbp = original_blueprints.Mesh[refid]
        if meshbp then
            local dupebp = table.deepcopy(meshbp)
            dupebp.BlueprintId = refid .. 'rnd'
            for i, lod in dupebp.LODs do
                dupebp.LODs[i].ShaderName = 'PhalanxEffect'
            end
            bp.Display[mesh] = dupebp.BlueprintId
            MeshBlueprint(dupebp)
        end
    end
    bp.Display.Mesh = {
        BlueprintId = bp.Display.MeshBlueprint,
        IconFadeInZoom = 130,
        Source = ref.Display.Mesh.Source,
    }
end

-- This isn't nessessary for its original purpose, but it doesn't hurt to keep it around
-- It's also a mess for cleanup, since it leaves table floating nowhere. Possible memory leak?
function CleanupDuplicateArrayKeys(array)
    local original = array
    local new = {}
    for i, v in array do
        if v and not table.find(new, v) then
            table.insert(new, v)
        end
    end
    return new
end

function CategoryArrayRemoveTierN(all_bps, table)
    if type(table) == "table" and table[1] and TableFindSubstrings(table, 'BUILTBY', 'TIER') then
        for i, cat in table do
            if string.find(cat, 'BUILTBY') and string.find(cat, 'TIER') then
                DumpOldBuiltByCategories(all_bps, cat)
                table[i] = string.gsub(cat, "TIER%d", "")
            end
        end
    end
end

function DumpOldBuiltByCategories(all_bps, cat)
    -- This dumping of old categories is so that they remain valid categories,
    -- but categories that do nothing when other mods affect and reference them.
    if not all_bps.zzz6969 then all_bps.zzz6969 = {BlueprintId = 'zzz6969',Categories = {'NOTHINGIMPORTANT'}} end
    if all_bps.zzz6969 and not table.find(all_bps.zzz6969.Categories, cat) then
        table.insert(all_bps.zzz6969.Categories, cat)
    end
end

end
