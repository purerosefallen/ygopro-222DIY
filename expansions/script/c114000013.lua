--★舞台装置の魔女（ヴァルプルギスナハト）
function c114000013.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c114000013.xyzcon)
	e1:SetOperation(c114000013.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c114000013.adval)
    c:RegisterEffect(e3)
	--defup(as_clone_of_atkup)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c114000013.immcon)
	e5:SetValue(c114000013.immfilter)
	c:RegisterEffect(e5)
	--destroy mg/trap
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(c114000013.descon)
	e6:SetOperation(c114000013.desop)
	c:RegisterEffect(e6)
end

function c114000013.xyzfilter(c)
	return c114000013.mjf(c)
	and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114000013.xyzfil0(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c114000013.mjf(c)
	return c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224
end

function c114000013.conmat(lvb,og,matorg,matbk,slf)
	local chkct=true
	local j=0
	local mct=matorg
	local rq=matbk
		for i=1,lvb do
			j=0
			chkct=true
			repeat
				if Duel.CheckXyzMaterial(slf,c114000013.xyzfilter,i,j+1,j+1,og) then
					j=j+1
				else
					chkct=false
				end
			until not chkct
			mct=mct+j
			if mct>=rq then break end			
		end
	return mct
end

function c114000013.mxyzfilter(c)
	return c114000013.mjf(c)
	and ( c:IsFaceup() or not c:IsLocation(LOCATION_MZONE) ) and c:IsType(TYPE_XYZ)
end

function c114000013.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	--
	local mtf=Duel.GetMatchingGroup(c114000013.xyzfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local mtfmat=mtf:Filter(Card.IsCanBeXyzMaterial,nil,c)
	local bd=1-mtfmat:GetCount()
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	if ft>=bd and Duel.GetFlagEffect(tp,114000013)==0 then 
		local lvb=c114000013.lvchk(tp)
		local mct=0 -- count suitable monsters
		local rq=1 -- count least materials
		if ft<=0 then rq=rq-ft end
		mct=c114000013.conmat(lvb,og,mct,rq,c)
		-- for extra xyz monsters
		local mxyzg1=Duel.GetMatchingGroup(c114000013.mxyzfilter,c:GetControler(),LOCATION_MZONE,0,nil)
		mct=mct+mxyzg1:GetCount()
		--
		if mct>=rq then 
			abcount=abcount+2 
		else
			if ft>0 then
				local mtg=Duel.GetMatchingGroup(c114000013.xyzfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
				local mtgmat=mtg:Filter(Card.IsCanBeXyzMaterial,nil,c)
				mct=c114000013.conmat(lvb,mtgmat,mct,rq,c)
				-- for extra xyz monsters
				local mxyzg2=Duel.GetMatchingGroup(c114000013.mxyzfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
				mct=mct+mxyzg2:GetCount()
				--
				if mct>=rq then abcount=abcount+2 end
			end
		end
	end
	--
	if ft>=-3 then
		if Duel.CheckXyzMaterial(c,c114000013.xyzfil0,4,4,4,og) then abcount=abcount+1 end 
	end
	--
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end
--
function c114000013.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	--for preparing xyz monster as materials
	local xyzlay=Group.CreateGroup()
	--
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000013,3))
			sel=Duel.SelectOption(tp,aux.Stringid(114000013,0),aux.Stringid(114000013,1))+1
		end
		if sel==2 then
			Duel.RegisterFlagEffect(tp,114000013,0,0,0)
			local ag=Duel.GetMatchingGroup(c114000013.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local ag2=Duel.GetMatchingGroup(c114000013.xyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
			local lvb=c114000013.lvchk(tp)
			local mgf=c114000013.opmat(ag,lvb,c)
			local mga=c114000013.opmat(ag2,lvb,c)
			--for extra xyz monsters
			local xyzag1=Duel.GetMatchingGroup(c114000013.mxyzfilter,tp,LOCATION_MZONE,0,nil)
			local xyzag2=Duel.GetMatchingGroup(c114000013.mxyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
			mgf:Merge(xyzag1)
			mga:Merge(xyzag2)
			--
			local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
			if ft<=0 then
				local ct=-ft
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				mg=mgf:Select(tp,ct+1,ct+1,nil)
				mga:Sub(mg)
				-- for extra xyz monsters
				local mgtc=mg:GetFirst()
				if mgtc:IsType(TYPE_XYZ) and mgtc:IsLocation(LOCATION_MZONE) then
					xyzlay:Merge(mgtc:GetOverlayGroup())
				end
				--
				if Duel.SelectYesNo(tp,aux.Stringid(114000013,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					mg2=mga:Select(tp,1,99,nil)
					mg:Merge(mg2)
					--for extra xyz monsters
					local mg2tc=mg2:GetFirst()
					while mg2tc do
						--get all overlay materials
						if mg2tc:IsType(TYPE_XYZ) and mg2tc:IsLocation(LOCATION_MZONE) then
							xyzlay:Merge(mg2tc:GetOverlayGroup())
						end
						mg2tc=mg2:GetNext()
					end
					--
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				mg=mga:Select(tp,1,99,nil)
				--for extra xyz monsters
				local mgtc=mg:GetFirst()
				while mgtc do
					--get all overlay materials
					if mgtc:IsType(TYPE_XYZ) and mgtc:IsLocation(LOCATION_MZONE) then
						xyzlay:Merge(mgtc:GetOverlayGroup())
					end
					mgtc=mg:GetNext()
				end
				--
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			mg=Duel.SelectXyzMaterial(tp,c,c114000013.xyzfil0,4,4,4)
		end
		Duel.SendtoGrave(xyzlay,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end
--
function c114000013.opmat(mg,lvb,slf)
	local sg=Group.CreateGroup()
	local ag=mg
	local agtg=ag:GetFirst()
	local chkpg=false
		while agtg do
			chkpg=false
			for i=1,lvb do
				if Duel.CheckXyzMaterial(slf,nil,i,1,1,Group.FromCards(agtg)) then sg:AddCard(agtg) chkpg=true end
				if chkpg then break end
			end
			agtg=ag:GetNext()
		end
	return sg
end
--
--atkup
function c114000013.adval(e,c)
        return c:GetOverlayCount()*700
end
--immune
function c114000013.immcon(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c114000013.immfilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
--destroy mg/trap
function c114000013.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():GetOverlayCount()>=4
end
function c114000013.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c114000013.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114000013.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--definition
function c114000013.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114000013)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114000013.lvchk(tp)
		for i=1,lvb do
			if i==4 then 
				if c:IsXyzLevel(mgtg,i) and ( c114000013.xyzfil0(c) or c114000013.mjf(c) ) then jud=true end
			else
				if c:IsXyzLevel(mgtg,i) and c114000013.mjf(c) then jud=true end
			end
			if jud then break end
		end
		--
		if not jud then
			local mxyzg1=Duel.GetMatchingGroup(c114000013.mxyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
			if mxyzg1:GetCount()>0 then jud=true end
		end
		--
		return jud
	else
		return ( c:GetLevel()==4 and c114000013.xyzfil0(c) ) or c114000013.mjf(c) or c114000013.mxyzfilter(c)
	end
end
--
function c114000013.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114000013.xyz_filter=c114000013.xyzdef
c114000013.xyz_count=2
--end of definition