
--[[
        Custom commands:
        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.
                                        Light Arts              Dark Arts
        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
	
		Toggle Function: 
		gs c toggle melee 				Toggle Melee mode on / off and locking of weapons
		gs c toggle mb					Toggles Magic Burst Mode on / off.
		gs c toggle runspeed			Toggles locking on / off Herald's Gaiters
        gs c toggle idlemode            Toggles between Refresh and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both. 		
        gs c toggle regenmode           Toggles between Hybrid, Duration and Potency mode for regen set 
        gs c toggle nukemode           	Toggles between Normal and Accuracy mode for midcast Nuking sets (MB included)
		
		Casting functions:
		these are to set fewer macros (1 cycle, 5 cast) to save macro space when playing lazily with controler
		
		gs c nuke cycle 				Cycles element type for nuking & SC
		gs c nuke t1					Cast tier 1 nuke of saved element 
		gs c nuke t2					Cast tier 2 nuke of saved element 
		gs c nuke t3					Cast tier 3 nuke of saved element 
		gs c nuke t4					Cast tier 4 nuke of saved element 
		gs c nuke t5					Cast tier 5 nuke of saved element 
		gs c nuke helix					Cast helix2 nuke of saved element
        gs c nuke storm                 Cast Storm II buff of saved element
	
		
		gs c sc tier					Cycles SC Tier (1 & 2)
		gs c sc castsc					Cast All the stuff to create a SC burstable by the nuke element set with '/console gs c nuke element'.
--]]

include('organizer-lib') -- optional, remove if you dont use organizer... 

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = {'refresh', 'dt', 'mdt'}
regenModes = {'hybrid', 'duration', 'potency'}
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = {'normal', 'acc'}

-- HUD Setups
-- Currently in construction.
use_UI = true 		-- Setting this to true will stop the text spam, and instead display modes in a UI.
hud_x_pos = 1400 	--important to update these if you have a smaller screen
hud_y_pos = 200		--important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)


-- Setup your Key Bindings here:
    windower.send_command('bind insert gs c nuke cycle')        -- insert Cycles Nuke element
    windower.send_command('bind delete gs c nuke cycledown')    -- delete Cycles Nuke element in reverse order    
    windower.send_command('bind !f9 gs c toggle runspeed') 		-- Alt-F9 toggles locking on / off Herald's Gaiters
    windower.send_command('bind f10 gs c toggle mb')			-- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind f12 gs c toggle melee')			-- F12 Toggle Melee mode on / off and locking of weapons
    windower.send_command('bind !` input /ma Stun <t>') 		-- Alt-` Quick Stun Shortcut.
    windower.send_command('bind home gs c sc tier')				-- Alt-F1 to change SC tier between Level 1 or Level 2 SC
    windower.send_command('bind !f12 gs c toggle regenmode')	-- Alt-F12 to change Regen Mode	
    windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode	
    windower.send_command('bind f9 gs c toggle idlemode')		-- F9 to change Idle Mode	


-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')	
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind !`')
    send_command('unbind home')
    send_command('unbind !f12')
    send_command('unbind !f10')	
    send_command('unbind !f9')		
end

-- Optional. Swap to your sch macro sheet / book
set_macros(1,17) -- Sheet, Book

refreshType = idleModes[1] -- leave this as is     

-- Setup your Gear Sets below:
function get_sets()
  
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my avatar's behaviour or abilities are under 'avatar', eg, Perpetuation, Blood Pacts, etc
      
    sets.me = {}        		-- leave this empty
    sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty

	-- For aug gear you can define some here like this.. Look below in the midcast MB set to see how it is used.
	-- This helps when your augment changes to only have 1 place to update. 
    MerlHead = {}
	MerlHead.MB = { name="Merlinic Hood", augments={'Attack+23','Magic burst dmg.+11%','INT+8','"Mag.Atk.Bns."+13',}}
    MerlHead.ACC = { name="Merlinic Hood", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+2%','INT+7','Mag. Acc.+15',}}
	
	ChiroPants = {}
	ChiroPants.ACC = { name="Chironic Hose", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','Enmity-5','INT+12','Mag. Acc.+11',}}

    -- Your idle set
    sets.me.idle.refresh = {    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Jhakri Robe +2",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    }

    -- Your idle Sublimation set combine from refresh or DT depening on mode.
    sets.me.idle.sublimation = set_combine(sets.me.idle.refresh,{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Jhakri Robe +2",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    })   
    -- Your idle DT set
    sets.me.idle.dt = set_combine(sets.me.idle[refreshType],{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    })  
    sets.me.idle.mdt = set_combine(sets.me.idle[refreshType],{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    })  
	-- Your MP Recovered Whilst Resting Set
    sets.me.resting = {     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    }
    
    sets.me.latent_refresh = {waist="Fucho-no-obi"}     
    
	-- Combat Related Sets
    sets.me.melee = set_combine(sets.me.idle[idleMode],{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    })
      
    -- Weapon Skills sets just add them by name.
    sets.me["Shattersoul"] = { 

    }
    sets.me["Myrkr"] = {     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Staunch Tathlum",
    head="Befouled Crown",
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Mallquis Clogs +1",
    neck="Sanctity Necklace",
    waist="Isa Belt",
    left_ear="Handler's Earring",
    right_ear="Thureous Earring",
    left_ring="Vocane Ring",
    right_ring="Defending Ring",
    back="Moonbeam Cape",

    }
      
    -- Feel free to add new weapon skills, make sure you spell it the same as in game. These are the only two I ever use though
  
    ------------
    -- Buff Sets
    ------------	
    -- Gear that needs to be worn to **actively** enhance a current player buff.
    -- Fill up following with your avaible pieces.
    sets.buff['Rapture'] = {head="Arbatel bonnet +1"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +1"}
    sets.buff['Penury'] = {legs="Arbatel Pants +1"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants +1"}
    sets.buff['Celerity'] = {feet="Peda. Loafers +3"}
    sets.buff['Alacrity'] = {feet="Peda. Loafers +3"}
    sets.buff['Klimaform'] = {feet="Mallquis Clogs +1"}	
    -- Ebulience set empy now as we get better damage out of a good Merlinic head
    sets.buff['Ebullience'] = {} -- I left it there still if it becomes needed so the SCH.lua file won't need modification should you want to use this set
   
	
	
    ---------------
    -- Casting Sets
    ---------------
    sets.precast = {}   		-- Leave this empty  
    sets.midcast = {}    		-- Leave this empty  
    sets.aftercast = {}  		-- Leave this empty  
	sets.midcast.nuking = {}	-- leave this empty
	sets.midcast.MB	= {}		-- leave this empty      
    ----------
    -- Precast
    ----------
      
    -- Generic Casting Set that all others take off of. Here you should add all your fast cast 
    -- Grimoire: 10 /rdm: 15
    sets.precast.casting = {        main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},


   }
    -- When spell school is aligned with grimoire, swap relevent pieces -- Can also use Arbatel +1 set here if you value 1% quickcast procs per piece. (2+ pieces)  
    -- Dont set_combine here, as this is the last step of the precast, it will have sorted all the needed pieces already based on type of spell.
    -- Then only swap in what under this set after everything else. 
    sets.precast.grimoire = {
		        main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},
    }

    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{
     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
     sub="Niobid Strap",
     ammo="Incantor Stone",
     head="Nahtirah Hat",
     body="Anhur Robe",
     hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
     legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
     feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
     neck="Stoicheion Medal",
     waist="Witful Belt",
     left_ear="Barkaro. Earring",
     right_ear="Loquac. Earring",
     left_ring="Prolix Ring",
     right_ring="Defending Ring",
     back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},
    })
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},
    })
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},
    })
      
    ---------------------
    -- Ability Precasting
    ---------------------

    sets.precast["Tabula Rasa"] = {    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},}
    
    sets.precast["Enlightenment"] = {    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},}	 
    
    sets.precast["Sublimation"] = {    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Incantor Stone",
    head="Nahtirah Hat",
    body="Anhur Robe",
    hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+21','"Fast Cast"+5',}},
    legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+18','"Fast Cast"+6','MND+1',}},
    neck="Stoicheion Medal",
    waist="Witful Belt",
    left_ear="Barkaro. Earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Defending Ring",
    back={ name="Lugh's Cape", augments={'Mag. Acc+1 /Mag. Dmg.+1','"Fast Cast"+10',}},}	 

	
	----------
    -- Midcast
    ----------
	
    -- Just go make it, inventory will thank you and making rules for each is meh.
    sets.midcast.Obi = {
    	waist="Hachirin-no-Obi",
    }
	
	-----------------------------------------------------------------------------------------------
	-- Helix sets automatically derives from casting sets. SO DONT PUT ANYTHING IN THEM other than:
	-- Pixie in DarkHelix
	-- Boots that aren't arbatel +1 (15% of small numbers meh, amalric+1 does more)
	-- Belt that isn't Obi.
	-----------------------------------------------------------------------------------------------
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.DarkHelix = {
		head="Pixie Hairpin +1",
    	-- Amalric Nails +1 are beating Arbatel Loafers +1 for Helix atm, YMMV
		feet="Mallquis Clogs +1",
		waist="Refoccilation Stone",
    }
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.Helix = {
		-- Amalric Nails +1 are beating Arbatel Loafers +1 for Helix atm, YMMV
		  main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
    }	

    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {       main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
	
    }

	sets.midcast["Sublimation"] = {head="Acad. Mortar. +1", body="Peda. Gown +1"}
    
    sets.midcast.nuking.normal = {       main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},

    }
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {         main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Jhakri Pigaches +1",
    neck="Mizu. Kubikazari",
    waist="Channeler's Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
    })
	
    sets.midcast.nuking.acc = {       main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body="Mallquis Saio +1",
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},

    }
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.normal, {         main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Occult Acumen"+4','INT+10','"Mag.Atk.Bns."+6',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+7%','Mag. Acc.+1','"Mag.Atk.Bns."+8',}},
    feet="Jhakri Pigaches +1",
    neck="Mizu. Kubikazari",
    waist="Channeler's Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},

    })	
	
    -- Enfeebling
	sets.midcast["Stun"] = {      main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Occult Acumen"+4','INT+10','"Mag.Atk.Bns."+6',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
	
	}	
    sets.midcast.IntEnfeebling = {       main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Occult Acumen"+4','INT+10','"Mag.Atk.Bns."+6',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},

    }
    sets.midcast.MndEnfeebling = {       main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head={ name="Merlinic Hood", augments={'Mag. crit. hit dmg. +5%','INT+15','Mag. Acc.+3','"Mag.Atk.Bns."+14',}},
    body={ name="Merlinic Jubbah", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Occult Acumen"+4','INT+10','"Mag.Atk.Bns."+6',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs="Jhakri Slops",
    feet="Arbatel Loafers +1",
    neck="Sanctity Necklace",
    waist="Refoccilation Stone",
    left_ear="Barkaro. Earring",
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1",
    back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10',}},
	
    }
	
    -- Enhancing
    sets.midcast.enhancing = set_combine(sets.midcast.casting,{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    })
    sets.midcast.storm = set_combine(sets.midcast.enhancing,{
	    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},
    })       
    -- Stoneskin
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing,{
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},
    })
    sets.midcast.refresh = set_combine(sets.midcast.enhancing,{
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},
    })
    sets.midcast.aquaveil = sets.midcast.refresh
	
    sets.midcast["Drain"] = set_combine(sets.midcast.nuking, {
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},
    })
    sets.midcast["Aspir"] = sets.midcast["Drain"]
 	
 	sets.midcast.cure = {} -- Leave This Empty
    -- Cure Potency
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    })
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{
		    main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    })    

    ------------
    -- Regen
    ------------	
	sets.midcast.regen = {} 	-- leave this empty
	-- Normal hybrid well rounded Regen
    sets.midcast.regen.hybrid = {     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    }
	-- Focus on Regen Duration 	
    sets.midcast.regen.duration = set_combine(sets.midcast.regen.hybrid,{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    }) 
	-- Focus on Regen Potency 	
    sets.midcast.regen.potency = set_combine(sets.midcast.regen.hybrid,{     main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
    sub="Niobid Strap",
    ammo="Ghastly Tathlum",
    head="Befouled Crown",
    body={ name="Telchine Chas.", augments={'Mag. Acc.+11','"Cure" spellcasting time -1%',}},
    hands={ name="Amalric Gages", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15',}},
    legs={ name="Telchine Braconi", augments={'"Mag.Atk.Bns."+6','"Fast Cast"+4','INT+7 MND+7',}},
    feet="Jhakri Pigaches +1",
    neck="Imbodla Necklace",
    waist="Olympus Sash",
    left_ear="Earthcry Earring",
    right_ear="Friomisi Earring",
    left_ring="Locus Ring",
    right_ring="Mujin Band",
    back={ name="Bookworm's Cape", augments={'INT+4','MND+4','Helix eff. dur. +15',}},

    }) 
	
    ------------
    -- Aftercast
    ------------
      
    -- I don't use aftercast sets, as we handle what to equip later depending on conditions using a function.
	
end
